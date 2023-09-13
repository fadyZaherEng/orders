// ignore_for_file: avoid_function_literals_in_foreach_calls, non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/models/admin_model.dart';
import 'package:orders/models/category_model.dart';
import 'package:orders/models/money.dart';
import 'package:orders/models/order_model.dart';
import 'package:orders/models/user_orders.dart';
import 'package:orders/models/user_profile.dart';
import 'package:orders/modules/admin_screen/orders/orders.dart';
import 'package:orders/modules/admin_screen/search_by_date/search.dart';
import 'package:orders/modules/admin_screen/show_order/show_orders.dart';
import 'package:orders/modules/admin_screen/today_orders/orders.dart';
import 'package:orders/shared/components/components.dart';
import 'package:orders/shared/network/local/cashe_helper.dart';

// ignore_for_file: avoid_print
class OrdersHomeCubit extends Cubit<OrdersHomeStates> {
  OrdersHomeCubit() : super(OrdersHomeInitialStates());

  static OrdersHomeCubit get(context) => BlocProvider.of(context);
  List<Widget> screens = [
    DisplayOrdersScreen(),
    const TodayOrders(),
    SearchByDateScreen(),
  ];

  //bottom nav
  int currentIndex = 0;

  void changeNav(int idx) {
    currentIndex = idx;
    emit(GetFileSuccessStates());
  }

  //users
  UserProfile? userProfile;

  void getUserProfile() {
    emit(OrdersHomeGetUserProfileLoadingStates());
    FirebaseFirestore.instance
        .collection('users')
        .doc(SharedHelper.get(key: 'uid'))
        .snapshots()
        .listen((event) {
      userProfile = UserProfile.fromJson(event.data());
      emit(OrdersHomeGetUserProfileSuccessStates());
    }).onError((handleError) {
      emit(OrdersHomeGetUserProfileErrorStates());
    });
  }

  //get num all orders
  int totalAllOrdersOfCurrentEmp = 0;

  void getTotalAllOrdersOfCurrentEmp() {
    emit(ViewFileLoadingStates());
    FirebaseFirestore.instance
        .collection('orders')
        .orderBy('date')
        .snapshots()
        .listen((event) {
      totalAllOrdersOfCurrentEmp = 0;
      event.docs.forEach((element) {
        OrderModel orderModel = OrderModel.fromMap(element.data());
        if (orderModel.employerName == userProfile!.name) {
          totalAllOrdersOfCurrentEmp++;
        }
        emit(ViewFileSuccessStates());
      });
      emit(ViewFileSuccessStates());
    }).onError((handleError) {
      emit(ViewFileErrorStates());
    });
  }

  //get num today orders
  int totalTodayOrdersOfCurrentEmp = 0;
  List<OrderModel> totalTodayOrdersOfCurrentEmpList = [];

  void getTodayTotalTodayOrdersOfCurrentEmp() {
    emit(ViewFileLoadingStates()); //=order id
    FirebaseFirestore.instance
        .collection('orders')
        .orderBy('date')
        .snapshots()
        .listen((event) {
      totalTodayOrdersOfCurrentEmp = 0;
      totalTodayOrdersOfCurrentEmpList = [];
      event.docs.forEach((element) {
        OrderModel orderModel = OrderModel.fromMap(element.data());
        if (orderModel.date.split(' ')[0] ==
            DateTime.now().toString().split(' ')[0] &&
            orderModel.employerName == userProfile!.name) {
          totalTodayOrdersOfCurrentEmp++;
          totalTodayOrdersOfCurrentEmpList.add(orderModel);
        }
        emit(ViewFileSuccessStates());
      });
      emit(ViewFileSuccessStates());
    }).onError((handleError) {
      emit(ViewFileErrorStates());
    });
  }

  //update orders
  void updateOrderConfirm(
      {required OrderModel orderModel, required context}) async {
    FirebaseFirestore.instance
        .collection('orders')
        .doc(orderModel.barCode)
        .update(orderModel.toMap())
        .then((value) {
      String text = "Edited Successfully...".tr();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.blueGrey,
      ));
      print(orderModel.price);
      emit(OrdersEditProfileSuccessStates());
    }).catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          onError.toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
        backgroundColor: Colors.pink,
      ));
      emit(OrdersEditProfileErrorStates());
    });
  }

