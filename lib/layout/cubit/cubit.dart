// ignore_for_file: avoid_function_literals_in_foreach_calls, non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/models/admin_model.dart';
import 'package:orders/models/category_model.dart';
import 'package:orders/models/order_model.dart';
import 'package:orders/models/user_profile.dart';
import 'package:orders/modules/admin_screen/orders/orders.dart';
import 'package:orders/modules/admin_screen/search_by_date/search.dart';
import 'package:orders/modules/admin_screen/today_orders/orders.dart';
import 'package:orders/shared/components/components.dart';
import 'package:orders/shared/network/local/cashe_helper.dart';

// ignore_for_file: avoid_print
class OrdersHomeCubit extends Cubit<OrdersHomeStates> {
  OrdersHomeCubit() : super(OrdersHomeInitialStates());

  static OrdersHomeCubit get(context) => BlocProvider.of(context);
  List<Widget>screens=[
    DisplayOrdersScreen(),
    const TodayOrders(),
    SearchByDateScreen(),
  ];

  //bottom nav
  int currentIndex=0;
  void changeNav(int idx){
    currentIndex=idx;
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

  //admins
  AdminModel? currentAdmin;
  List<AdminModel> admins = [];

  void getAdminsProfile() {
    emit(GetFileLoadingStates());
    FirebaseFirestore.instance.collection("admins").get().then((value) {
      admins=[];
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

  //get orders
  List<OrderModel> orders = [];
  double totalOfAllOrders = 0;

  void getOrders() {
    emit(ViewFileLoadingStates());
    FirebaseFirestore.instance
        .collection('orders')
        .orderBy('date')
        .snapshots()
        .listen((event) {
      orders = [];
      totalOfAllOrders = 0;
      event.docs.forEach((element) {
        OrderModel orderModel = OrderModel.fromMap(element.data());
        orders.add(orderModel);
        totalOfAllOrders += orderModel.totalPrice;
      });
      emit(ViewFileSuccessStates());
    }).onError((handleError) {
      emit(ViewFileErrorStates());
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
      required String date,
      required int number,
      required double price,
      required double totalPrice,
      required double salOfCharging,
      required context}) async {
    OrderModel orderModel = OrderModel(
        employerEmail: employerEmail,
        orderPhone: orderPhone,
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
        .set(orderModel.toMap())
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
  void addOrders(
      {required String orderName,
      required String conservation,
      required String city,
      required String address,
      required String type,
      required String employerName,
      required String employerPhone,
      required String employerEmail,
      required String orderPhone,
      required int number,
      required double price,
      required double totalPrice,
      required double salOfCharging,
      required context}) {
    OrderModel orderModel = OrderModel(
        orderPhone: orderPhone,
        orderName: orderName,
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
        salOfCharging: salOfCharging);
    CollectionReference ref = FirebaseFirestore.instance.collection('orders');
    DocumentReference docRef = ref.doc();
    String docId = docRef.id;
    orderModel.barCode = docId;
    String text = "Order Uploaded Successfully".tr();
    ref.add(orderModel.toMap()).then((value) {
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
          style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
        ),
        backgroundColor: Colors.pink,
      ));
      Navigator.of(context);

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
      context.setLocale(const Locale('en','US'));
    } else {
      SharedHelper.save(value: 'arabic', key: 'lang');
      context.setLocale(const Locale('ar','SA'));
    }
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
      });
      emit(ViewFileSuccessStates());
    }).onError((handleError) {
      emit(ViewFileErrorStates());
    });
  }

//add categories
  void addCategories(
      {required date,
      required catName,
      required salOfCharging,
      required notes,
      required totalPrice,
      required price,
      required amount,
      required context}) {
    CategoryModel categoryModel = CategoryModel(
        date: date,
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

    ref.add(categoryModel.toMap()).then((value) {
      showToast(message: text, state: ToastState.SUCCESS);
      emit(GetFileSuccessStates());
    }).catchError((onError) {
      print('pppppppppppppppppppppppp${onError.toString()}');
      showToast(message: onError.toString(), state: ToastState.WARNING);
      emit(GetFileErrorStates());
    });
  }

  //search barcode
  OrderModel? searchOrderBarcode;
  void searchOrdersByBarcode(String barcode){
    emit(ViewFileLoadingStates());//=order id
    FirebaseFirestore.instance
        .collection('orders')
        .orderBy('date')
        .get()
        .then((event) {
      event.docs.forEach((element) {
        OrderModel orderModel=OrderModel.fromMap(element.data());
       if(orderModel.barCode==barcode){
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
  List<OrderModel>searchOrdersDate=[];
  void searchOrdersByDate(String date,TimeOfDay firstTime,TimeOfDay lastTime){
    emit(ViewFileLoadingStates());
    FirebaseFirestore.instance
        .collection('orders')
        .orderBy('date')
        .get()
        .then((event) {
       searchOrdersDate=[];
      int tempHourTime,tempHourLastTime,tempHourFirstTime;
      event.docs.forEach((element) {
        OrderModel orderModel=OrderModel.fromMap(element.data());
        if(orderModel.date.split(' ')[0]==date.split(' ')[0]){
          TimeOfDay time=TimeOfDay.fromDateTime(DateTime.parse(orderModel.date));
          tempHourTime=time.hour;
          tempHourFirstTime=firstTime.hour;
          tempHourLastTime=lastTime.hour;
          if(tempHourTime>12){
            tempHourTime-=12;
          }
          if(tempHourFirstTime>12){
            tempHourFirstTime-=12;
          }
          if(tempHourLastTime>12){
            tempHourLastTime-=12;
          }
          if(tempHourTime>tempHourFirstTime&&tempHourTime<tempHourLastTime){
            searchOrdersDate.add(orderModel);
          }
          if(tempHourTime==tempHourFirstTime&&time.minute>=firstTime.minute){
            searchOrdersDate.add(orderModel);
          }
          if(tempHourTime==tempHourLastTime&&time.minute<=lastTime.minute){
            searchOrdersDate.add(orderModel);
          }
        }
      });
      emit(ViewFileSuccessStates());
    }).catchError((handleError) {
      emit(ViewFileErrorStates());
    });
  }
//today order
  List<OrderModel>todayOrders=[];
  void getTodayOrders(){
    emit(ViewFileLoadingStates());//=order id
    FirebaseFirestore.instance
        .collection('orders')
        .orderBy('date')
        .where('date',isEqualTo: DateTime.now())
        .snapshots()
        .listen((event) {
      todayOrders = [];
      event.docs.forEach((element) {
        OrderModel orderModel = OrderModel.fromMap(element.data());
        todayOrders.add(orderModel);
      });
      emit(ViewFileSuccessStates());
    }).onError((handleError) {
      emit(ViewFileErrorStates());
    });
  }

}
