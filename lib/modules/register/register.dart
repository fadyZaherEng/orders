// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:orders/layout/home_screen.dart';
import 'package:orders/modules/login/login.dart';
import 'package:orders/modules/register/bloc/cubit.dart';
import 'package:orders/modules/register/bloc/states.dart';
import 'package:orders/shared/components/components.dart';
import 'package:orders/shared/network/local/cashe_helper.dart';

class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrdersAppRegisterCubit(),
      child: BlocConsumer<OrdersAppRegisterCubit, OrdersAppRegisterStates>(
        listener: (context, state) {
          if (state is OrdersAppRegisterSuccessStates) {
            showToast(
                message: "Create Account Successfully".tr(),
                state: ToastState.SUCCESS);
            SharedHelper.save(value: state.uid, key: 'uid');
            navigateToWithoutReturn(context, LogInScreen());
          }
          if (state is OrdersAppRegisterErrorStates) {
            showToast(message: state.error.toString(), state: ToastState.ERROR);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        CircleAvatar(
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            radius: 90.0,
                            backgroundImage:
                                const AssetImage('assets/images/register.jpg')),
                        const SizedBox(
                          height: 60,
                        ),
                        defaultTextForm(
                          context: context,
                          type: TextInputType.text,
                          Controller: OrdersAppRegisterCubit.get(context)
                              .nameController,
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.indigo,
                          ),
                          text:"Name".tr() ,
                          validate: (val) {
                            if (val.toString().isEmpty) {
                              return "Please Enter Your Username".tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        defaultTextForm(
                            context: context,
                            type: TextInputType.emailAddress,
                            Controller: OrdersAppRegisterCubit.get(context)
                                .emailController,
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.indigo,
                            ),
                            text: "Email".tr(),
                            validate: (val) {
                              if (val.toString().isEmpty) {
                                return "Please Enter Your Email Address".tr();
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        defaultTextForm(
                          context: context,
                          type: TextInputType.phone,
                          Controller: OrdersAppRegisterCubit.get(context)
                              .phoneController,
                          prefixIcon: const Icon(
                            Icons.phone,
                            color: Colors.indigo,
                          ),
                          text: "Phone".tr() ,
                          validate: (val) {
                            if (val.toString().isEmpty) {
                              return "Please Enter Your Phone".tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        defaultTextForm(
                          context: context,
                          type: TextInputType.visiblePassword,
                          Controller: OrdersAppRegisterCubit.get(context)
                              .passwordController,
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.indigo,
                          ),
                          text: "Password".tr(),
                          validate: (val) {
                            if (val.toString().isEmpty) {
                              return  "Password is Very Short".tr();
                            }
                            return null;
                          },
                          obscure: OrdersAppRegisterCubit.get(context).obscure,
                          suffixIcon: IconButton(
                              onPressed: () {
                                OrdersAppRegisterCubit.get(context)
                                    .changeVisibilityOfEye();
                              },
                              icon: OrdersAppRegisterCubit.get(context)
                                  .suffixIcon),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        MaterialButton(
                          height: 50,
                          minWidth: double.infinity,
                          onPressed: () {
                            //register
                            if (formKey.currentState!.validate()) {
                              OrdersAppRegisterCubit.get(context).signUp();
                              FocusScope.of(context).unfocus();
                            }
                          },
                          color: HexColor('180040'),
                          child:  Text(
                            "REGISTER NOW".tr(),
                            style:const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
