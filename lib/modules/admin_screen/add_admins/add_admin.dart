// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:orders/modules/admin_screen/add_admins/bloc/cubit.dart';
import 'package:orders/modules/admin_screen/add_admins/bloc/states.dart';
import 'package:orders/modules/login/bloc/cubit.dart';
import 'package:orders/shared/components/components.dart';
//checked
class AddAdminScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  AddAdminScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrdersAppAddAdminCubit>(
      create: (context) => OrdersAppAddAdminCubit(),
      child: BlocConsumer<OrdersAppAddAdminCubit, OrdersAppAddAdminStates>(
        listener: (context, state) {
          if (state is OrdersAppAddAdminSuccessStates) {
            showToast(message:"Logged Successfully".tr() , state: ToastState.SUCCESS);
          }
          if (state is OrdersAppAddAdminErrorStates) {
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
                            Center(child:  Text("Add Admin".tr(),)),
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
                                    OrdersAppAddAdminCubit.get(context)
                                        .changeVisibilityOfEye();
                                  },
                                  icon: OrdersAppAddAdminCubit.get(context).suffixIcon),
                              text: "Password".tr(),
                              validate: (val) {
                                if (val.toString().isEmpty) {
                                  return  "Password is Very Short".tr();
                                }
                                return null;
                              },
                              obscure: OrdersAppAddAdminCubit.get(context).obscure,

                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            MaterialButton(
                              height: 50,
                              minWidth: double.infinity,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  OrdersAppAddAdminCubit.get(context).addAdmin(
                                      context: context,
                                      email: emailController.text,
                                      password: passwordController.text
                                  );
                                  FocusScope.of(context).unfocus();
                                }
                              },
                              color: HexColor('180040'),
                              child:  Text(
                                "Add Admin".tr(),
                                style:const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
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
