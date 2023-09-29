// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/models/user_profile.dart';
import 'package:orders/models/user_profile.dart';
import 'package:orders/shared/components/components.dart';

class UserPermissionScreen extends StatefulWidget {

  UserPermissionScreen({super.key});

  @override
  State<UserPermissionScreen> createState() => _UserPermissionScreenState();
}

class _UserPermissionScreenState extends State<UserPermissionScreen> {
  bool isAdmin=false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        return Scaffold(
          body: SafeArea(
            child: ConditionalBuilder(
                condition: OrdersHomeCubit.get(context).users.isNotEmpty,
                builder: (ctx) => ListView.separated(
                    itemBuilder: (context, idx) =>
                        listItem(ctx, OrdersHomeCubit.get(context).users[idx]),
                    separatorBuilder: (context, idx) => mySeparator(context),
                    itemCount: OrdersHomeCubit.get(context).users.length),
                fallback: (ctx) => CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                )),
          ),
        );
      },
    );
  }

  Widget listItem(BuildContext ctx, UserProfile user) {
    isAdmin=user.isAdmin!;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide.none
        ),
        color: Colors.grey,
        elevation: 15,
        shadowColor: Theme.of(ctx).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text("${"Employer Name: ".tr()}${user.name}")),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Is Admin".tr()),
                  Switch(value:isAdmin, onChanged: (value){
                    isAdmin=value;
                    OrdersHomeCubit.get(ctx).userIsAdminPermission(value, user,ctx);
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
