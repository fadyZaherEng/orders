// ignore_for_file: avoid_function_literals_in_foreach_calls, non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:orders/modules/admin_screen/search_using_barcode/search.dart';
import 'package:orders/modules/admin_screen/today_orders/orders.dart';
import 'package:orders/shared/components/components.dart';
import 'package:orders/shared/lang/arabic.dart';
import 'package:orders/shared/lang/english.dart';
import 'package:orders/shared/network/local/cashe_helper.dart';

// ignore_for_file: avoid_print
class OrdersHomeCubit extends Cubit<OrdersHomeStates> {
  OrdersHomeCubit() : super(OrdersHomeInitialStates());

  static OrdersHomeCubit get(context) => BlocProvider.of(context);
  List<Widget>screens=[
    DisplayOrdersScreen(),
    TodayOrders(),
    const SearchByDateScreen(),
  ];
  List<String>titles=[
    SharedHelper.get(key: 'lang')=='arabic'?arabic["Total Price: "]:english['Total Price: '],
    SharedHelper.get(key: 'lang')=='arabic'?arabic["Today Orders"]:english["Today Orders"] ,
    SharedHelper.get(key: 'lang')=='arabic'?arabic['Search By Date']:english['Search By Date'],

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
        String text = SharedHelper.get(key: 'lang') == 'arabic'
            ? arabic["Appear Successfully"]
            : english["Appear Successfully"];
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
        String text = SharedHelper.get(key: 'lang') == 'arabic'
            ? arabic["Appear Successfully"]
            : english["Appear Successfully"];
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
        String text = SharedHelper.get(key: 'lang') == 'arabic'
            ? arabic["Appear Successfully"]
            : english["Appear Successfully"];
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
        String text = SharedHelper.get(key: 'lang') == 'arabic'
            ? arabic["Appear Successfully"]
            : english["Appear Successfully"];
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
        String text = SharedHelper.get(key: 'lang') == 'arabic'
            ? arabic["Appear Successfully"]
            : english["Appear Successfully"];
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
      required String orderId,
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
        orderId: orderId,
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
        .doc(orderId)
        .set(orderModel.toMap())
        .then((value) {
      String text = SharedHelper.get(key: 'lang') == 'arabic'
          ? arabic["Edited Successfully..."]
          : english["Edited Successfully..."];
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
      required context}) {
    OrderModel orderModel = OrderModel(
        orderPhone: orderPhone,
        orderName: orderName,
        employerEmail: employerEmail,
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
    CollectionReference ref = FirebaseFirestore.instance.collection('orders');
    DocumentReference docRef = ref.doc();
    String docId = docRef.id;
    orderModel.orderId = docId;
    String text = SharedHelper.get(key: 'lang') == 'arabic'
        ? arabic["Order Uploaded Successfully"]
        : english["Order Uploaded Successfully"];
    ref.add(orderModel.toMap()).then((value) {
      showToast(message: text, state: ToastState.SUCCESS);
      emit(GetFileSuccessStates());
    }).catchError((onError) {
      print('pppppppppppppppppppppppp${onError.toString()}');
      showToast(message: onError.toString(), state: ToastState.WARNING);
      emit(GetFileErrorStates());
    });
  }

//remove orders
  void removeOrders({required String docId, required context}) {
    emit(RejectFileLoadingStates());
    FirebaseFirestore.instance
        .collection('orders')
        .doc(docId)
        .delete()
        .then((value) {
      String text = SharedHelper.get(key: 'lang') == 'arabic'
          ? arabic["Deleted Successfully"]
          : english["Deleted Successfully"];
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
  void langChange() {
    if (SharedHelper.get(key: 'lang') == 'arabic') {
      SharedHelper.save(value: 'english', key: 'lang');
    } else {
      SharedHelper.save(value: 'arabic', key: 'lang');
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
    String text = SharedHelper.get(key: 'lang') == 'arabic'
        ? arabic["Category Uploaded Successfully"]
        : english["Category Uploaded Successfully"];

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
  void searchOrdersByDate(String date){
    emit(ViewFileLoadingStates());
    FirebaseFirestore.instance
        .collection('orders')
        .orderBy('date')
       .where('date',isEqualTo: date)
        .get()
        .then((event) {
      event.docs.forEach((element) {
        OrderModel orderModel=OrderModel.fromMap(element.data());
        searchOrdersDate.add(orderModel);
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






















////////////////////////////////////////////////////////////////////////////////////////

//   File? profileImage;
//
//   void getProfileImage() async {
//     emit(OrdersUpdateProfileDataWaitingImageToFinishUploadStates());
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       profileImage = File(pickedFile.path);
//       uploadProfileImage();
//       //   emit(SocialGetProfileImageSuccessStates());
//     } else {
//       showToast(message: 'No Image Selected', state: ToastState.WARNING);
//       print('eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee$onError');
//       emit(OrdersUpdateProfileDataWaitingImageToFinishUploadErrorStates());
//     }
//   }
//
//   String? profileImageUrl;
//
//   void uploadProfileImage() {
//     FirebaseStorage.instance
//         .ref()
//         .child(
//             'users/${Uri.file(profileImage!.path).pathSegments.length / DateTime.now().millisecond}')
//         .putFile(profileImage!)
//         .then((val) {
//       val.ref.getDownloadURL().then((value) {
//         profileImageUrl = value;
//         emit(OrdersUpdateProfileDataWaitingImageToFinishSuccessStates());
//       }).catchError((onError) {
//         print('eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee$onError');
//         emit(OrdersUpdateProfileDataWaitingImageToFinishErrorStates());
//       });
//     }).catchError((onError) {
//       print('eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee$onError');
//       emit(OrdersUpdateProfileDataWaitingImageToFinishErrorStates());
//     });
//   }
//
//   //get online w offline
//   ///////////////////////////////////////////////////
//   //get all users
//   Set<UserProfile> users = {};
//   Map<String, String> usersStatus = {};
//
//   void getAllUsers() async {
//     emit(OrdersGetAllUsersLoadingStates());
//     FirebaseFirestore.instance
//         .collection('users')
//         .orderBy('name')
//         .snapshots()
//         .listen((event) async {
//       users.clear();
//       usersStatus.clear();
//       for (var element in event.docs) {
//         if (element.data()['uId'] != SharedHelper.get(key: 'uid') &&
//             element.data()['status'] &&
//             !element.data()['block_final']) {
//           DocumentSnapshot<Map<String, dynamic>> Status =
//               await FirebaseFirestore.instance
//                   .collection('users')
//                   .doc(element.data()['uId'])
//                   .collection('userStatus')
//                   .doc('status')
//                   .get();
//             users.add(UserProfile.fromJson(element.data()));
//             usersStatus[element.data()['uId']] = Status['userStatus'];
//         }
//       }
//       emit(OrdersGetAllUsersSuccessStates());
//     }).onError((handleError) {
//       emit(OrdersGetAllUsersErrorStates());
//     }); //uid
//   }
//
//   //get user status
//   void getUserStatus() async {
//     await FirebaseFirestore.instance
//         .collection('users')
//         .orderBy('name')
//         .get()
//         .then((event) {
//       usersStatus.clear();
//       event.docs.forEach((element) async {
//         FirebaseFirestore.instance
//             .collection('users')
//             .doc(element.id)
//             .collection('userStatus')
//             .doc('status')
//             .snapshots()
//             .listen((event) {
//           if (element.data()['uId'] != SharedHelper.get(key: 'uid') &&
//               element.data()['status'] &&
//               !element.data()['block_final']) {
//             usersStatus[element.data()['uId']] = event['userStatus'];
//             emit(SocialGetUserStatusSuccessStates());
//           }
//         });
//       });
//       emit(SocialGetUserStatusSuccessStates());
//     }).catchError((onError) {
//       emit(SocialGetUserStatusErrorStates());
//     });
//   }
//
//   ///////////////////////////////////////////////////

//   //add massages
//   void addMassage(
//       {required String receiverId,
//       required String? text,
//       required String dateTime,
//       required String createdAt,
//       String? chatImage}) {
//     MassageModel model = MassageModel(
//         senderId: userProfile!.uId,
//         receiverId: receiverId,
//         text: text,
//         dateTime: dateTime,
//         createdAt: createdAt,
//         image: chatImage);
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(userProfile!.uId)
//         .collection('chats')
//         .doc(receiverId)
//         .collection('massages')
//         .add(model.toMap())
//         .then((value) {
//       emit(SocialAddMassageSuccessStates());
//     }).catchError((onError) {
//       emit(SocialAddMassageErrorStates());
//     });
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(receiverId)
//         .collection('chats')
//         .doc(userProfile!.uId)
//         .collection('massages')
//         .add(model.toMap())
//         .then((value) {
//       emit(SocialAddMassageSuccessStates());
//     }).catchError((onError) {
//       emit(SocialAddMassageErrorStates());
//     });
//   }
//
//   List<MassageModel> massages = [];
//   List<String> massagesId = [];
//
//   //get massages
//   void getMassage({
//     required String receiverId,
//   }) {
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(userProfile!.uId)
//         .collection('chats')
//         .doc(receiverId)
//         .collection('massages')
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .listen((event) {
//       massages = [];
//       massagesId = [];
//       event.docs.forEach((element) {
//         massages.add(MassageModel.fromJson(element.data()));
//         massagesId.add(element.id);
//       });
//       emit(OrdersGetMassageSuccessStates());
//     }).onError((error) {
//       emit(OrdersGetMassageErrorStates());
//     });
//   }
//
//   void getOrdersImage({
//     required String receiverId,
//     required String? text,
//     required String dateTime,
//     required String createdAt,
//   }) async {
//     emit(OrdersUploadImageLoadingSuccessStates());
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       uploadOrdersImage(
//         chatImage: File(pickedFile.path),
//         text: text,
//         dateTime: dateTime,
//         createdAt: createdAt,
//         receiverId: receiverId,
//       );
//     } else {
//       showToast(message: 'No Orders Image Selected', state: ToastState.WARNING);
//       emit(OrdersUploadImageLoadingErrorStates());
//     }
//   }
//
//   void uploadOrdersImage({
//     required File chatImage,
//     required String receiverId,
//     required String? text,
//     required String dateTime,
//     required String createdAt,
//   }) {
//     FirebaseStorage.instance
//         .ref()
//         .child(
//             'chats/${Uri.file(chatImage.path).pathSegments.length / DateTime.now().millisecondsSinceEpoch}')
//         .putFile(chatImage)
//         .then((val) {
//       val.ref.getDownloadURL().then((value) {
//         addMassage(
//             receiverId: receiverId,
//             text: text,
//             dateTime: dateTime,
//             createdAt: createdAt,
//             chatImage: value.toString());
//       }).catchError((onError) {
//         emit(OrdersUploadImageLoadingErrorStates());
//       });
//     }).catchError((onError) {
//       emit(OrdersUploadImageLoadingErrorStates());
//     });
//   }
//
//   //delete massage from me
//   void deleteMassageFromMe({
//     required String receiverId,
//     required String massageId,
//   }) {
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(userProfile!.uId)
//         .collection('chats')
//         .doc(receiverId)
//         .collection('massages')
//         .doc(massageId)
//         .delete()
//         .then((value) {
//       emit(SocialDeleteMassageSuccessStates());
//     }).catchError((onError) {
//       emit(SocialDeleteMassageErrorStates());
//     });
//   }
//
// //delete massage from all
//   void deleteMassageFromAll({
//     required String receiverId,
//     required String massageId,
//   }) {
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(userProfile!.uId)
//         .collection('chats')
//         .doc(receiverId)
//         .collection('massages')
//         .doc(massageId)
//         .delete()
//         .then((value) {
//       emit(SocialDeleteMassageSuccessStates());
//     }).catchError((onError) {
//       emit(SocialDeleteMassageErrorStates());
//     });
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(receiverId)
//         .collection('chats')
//         .doc(userProfile!.uId)
//         .collection('massages')
//         .doc(massageId)
//         .delete()
//         .then((value) {
//       emit(SocialDeleteMassageSuccessStates());
//     }).catchError((onError) {
//       emit(SocialDeleteMassageErrorStates());
//     });
//   }
//

//
//   void changeSettings(context) {
//     Navigator.pop(context);
//     changeNav(2);
//   }
//
//   ///////////////////lectures
//   void getPDF({required String name, required context}) async {
//     emit(GetFileLoadingStates());
//     FilePickerResult? result = await FilePicker.platform
//         .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
//     if (result != null) {
//       File pick = File(result.files.single.path.toString());
//       var file = pick.readAsBytesSync();
//       FirebaseStorage.instance
//           .ref()
//           .child('lectures/${DateTime.now().millisecondsSinceEpoch}')
//           .child('/.pdf')
//           .putData(file)
//           .then((val) {
//         val.ref.getDownloadURL().then((value) {
//           storeInFirestore(
//               link: value.toString(), pdfName: name, context: context);
//         }).catchError((onError) {
//           showToast(message: onError.toString(), state: ToastState.WARNING);
//           emit(GetFileErrorStates());
//         });
//       }).catchError((onError) {
//         showToast(message: onError.toString(), state: ToastState.WARNING);
//         emit(GetFileErrorStates());
//       });
//     } else {
//       showToast(message: 'No File Selected', state: ToastState.WARNING);
//       emit(GetFileSuccessStates());
//     }
//   }
//
//   void storeInFirestore({
//     required String link,
//     required String pdfName,
//     required context,
//   }) {
//     FileModel model = FileModel(name: pdfName, link: link);
//     FirebaseFirestore.instance
//         .collection('lectures')
//         .add(model.toMap())
//         .then((value) {
//       showToast(
//           message: 'File Uploaded Successfully', state: ToastState.SUCCESS);
//       emit(GetFileSuccessStates());
//     }).catchError((onError) {
//       showToast(message: onError.toString(), state: ToastState.WARNING);
//       emit(GetFileErrorStates());
//     });
//   }
//

//
//   ///////////////////lectures using user
//   void getPDFUsingUser({
//     required String name,
//     required String username,
//     required String date,
//     required context,
//   }) async {
//     emit(GetFileLoadingStates());
//     FilePickerResult? result = await FilePicker.platform
//         .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
//     if (result != null) {
//       File pick = File(result.files.single.path.toString());
//       var file = pick.readAsBytesSync();
//       FirebaseStorage.instance
//           .ref()
//           .child('lectures/${DateTime.now().millisecondsSinceEpoch}')
//           .child('/.pdf')
//           .putData(file)
//           .then((val) {
//         val.ref.getDownloadURL().then((value) {
//           storeInFirestoreUsingUser(
//               link: value.toString(),
//               pdfName: name,
//               username: username,
//               date: date,
//               context: context);
//         }).catchError((onError) {
//           print('jjjjjjjjjjjjjjjjjjjjjjjjj${onError.toString()}');
//           showToast(message: onError.toString(), state: ToastState.ERROR);
//           emit(GetFileErrorStates());
//         });
//       }).catchError((onError) {
//         print('xxxxxxxxxxxxxxxxxxxxxxxxxx${onError.toString()}');
//         showToast(message: onError.toString(), state: ToastState.WARNING);
//         emit(GetFileErrorStates());
//       });
//     } else {
//       showToast(message: 'No File Selected', state: ToastState.WARNING);
//       print('ccccccccccccccccccccccc${onError.toString()}');
//       emit(GetFileErrorStates());
//     }
//   }
//

//   List<FileModelUser> lecturesUsingUser = [];
//   List<String> lecturesUsingUserId = [];
//   void getLecturesUsingUser() {
//     emit(ViewFileLoadingStates());
//     FirebaseFirestore.instance
//         .collection('lecturesUsingUser')
//         .snapshots()
//         .listen((event) {
//       lecturesUsingUser = [];
//       lecturesUsingUserId = [];
//       event.docs.forEach((element) {
//         lecturesUsingUser.add(FileModelUser.fromJson(element.data()));
//         lecturesUsingUserId.add(element.id);
//       });
//       emit(ViewFileSuccessStates());
//     }).onError((handleError) {
//       print('xxxxxxxxxxxxxxxxxxxxrrrrrrrrrrrr${onError.toString()}');
//       emit(ViewFileErrorStates());
//     });
//   }
//
//   //accept lecture from admin
//   void accept({required String pdfId}) {
//     {
//       emit(AcceptFileLoadingStates());
//       FirebaseFirestore.instance
//           .collection('lecturesUsingUser')
//           .doc(pdfId)
//           .get()
//           .then((value) {
//         FileModel model =
//             FileModel(name: value.data()!['name'], link: value.data()!['link']);
//         FirebaseFirestore.instance
//             .collection('lectures')
//             .add(model.toMap())
//             .then((value) async {
//           await FirebaseFirestore.instance
//               .collection('lecturesUsingUser')
//               .doc(pdfId)
//               .delete();
//           emit(AcceptFileSuccessStates());
//         }).catchError((onError) {
//           emit(AcceptFileErrorStates());
//         });
//       }).catchError((onError) {
//         emit(AcceptFileErrorStates());
//       });
//     }
//   }
//
//   //reject lecture from admin
//   void reject({required String pdfId}) {
//     emit(RejectFileLoadingStates());
//     FirebaseFirestore.instance
//         .collection('lecturesUsingUser')
//         .doc(pdfId)
//         .delete()
//         .then((value) {
//       emit(RejectFileSuccessStates());
//     }).catchError((onError) {
//       emit(RejectFileErrorStates());
//     });
//   }
//
//   List<FileModel> searchLecture = [];
//   //search lecture
//   void searchLectures(String name) {
//     emit(ViewFileLoadingStates());
//     FirebaseFirestore.instance.collection('lectures').get().then((value) {
//       searchLecture = [];
//       value.docs.forEach((element) {
//         if (element
//             .data()['name']
//             .toString()
//             .toUpperCase()
//             .contains(name.toUpperCase())) {
//           searchLecture.add(FileModel.fromJson(element.data()));
//         }
//       });
//       emit(ViewFileSuccessStates());
//     }).catchError((onError) {
//       emit(ViewFileErrorStates());
//     });
//   }
//
//   List<UserProfile> usersWaiting = [];
//   void getUserWaiting() {
//     emit(GetUserWaitingLoadingStates());
//     FirebaseFirestore.instance
//         .collection('users')
//         .orderBy('name')
//         .snapshots()
//         .listen((event) {
//       usersWaiting = [];
//       event.docs.forEach((element) {
//         if (!element.data()['status']) {
//           usersWaiting.add(UserProfile.fromJson(element.data()));
//         }
//       });
//       emit(GetUserWaitingSuccessStates());
//     }).onError((handleError) {
//       emit(GetUserWaitingErrorStates());
//     });
//   }
//
//   void acceptAccount(UserProfile profile) async {
//     emit(GetUserAcceptWaitingLoadingStates());
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(profile.uId)
//         .collection('userStatus')
//         .doc('status')
//         .set({
//       'userStatus': DateFormat('dd,MM yyyy hh:mm a').format(DateTime.now())
//     });
//     UserProfile user = UserProfile(
//         uId: profile.uId,
//         status: true,
//         token: profile.token,
//         email: profile.email,
//         name: profile.name,
//         password: profile.password,
//         image: profile.image,
//         phone: profile.phone,
//         bio: profile.bio,
//         block: profile.block,
//         block_final: profile.block_final,
//         disappear: profile.disappear);
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(profile.uId)
//         .set(user.toMap())
//         .then((value) {
//       DioHelper.postData(
//               token: profile.token,
//               massage:
//                   "لقد تم انشاء حسابك بنجاح تستطيع ان تجعل تسجيل الدخول الان")
//           .then((value) {
//         showToast(message: 'Accepted Successfully', state: ToastState.SUCCESS);
//         emit(GetUserAcceptWaitingSuccessStates());
//       }).catchError((onError) {
//         emit(GetUserAcceptWaitingErrorStates());
//       });
//     }).catchError((onError) {
//       emit(GetUserAcceptWaitingErrorStates());
//     });
//   }
//
//   void rejectAccount(UserProfile profile, context) {
//     emit(GetUserRejectWaitingLoadingStates());
//     showDialog(
//         barrierDismissible: false, //prevent close
//         context: context,
//         builder: (context) => AlertDialog(
//               backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//               title: const Text(
//                 'Confirm....',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     'Are you Sure that delete this account Finally',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.normal,
//                       fontSize: 15,
//                     ),
//                   ),
//                   Center(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         MaterialButton(
//                           onPressed: () {
//                             FirebaseFirestore.instance
//                                 .collection('users')
//                                 .doc(profile.uId)
//                                 .delete()
//                                 .then((value) {
//                               usersStatus.remove(profile.uId);
//                               Navigator.pop(context);
//                               DioHelper.postData(token: profile.token,
//                                       massage: "عذرا لقد تم رفض حسابك تستطيع ان تجعل حساب اخر ")
//                                   .then((value) {
//                                 emit(GetUserRejectWaitingSuccessStates());
//                               }).catchError((onError) {
//                                 emit(GetUserRejectWaitingErrorStates());
//                               });
//                             }).catchError((onError) {
//                               Navigator.pop(context);
//                               emit(GetUserRejectWaitingErrorStates());
//                             });
//                           },
//                           child: const Text(
//                             'Yes',
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white),
//                           ),
//                           color: Colors.green,
//                         ),
//                         const SizedBox(
//                           width: 20,
//                         ),
//                         MaterialButton(
//                           onPressed: () async {
//                             Navigator.pop(context);
//                           },
//                           child: const Text('No',
//                               style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white)),
//                           color: Colors.red,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ));
//   }
//
//   //add massages group
//   void addMassageToGroup(
//       {required String? text,
//       required String dateTime,
//       required String createdAt,
//       String? chatImage}) {
//     MassageModelGroup model = MassageModelGroup(
//         senderId: userProfile!.uId,
//         text: text,
//         dateTime: dateTime,
//         createdAt: createdAt,
//         image: chatImage,
//         name: userProfile!.name,
//         userImage: userProfile!.image);
//     FirebaseFirestore.instance
//         .collection('group')
//         .doc('chat')
//         .collection('massages')
//         .add(model.toMap())
//         .then((value) {
//       emit(SocialAddMassageSuccessStates());
//     }).catchError((onError) {
//       emit(SocialAddMassageErrorStates());
//     });
//   }
//
//   List<MassageModelGroup> massagesGroup = [];
//   List<String> massagesGroupId = [];
//
//   //get massages
//   void getMassageGroup() {
//     FirebaseFirestore.instance
//         .collection('group')
//         .doc('chat')
//         .collection('massages')
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .listen((event) {
//       massagesGroup = [];
//       massagesGroupId = [];
//       event.docs.forEach((element) {
//         massagesGroup.add(MassageModelGroup.fromJson(element.data()));
//         massagesGroupId.add(element.id);
//       });
//       emit(OrdersGetMassageSuccessStates());
//     }).onError((error) {
//       emit(OrdersGetMassageErrorStates());
//     });
//   }
//
//   void getGroupImage({
//     required String? text,
//     required String dateTime,
//     required String createdAt,
//   }) async {
//     emit(OrdersUploadImageLoadingSuccessStates());
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       uploadGroupImage(
//         chatImage: File(pickedFile.path),
//         text: text,
//         dateTime: dateTime,
//         createdAt: createdAt,
//       );
//     } else {
//       showToast(message: 'No Orders Image Selected', state: ToastState.WARNING);
//       emit(OrdersUploadImageLoadingErrorStates());
//     }
//   }
//
//   void uploadGroupImage({
//     required File chatImage,
//     required String? text,
//     required String dateTime,
//     required String createdAt,
//   }) {
//     FirebaseStorage.instance
//         .ref()
//         .child(
//             'chats/${Uri.file(chatImage.path).pathSegments.length / DateTime.now().millisecondsSinceEpoch}')
//         .putFile(chatImage)
//         .then((val) {
//       val.ref.getDownloadURL().then((value) {
//         addMassageToGroup(
//             text: text,
//             dateTime: dateTime,
//             createdAt: createdAt,
//             chatImage: value.toString());
//       }).catchError((onError) {
//         emit(OrdersUploadImageLoadingErrorStates());
//       });
//     }).catchError((onError) {
//       emit(OrdersUploadImageLoadingErrorStates());
//     });
//   }
//
//   //block from chat
//   void blockUserFromOrders({
//     required UserProfile profile,
//   }) {
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(FirebaseAuth.instance.currentUser!.uid.toString())
//         .get()
//         .then((value) {
//       SharedHelper.save(value: value.data()!['block'], key: 'block');
//       emit(SocialDeleteMassageSuccessStates());
//     }).catchError((onError) {
//       emit(SocialDeleteMassageErrorStates());
//     });
//     profile.block = true;
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(profile.uId)
//         .set(profile.toMap())
//         .then((value) {
//       emit(SocialDeleteMassageSuccessStates());
//     }).catchError((onError) {
//       emit(SocialDeleteMassageErrorStates());
//     });
//   }
//
//   //block from app
//   void blockUserFromApp({
//     required UserProfile profile,
//   }) {
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(FirebaseAuth.instance.currentUser!.uid.toString())
//         .get()
//         .then((value) {
//       SharedHelper.save(value: value.data()!['block'], key: 'block_final');
//       emit(SocialDeleteMassageSuccessStates());
//     }).catchError((onError) {
//       emit(SocialDeleteMassageErrorStates());
//     });
//     profile.block_final = true;
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(profile.uId)
//         .set(profile.toMap())
//         .then((value) {
//       emit(SocialDeleteMassageSuccessStates());
//     }).catchError((onError) {
//       emit(SocialDeleteMassageErrorStates());
//     });
//   }
//
//   //delete group massage
//   void deleteGroupMassage({required int index, required String id}) {
//     MassageModelGroup group = MassageModelGroup(
//         name: massagesGroup[index].name,
//         userImage: massagesGroup[index].userImage,
//         createdAt: massagesGroup[index].createdAt,
//         text: 'لقد تم مسح ارسال رسالة',
//         dateTime: massagesGroup[index].dateTime,
//         image: massagesGroup[index].image,
//         senderId: massagesGroup[index].senderId);
//     FirebaseFirestore.instance
//         .collection('group')
//         .doc('chat')
//         .collection('massages')
//         .doc(id)
//         .set(group.toMap())
//         .then((value) {
//       emit(SocialDeleteMassageSuccessStates());
//     }).catchError((onError) {
//       emit(SocialDeleteMassageErrorStates());
//     });
//   }
//
//   void getBlockStatus() {
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .get()
//         .then((value) {
//       SharedHelper.save(value: value.data()!['block'], key: 'block');
//       emit(OrdersGetAllUsersLoadingStates());
//     });
//   }
//
// //upload video using user
//   void getVideoUsingUser(
//       {required context,
//       required String name,
//       required String username,
//       required String date}) async {
//     emit(GetVedioLoadingStates());
//     final pickedFile =
//         await ImagePicker().pickVideo(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       uploadVideoUsingUser(
//         date: date,
//         name: name,
//         username: username,
//         context: context,
//         video: File(pickedFile.path),
//       );
//     } else {
//       showToast(message: 'No Orders Image Selected', state: ToastState.WARNING);
//       emit(GetVedioErrorStates());
//     }
//   }
//
//   double progress = 0.0;
//   void uploadVideoUsingUser(
//       {required File video,
//       required context,
//       required String name,
//       required String username,
//       required String date}) {
//     progress = 0.0;
//     UploadTask task = FirebaseStorage.instance
//         .ref()
//         .child(
//             'Videos/${Uri.file(video.path).pathSegments.length / DateTime.now().millisecondsSinceEpoch}')
//         .putFile(
//             video,
//             firebase_storage.SettableMetadata(
//               contentType: 'video/mp4',
//             ));
//     task.snapshotEvents.listen((event) {
//       progress =
//           ((event.bytesTransferred.toDouble() / event.totalBytes.toDouble()) *
//                   100)
//               .roundToDouble();
//       print(progress);
//       emit(GetVedioLoadingStates());
//     });
//
//     task.then((val) {
//       val.ref.getDownloadURL().then((value) {
//         print(value);
//         storeVideoInFirestoreUsingUser(
//             link: value.toString(),
//             videoName: name,
//             username: username,
//             date: date,
//             context: context);
//       }).catchError((onError) {
//         showToast(message: onError.toString(), state: ToastState.ERROR);
//         emit(GetVedioErrorStates());
//       });
//     }).catchError((onError) {
//       showToast(message: onError.toString(), state: ToastState.WARNING);
//       emit(GetVedioErrorStates());
//     });
//   }
//
//   void storeVideoInFirestoreUsingUser({
//     required String videoName,
//     required String link,
//     required String username,
//     required String date,
//     required context,
//   }) {
//     VideoModelUser model = VideoModelUser(
//         name: videoName, link: link, date: date, username: username);
//     FirebaseFirestore.instance
//         .collection('videosUsingUser')
//         .add(model.toMap())
//         .then((value) {
//       showToast(
//           message: 'Video Uploaded Successfully', state: ToastState.SUCCESS);
//       emit(GetVedioSuccessStates());
//     }).catchError((onError) {
//       print('pppppppppppppppppppppppp${onError.toString()}');
//       showToast(message: onError.toString(), state: ToastState.WARNING);
//       emit(GetVedioErrorStates());
//     });
//   }
//
//   //upload video using admin
//   void getVideo({
//     required context,
//     required String name,
//   }) async {
//     emit(GetVedioLoadingStates());
//     final pickedFile =
//         await ImagePicker().pickVideo(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       uploadVideo(
//         name: name,
//         context: context,
//         video: File(pickedFile.path),
//       );
//     } else {
//       showToast(message: 'No Orders Image Selected', state: ToastState.WARNING);
//       emit(GetVedioErrorStates());
//     }
//   }
//
//   void uploadVideo({
//     required File video,
//     required context,
//     required String name,
//   }) {
//     UploadTask task = FirebaseStorage.instance
//         .ref()
//         .child(
//             'Videos/${Uri.file(video.path).pathSegments.length / DateTime.now().millisecondsSinceEpoch}')
//         .putFile(
//             video,
//             firebase_storage.SettableMetadata(
//               contentType: 'video/mp4',
//             ));
//     //calculate progress
//     task.snapshotEvents.listen((event) {
//       progress =
//           ((event.bytesTransferred.toDouble() / event.totalBytes.toDouble()) *
//                   100)
//               .roundToDouble();
//       print(progress);
//       emit(GetVedioLoadingStates());
//     });
//     task.then((val) {
//       val.ref.getDownloadURL().then((value) {
//         print(value);
//         storeVideoInFirestore(
//             link: value.toString(), videoName: name, context: context);
//       }).catchError((onError) {
//         showToast(message: onError.toString(), state: ToastState.ERROR);
//         emit(GetVedioErrorStates());
//       });
//     }).catchError((onError) {
//       showToast(message: onError.toString(), state: ToastState.WARNING);
//       emit(GetVedioErrorStates());
//     });
//   }
//
//   void storeVideoInFirestore({
//     required String videoName,
//     required String link,
//     required context,
//   }) {
//     VideoModel model = VideoModel(
//       name: videoName,
//       link: link,
//     );
//     FirebaseFirestore.instance
//         .collection('videos')
//         .add(model.toMap())
//         .then((value) {
//       showToast(
//           message: 'Video Uploaded Successfully', state: ToastState.SUCCESS);
//       emit(GetVedioSuccessStates());
//     }).catchError((onError) {
//       print('pppppppppppppppppppppppp${onError.toString()}');
//       showToast(message: onError.toString(), state: ToastState.WARNING);
//       emit(GetVedioErrorStates());
//     });
//   }
//
// //upload image using user
//   void getImageUsingUser(
//       {required context,
//       required String name,
//       required String username,
//       required String date}) async {
//     emit(GetImageLoadingStates());
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       uploadImageUsingUser(
//         date: date,
//         name: name,
//         username: username,
//         context: context,
//         Image: File(pickedFile.path),
//       );
//     } else {
//       showToast(message: 'No Orders Image Selected', state: ToastState.WARNING);
//       emit(GetImageErrorStates());
//     }
//   }
//
//   void uploadImageUsingUser(
//       {required File Image,
//       required context,
//       required String name,
//       required String username,
//       required String date}) {
//     FirebaseStorage.instance
//         .ref()
//         .child(
//             'Images/${Uri.file(Image.path).pathSegments.length / DateTime.now().millisecondsSinceEpoch}')
//         .putFile(Image)
//         .then((val) {
//       val.ref.getDownloadURL().then((value) {
//         print(value);
//         storeImageInFirestoreUsingUser(
//             link: value.toString(),
//             Image: name,
//             username: username,
//             date: date,
//             context: context);
//       }).catchError((onError) {
//         showToast(message: onError.toString(), state: ToastState.ERROR);
//         emit(GetImageErrorStates());
//       });
//     }).catchError((onError) {
//       showToast(message: onError.toString(), state: ToastState.WARNING);
//       emit(GetImageErrorStates());
//     });
//   }
//
//   void storeImageInFirestoreUsingUser({
//     required String Image,
//     required String link,
//     required String username,
//     required String date,
//     required context,
//   }) {
//     ImageModelUser model =
//         ImageModelUser(name: Image, link: link, date: date, username: username);
//     FirebaseFirestore.instance
//         .collection('imagesUsingUser')
//         .add(model.toMap())
//         .then((value) {
//       showToast(
//           message: 'Image Uploaded Successfully', state: ToastState.SUCCESS);
//       emit(GetImageSuccessStates());
//     }).catchError((onError) {
//       print('pppppppppppppppppppppppp${onError.toString()}');
//       showToast(message: onError.toString(), state: ToastState.WARNING);
//       emit(GetImageErrorStates());
//     });
//   }
//
//   //upload image using admin
//   void getImage({
//     required context,
//     required String name,
//   }) async {
//     emit(GetImageLoadingStates());
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       uploadImage(
//         name: name,
//         context: context,
//         Image: File(pickedFile.path),
//       );
//     } else {
//       showToast(message: 'No Orders Image Selected', state: ToastState.WARNING);
//       emit(GetImageErrorStates());
//     }
//   }
//
//   void uploadImage({
//     required File Image,
//     required context,
//     required String name,
//   }) {
//     FirebaseStorage.instance
//         .ref()
//         .child(
//             'Images/${Uri.file(Image.path).pathSegments.length / DateTime.now().millisecondsSinceEpoch}')
//         .putFile(Image)
//         .then((val) {
//       val.ref.getDownloadURL().then((value) {
//         print(value);
//         storeImageInFirestore(
//             link: value.toString(), ImageName: name, context: context);
//       }).catchError((onError) {
//         showToast(message: onError.toString(), state: ToastState.ERROR);
//         emit(GetImageErrorStates());
//       });
//     }).catchError((onError) {
//       showToast(message: onError.toString(), state: ToastState.WARNING);
//       emit(GetImageErrorStates());
//     });
//   }
//
//   void storeImageInFirestore({
//     required String ImageName,
//     required String link,
//     required context,
//   }) {
//     ImageModel model = ImageModel(
//       name: ImageName,
//       link: link,
//     );
//     FirebaseFirestore.instance
//         .collection('images')
//         .add(model.toMap())
//         .then((value) {
//       showToast(
//           message: 'Image Uploaded Successfully', state: ToastState.SUCCESS);
//       emit(GetImageSuccessStates());
//     }).catchError((onError) {
//       print('pppppppppppppppppppppppp${onError.toString()}');
//       showToast(message: onError.toString(), state: ToastState.WARNING);
//       emit(GetImageErrorStates());
//     });
//   }
//
//   //get video using admin
//   List<VideoModel> lecturesVideos = [];
//   void getVideos() {
//     emit(ViewFileLoadingStates());
//     FirebaseFirestore.instance.collection('videos').snapshots().listen((event) {
//       lecturesVideos = [];
//       event.docs.forEach((element) {
//         lecturesVideos.add(VideoModel.fromJson(element.data()));
//       });
//       emit(ViewFileSuccessStates());
//     }).onError((handleError) {
//       emit(ViewFileErrorStates());
//     });
//   }
//
//   //get images using admin
//   List<ImageModel> lecturesImages = [];
//   void getImages() {
//     emit(ViewFileLoadingStates());
//     FirebaseFirestore.instance.collection('images').snapshots().listen((event) {
//       lecturesImages = [];
//       event.docs.forEach((element) {
//         lecturesImages.add(ImageModel.fromJson(element.data()));
//       });
//       emit(ViewFileSuccessStates());
//     }).onError((handleError) {
//       emit(ViewFileErrorStates());
//     });
//   }
//
//   //get videos using user
//   List<VideoModelUser> VideosUsingUser = [];
//   List<String> VideosUsingUserId = [];
//   void getVideosUsingUser() {
//     emit(ViewVedioLoadingStates());
//     FirebaseFirestore.instance
//         .collection('videosUsingUser')
//         .snapshots()
//         .listen((event) {
//       VideosUsingUser = [];
//       VideosUsingUserId = [];
//       event.docs.forEach((element) {
//         VideosUsingUser.add(VideoModelUser.fromJson(element.data()));
//         VideosUsingUserId.add(element.id);
//       });
//       emit(ViewVedioSuccessStates());
//     }).onError((handleError) {
//       print('xxxxxxxxxxxxxxxxxxxxrrrrrrrrrrrr${onError.toString()}');
//       emit(ViewVedioErrorStates());
//     });
//   }
//
//   //accept video from admin
//   void acceptVideoUsingUser({required String videoId}) {
//     {
//       emit(AcceptFileLoadingStates());
//       FirebaseFirestore.instance
//           .collection('videosUsingUser')
//           .doc(videoId)
//           .get()
//           .then((value) {
//         VideoModel model = VideoModel(
//             name: value.data()!['name'], link: value.data()!['link']);
//         FirebaseFirestore.instance
//             .collection('videos')
//             .add(model.toMap())
//             .then((value) async {
//           await FirebaseFirestore.instance
//               .collection('videosUsingUser')
//               .doc(videoId)
//               .delete();
//           emit(AcceptFileSuccessStates());
//         }).catchError((onError) {
//           emit(AcceptFileErrorStates());
//         });
//       }).catchError((onError) {
//         emit(AcceptFileErrorStates());
//       });
//     }
//   }
//
//   //reject video from admin
//   void rejectVideoUsingUser({required String videoId}) {
//     emit(RejectFileLoadingStates());
//     FirebaseFirestore.instance
//         .collection('videosUsingUser')
//         .doc(videoId)
//         .delete()
//         .then((value) {
//       emit(RejectFileSuccessStates());
//     }).catchError((onError) {
//       emit(RejectFileErrorStates());
//     });
//   }
//
//   //get images using user
//   List<ImageModelUser> ImagesUsingUser = [];
//   List<String> ImagesUsingUserId = [];
//   void getImagesUsingUser() {
//     emit(ViewVedioLoadingStates());
//     FirebaseFirestore.instance
//         .collection('imagesUsingUser')
//         .snapshots()
//         .listen((event) {
//       ImagesUsingUser = [];
//       ImagesUsingUserId = [];
//       event.docs.forEach((element) {
//         ImagesUsingUser.add(ImageModelUser.fromJson(element.data()));
//         ImagesUsingUserId.add(element.id);
//       });
//       emit(ViewVedioSuccessStates());
//     }).onError((handleError) {
//       print('xxxxxxxxxxxxxxxxxxxxrrrrrrrrrrrr${onError.toString()}');
//       emit(ViewVedioErrorStates());
//     });
//   }
//
//   //accept image from admin
//   void acceptImageUsingUser({required String imageId}) {
//     {
//       emit(AcceptFileLoadingStates());
//       FirebaseFirestore.instance
//           .collection('imagesUsingUser')
//           .doc(imageId)
//           .get()
//           .then((value) {
//         ImageModel model = ImageModel(
//             name: value.data()!['name'], link: value.data()!['link']);
//         FirebaseFirestore.instance
//             .collection('images')
//             .add(model.toMap())
//             .then((value) async {
//           await FirebaseFirestore.instance
//               .collection('imagesUsingUser')
//               .doc(imageId)
//               .delete();
//           emit(AcceptFileSuccessStates());
//         }).catchError((onError) {
//           emit(AcceptFileErrorStates());
//         });
//       }).catchError((onError) {
//         emit(AcceptFileErrorStates());
//       });
//     }
//   }
//
//   //reject image from admin
//   void rejectImageUsingUser({required String imageId}) {
//     emit(RejectFileLoadingStates());
//     FirebaseFirestore.instance
//         .collection('imagesUsingUser')
//         .doc(imageId)
//         .delete()
//         .then((value) {
//       emit(RejectFileSuccessStates());
//     }).catchError((onError) {
//       emit(RejectFileErrorStates());
//     });
//   }
//   Set usersTemporal={};
}