//update orders
  void updateOrderWaiting({
    required OrderModel orderModel,
    required context,
  }) async {
    FirebaseFirestore.instance
        .collection('orders')
        .doc(orderModel.barCode)
        .update(orderModel.toMap())
        .then((value) {
      String text = "Edited Successfully...".tr();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.blueGrey,
      ));
      print(orderModel.price);
      emit(OrdersEditProfileSuccessStates());
    }).catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          onError.toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
        backgroundColor: Colors.pink,
      ));
      emit(OrdersEditProfileErrorStates());
    });
  }

  //admins
  AdminModel? currentAdmin;
  List<AdminModel> admins = [];

  void getAdminsProfile() {
    emit(GetFileLoadingStates());
    FirebaseFirestore.instance.collection("admins").snapshots().listen((value) {
      admins = [];
      for (var admin in value.docs) {
        if (admin['email'] == SharedHelper.get(key: 'adminEmail')) {
          currentAdmin = AdminModel.fromMap(admin.data());
          emit(GetFileSuccessStates());
        } else {
          admins.add(AdminModel.fromMap(admin.data()));
          emit(GetFileSuccessStates());
        }
      }
      emit(GetFileSuccessStates());
    }).onError((onError) {
      showToast(message: onError.toString(), state: ToastState.ERROR);
      emit(GetUserWaitingErrorStates());
    });
  }

  //admin permission
  void adminShowOrdersPermission(bool showOrders, AdminModel adminModel,
      context) {
    emit(GetFileLoadingStates());
    FirebaseFirestore.instance.collection("admins").get().then((value) {
      String docId = "";
      for (var admin in value.docs) {
        if (admin['email'] == adminModel.email) {
          docId = admin.id;
          break;
        }
      }
      adminModel.showOrders = showOrders;
      FirebaseFirestore.instance
          .collection("admins")
          .doc(docId)
          .set(adminModel.toMap())
          .then((value) {
        String text = "Appear Successfully".tr();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme
                .of(context)
                .scaffoldBackgroundColor),
          ),
          backgroundColor: Colors.pink,
        ));
        emit(GetFileSuccessStates());
      }).catchError((onError) {
        showToast(message: onError.toString(), state: ToastState.ERROR);
        print(onError.toString());
        emit(GetUserWaitingErrorStates());
      });
      emit(GetFileSuccessStates());
    }).catchError((onError) {
      showToast(message: onError.toString(), state: ToastState.ERROR);
      emit(GetUserWaitingErrorStates());
    });
  }

  void adminShowCategoriesPermission(bool showCategories, AdminModel adminModel,
      context) {
    emit(GetFileLoadingStates());
    FirebaseFirestore.instance.collection("admins").get().then((value) {
      String docId = "";
      for (var admin in value.docs) {
        if (admin['email'] == adminModel.email) {
          docId = admin.id;
          break;
        }
      }
      adminModel.showCategories = showCategories;
      FirebaseFirestore.instance
          .collection("admins")
          .doc(docId)
          .set(adminModel.toMap())
          .then((value) {
        String text = "Appear Successfully".tr();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme
                .of(context)
                .scaffoldBackgroundColor),
          ),
          backgroundColor: Colors.pink,
        ));
        emit(GetFileSuccessStates());
      }).catchError((onError) {
        showToast(message: onError.toString(), state: ToastState.ERROR);
        emit(GetUserWaitingErrorStates());
      });
      emit(GetFileSuccessStates());
    }).catchError((onError) {
      showToast(message: onError.toString(), state: ToastState.ERROR);
      emit(GetUserWaitingErrorStates());
    });
  }

  void adminAddCatPermission(bool addCat, AdminModel adminModel, context) {
    emit(GetFileLoadingStates());
    FirebaseFirestore.instance.collection("admins").get().then((value) {
      String docId = "";
      for (var admin in value.docs) {
        if (admin['email'] == adminModel.email) {
          docId = admin.id;
          break;
        }
      }
      adminModel.addCat = addCat;
      FirebaseFirestore.instance
          .collection("admins")
          .doc(docId)
          .set(adminModel.toMap())
          .then((value) {
        String text = "Appear Successfully".tr();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme
                .of(context)
                .scaffoldBackgroundColor),
          ),
          backgroundColor: Colors.pink,
        ));
        emit(GetFileSuccessStates());
      }).catchError((onError) {
        showToast(message: onError.toString(), state: ToastState.ERROR);
        emit(GetUserWaitingErrorStates());
      });
      emit(GetFileSuccessStates());
    }).catchError((onError) {
      showToast(message: onError.toString(), state: ToastState.ERROR);
      emit(GetUserWaitingErrorStates());
    });
  }

  void adminSaveOrderPermission(bool saveOrder, AdminModel adminModel,
      context) {
    emit(GetFileLoadingStates());
    FirebaseFirestore.instance.collection("admins").get().then((value) {
      String docId = "";
      for (var admin in value.docs) {
        if (admin['email'] == adminModel.email) {
          docId = admin.id;
          break;
        }
      }
      adminModel.saveOrder = saveOrder;
      FirebaseFirestore.instance
          .collection("admins")
          .doc(docId)
          .set(adminModel.toMap())
          .then((value) {
        String text = "Appear Successfully".tr();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme
                .of(context)
                .scaffoldBackgroundColor),
          ),
          backgroundColor: Colors.pink,
        ));
        emit(GetFileSuccessStates());
      }).catchError((onError) {
        showToast(message: onError.toString(), state: ToastState.ERROR);
        emit(GetUserWaitingErrorStates());
      });
      emit(GetFileSuccessStates());
    }).catchError((onError) {
      showToast(message: onError.toString(), state: ToastState.ERROR);
      emit(GetUserWaitingErrorStates());
    });
  }

  void adminRemoveOrderPermission(bool removeOrder, AdminModel adminModel,
      context) {
    emit(GetFileLoadingStates());
    FirebaseFirestore.instance.collection("admins").get().then((value) {
      String docId = "";
      for (var admin in value.docs) {
        if (admin['email'] == adminModel.email) {
          docId = admin.id;
          break;
        }
      }
      adminModel.removeOrder = removeOrder;
      FirebaseFirestore.instance
          .collection("admins")
          .doc(docId)
          .set(adminModel.toMap())
          .then((value) {
        String text = "Appear Successfully".tr();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme
                .of(context)
                .scaffoldBackgroundColor),
          ),
          backgroundColor: Colors.pink,
        ));
        emit(GetFileSuccessStates());
      }).catchError((onError) {
        showToast(message: onError.toString(), state: ToastState.ERROR);
        emit(GetUserWaitingErrorStates());
      });
      emit(GetFileSuccessStates());
    }).catchError((onError) {
      showToast(message: onError.toString(), state: ToastState.ERROR);
      emit(GetUserWaitingErrorStates());
    });
  }

  //get orders
  List<OrderModel> orders = [];
  double totalOfAllOrders = 0;
  double totalOfAllOrdersConfirm = 0;

  void getOrders(String filter) {
    emit(ViewFileLoadingStates());
    FirebaseFirestore.instance
        .collection('orders')
        .orderBy('date')
        .snapshots()
        .listen((event) {
      orders = [];
      totalOfAllOrders = 0;
      totalOfAllOrdersConfirm = 0;
      event.docs.forEach((element) {
        OrderModel orderModel = OrderModel.fromMap(element.data());
        if (orderModel.confirm) {
          totalOfAllOrdersConfirm += orderModel.totalPrice;
        }
        if (filter == "Confirm" && orderModel.confirm) {
          orders.add(orderModel);
          totalOfAllOrders += orderModel.totalPrice;
        } else if (filter == "Waiting" && orderModel.waiting) {
          orders.add(orderModel);
          totalOfAllOrders += orderModel.totalPrice;
        } else if (filter == "Cancel" && !orderModel.confirm) {
          orders.add(orderModel);
          totalOfAllOrders += orderModel.totalPrice;
        }
        emit(ViewFileSuccessStates());
      });
      emit(ViewFileSuccessStates());
    }).onError((handleError) {
      emit(ViewFileErrorStates());
    });
  }

