// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/modules/admin_screen/show_order/show_orders.dart';
import 'package:orders/modules/login/bloc/states.dart';
import 'package:orders/shared/components/components.dart';
import 'package:orders/shared/network/local/cashe_helper.dart';

class OrdersAppLoginCubit extends Cubit<OrdersAppLogInStates> {
  OrdersAppLoginCubit() : super(OrdersAppLogInInitialStates());

  static OrdersAppLoginCubit get(context) => BlocProvider.of(context);
  bool isAdmin = false;
  String adminText="I\"m Admin?".tr();

  void isAdminLogIn() {
    isAdmin = !isAdmin;
    if(isAdmin){
      adminText="I\"m Employer?".tr();
    }else{
      adminText="I\"m Admin?".tr();
    }
    emit(OrdersAppIsAdminStates());
  }

  void LogIn({
    required String email,
    required String password,
  }) {
    emit(OrdersAppLogInLoadingStates());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value) {
      showToast(message:"Welcome".tr(), state: ToastState.SUCCESS);
      emit(OrdersAppLogInSuccessStates(value.user!.uid));
      print(value.user!.email);
    }).catchError((onError) {
      emit(OrdersAppLogInErrorStates(onError.toString()));
    });
  }

  Icon suffixIcon = const Icon(
    Icons.visibility_outlined,
    color: Colors.indigo,
  );
  bool obscure = true;

  void changeVisibilityOfEye() {
    obscure = !obscure;
    if (obscure) {
      suffixIcon = const Icon(
        Icons.remove_red_eye,
        color: Colors.indigo,
      );
    } else {
      suffixIcon = const Icon(
        Icons.visibility_off_outlined,
        color: Colors.indigo,
      );
    }
    emit(OrdersAppLogInChangeEyeStates());
  }

  //log in admin
  void logInAdmin({
    required String email,
    required String password,
    required context,
  }) {
    bool adminFound=false;
    emit(OrdersAppLogInAdminLoadingStates());
    FirebaseFirestore.instance
        .collection("admins")
        .get()
        .then((value) {
          for(var admin in value.docs){
            if(admin['password']==password&&admin['email']==email){
              adminFound=true;
              SharedHelper.save(value: email, key:'adminEmail');
              showToast(message:"Welcome".tr(), state: ToastState.SUCCESS);
              emit(OrdersAppLogInAdminSuccessStates('admin'));
              navigateToWithoutReturn(context, const AdminShowOrders());
              break;
            }
          }
          if(!adminFound){
            showToast(message:"Admin Not Found".tr() , state: ToastState.ERROR);
          }
    }).catchError((onError) {
      showToast(message: onError.toString(), state: ToastState.ERROR);
      emit(OrdersAppLogInAdminErrorStates(onError.toString()));
    });
  }
}
