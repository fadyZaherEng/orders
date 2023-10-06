// ignore_for_file: avoid_function_literals_in_foreach_calls, non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/modules/admin_screen/showPapers/papers.dart';
import 'dart:io';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/models/admin_model.dart';
import 'package:orders/models/category_model.dart';
import 'package:orders/models/import.dart';
import 'package:orders/models/model_group_massage.dart';
import 'package:orders/models/money.dart';
import 'package:orders/models/order_model.dart';
import 'package:orders/models/page_model.dart';
import 'package:orders/models/source_model.dart';
import 'package:orders/models/state_model.dart';
import 'package:orders/models/user_orders.dart';
import 'package:orders/models/user_profile.dart';
import 'package:orders/modules/admin_screen/orders/orders.dart';
import 'package:orders/modules/admin_screen/search_by_date/search.dart';
import 'package:orders/modules/admin_screen/show_order/show_orders.dart';
import 'package:orders/modules/admin_screen/today_orders/orders.dart';
import 'package:orders/modules/admin_screen/update_order/update_order.dart';
import 'package:orders/shared/components/components.dart';
import 'package:orders/shared/network/local/cashe_helper.dart';
import 'package:once/once.dart';

// ignore_for_file: avoid_print
class OrdersHomeCubit extends Cubit<OrdersHomeStates> {
  OrdersHomeCubit() : super(OrdersHomeInitialStates());