//update orders
  void updateOrder({required String orderName,
    required String conservation,
    required String city,
    required String address,
    required bool waiting,
    required String type,
    required String barCode,
    required String employerName,
    required String employerPhone,
    required String employerEmail,
    required String orderPhone,
    required String serviceType,
    required String notes,
    required String date,
    required int number,
    required double price,
    required double totalPrice,
    required double salOfCharging,
    required context}) async {
    OrderModel orderModel = OrderModel(
        employerEmail: employerEmail,
        waiting: waiting,
        orderPhone: orderPhone,
        serviceType: serviceType,
        notes: notes,
        orderName: orderName,
        conservation: conservation,
        city: city,
        address: address,
        type: type,
        barCode: barCode,
        employerName: employerName,
        employerPhone: employerPhone,
        date: date,
        number: number,
        price: price,
        totalPrice: totalPrice,
        salOfCharging: salOfCharging);
    FirebaseFirestore.instance
        .collection('orders')
        .doc(barCode)
        .update(orderModel.toMap())
        .then((value) {
      String text = "Edited Successfully...".tr();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.blueGrey,
      ));
      print(orderModel.price);
      emit(OrdersEditProfileSuccessStates());
    }).catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          onError.toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
        backgroundColor: Colors.pink,
      ));
      emit(OrdersEditProfileErrorStates());
    });
  }

  //add orders
  void addOrders({required String orderName,
    required String conservation,
    required String city,
    required String address,
    required String type,
    required String employerName,
    required String employerPhone,
    required String employerEmail,
    required String orderPhone,
    required String notes,
    required String serviceType,
    required int number,
    required double price,
    required bool waiting,
    required double totalPrice,
    required double salOfCharging,
    required context}) {
    OrderModel orderModel = OrderModel(
      orderPhone: orderPhone,
      orderName: orderName,
      notes: notes,
      waiting: waiting,
      serviceType: serviceType,
      employerEmail: employerEmail,
      conservation: conservation,
      city: city,
      address: address,
      type: type,
      employerName: employerName,
      employerPhone: employerPhone,
      date: DateTime.now().toString(),
      number: number,
      price: price,
      totalPrice: totalPrice,
      salOfCharging: salOfCharging,
    );
    CollectionReference ref = FirebaseFirestore.instance.collection('orders');
    DocumentReference docRef = ref.doc();
    String docId = docRef.id;
    orderModel.barCode = docId;
    String text = "Order Uploaded Successfully".tr();
    docRef.set(orderModel.toMap()).then((value) {
      showToast(message: text, state: ToastState.SUCCESS);
      emit(GetFileSuccessStates());
    }).catchError((onError) {
      print('pppppppppppppppppppppppp${onError.toString()}');
      showToast(message: onError.toString(), state: ToastState.WARNING);
      emit(GetFileErrorStates());
    });
  }

