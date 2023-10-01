// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:orders/layout/home_screen.dart';
import 'package:orders/modules/login/bloc/cubit.dart';
import 'package:orders/modules/login/bloc/states.dart';
import 'package:orders/modules/register/register.dart';
import 'package:orders/shared/components/components.dart';
import 'package:orders/shared/network/local/cashe_helper.dart';

class LogInScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  LogInScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrdersAppLoginCubit(),
      child: BlocConsumer<OrdersAppLoginCubit, OrdersAppLogInStates>(
        listener: (context, state) {
          if (state is OrdersAppLogInSuccessStates) {
            showToast(
                message:"Logged Successfully".tr() , state: ToastState.SUCCESS);
            SharedHelper.save(value: state.uid, key: 'uid');
            if(SharedHelper.get(key: 'adminEmail')!=null) {
              SharedHelper.remove(key: 'adminEmail');
            }
            navigateToWithoutReturn(context, const HomeScreen());
          }
          if (state is OrdersAppLogInErrorStates) {
            showToast(message: state.error.toString(), state: ToastState.ERROR);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
                child: Center(
                    child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      backgroundImage:
                          const AssetImage('assets/images/login.jpg'),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    defaultTextForm(
                        context: context,
                        type: TextInputType.emailAddress,
                        Controller: emailController,
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.indigo,
                        ),
                        text:"Email".tr(),
                        validate: (val) {
                          if (val.toString().isEmpty) {
                            return "Please Enter Your Email Address".tr();
                          }
                          return null;
                        },
                       ),
                    const SizedBox(
                      height: 30,
                    ),
                    defaultTextForm(
                      context: context,
                      type: TextInputType.visiblePassword,
                      Controller: passwordController,
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.indigo,
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            OrdersAppLoginCubit.get(context)
                                .changeVisibilityOfEye();
                          },
                          icon: OrdersAppLoginCubit.get(context).suffixIcon),
                      text: "Password".tr(),
                      validate: (val) {
                        if (val.toString().isEmpty) {
                          return  "Password is Very Short".tr();
                        }
                        return null;
                      },
                      obscure: OrdersAppLoginCubit.get(context).obscure,

                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    MaterialButton(
                      height: 50,
                      minWidth: double.infinity,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                         if(!OrdersAppLoginCubit.get(context).isAdmin){
                           //log in
                           OrdersAppLoginCubit.get(context).LogIn(
                               email: emailController.text,
                               password: passwordController.text);
                           FocusScope.of(context).unfocus();
                         }else{
                           //get admin from cloud
                           OrdersAppLoginCubit.get(context).logInAdmin(
                               email: emailController.text,
                               password: passwordController.text,
                               context: context
                           );
                           FocusScope.of(context).unfocus();
                         }
                        }
                      },
                      color: HexColor('180040'),
                      child:  Text(
                        "Log In".tr(),
                        style:const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don\"t have an account?".tr(),
                            style: Theme.of(context).textTheme.bodyText1),
                        TextButton(
                          onPressed: () {
                            navigateToWithReturn(context, RegisterScreen());
                          },
                          child: Text(
                            "REGISTER".tr(),
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          OrdersAppLoginCubit.get(context).isAdminLogIn();
                        },
                        child: Text(
                          OrdersAppLoginCubit.get(context).adminText,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ))),
          );
        },
      ),
    );
  }
}
