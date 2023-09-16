// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/models/admin_model.dart';
import 'package:orders/modules/admin_screen/add_admins/bloc/states.dart';
import 'package:orders/shared/components/components.dart';

class OrdersAppAddAdminCubit extends Cubit<OrdersAppAddAdminStates> {
  OrdersAppAddAdminCubit() : super(OrdersAppAddAdminInitialStates());

  static OrdersAppAddAdminCubit get(context) => BlocProvider.of(context);

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
    emit(OrdersAppAddAdminChangeEyeStates());
  }

  //add admin
  void addAdmin({
    required String email,
    required String password,
    required context,
  }) {
    CollectionReference ref =
    FirebaseFirestore.instance.collection('admins');
    DocumentReference docRef = ref.doc();
    String docId = docRef.id;
    AdminModel adminModel = AdminModel(email: email,
        showOrders: false,
        showCategories: false,
        id: docId,
        addCat: false,
        saveOrder: false,
        removeOrder: false,
        password: password);
    emit(OrdersAppAddAdminAdminLoadingStates());
        docRef.set(adminModel.toMap())
        .then((value) {
      showToast(message: "Create Account Success ....".tr() , state: ToastState.WARNING);
    }).catchError((onError) {
      showToast(message: onError.toString(), state: ToastState.ERROR);
      emit(OrdersAppAddAdminAdminErrorStates(onError.toString()));
    });
  }
}