//remove orders doc id equal barcode
  void removeOrders({required String docId, required context}) {
    emit(RejectFileLoadingStates());
    FirebaseFirestore.instance
        .collection('orders')
        .doc(docId)
        .delete()
        .then((value) {
      String text = "Deleted Successfully".tr();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme
              .of(context)
              .scaffoldBackgroundColor),
        ),
        backgroundColor: Colors.pink,
      ));
      navigateToWithReturn(context, const AdminShowOrders());
      emit(RejectFileSuccessStates());
    }).catchError((onError) {
      emit(RejectFileErrorStates());
    });
  }

////////////////////////////////////////////////////////////////////////////////////
//mode
  void modeChange() {
    if (SharedHelper.get(key: 'theme') == 'Light Theme') {
      SharedHelper.save(value: 'Dark Theme', key: 'theme');
    } else {
      SharedHelper.save(value: 'Light Theme', key: 'theme');
    }
    emit(OrdersChangeModeStates());
  }

  //lang
  void langChange(BuildContext context) {
    if (SharedHelper.get(key: 'lang') == 'arabic') {
      SharedHelper.save(value: 'english', key: 'lang');
      context.setLocale(const Locale('en', 'US'));
      emit(OrdersChangeModeStates());
      //Phoenix.rebirth(context);
    } else {
      SharedHelper.save(value: 'arabic', key: 'lang');
      context.setLocale(const Locale('ar', 'SA'));
      emit(OrdersChangeModeStates());
      //Phoenix.rebirth(context);
    }
    emit(OrdersChangeModeStates());
    Phoenix.rebirth(context);
    emit(OrdersChangeModeStates());
  }

//logout
  void logOut() async {
    SharedHelper.remove(key: 'adminEmail');
    await FirebaseAuth.instance.signOut();
  }