  static OrdersHomeCubit get(context) => BlocProvider.of(context);
  List<Widget> screens = [
    const DisplayOrdersScreen(),
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
      userProfile = UserProfile.fromMap(event.data()!);
      emit(OrdersHomeGetUserProfileSuccessStates());
    }).onError((handleError) {
      emit(OrdersHomeGetUserProfileErrorStates());
    });
  }

  void removeUserProfile({required String docId}) {
    emit(OrdersHomeGetUserProfileLoadingStates());
    FirebaseFirestore.instance
        .collection('users')
        .doc(docId)
        .delete()
        .then((event) {
      emit(OrdersHomeGetUserProfileSuccessStates());
    }).catchError((handleError) {
      emit(OrdersHomeGetUserProfileErrorStates());
    });
  }

  void acceptUserProfile({required UserProfile user}) {
    emit(OrdersHomeGetUserProfileLoadingStates());
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update(user.toMap())
        .then((event) {
      emit(OrdersHomeGetUserProfileSuccessStates());
    }).catchError((handleError) {
      emit(OrdersHomeGetUserProfileErrorStates());
    });
  }

  //get num all orders
  int totalAllOrdersOfCurrentEmp = 0;

  void getTotalAllOrdersOfCurrentEmp() {
    emit(ViewFileLoadingStates());
    FirebaseFirestore.instance
        .collection('orders')
        .orderBy('date', descending: true)
        .snapshots()
        .listen((event) {
      totalAllOrdersOfCurrentEmp = 0;
      event.docs.forEach((element) {
        OrderModel orderModel = OrderModel.fromMap(element.data());
        if (userProfile != null &&
            orderModel.employerName == userProfile!.name) {
          totalAllOrdersOfCurrentEmp++;
        }
        emit(ViewFileSuccessStates());
      });
      emit(ViewFileSuccessStates());
    }).onError((handleError) {
      print(handleError.toString());
      emit(ViewFileErrorStates());
    });
  }

  //get num today orders
  int totalTodayOrdersOfCurrentEmp = 0;
  List<OrderModel> totalTodayOrdersOfCurrentEmpList = [];

  void getTodayTotalTodayOrdersOfCurrentEmp(String filter) {
    emit(ViewFileLoadingStates()); //=order id
    FirebaseFirestore.instance
        .collection('orders')
        .orderBy('date', descending: true)
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
          if (filter == "كل الطلبات") {
            totalTodayOrdersOfCurrentEmpList.add(orderModel);
          } else if (filter == orderModel.statusOrder) {
            totalTodayOrdersOfCurrentEmpList.add(orderModel);
          }
        }
        emit(ViewFileSuccessStates());
      });
      emit(ViewFileSuccessStates());
    }).onError((handleError) {
      emit(ViewFileErrorStates());
    });
  }

  //update orders
  void updateOrderStatus(
      {required OrderModel orderModel, required context}) async {
    FirebaseFirestore.instance
        .collection('orders')
        .doc(orderModel.barCode)
        .update(orderModel.toMap())
        .then((value) {
      String text = "Edited Successfully...".tr();
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(
      //     text,
      //     textAlign: TextAlign.center,
      //     style: const TextStyle(color: Colors.green),
      //   ),
      //   backgroundColor: Colors.blueGrey,
      // ));
      showToast(message: text, state: ToastState.SUCCESS);
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

  List<UserProfile> users = [];

  void getUsers() {
    emit(GetFileLoadingStates());
    FirebaseFirestore.instance.collection("users").snapshots().listen((value) {
      users = [];
      for (var user in value.docs) {
        users.add(UserProfile.fromMap(user.data()));
        emit(GetFileSuccessStates());
      }
      emit(GetFileSuccessStates());
    }).onError((onError) {
      showToast(message: onError.toString(), state: ToastState.ERROR);
      emit(GetUserWaitingErrorStates());
    });
  }

//add admin
  void addAdmin({
    required String email,
    required String password,
    required context,
  }) {
    CollectionReference ref = FirebaseFirestore.instance.collection('admins');
    DocumentReference docRef = ref.doc();
    String docId = docRef.id;
    AdminModel adminModel = AdminModel(
        email: email,
        showOrders: true,
        showCategories: true,
        id: docId,
        addCat: true,
        saveOrder: true,
        removeOrder: true,
        password: password);
    emit(GetFileLoadingStates());
    docRef.set(adminModel.toMap()).then((value) {
      showToast(
          message: "Create Account Success ....".tr(),
          state: ToastState.SUCCESS);
      emit(GetFileSuccessStates());
    }).catchError((onError) {
      showToast(message: onError.toString(), state: ToastState.ERROR);
      emit(GetUserWaitingErrorStates());
    });
  }

  void removeAdmin({
    required String email,
    required context,
  }) {
    emit(GetFileLoadingStates());
    FirebaseFirestore.instance.collection("admins").get().then((value) {
      String docId = "";
      for (var admin in value.docs) {
        if (admin['email'] == email) {
          docId = admin["id"];
          break;
        }
      }
      FirebaseFirestore.instance
          .collection("admins")
          .doc(docId)
          .delete()
          .then((value) {
        emit(GetFileSuccessStates());
      }).catchError((onError) {
        emit(GetUserWaitingErrorStates());
      });
    });
  }

  void removePaper({
    required String paper,
    required context,
  }) {
    emit(GetFileLoadingStates());
    FirebaseFirestore.instance.collection("papers").get().then((value) {
      String docId = "";
      for (var page in value.docs) {
        if (page['name'] == paper) {
          docId = page.id;
          break;
        }
      }
      FirebaseFirestore.instance
          .collection("papers")
          .doc(docId)
          .delete()
          .then((value) {
        emit(GetFileSuccessStates());
      }).catchError((onError) {
        emit(GetUserWaitingErrorStates());
      });
    });
  }

  void userIsAdminPermission(bool isAdmin, UserProfile userProfile, context) {
    emit(GetFileLoadingStates());
    FirebaseFirestore.instance.collection("users").get().then((value) {
      String docId = "";
      for (var user in value.docs) {
        if (user['email'] == userProfile.email) {
          docId = user["uid"];
          break;
        }
      }
      userProfile.isAdmin = isAdmin;
      FirebaseFirestore.instance
          .collection("users")
          .doc(docId)
          .set(userProfile.toMap())
          .then((value) {
        String text = "Successfully".tr();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
          ),
          backgroundColor: Colors.pink,
        ));
        if (isAdmin) {
          addAdmin(
              email: userProfile.email,
              password: userProfile.password,
              context: context);
        } else if (!isAdmin) {
          removeAdmin(email: userProfile.email, context: context);
        }
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

  //admin permission
  void adminShowOrdersPermission(
      bool showOrders, AdminModel adminModel, context) {
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
            style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
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

  void adminShowCategoriesPermission(
      bool showCategories, AdminModel adminModel, context) {
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
            style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
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
            style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
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

  void adminSaveOrderPermission(
      bool saveOrder, AdminModel adminModel, context) {
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
            style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
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

  void adminRemoveOrderPermission(
      bool removeOrder, AdminModel adminModel, context) {
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
            style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
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

//update orders
  void updateOrder(
      {required String orderName,
      required String conservation,
      required String city,
      required String address,
      required String type,
      required String barCode,
      required String employerName,
      required String employerPhone,
      required String employerEmail,
      required String orderPhone,
      required String serviceType,
      required String statusOrder,
      required String notes,
      required String paper,
      required bool isSelected,
      required String editEmail,
      required String date,
      required int number,
      required double price,
      required double totalPrice,
      required double salOfCharging,
      required context}) async {
    OrderModel orderModel = OrderModel(
      employerEmail: employerEmail,
      orderPhone: orderPhone,
      statusOrder: statusOrder,
      serviceType: serviceType,
      notes: notes,
      editEmail: editEmail,
      orderName: orderName,
      conservation: conservation,
      city: city,
      address: address,
      type: type,
      paper: paper,
      isSelected: isSelected,
      barCode: barCode,
      employerName: employerName,
      employerPhone: employerPhone,
      date: date,
      number: number,
      price: price,
      totalPrice: totalPrice,
      salOfCharging: salOfCharging,
    );
    emit(OrderUpdateOrderLoadingStates());
    FirebaseFirestore.instance
        .collection('orders')
        .doc(barCode)
        .update(orderModel.toMap())
        .then((value) {
      String text = "Edited Successfully...".tr();
      showToast(message: text, state: ToastState.SUCCESS);
      emit(OrdersEditProfileSuccessStates());
    }).catchError((onError) {
      showToast(message: onError.toString(), state: ToastState.ERROR);
      emit(OrdersEditProfileErrorStates());
    });
  }

  //add orders
  void addOrders(
      {required String orderName,
      required String conservation,
      required String city,
      required String address,
      required String type,
      required String paper,
      required String employerName,
      required String employerPhone,
      required String employerEmail,
      required String orderPhone,
      required String notes,
      required String serviceType,
      required String statusOrder,
      required int number,
      required double price,
      required double totalPrice,
      required double salOfCharging,
      required context}) {
    emit(OrderAddOrderLoadingStates());
    OrderModel orderModel = OrderModel(
      orderPhone: orderPhone,
      orderName: orderName,
      isSelected: false,
      notes: notes,
      paper: paper,
      editEmail: "",
      statusOrder: statusOrder,
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
      navigateToWithReturn(
          context,
          UpdateOrdersScreen(
            orderModel: orderModel,
            editEmail: employerName,
          ));
      emit(GetFileSuccessStates());
    }).catchError((onError) {
      print('pppppppppppppppppppppppp${onError.toString()}');
      showToast(message: onError.toString(), state: ToastState.ERROR);
      emit(GetFileErrorStates());
    });
  }

//remove orders doc id equal barcode
  void removeOrders({required String docId, required context}) {
    emit(RejectFileLoadingStates());
    navigateToWithReturn(context, const AdminShowOrders());
    String text = "Deleted Successfully".tr();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
      ),
      backgroundColor: Colors.pink,
    ));
    FirebaseFirestore.instance
        .collection('orders')
        .doc(docId)
        .delete()
        .then((value) {
      emit(RejectFileSuccessStates());
    }).catchError((onError) {
      emit(RejectFileErrorStates());
    });
  }
//remove collection of order
  void removeCollectionsOrders({required List<OrderModel>orders, required context}) {
   orders.forEach((order) {
     emit(RejectFileLoadingStates());
     navigateToWithReturn(context, const AdminShowOrders());
     String text = "Deleted Successfully".tr();
     FirebaseFirestore.instance
         .collection('orders')
         .doc(order.barCode)
         .delete()
         .then((value) {
           showToast(message: text, state: ToastState.SUCCESS);
       emit(RejectFileSuccessStates());
     }).catchError((onError) {
       emit(RejectFileErrorStates());
     });
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
        .orderBy('date', descending: true)
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
  void addCategories(
      {required date, required catName, required price, required context}) {
    CategoryModel categoryModel = CategoryModel(
      date: date,
      catName: catName,
      price: price,
    );
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
          style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
        ),
        backgroundColor: Colors.pink,
      ));
      emit(RejectFileSuccessStates());
    }).catchError((onError) {
      emit(RejectFileErrorStates());
    });
  }

  void removeImport({required String docId, required context}) {
    emit(RejectFileLoadingStates());
    FirebaseFirestore.instance
        .collection('imports')
        .doc(docId)
        .delete()
        .then((value) {
      String text = "Deleted Successfully".tr();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
        ),
        backgroundColor: Colors.pink,
      ));
      emit(RejectFileSuccessStates());
    }).catchError((onError) {
      emit(RejectFileErrorStates());
    });
  }

  void removeMoney({required String docId, required context}) {
    emit(RejectFileLoadingStates());
    FirebaseFirestore.instance
        .collection('money')
        .doc(docId)
        .delete()
        .then((value) {
      String text = "Deleted Successfully".tr();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
        ),
        backgroundColor: Colors.pink,
      ));
      emit(RejectFileSuccessStates());
    }).catchError((onError) {
      emit(RejectFileErrorStates());
    });
  }

  void removeState({required String docId, required context}) {
    emit(RejectFileLoadingStates());
    FirebaseFirestore.instance
        .collection('states')
        .doc(docId)
        .delete()
        .then((value) {
      String text = "Deleted Successfully".tr();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
        ),
        backgroundColor: Colors.pink,
      ));
      emit(RejectFileSuccessStates());
    }).catchError((onError) {
      emit(RejectFileErrorStates());
    });
  }

  void removePage({required String docId, required context}) {
    emit(RejectFileLoadingStates());
    FirebaseFirestore.instance
        .collection('papers')
        .doc(docId)
        .delete()
        .then((value) {
      String text = "Deleted Successfully".tr();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
        ),
        backgroundColor: Colors.pink,
      ));
      emit(RejectFileSuccessStates());
    }).catchError((onError) {
      emit(RejectFileErrorStates());
    });
  }

  void removeUser({required String docId, required context}) {
    emit(RejectFileLoadingStates());
    FirebaseFirestore.instance
        .collection('users')
        .doc(docId)
        .delete()
        .then((value) {
      String text = "Deleted Successfully".tr();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
        ),
        backgroundColor: Colors.pink,
      ));
      emit(RejectFileSuccessStates());
    }).catchError((onError) {
      emit(RejectFileErrorStates());
    });
  }

  void removeAllOrders(context) async {
    emit(RejectFileLoadingStates());
    final instance = FirebaseFirestore.instance;
    final batch = instance.batch();
    var collection = instance.collection('orders');
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit().then((value) {
      Phoenix.rebirth(context);
      String text = "Deleted Successfully".tr();
      showToast(message: text, state: ToastState.SUCCESS);
      emit(RejectFileSuccessStates());
    }).catchError((onError) {
      emit(RejectFileErrorStates());
    });
  }

  void removeChats() {
    Once.runCustom("Custom", callback: () async {
      emit(RejectFileLoadingStates());
      final instance = FirebaseFirestore.instance;
      final batch = instance.batch();
      var collection =
          instance.collection('group').doc('chat').collection('massages');
      var snapshots = await collection.get();
      for (var doc in snapshots.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit().then((value) {
        // String text = "Deleted Successfully".tr();
        // showToast(message: text, state: ToastState.SUCCESS);
        emit(RejectFileSuccessStates());
      }).catchError((onError) {
        emit(RejectFileErrorStates());
      });
    }, duration: const Duration(days: 10));
  }

  void editCat(
      {required String docId,
      required CategoryModel categoryModel,
      required context}) {
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
          style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
        ),
        backgroundColor: Colors.pink,
      ));
      emit(RejectFileSuccessStates());
    }).catchError((onError) {
      emit(RejectFileErrorStates());
    });
  }

  //////////////////////////////////////////////////////////////////////////////////
  //search barcode
  OrderModel? searchOrderBarcode;

  void searchOrdersByBarcode(String barcode) {
    emit(ViewFileLoadingStates()); //=order id
    FirebaseFirestore.instance
        .collection('orders')
        .orderBy('date', descending: true)
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
  int numSearchOrdersDate = 0;
  double priceSearchOrdersDate = 0;

  void searchOrdersByDate({
    required String startDate,
    required String endDate,
    required String filter,
    required TimeOfDay firstTime,
    required TimeOfDay lastTime,
  }) {
    emit(ViewFileLoadingStates());
    FirebaseFirestore.instance
        .collection('orders')
        .orderBy('date', descending: true)
        .get()
        .then((event) {
      numSearchOrdersDate = 0;
      priceSearchOrdersDate = 0;
      searchOrdersDate = [];
      int tempHourTime = 0, tempHourLastTime = 0, tempHourFirstTime = 0;
      DateTime firstDate = DateTime.parse(startDate.split(' ')[0]);
      DateTime finishDate = DateTime.parse(endDate.split(' ')[0]);
      event.docs.forEach((element) {
        OrderModel orderModel = OrderModel.fromMap(element.data());
        DateTime orderDate = DateTime.parse(orderModel.date.split(' ')[0]);
        if (!finishDate.isAtSameMomentAs(firstDate) &&
            orderDate.isAfter(firstDate) &&
            orderDate.isBefore(finishDate)) {
          if (filter == "كل الطلبات") {
            searchOrdersDate.add(orderModel);
            numSearchOrdersDate++;
            priceSearchOrdersDate += orderModel.totalPrice;
          } else if (filter == orderModel.statusOrder) {
            searchOrdersDate.add(orderModel);
            numSearchOrdersDate++;
            priceSearchOrdersDate += orderModel.totalPrice;
          }
        } else if (!finishDate.isAtSameMomentAs(firstDate) &&
            orderDate.isAtSameMomentAs(firstDate)) {
          TimeOfDay time =
              TimeOfDay.fromDateTime(DateTime.parse(orderModel.date));
          tempHourTime = time.hour;
          tempHourFirstTime = firstTime.hour;
          tempHourLastTime = lastTime.hour;
          if (tempHourTime > tempHourFirstTime) {
            if (filter == "كل الطلبات") {
              searchOrdersDate.add(orderModel);
              numSearchOrdersDate++;
              priceSearchOrdersDate += orderModel.totalPrice;
            } else if (filter == orderModel.statusOrder) {
              searchOrdersDate.add(orderModel);
              numSearchOrdersDate++;
              priceSearchOrdersDate += orderModel.totalPrice;
            }
          }
          if (tempHourTime == tempHourFirstTime &&
              time.minute >= firstTime.minute) {
            if (filter == "كل الطلبات") {
              searchOrdersDate.add(orderModel);
              numSearchOrdersDate++;
              priceSearchOrdersDate += orderModel.totalPrice;
            } else if (filter == orderModel.statusOrder) {
              searchOrdersDate.add(orderModel);
              numSearchOrdersDate++;
              priceSearchOrdersDate += orderModel.totalPrice;
            }
          }
        } else if (!finishDate.isAtSameMomentAs(firstDate) &&
            orderDate.isAtSameMomentAs(finishDate)) {
          TimeOfDay time =
              TimeOfDay.fromDateTime(DateTime.parse(orderModel.date));
          tempHourTime = time.hour;
          tempHourFirstTime = firstTime.hour;
          tempHourLastTime = lastTime.hour;
          if (tempHourTime < tempHourLastTime) {
            if (filter == "كل الطلبات") {
              searchOrdersDate.add(orderModel);
              numSearchOrdersDate++;
              priceSearchOrdersDate += orderModel.totalPrice;
            } else if (filter == orderModel.statusOrder) {
              searchOrdersDate.add(orderModel);
              numSearchOrdersDate++;
              priceSearchOrdersDate += orderModel.totalPrice;
            }
          }
          if (tempHourTime == tempHourLastTime &&
              lastTime.minute >= time.minute) {
            if (filter == "كل الطلبات") {
              searchOrdersDate.add(orderModel);
              numSearchOrdersDate++;
              priceSearchOrdersDate += orderModel.totalPrice;
            } else if (filter == orderModel.statusOrder) {
              searchOrdersDate.add(orderModel);
              numSearchOrdersDate++;
              priceSearchOrdersDate += orderModel.totalPrice;
            }
          }
        } else if (finishDate.isAtSameMomentAs(firstDate) &&
            orderDate.isAtSameMomentAs(finishDate)) {
          TimeOfDay time =
              TimeOfDay.fromDateTime(DateTime.parse(orderModel.date));
          tempHourTime = time.hour;
          tempHourFirstTime = firstTime.hour;
          tempHourLastTime = lastTime.hour;
          if (tempHourTime > tempHourFirstTime &&
              (tempHourTime >= 1 && tempHourTime <= 12) &&
              (tempHourFirstTime >= 1 && tempHourFirstTime <= 12) &&
              (tempHourLastTime >= 1 && tempHourLastTime <= 12) &&
              tempHourTime < tempHourLastTime) {
            if (filter == "كل الطلبات") {
              searchOrdersDate.add(orderModel);
              numSearchOrdersDate++;
              priceSearchOrdersDate += orderModel.totalPrice;
            } else if (filter == orderModel.statusOrder) {
              searchOrdersDate.add(orderModel);

              numSearchOrdersDate++;
              priceSearchOrdersDate += orderModel.totalPrice;
            }
          }
          if (tempHourTime > tempHourFirstTime &&
              (tempHourTime >= 13 && tempHourTime <= 23) &&
              (tempHourFirstTime >= 13 && tempHourFirstTime <= 23) &&
              (tempHourLastTime >= 13 && tempHourLastTime <= 23) &&
              tempHourTime < tempHourLastTime) {
            if (filter == "كل الطلبات") {
              searchOrdersDate.add(orderModel);

              numSearchOrdersDate++;
              priceSearchOrdersDate += orderModel.totalPrice;
            } else if (filter == orderModel.statusOrder) {
              searchOrdersDate.add(orderModel);

              numSearchOrdersDate++;
              priceSearchOrdersDate += orderModel.totalPrice;
            }
          }
          if ((tempHourTime >= 13 && tempHourTime <= 23) &&
                  (tempHourFirstTime >= 1 && tempHourFirstTime <= 12) &&
                  (tempHourLastTime >= 13 && tempHourLastTime <= 23) &&
                  tempHourTime < tempHourLastTime ||
              (tempHourTime >= 13 && tempHourTime <= 23) &&
                  (tempHourFirstTime >= 13 && tempHourFirstTime <= 23) &&
                  tempHourTime > tempHourFirstTime &&
                  (tempHourLastTime >= 1 && tempHourLastTime <= 12)) {
            if (filter == "كل الطلبات") {
              searchOrdersDate.add(orderModel);

              numSearchOrdersDate++;
              priceSearchOrdersDate += orderModel.totalPrice;
            } else if (filter == orderModel.statusOrder) {
              searchOrdersDate.add(orderModel);

              numSearchOrdersDate++;
              priceSearchOrdersDate += orderModel.totalPrice;
            }
          }
          if (tempHourTime == tempHourFirstTime &&
              time.minute >= firstTime.minute) {
            if (filter == "كل الطلبات") {
              searchOrdersDate.add(orderModel);

              numSearchOrdersDate++;
              priceSearchOrdersDate += orderModel.totalPrice;
            } else if (filter == orderModel.statusOrder) {
              searchOrdersDate.add(orderModel);

              numSearchOrdersDate++;
              priceSearchOrdersDate += orderModel.totalPrice;
            }
          }
          if (tempHourTime == tempHourLastTime &&
              time.minute <= lastTime.minute) {
            if (filter == "كل الطلبات") {
              searchOrdersDate.add(orderModel);

              numSearchOrdersDate++;
              priceSearchOrdersDate += orderModel.totalPrice;
            } else if (filter == orderModel.statusOrder) {
              searchOrdersDate.add(orderModel);

              numSearchOrdersDate++;
              priceSearchOrdersDate += orderModel.totalPrice;
            }
          }
        }
        emit(ViewFileSuccessStates());
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
    FirebaseFirestore.instance
        .collection('orders')
        .orderBy('date', descending: true)
        .get()
        .then((event) {
      searchOrderPhone = [];
      searchOrderPhonePrice = 0;
      searchOrderPhoneNum = 0;
      event.docs.forEach((element) {
        OrderModel orderModel = OrderModel.fromMap(element.data());
        if (orderModel.orderPhone == phone) {
          searchOrderPhone.add(orderModel);
          searchOrderPhonePrice += orderModel.totalPrice;
          searchOrderPhoneNum++;
          emit(ViewFileSuccessStates());
        }
      });
      emit(ViewFileSuccessStates());
    }).catchError((handleError) {
      emit(ViewFileErrorStates());
    });
  }

  //name
  List<OrderModel> searchOrderName = [];
  double searchOrderNamePrice = 0;
  int searchOrderNameNum = 0;

  void searchOrdersByName(String name) {
    emit(ViewFileLoadingStates());
    FirebaseFirestore.instance
        .collection('orders')
        .orderBy('date', descending: true)
        .get()
        .then((event) {
      searchOrderName = [];
      searchOrderNamePrice = 0;
      searchOrderNameNum = 0;
      event.docs.forEach((element) {
        OrderModel orderModel = OrderModel.fromMap(element.data());
        print(name);
        if (orderModel.orderName.toString().contains(name)) {
          searchOrderName.add(orderModel);
          searchOrderNamePrice += orderModel.totalPrice;
          searchOrderNameNum++;
          emit(ViewFileSuccessStates());
        }
      });
      emit(ViewFileSuccessStates());
    }).catchError((handleError) {
      emit(ViewFileErrorStates());
    });
  }

  //validate phone

  void validateOrdersByPhone(String phone) {
    emit(ViewFileLoadingStates()); //=order id
    FirebaseFirestore.instance
        .collection('orders')
        .orderBy('date', descending: true)
        .get()
        .then((event) {
      int num = 0;
      String date = "";
      String status = "";
      bool found = false;
      event.docs.forEach((element) {
        OrderModel orderModel = OrderModel.fromMap(element.data());
        if (orderModel.orderPhone == phone) {
          num++;
          date = orderModel.date;
          status = orderModel.statusOrder;
          found = true;
        }
      });
      String? validateOrder;
      if (found) {
        validateOrder = "number orders".tr() +
            " " +
            num.toString() +
            "\n" +
            "last order".tr() +
            " :$date" +
            "\n" +
            "Status".tr() +
            " : " +
            status;
      } else {
        validateOrder = null;
      }
      emit(OrdersHomeValidtePhoneOrderStates(validate: validateOrder));
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
    FirebaseFirestore.instance
        .collection('orders')
        .orderBy('date', descending: true)
        .snapshots()
        .listen((event) {
      todayOrders = [];
      todayOrdersPrice = 0;
      todayOrdersNumber = 0;
      event.docs.forEach((element) {
        OrderModel orderModel = OrderModel.fromMap(element.data());
        if (orderModel.date.split(' ')[0] ==
            DateTime.now().toString().split(' ')[0]) {
          if (filter == "كل الطلبات") {
            todayOrders.add(orderModel);
            todayOrdersPrice += orderModel.totalPrice;
            todayOrdersNumber++;
          }
          if (filter == orderModel.statusOrder) {
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
        .collection("cities")
        .doc(state)
        .collection('values')
        .add({'city': city}).then((value) {
      showToast(message: "تم اضافة مدينة بنجاح", state: ToastState.SUCCESS);
      emit(SocialGetUserStatusSuccessStates());
    }).catchError((onError) {
      emit(GetVedioErrorStates());
    });
  }

  List<String> cities = [];

  void getCites(String state) {
    emit(OrderGetCityLoadingStates());
    FirebaseFirestore.instance
        .collection('cities')
        .doc(state)
        .collection('values')
        .snapshots()
        .listen((event) {
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
    CollectionReference ref = FirebaseFirestore.instance.collection('states');
    DocumentReference docRef = ref.doc();
    String docId = docRef.id;
    docRef.set({
      'state': state,
      "id": docId,
      "date": DateTime.now().toString()
    }).then((value) {
      showToast(message: "تم اضافة محافظة بنجاح", state: ToastState.SUCCESS);
      emit(SocialGetUserStatusSuccessStates());
    }).catchError((onError) {
      emit(GetVedioErrorStates());
    });
  }

  void addPapers(String paper) {
    CollectionReference ref = FirebaseFirestore.instance.collection('papers');
    DocumentReference docRef = ref.doc();
    String docId = docRef.id;
    PageModel pageModel =
        PageModel(id: docId, name: paper, date: DateTime.now().toString());
    docRef.set(pageModel.toMap()).then((value) {
      showToast(message: "تم اضافة الصفحة بنجاح", state: ToastState.SUCCESS);
      emit(SocialGetUserStatusSuccessStates());
    }).catchError((onError) {
      emit(GetVedioErrorStates());
    });
  }

  List<StateModel> states = [];

  void getStates() {
    FirebaseFirestore.instance
        .collection('states')
        .orderBy('date', descending: true)
        .snapshots()
        .listen((value) {
      states = [];
      value.docs.forEach((element) {
        states.add(StateModel.fromMap(element.data()));
      });
      emit(SocialGetUserStatusSuccessStates());
    }).onError((onError) {
      emit(GetVedioErrorStates());
    });
  }

  ////////////////////////////////////////////////////
  Map<String, UserOrders> userFilterOrders = {};

  void userOrdersFilter() {
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      userFilterOrders = {};
      event.docs.forEach((element) async {
        String email = element['email'];
        String name = element['name'];
        int numToday = 0;
        int numAll = 0;
        String key = element.id;
        FirebaseFirestore.instance
            .collection('orders')
            .snapshots()
            .listen((orders) async {
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
          UserOrders userOrders = UserOrders(
            email: email,
            numOfAllOrders: numAll,
            numOfTodayOrders: numToday,
            name: name,
          );
          if (!userFilterOrders.containsKey(key)) {
            userFilterOrders[key] = userOrders;
          }
        }).onError((handleError) {
          showToast(message: handleError.toString(), state: ToastState.ERROR);
        });
      });
    }).onError((handleError) {
      showToast(message: handleError.toString(), state: ToastState.ERROR);
    });
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void addStatus(String status) {
    FirebaseFirestore.instance
        .collection('status')
        .add({'state': status}).then((value) {
      showToast(message: "تم اضافة حالة بنجاح", state: ToastState.SUCCESS);
      emit(SocialGetUserStatusSuccessStates());
    }).catchError((onError) {
      emit(GetVedioErrorStates());
    });
  }

  List<String> status = [
    'جاري الشحن',
    "تم التاكيد",
    "تسليم ناجح",
    "ملغي",
    "غير مؤكد",
    "تسليم جزئي",
    "مرتجع ناقص",
    "مرتجع كامل لدينا",
    "مرتجع لدى شركة الشحن",
    "كل الطلبات",
  ];
  List<OrderModel> editOrders = [];

  void getOrdersToEdit(String filter) {
    emit(ViewFileLoadingStates());
    FirebaseFirestore.instance
        .collection('orders')
        .orderBy('date', descending: true)
        .snapshots()
        .listen((event) {
      editOrders = [];
      event.docs.forEach((element) {
        OrderModel orderModel = OrderModel.fromMap(element.data());
        if (filter == "كل الطلبات") {
          editOrders.add(orderModel);
        } else if (filter == orderModel.statusOrder) {
          editOrders.add(orderModel);
        }
        //emit(ViewFileSuccessStates());
      });
      emit(ViewFileSuccessStates());
    }).onError((handleError) {
      emit(ViewFileErrorStates());
    });
  }

  //get orders
  List<OrderModel> orders = [];
  double totalOfAllOrders = 0;
  double totalOfAllOrdersConfirm = 0;
  int totalOfConfirmedNumber = 0;
  double totalOfConfirmedPrice = 0;

  void getOrders(String filter) {
    emit(OrdergetLoadingStates());
    FirebaseFirestore.instance
        .collection('orders')
        .orderBy('date', descending: true)
        .snapshots()
        .listen((event) {
      orders = [];
      totalOfAllOrders = 0;
      totalOfAllOrdersConfirm = 0;
      totalOfConfirmedNumber = 0;
      totalOfConfirmedPrice = 0;
      papersDetailsFilter.updateAll((key, value) => papersDetailsFilter[key] = []);
      event.docs.forEach((element) {
        OrderModel orderModel = OrderModel.fromMap(element.data());
        if (papersDetailsFilter.containsKey(orderModel.paper)) {
          papersDetailsFilter[orderModel.paper]!.add(orderModel);
        }
        if (orderModel.statusOrder == "تسليم ناجح") {
          totalOfAllOrdersConfirm += orderModel.totalPrice;
        }
        if (orderModel.statusOrder == 'جاري الشحن') {
          totalOfConfirmedPrice += orderModel.totalPrice;
          totalOfConfirmedNumber++;
        }
        if (filter == "كل الطلبات") {
          orders.add(orderModel);
          totalOfAllOrders += orderModel.totalPrice;
        }
        if (filter == orderModel.statusOrder) {
          orders.add(orderModel);
          totalOfAllOrders += orderModel.totalPrice;
        }
        emit(ViewFileSuccessStates());
      });
      emit(GetFinishedStates());
    }).onError((handleError) {
      emit(ViewFileErrorStates());
    });
  }

  Map<String, List<OrderModel>> papersDetailsFilter = {};
  List<PageModel> resPagesFilter = [];
  List<String> resPagesUnique = [];
  void getPapersFilter(String date,context) async{
    emit(GetPaperFiltermLoadingStates());
     FirebaseFirestore.instance
        .collection('orders')
        .get()
        .then((value) {
      papersDetailsFilter = {};
      resPagesFilter = [];
      resPagesUnique=[];
      value.docs.forEach((order) {
        if (date.split(" ")[0] == OrderModel.fromMap(order.data()).date.split(" ")[0]) {
          OrderModel  orderModel=OrderModel.fromMap(order.data());
          FirebaseFirestore.instance
              .collection('papers')
              .get()
              .then((value) {
            value.docs.forEach((element) async{
              if (!resPagesUnique.contains(element['name'])) {
                resPagesUnique.add(element['name']);
                resPagesFilter.add(PageModel.fromMap(element.data()));
              }
              if(orderModel.paper==element['name']) {
                if ( !papersDetailsFilter.containsKey(element['name'])) {
                   papersDetailsFilter[element['name']]=[];
                }
                if (papersDetailsFilter.containsKey(element['name'])) {
                  papersDetailsFilter[element['name']]!.add(orderModel);
                }
              }
            });
            emit(GetFileSuccessStates());

          }).catchError((onError) {
            emit(GetVedioErrorStates());
          });
        }
      });
      print(papersDetailsFilter);

      emit(GetFileSuccessStates());
    }).catchError((onError){
      emit(GetVedioErrorStates());
    });
    emit(GetFileSuccessStates());

  }

  List<String> papers = [];
  void getPapers() {
    emit(ViewFileLoadingStates());
    FirebaseFirestore.instance
        .collection('papers')
        .orderBy('date', descending: true)
        .snapshots()
        .listen((value) {
      papers = [];
      value.docs.forEach((element) {
          if (!papers.contains(element['name'])) {
            papers.add(element['name']);
          }
      });
      //getOrders('كل الطلبات');
    }).onError((onError) {
      emit(GetVedioErrorStates());
    });
  }

  //get orders
  List<OrderModel> ordersTest = [];
  double totalOfAllOrdersTest = 0;
  double totalOfAllOrdersConfirmTest = 0;
  int totalOfConfirmedNumberTest = 0;
  double totalOfConfirmedPriceTest = 0;
  bool isMoreData = true;
  bool isLoading = false;
  DocumentSnapshot? last;
  int len = 0;

  void firstLoad(String filter, int limit) {
    FirebaseFirestore.instance
        .collection('orders')
        .orderBy('date')
        .limit(limit)
        .snapshots()
        .listen((event) {
      isMoreData = true;
      ordersTest = [];
      totalOfAllOrdersTest = 0;
      totalOfAllOrdersConfirmTest = 0;
      totalOfConfirmedNumberTest = 0;
      totalOfConfirmedPriceTest = 0;
      isLoading = false;
      last = event.docs.last;
      len = event.docs.length;
      if (limit > len) {
        print("ggggggggggggggggggggg");
        isMoreData = false;
      }
      // print('$len ppppppppppppppppp');
      event.docs.forEach((element) {
        OrderModel orderModel = OrderModel.fromMap(element.data());
        if (papersDetailsFilter.containsKey(orderModel.paper)) {
          papersDetailsFilter[orderModel.paper]!.add(orderModel);
        }
        if (orderModel.statusOrder == "تسليم ناجح") {
          totalOfAllOrdersConfirmTest += orderModel.totalPrice;
        }
        if (orderModel.statusOrder == 'جاري الشحن') {
          totalOfConfirmedPriceTest += orderModel.totalPrice;
          totalOfConfirmedNumberTest++;
        }
        if (filter == orderModel.statusOrder) {
          ordersTest.add(orderModel);
          totalOfAllOrdersTest += orderModel.totalPrice;
        }
        emit(ViewFileSuccessStates());
      });
      if (filter == "Select".tr()) {
        event.docs.forEach((element) {
          OrderModel orderModel = OrderModel.fromMap(element.data());
          ordersTest.add(orderModel);
          totalOfAllOrdersTest += orderModel.totalPrice;
          emit(ViewFileSuccessStates());
        });
      }
      emit(ViewFileSuccessStates());
    }).onError((handleError) {
      emit(ViewFileErrorStates());
    });
  }

  void more(String filter, int limit, bool change, context) {
    if (isMoreData) {
      isLoading = true;
      emit(ViewFileLoadingStates());
      FirebaseFirestore.instance
          .collection('orders')
          .orderBy('date')
          .limit(limit)
          .startAfterDocument(last!)
          .snapshots()
          .listen((event) {
        isLoading = false;
        isMoreData = true;
        len = event.docs.length;
        try {
          last = event.docs.last;
        } catch (e) {
          isMoreData = false;
        }
        if (limit > len) {
          print("ggggggggggggggggggggg");
          isMoreData = false;
        }
        event.docs.forEach((element) {
          OrderModel orderModel = OrderModel.fromMap(element.data());
          if (papersDetailsFilter.containsKey(orderModel.paper)) {
            papersDetailsFilter[orderModel.paper]!.add(orderModel);
          }
          if (orderModel.statusOrder == "تسليم ناجح") {
            totalOfAllOrdersConfirmTest += orderModel.totalPrice;
          }
          if (orderModel.statusOrder == 'جاري الشحن') {
            totalOfConfirmedPriceTest += orderModel.totalPrice;
            totalOfConfirmedNumberTest++;
          }
          if (filter == orderModel.statusOrder) {
            ordersTest.add(orderModel);
            totalOfAllOrdersTest += orderModel.totalPrice;
          }
          emit(ViewFileSuccessStates());
        });
        if (filter == "Select".tr()) {
          event.docs.forEach((element) {
            OrderModel orderModel = OrderModel.fromMap(element.data());
            ordersTest.add(orderModel);
            totalOfAllOrdersTest += orderModel.totalPrice;
            emit(ViewFileSuccessStates());
          });
        }
        emit(ViewFileSuccessStates());
      }).onError((handleError) {
        emit(ViewFileErrorStates());
      });

      emit(SocialGetUserStatusSuccessStates());
    } else {
      print("No More Order");
      String text = "No More Data".tr();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.blueGrey,
      ));
    }
    emit(SocialGetUserStatusSuccessStates());
  }

  double searchCatPrice = 0;

  void getPriceCategory(String cat) {
    emit(ViewFileLoadingStates());
    FirebaseFirestore.instance
        .collection('categories')
        .orderBy('date', descending: true)
        .get()
        .then((event) {
      for (var element in event.docs) {
        CategoryModel categoryModel = CategoryModel.fromMap(element.data());
        if (categoryModel.catName == cat) {
          searchCatPrice = categoryModel.price;
          emit(ViewFileSuccessStates());
          break;
        }
      }
      emit(ViewFileSuccessStates());
    }).catchError((handleError) {
      emit(ViewFileErrorStates());
    });
  }

//add categories
  void addImport({required sourceName, required context}) {
    CollectionReference ref = FirebaseFirestore.instance.collection('imports');
    DocumentReference docRef = ref.doc();
    String docId = docRef.id;
    String text = "Source Uploaded Successfully".tr();
    ImportModel importModel = ImportModel(import: sourceName, id: docId);
    docRef.set(importModel.toMap()).then((value) {
      showToast(message: text, state: ToastState.SUCCESS);
      emit(GetFileSuccessStates());
    }).catchError((onError) {
      print('pppppppppppppppppppppppp${onError.toString()}');
      showToast(message: onError.toString(), state: ToastState.WARNING);
      emit(GetFileErrorStates());
    });
  }

  List<ImportModel> imports = [];

  void getImport() {
    FirebaseFirestore.instance
        .collection('imports')
        .snapshots()
        .listen((value) {
      imports = [];
      value.docs.forEach((element) {
        imports.add(ImportModel.fromMap(element.data()));
      });
      emit(GetFileSuccessStates());
    }).onError((onError) {
      print('pppppppppppppppppppppppp${onError.toString()}');
      showToast(message: onError.toString(), state: ToastState.WARNING);
      emit(GetFileErrorStates());
    });
  }

//add categories
  void addSource(
      {required date,
      required sourceName,
      required num,
      required total,
      required price,
      required context}) {
    SourceModel sourceModel =
        SourceModel(date: date, price: price, num: num, total: total);
    String text = "Source Uploaded Successfully".tr();
    FirebaseFirestore.instance
        .collection('sources')
        .doc(sourceName)
        .collection('fatora')
        .add(sourceModel.toMap())
        .then((value) {
      showToast(message: text, state: ToastState.SUCCESS);
      emit(GetFileSuccessStates());
    }).catchError((onError) {
      print('pppppppppppppppppppppppp${onError.toString()}');
      showToast(message: onError.toString(), state: ToastState.WARNING);
      emit(GetFileErrorStates());
    });
  }

  List<SourceModel> sources = [];

  void getSource(String name) {
    FirebaseFirestore.instance
        .collection('sources')
        .doc(name)
        .collection('fatora')
        .get()
        .then((value) {
      sources = [];
      value.docs.forEach((element) {
        sources.add(SourceModel.fromMap(element.data()));
        //emit(GetFileSuccessStates());
      });
      emit(GetFileSuccessStates());
    }).catchError((onError) {
      print('pppppppppppppppppppppppp${onError.toString()}');
      showToast(message: onError.toString(), state: ToastState.WARNING);
      emit(GetFileErrorStates());
    });
  }

  ////////////////////////////////////////////////////////////////
//group
  //add massages group
  void addMassageToGroup({
    required String text,
    required String senderId,
    required String dateTime,
    required String name,
    required String createdAt,
  }) {
    MassageModelGroup model = MassageModelGroup(
      senderId: senderId,
      text: text,
      dateTime: dateTime,
      createdAt: createdAt,
      name: name,
    );
    FirebaseFirestore.instance
        .collection('group')
        .doc('chat')
        .collection('massages')
        .add(model.toMap())
        .then((value) {
      emit(SocialAddMassageSuccessStates());
    }).catchError((onError) {
      showToast(message: onError.toString(), state: ToastState.ERROR);
      emit(SocialAddMassageErrorStates());
    });
  }

  List<MassageModelGroup> massagesGroup = [];

  //get massages
  void getMassageGroup() {
    FirebaseFirestore.instance
        .collection('group')
        .doc('chat')
        .collection('massages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((event) {
      massagesGroup = [];
      event.docs.forEach((element) {
        massagesGroup.add(MassageModelGroup.fromJson(element.data()));
      });
      emit(GetFileSuccessStates());
    }).onError((error) {
      showToast(message: onError.toString(), state: ToastState.ERROR);
      emit(GetFileErrorStates());
    });
  }

  void updateOrderCharging(
      {required String orderName,
        required String conservation,
        required String city,
        required String address,
        required String type,
        required String barCode,
        required String employerName,
        required String employerPhone,
        required String employerEmail,
        required String orderPhone,
        required String serviceType,
        required String statusOrder,
        required String notes,
        required String paper,
        required bool isSelected,
        required String editEmail,
        required String date,
        required int number,
        required double price,
        required double totalPrice,
        required double salOfCharging,
        required context}) async {
    OrderModel orderModel = OrderModel(
      employerEmail: employerEmail,
      orderPhone: orderPhone,
      statusOrder: statusOrder,
      serviceType: serviceType,
      notes: notes,
      editEmail: editEmail,
      orderName: orderName,
      conservation: conservation,
      city: city,
      address: address,
      type: type,
      paper: paper,
      isSelected: isSelected,
      barCode: barCode,
      employerName: employerName,
      employerPhone: employerPhone,
      date: date,
      number: number,
      price: price,
      totalPrice: totalPrice,
      salOfCharging: salOfCharging,
    );
    FirebaseFirestore.instance
        .collection('orders')
        .doc(barCode)
        .update(orderModel.toMap())
        .then((value) {
    }).catchError((onError) {
      showToast(message: onError.toString(), state: ToastState.ERROR);
      emit(OrdersEditProfileErrorStates());
    });
  }
  ////////////////////////
  double progress = 0.0;
  void createExcelSheet(context) async {
    emit(GhhhetFinishedStates());
    excel.Workbook workbook = excel.Workbook();
    excel.Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByIndex(1, 1).setText("Consignee_Name");
    sheet.getRangeByIndex(1, 2).setText("City");
    sheet.getRangeByIndex(1, 3).setText("Area");
    sheet.getRangeByIndex(1, 4).setText("Address");
    sheet.getRangeByIndex(1, 5).setText("Phone_1");
    sheet.getRangeByIndex(1, 6).setText("Order");
    sheet.getRangeByIndex(1, 7).setText("Employee_Name");
    sheet.getRangeByIndex(1, 8).setText("product");
    sheet.getRangeByIndex(1, 9).setText("Charging");
    sheet.getRangeByIndex(1, 10).setText("Item_Name");
    sheet.getRangeByIndex(1, 11).setText("Quantity");
    sheet.getRangeByIndex(1, 12).setText("Item_Description");
    sheet.getRangeByIndex(1, 13).setText("COD");
    sheet.getRangeByIndex(1, 14).setText("Weight");
    sheet.getRangeByIndex(1, 15).setText("Size");
    sheet.getRangeByIndex(1, 16).setText("Service_Type");
    sheet.getRangeByIndex(1, 17).setText("notes");
    for (int i = 0; i < orders.length; i++) {
      updateOrderCharging(
          orderName: orders[i].orderName,
          paper: orders[i].paper,
          conservation: orders[i].conservation,
          isSelected: orders[i].isSelected,
          statusOrder: 'جاري الشحن',
          city: orders[i].city,
          editEmail: orders[i].editEmail,
          address: orders[i].address,
          type: orders[i].type,
          barCode: orders[i].barCode,
          employerName: orders[i].employerName,
          employerPhone: orders[i].employerPhone,
          employerEmail: orders[i].employerEmail,
          orderPhone: orders[i].orderPhone,
          serviceType: orders[i].serviceType,
          notes: orders[i].notes,
          date: orders[i].date,
          number: orders[i].number,
          price: orders[i].price,
          totalPrice: orders[i].totalPrice,
          salOfCharging: orders[i].salOfCharging,
          context: context);
      sheet
          .getRangeByIndex(i + 2, 1)
          .setText(orders[i].orderName);
      sheet
          .getRangeByIndex(i + 2, 2)
          .setText(orders[i].conservation);
      sheet
          .getRangeByIndex(i + 2, 3)
          .setText(orders[i].city);
      sheet
          .getRangeByIndex(i + 2, 4)
          .setText(orders[i].address);
      sheet
          .getRangeByIndex(i + 2, 5)
          .setText(orders[i].orderPhone);
      sheet.getRangeByIndex(i + 2, 6).setText(" ");
      sheet
          .getRangeByIndex(i + 2, 7)
          .setText(orders[i].employerName);
      sheet.getRangeByIndex(i + 2, 8).setText(" ");
      sheet.getRangeByIndex(i + 2, 9).setText(" ");
      sheet
          .getRangeByIndex(i + 2, 10)
          .setText(orders[i].type);
      sheet
          .getRangeByIndex(i + 2, 11)
          .setValue(orders[i].number);
      sheet.getRangeByIndex(i + 2, 12).setText(" ");
      sheet
          .getRangeByIndex(i + 2, 13)
          .setNumber(orders[i].totalPrice);
      sheet.getRangeByIndex(i + 2, 14).setText(" ");
      sheet.getRangeByIndex(i + 2, 15).setText(" ");
      sheet
          .getRangeByIndex(i + 2, 16)
          .setText(orders[i].serviceType);
      sheet
          .getRangeByIndex(i + 2, 17)
          .setText(orders[i].notes);
    }
    await Future.delayed(const Duration(seconds: 80))
    .then((value)async{
      //save
      String text = "Edited Successfully...".tr();
      showToast(message: text, state: ToastState.SUCCESS);
      final List<int> bytes = workbook.saveAsStream();
      await workbook.save();
      workbook.dispose();
      final String path = (await getApplicationCacheDirectory()).path;
      final String fileName = '$path/orders.xlsx';
      final File file = File(fileName);
      await file.writeAsBytes(
      bytes,
      flush: true,
      );
      emit(GetFinishedStates());
      OpenFile.open(fileName);
    })
    .catchError((onError){

    });
  }

}
