
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/models/user_profile.dart';
import 'package:orders/modules/register/bloc/states.dart';
import 'package:orders/shared/components/components.dart';
import 'package:orders/shared/lang/arabic.dart';
import 'package:orders/shared/lang/english.dart';
import 'package:orders/shared/network/local/cashe_helper.dart';



class OrdersAppRegisterCubit extends Cubit<OrdersAppRegisterStates>
{
  var gendreController=TextEditingController();

  OrdersAppRegisterCubit() : super(OrdersAppRegisterInitialStates());
  static OrdersAppRegisterCubit get(context)=>BlocProvider.of(context);
  Icon suffixIcon=const Icon(Icons.visibility_outlined,color: Colors.indigo,);
  bool obscure=true;
  void changeVisibilityOfEye(){
    obscure=!obscure;
    if(obscure){
      suffixIcon=const Icon(Icons.remove_red_eye,color: Colors.indigo,);
    }else{
      suffixIcon=const Icon(Icons.visibility_off_outlined,color: Colors.indigo,);
    }
    emit(OrdersAppRegisterChangeEyeStates());
  }
  var passwordController=TextEditingController();
  var emailController=TextEditingController();
  var nameController=TextEditingController();
  var phoneController=TextEditingController();
  void signUp(){
    emit(OrdersAppRegisterLoadingStates());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
    ).then((value)async {
      var x=value;
       showToast(message: SharedHelper.get(key: 'lang')=='arabic'?arabic['Create Account Loading ....']:english['Create Account Loading ....'] , state: ToastState.WARNING);
      await storeDatabaseFirestore(value.user!.uid.toString()).then((value) {
        emit(OrdersAppRegisterSuccessStates(x.user!.uid.toString()));
      }).catchError((onError){
        emit(OrdersAppRegisterErrorStates(onError.toString()));
      });
    }).catchError((onError){
        emit(OrdersAppRegisterErrorStates(onError.toString()));
    });
  }

  Future storeDatabaseFirestore(String uid) {
    UserProfile profile=UserProfile(
        phone: phoneController.text,
        name: nameController.text,
        email: emailController.text,
        uid: uid,

    );
    CollectionReference users = FirebaseFirestore.instance.collection('users');
   return users.doc(uid).set(profile.toMap());
  }
}