////////////////////////////////////////////////////////////////////////////////////////////////
//get categories
  List<CategoryModel> categories = [];

  void getCategories() {
    emit(ViewFileLoadingStates());
    FirebaseFirestore.instance
        .collection('categories')
        .orderBy('date')
        .snapshots()
        .listen((event) {
      categories = [];
      event.docs.forEach((element) {
        categories.add(CategoryModel.fromMap(element.data()));
        emit(ViewFileSuccessStates());
      });
      emit(ViewFileSuccessStates());
    }).onError((handleError) {
      emit(ViewFileErrorStates());
    });
  }

//add categories
  void addCategories({required date,
    required catName,
    required salOfCharging,
    required notes,
    required source,
    required totalPrice,
    required price,
    required amount,
    required context}) {
    CategoryModel categoryModel = CategoryModel(
        date: date,
        source: source,
        catName: catName,
        salOfCharging: salOfCharging,
        notes: notes,
        totalPrice: totalPrice,
        price: price,
        amount: amount);
    CollectionReference ref =
    FirebaseFirestore.instance.collection('categories');
    DocumentReference docRef = ref.doc();
    String docId = docRef.id;
    categoryModel.catId = docId;
    String text = "Category Uploaded Successfully".tr();
    docRef.set(categoryModel.toMap()).then((value) {
      showToast(message: text, state: ToastState.SUCCESS);
      emit(GetFileSuccessStates());
    }).catchError((onError) {
      print('pppppppppppppppppppppppp${onError.toString()}');
      showToast(message: onError.toString(), state: ToastState.WARNING);
      emit(GetFileErrorStates());
    });
  }

  void removeCat({required String docId, required context}) {
    emit(RejectFileLoadingStates());
    FirebaseFirestore.instance
        .collection('categories')
        .doc(docId)
        .delete()
        .then((value) {
      String text = "Deleted Successfully".tr();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme
              .of(context)
              .scaffoldBackgroundColor),
        ),
        backgroundColor: Colors.pink,
      ));
      navigateToWithReturn(context, const AdminShowOrders());
      emit(RejectFileSuccessStates());
    }).catchError((onError) {
      emit(RejectFileErrorStates());
    });
  }

  void editCat({required String docId,
    required CategoryModel categoryModel,
    required context}) {
    if (categoryModel.amount == 0) {
      removeCat(docId: docId, context: context);
    } else {
      emit(RejectFileLoadingStates());
      FirebaseFirestore.instance
          .collection('categories')
          .doc(docId)
          .update(categoryModel.toMap())
          .then((value) {
        String text = "Updated Successfully".tr();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme
                .of(context)
                .scaffoldBackgroundColor),
          ),
          backgroundColor: Colors.pink,
        ));
        emit(RejectFileSuccessStates());
      }).catchError((onError) {
        emit(RejectFileErrorStates());
      });
    }
  }

  //////////////////////////////////////////////////////////////////////////////////
  //search barcode
  OrderModel? searchOrderBarcode;

  void searchOrdersByBarcode(String barcode) {
    emit(ViewFileLoadingStates()); //=order id
    FirebaseFirestore.instance
        .collection('orders')
        .orderBy('date')
        .get()
        .then((event) {
      event.docs.forEach((element) {
        OrderModel orderModel = OrderModel.fromMap(element.data());
        if (orderModel.barCode == barcode) {
          searchOrderBarcode = OrderModel.fromMap(element.data());
          emit(ViewFileSuccessStates());
          return;
        }
      });
      emit(ViewFileSuccessStates());
    }).catchError((handleError) {
      emit(ViewFileErrorStates());
    });
  }

