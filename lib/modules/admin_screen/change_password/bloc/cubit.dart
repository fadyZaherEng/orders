// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/models/admin_model.dart';
import 'package:orders/modules/admin_screen/change_password/bloc/states.dart';
import 'package:orders/shared/components/components.dart';

class OrdersAppChangeAdminPassCubit extends Cubit<OrdersAppChangeAdminPasswordStates> {
  OrdersAppChangeAdminPassCubit() : super(OrdersAppChangeAdminPasswordInitialStates());
  static OrdersAppChangeAdminPassCubit get(context) => BlocProvider.of(context);
  bool adminFound=false;
  void changePassword(String email,String oldPassword,String newPassword){
    FirebaseFirestore.instance
        .collection("admins")
        .get()
        .then((value) {
          adminFound=false;
      for(var admin in value.docs){
        AdminModel adminModel=AdminModel.fromMap(admin.data());
        adminFound=true;
        if(adminModel.password==oldPassword&&adminModel.email==email){
          adminModel.password=newPassword;
          FirebaseFirestore.instance
              .collection("admins")
          .doc(adminModel.id)
          .update(adminModel.toMap()).then((value) {
            emit(OrdersAppChangeAdminPasswordChangeEyeStates());
            showToast(message: "Success", state: ToastState.SUCCESS);
          }).catchError((onError){
            emit(OrdersAppChangeAdminPasswordErrorStates(onError.toString()));
          });
          break;
        }
      }
      if(!adminFound){
        showToast(message:"Admin Not Found".tr() , state: ToastState.ERROR);
      }
    }).catchError((onError){
      emit(OrdersAppChangeAdminPasswordErrorStates(onError.toString()));
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
    emit(OrdersAppChangeAdminPasswordChangeEyeStates());
  }

}
