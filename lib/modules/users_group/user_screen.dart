// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, avoid_print
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/models/user_profile.dart';
import 'package:orders/shared/network/local/cashe_helper.dart';

class UsersGroupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
          listener: (context, state) {
          },
          builder: (context, state) {
            return Scaffold(
              backgroundColor: SharedHelper.get(key: "theme") == 'Light Theme'
                  ? Colors.white
                  : Theme.of(context).scaffoldBackgroundColor,
              body: SafeArea(
                child: ConditionalBuilder(
                  condition: OrdersHomeCubit.get(context).users.isNotEmpty,
                  builder: (context) => ListView.separated(
                      itemBuilder: (context, index) => buildItem(
                          context, OrdersHomeCubit.get(context).users[index]),
                      separatorBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              height: 1,
                              width: double.infinity,
                              color: Colors.grey[300],
                            ),
                          ),
                      itemCount:OrdersHomeCubit.get(context).users.length),
                  fallback: (context) =>
                      const Center(child: CircularProgressIndicator()),
                ),
              ),
            );
          });
    });
  }

  Widget buildItem(context, UserProfile profile) => InkWell(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            profile.name,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      );
  String getTime(dateTime) {
    print(dateTime);
    DateTime lastTime = DateTime.parse(dateTime);
    DateTime currentTime = DateTime.now();
    int differenceMinutes = currentTime.difference(lastTime).inMinutes;
    int differenceHours = currentTime.difference(lastTime).inHours;
    int differenceDays = currentTime.difference(lastTime).inDays;
    if (differenceMinutes < 60) {
      if (differenceMinutes == 0) {
        return 'now';
      }
      return '$differenceMinutes m';
    } else if (differenceHours < 24) {
      return '$differenceHours h';
    } else if (differenceDays < 30) {
      return '$differenceDays days';
    } else if (differenceDays > 30 && differenceDays <= 365) {
      return '${differenceDays / 30} month';
    } else {
      return '${differenceDays / 365} year';
    }
  }
}