//search date
  List<OrderModel> searchOrdersDate = [];

  void searchOrdersByDate({
    required String startDate,
    required String endDate,
    required TimeOfDay firstTime,
    required TimeOfDay lastTime,
  }) {
    emit(ViewFileLoadingStates());
    FirebaseFirestore.instance
        .collection('orders')
        .where('confirm', isEqualTo: true)
        .get()
        .then((event) {
      searchOrdersDate = [];
      int tempHourTime = 0,
          tempHourLastTime = 0,
          tempHourFirstTime = 0;
      DateTime firstDate= DateTime.parse(startDate.split(' ')[0]);
      DateTime finishDate= DateTime.parse(endDate.split(' ')[0]);
      event.docs.forEach((element) {
        OrderModel orderModel = OrderModel.fromMap(element.data());
        DateTime orderDate= DateTime.parse(orderModel.date.split(' ')[0]);
        if (orderDate.isAfter(finishDate)&&orderDate.isBefore(firstDate)||
            orderDate.isAtSameMomentAs(firstDate)||orderDate.isAtSameMomentAs(finishDate)) {
          TimeOfDay time = TimeOfDay.fromDateTime(DateTime.parse(orderModel.date));
          tempHourTime = time.hour;
          tempHourFirstTime = firstTime.hour;
          tempHourLastTime = lastTime.hour;
          if (tempHourTime > tempHourFirstTime &&
              (tempHourTime >= 1 && tempHourTime <= 12) &&
              (tempHourFirstTime >= 1 && tempHourFirstTime <= 12) &&
              (tempHourLastTime >= 1 && tempHourLastTime <= 12) &&
              tempHourTime < tempHourLastTime) {
            searchOrdersDate.add(orderModel);
          }
          if (tempHourTime > tempHourFirstTime &&
              (tempHourTime >= 13 && tempHourTime <= 23) &&
              (tempHourFirstTime >= 13 && tempHourFirstTime <= 23) &&
              (tempHourLastTime >= 13 && tempHourLastTime <= 23) &&
              tempHourTime < tempHourLastTime) {
            searchOrdersDate.add(orderModel);
          }
          if ((tempHourTime >= 13 && tempHourTime <= 23) &&
              (tempHourFirstTime >= 1 && tempHourFirstTime <= 12) &&
              (tempHourLastTime >= 13 && tempHourLastTime <= 23) &&
              tempHourTime < tempHourLastTime ||
              (tempHourTime >= 13 && tempHourTime <= 23) &&
                  (tempHourFirstTime >= 13 && tempHourFirstTime <= 23) &&
                  tempHourTime > tempHourFirstTime &&
                  (tempHourLastTime >= 1 && tempHourLastTime <= 12)) {
            searchOrdersDate.add(orderModel);
          }
          if (tempHourTime == tempHourFirstTime &&
              time.minute >= firstTime.minute) {
            searchOrdersDate.add(orderModel);
          }
          if (tempHourTime == tempHourLastTime &&
              time.minute <= lastTime.minute) {
            searchOrdersDate.add(orderModel);
          }
        }
      });
      emit(ViewFileSuccessStates());
    }).catchError((handleError) {
      emit(ViewFileErrorStates());
    });
  }

//search barcode
  List<OrderModel> searchOrderPhone = [];
  double searchOrderPhonePrice = 0;
  int searchOrderPhoneNum = 0;

  void searchOrdersByPhone(String phone) {
    emit(ViewFileLoadingStates()); //=order id
    FirebaseFirestore.instance.collection('orders').get().then((event) {
      searchOrderPhone = [];
      searchOrderPhonePrice = 0;
      searchOrderPhoneNum = 0;
      event.docs.forEach((element) {
        OrderModel orderModel = OrderModel.fromMap(element.data());
        print(orderModel.orderPhone);
        print(phone);
        if (orderModel.orderPhone == phone) {
          searchOrderPhone.add(orderModel);
          emit(ViewFileSuccessStates());
        }
      });
      emit(ViewFileSuccessStates());
    }).catchError((handleError) {
      emit(ViewFileErrorStates());
    });
  }

//today order
  List<OrderModel> todayOrders = [];
  double todayOrdersPrice = 0;
  int todayOrdersNumber = 0;

  void getTodayOrders(String filter) {
    emit(ViewFileLoadingStates()); //=order id
    FirebaseFirestore.instance.collection('orders').snapshots().listen((event) {
      todayOrders = [];
      todayOrdersPrice = 0;
      todayOrdersNumber = 0;
      event.docs.forEach((element) {
        OrderModel orderModel = OrderModel.fromMap(element.data());
        if (orderModel.date.split(' ')[0] ==
            DateTime.now().toString().split(' ')[0]) {
          if (filter == "Confirm" && orderModel.confirm) {
            todayOrders.add(orderModel);
            todayOrdersPrice += orderModel.totalPrice;
            todayOrdersNumber++;
          } else if (filter == "Waiting" && orderModel.waiting) {
            todayOrders.add(orderModel);
            todayOrdersPrice += orderModel.totalPrice;
            todayOrdersNumber++;
          } else if (filter == "Cancel" && !orderModel.confirm) {
            todayOrders.add(orderModel);
            todayOrdersPrice += orderModel.totalPrice;
            todayOrdersNumber++;
          }
        }
        emit(ViewFileSuccessStates());
      });
      emit(ViewFileSuccessStates());
    }).onError((handleError) {
      emit(ViewFileErrorStates());
    });
  }

