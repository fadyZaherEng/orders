// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/models/user_profile.dart';
import 'package:orders/shared/components/components.dart';

class UserBlockScreen extends StatefulWidget {
  const UserBlockScreen({super.key});

  @override
  State<UserBlockScreen> createState() => _UserBlockScreenState();
}

class _UserBlockScreenState extends State<UserBlockScreen> {
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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${"Employer Name: ".tr()}${user.name}"),
              const SizedBox(width: 15,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${"Employer Email: ".tr()}${user.email}",
                      maxLines: 100,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "${"Employer Phone: ".tr()}${user.phone}",
                      maxLines: 100,
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              if (!user.block)
                TextButton(
                    onPressed: () {
                      OrdersHomeCubit.get(context)
                          .removeUserProfile(docId: user.uid);
                    },
                    child: Text("Block".tr())),
              if (user.block)
                TextButton(
                    onPressed: () {
                      user.block = false;
                      OrdersHomeCubit.get(context)
                          .acceptUserProfile(user: user);
                    },
                    child: Text("Accept".tr())),
            ],
          ),
        ],
      ),
    );
  }
}
