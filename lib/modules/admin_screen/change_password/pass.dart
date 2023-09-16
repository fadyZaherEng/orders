// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:orders/modules/admin_screen/change_password/bloc/cubit.dart';
import 'package:orders/modules/admin_screen/change_password/bloc/states.dart';
import 'package:orders/modules/login/bloc/cubit.dart';
import 'package:orders/shared/components/components.dart';
//checked
class ChangeAdminPasswordScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var oldPasswordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  var newPasswordController = TextEditingController();

  ChangeAdminPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrdersAppChangeAdminPassCubit>(
      create: (context) => OrdersAppChangeAdminPassCubit(),
      child: BlocConsumer<
          OrdersAppChangeAdminPassCubit,
          OrdersAppChangeAdminPasswordStates>(
        listener: (context, state) {
          if (state is OrdersAppChangeAdminPasswordSuccessStates) {
            showToast(message: "Change Successfully".tr(), state: ToastState.SUCCESS);
          }
          if (state is OrdersAppChangeAdminPasswordErrorStates) {
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
                             Center(child: Text("Change Admin Password".tr(),)),
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
                              text: "Email".tr(),
                              validate: (val) {
                                if (val
                                    .toString()
                                    .isEmpty) {
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
                              Controller: oldPasswordController,
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.indigo,
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    OrdersAppChangeAdminPassCubit.get(context)
                                        .changeVisibilityOfEye();
                                  },
                                  icon: OrdersAppChangeAdminPassCubit
                                      .get(context)
                                      .suffixIcon),
                              text: "Old Password".tr(),
                              validate: (val) {
                                if (val
                                    .toString()
                                    .isEmpty) {
                                  return "Password is Very Short".tr();
                                }
                                return null;
                              },
                              obscure: OrdersAppChangeAdminPassCubit
                                  .get(context)
                                  .obscure,

                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            defaultTextForm(
                              context: context,
                              type: TextInputType.visiblePassword,
                              Controller: newPasswordController,
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.indigo,
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    OrdersAppChangeAdminPassCubit.get(context)
                                        .changeVisibilityOfEye();
                                  },
                                  icon: OrdersAppChangeAdminPassCubit
                                      .get(context)
                                      .suffixIcon),
                              text: "New Password".tr(),
                              validate: (val) {
                                if (val
                                    .toString()
                                    .isEmpty) {
                                  return "Password is Very Short".tr();
                                }
                                return null;
                              },
                              obscure: OrdersAppChangeAdminPassCubit
                                  .get(context)
                                  .obscure,

                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            MaterialButton(
                              height: 50,
                              minWidth: double.infinity,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  OrdersAppChangeAdminPassCubit.get(context)
                                      .changePassword(
                                      emailController.text, oldPasswordController.text, newPasswordController.text);
                                  FocusScope.of(context).unfocus();
                                }
                              },
                              color: HexColor('180040'),
                              child: Text(
                                "Change Password".tr(),
                                style: const TextStyle(
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