////////////money
  void addMoney({required type, required value, required context}) {
    CollectionReference ref = FirebaseFirestore.instance.collection('money');
    DocumentReference docRef = ref.doc();
    String docId = docRef.id;
    MoneyModel moneyModel =
    MoneyModel(type: type, value: double.parse(value), docId: docId);
    String text = "Money Uploaded Successfully".tr();
    docRef.set(moneyModel.toMap()).then((value) {
      showToast(message: text, state: ToastState.SUCCESS);
      emit(GetFileSuccessStates());
    }).catchError((onError) {
      print('pppppppppppppppppppppppp${onError.toString()}');
      showToast(message: onError.toString(), state: ToastState.WARNING);
      emit(GetFileErrorStates());
    });
  }

  //get money
  double totalPriceCost = 0;
  List<MoneyModel> moneys = [];

  void getMoney() {
    FirebaseFirestore.instance.collection('money').snapshots().listen((event) {
      moneys = [];
      totalPriceCost = 0;
      event.docs.forEach((element) {
        MoneyModel moneyModel = MoneyModel.fromMap(element.data());
        moneys.add(moneyModel);
        totalPriceCost += moneyModel.value;
        emit(GetFileSuccessStates());
      });
      emit(GetFileSuccessStates());
    }).onError((onError) {
      print('pppppppppppppppppppppppp${onError.toString()}');
      showToast(message: onError.toString(), state: ToastState.WARNING);
      emit(GetFileErrorStates());
    });
  }

  //add cities and states
  void addCites(String city, String state) {
    FirebaseFirestore.instance
        .collection(state)
        .add({'city': city}).then((value) {
      showToast(message: "تم اضافة مدينة بنجاح", state: ToastState.SUCCESS);
      emit(SocialGetUserStatusSuccessStates());
    }).catchError((onError) {
      emit(GetVedioErrorStates());
    });
  }

  List<String> cities = [];

  void getCites(String state) {
    FirebaseFirestore.instance.collection(state).snapshots().listen((event) {
      cities = [];
      event.docs.forEach((element) {
        cities.add(element['city']);
        emit(SocialGetUserStatusSuccessStates());
      });
      emit(SocialGetUserStatusSuccessStates());
    }).onError((handleError) {
      emit(GetVedioErrorStates());
    });
  }

  void addStates(String state) {
    FirebaseFirestore.instance
        .collection('states')
        .add({'state': state}).then((value) {
      showToast(message: "تم اضافة محافظة بنجاح", state: ToastState.SUCCESS);
      emit(SocialGetUserStatusSuccessStates());
    }).catchError((onError) {
      emit(GetVedioErrorStates());
    });
  }

  List<String> states = [];

  void getStates() {
    FirebaseFirestore.instance.collection('states').snapshots().listen((value) {
      value.docs.forEach((element) {
        states.add(element['state']);
      });
      emit(SocialGetUserStatusSuccessStates());
    }).onError((onError) {
      emit(GetVedioErrorStates());
    });
  }

  ////////////////////////////////////////////////////
  List<UserOrders> userFilterOrders = [];

  void userOrdersFilter() {
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      event.docs.forEach((element) async {
        String email = element['email'];
        String name = element['name'];
        int numToday = 0;
        int numAll = 0;
        FirebaseFirestore.instance.collection('orders').get().then((orders) {
          orders.docs.forEach((order) {
            OrderModel orderModel = OrderModel.fromMap(order.data());
            if (orderModel.employerEmail == email) {
              numAll++;
              if (orderModel.date.split(' ')[0] ==
                  DateTime.now().toString().split(' ')[0]) {
                numToday++;
              }
            }
          });
          userFilterOrders.add(
            UserOrders(
              email: email,
              numOfAllOrders: numAll,
              numOfTodayOrders: numToday,
              name: name,
            ),
          );
        }).catchError((handleError) {});
      });
    }).onError((handleError) {});
  }
}
