// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, avoid_print, deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/models/model_group_massage.dart';
import 'package:orders/modules/users_group/user_screen.dart';
import 'package:orders/shared/components/components.dart';
import 'package:orders/shared/network/local/cashe_helper.dart';

class ChatGroupScreen extends StatelessWidget {
  var textController = TextEditingController();

  String? signIn = SharedHelper.get(key: 'uid');
  String? email = SharedHelper.get(key: 'adminEmail');
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      //equal on start android

      return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
                backgroundColor: SharedHelper.get(key: 'theme') == 'Light Theme'
                    ? Colors.white
                    : Theme.of(context).scaffoldBackgroundColor,
                appBar: AppBar(
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.keyboard_arrow_left)),
                  titleSpacing: 0,
                  title: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            backgroundImage:
                                const AssetImage('assets/images/logo.jpg'),
                          ),
                          const SizedBox(
                            width: 11,
                          ),
                          Text(
                            "Orders".tr(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      navigateToWithReturn(context, UsersGroupScreen());
                    },
                  ),
                ),
                body: Column(
                  children: [
                    ConditionalBuilder(
                        condition: OrdersHomeCubit.get(context)
                            .massagesGroup
                            .isNotEmpty,
                        builder: (context) => Expanded(
                              child: Stack(
                                children: [
                                  Image(
                                      fit: BoxFit.fill,
                                      width: double.infinity,
                                      height: double.infinity,
                                      image: SharedHelper.get(key: 'theme') ==
                                              'Light Theme'
                                          ? const AssetImage(
                                              'assets/images/cccc.jpg')
                                          : const AssetImage(
                                              'assets/images/cc.jpg')),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        top: 20, start: 10, end: 10, bottom: 8),
                                    child: ListView.separated(
                                        physics: const BouncingScrollPhysics(),
                                        reverse: true,
                                        itemBuilder: (context, index) {
                                          var massage =
                                              OrdersHomeCubit.get(context)
                                                  .massagesGroup[index];
                                          if (massage.text != '') {
                                            bool flag = false;
                                            if (signIn!=null&&
                                                FirebaseAuth.instance.currentUser!.uid == massage.senderId) {
                                              if (index > 0) {
                                                var nextMassage =
                                                    OrdersHomeCubit.get(context)
                                                            .massagesGroup[
                                                        index - 1];
                                                if (FirebaseAuth.instance
                                                        .currentUser!.uid !=
                                                    nextMassage.senderId) {
                                                  flag = true;
                                                }
                                              }
                                              if (index == 0) {
                                                flag = true;
                                              }
                                              return buildSenderMassage(massage,
                                                  context, index, flag);
                                            }
                                            else   if (email!=null&&
                                                OrdersHomeCubit.get(context).currentAdmin!.id == massage.senderId) {
                                              if (index > 0) {
                                                var nextMassage =
                                                OrdersHomeCubit.get(context)
                                                    .massagesGroup[
                                                index - 1];
                                                if (OrdersHomeCubit.get(context).currentAdmin!.id !=
                                                    nextMassage.senderId) {
                                                  flag = true;
                                                }
                                              }
                                              if (index == 0) {
                                                flag = true;
                                              }
                                              return buildSenderMassage(massage,
                                                  context, index, flag);
                                            }
                                            else {
                                              if (index > 0) {
                                                var nextMassage =
                                                    OrdersHomeCubit.get(context)
                                                            .massagesGroup[
                                                        index - 1];
                                                if (massage.senderId !=
                                                    nextMassage.senderId) {
                                                  flag = true;
                                                }
                                              }
                                              if (index == 0) {
                                                flag = true;
                                              }
                                              return buildReceiverMassage(
                                                  massage,
                                                  context,
                                                  index,
                                                  flag);
                                            }
                                          }
                                          return null;
                                        },
                                        separatorBuilder: (context, index) {
                                          var massage =
                                              OrdersHomeCubit.get(context)
                                                  .massagesGroup[index];
                                          if (index > 0) {
                                            var nextMassage =
                                                OrdersHomeCubit.get(context)
                                                    .massagesGroup[index - 1];
                                            if (signIn!=null&&FirebaseAuth.instance
                                                    .currentUser!.uid ==
                                                massage.senderId) {
                                              if (signIn!=null&&FirebaseAuth.instance
                                                      .currentUser!.uid !=
                                                  nextMassage.senderId) {
                                                return const SizedBox(
                                                  height: 10,
                                                );
                                              }
                                            } else {
                                              if (massage.senderId !=
                                                  nextMassage.senderId) {
                                                return const SizedBox(
                                                  height: 10,
                                                );
                                              }
                                            }
                                          }
                                          if (index == 0) {
                                            return const SizedBox(
                                              height: 10,
                                            );
                                          }
                                          return const SizedBox(
                                            height: 0.5,
                                          );
                                        },
                                        itemCount: OrdersHomeCubit.get(context)
                                            .massagesGroup
                                            .length),
                                  ),
                                ],
                              ),
                            ),
                        fallback: (context) => Expanded(
                                child: Center(
                                    child: Text(
                              'No Massages',
                              style: Theme.of(context).textTheme.bodyText2,
                            )))),
                    if (OrdersHomeCubit.get(context).massagesGroup.isEmpty)
                      const Spacer(),
                    buildBottom(context, state),
                  ],
                ));
          });
    });
  }

  Widget buildSenderMassage(
      MassageModelGroup massageModelGroup, context, index, flag) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Column(
        children: [
          if (flag)
            const SizedBox(
              height: 5,
            ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (flag)
                Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: 5,
                      end: 5,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (flag)
                          Text(
                            massageModelGroup.name,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        Text(
                          getTime(massageModelGroup.dateTime),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[300]),
                        ),
                      ],
                    ),
                  ),
                ),
              if (flag)
                const SizedBox(
                  width: 10,
                ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.6),
                    borderRadius: const BorderRadiusDirectional.only(
                      topStart: Radius.circular(10),
                      topEnd: Radius.circular(10),
                      bottomStart: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    massageModelGroup.text,
                    style: Theme.of(context).textTheme.bodyText2,
                    maxLines: 1000,
                    softWrap: true,
                  ),
                ),
              ),
              if (flag)
                const SizedBox(
                  width: 4,
                ),
              if (flag)
                CircleAvatar(
                  radius: 20,
                  backgroundColor:
                      SharedHelper.get(key: 'theme') == 'Light Theme'
                          ? Colors.white
                          : Theme.of(context).scaffoldBackgroundColor,
                  backgroundImage: const AssetImage("assets/images/logo.jpg"),
                ),
              if (!flag)
                const SizedBox(
                  width: 40,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildReceiverMassage(
          MassageModelGroup massageModelGroup, context, index, flag) =>
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: Column(
          children: [
            if (flag)
              const SizedBox(
                height: 5,
              ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (flag)
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    backgroundImage:const AssetImage("assets/images/logo.jpg"),
                  ),
                if (flag)
                  const SizedBox(
                    width: 4,
                  ),
                if (!flag)
                  const SizedBox(
                    width: 40,
                  ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadiusDirectional.only(
                        topStart: Radius.circular(10),
                        topEnd: Radius.circular(10),
                        bottomEnd: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      massageModelGroup.text,
                      style: Theme.of(context).textTheme.bodyText2,
                      maxLines: 1000,
                      softWrap: true,
                    ),
                  ),
                ),
                if (flag)
                  const SizedBox(
                    width: 10,
                  ),
                if (flag)
                  Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: 5,
                        end: 5,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (flag)
                            Text(
                              massageModelGroup.name,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          Text(
                            getTime(massageModelGroup.dateTime),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[300]),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      );

  buildBottom(context, state) => Padding(
        padding: const EdgeInsetsDirectional.only(
            top: 2, start: 5, end: 5, bottom: 2),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: SharedHelper.get(key: 'theme') == 'Light Theme'
                ? Colors.white
                : Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  maxLines: 1000,
                  minLines: 1,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                  controller: textController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'write here your massage...',
                      hintStyle: TextStyle(color: Colors.grey)),
                  // style: Theme.of(context).textTheme.bodyText2,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5, right: 5),
                child: MaterialButton(
                    height: 50,
                    color: SharedHelper.get(key: 'theme') == 'Light Theme'
                        ? Colors.white
                        : Theme.of(context).scaffoldBackgroundColor,
                    onPressed: () {
                      if (textController.text != '') {
                        OrdersHomeCubit.get(context).addMassageToGroup(
                          name:signIn!=null? OrdersHomeCubit.get(context).userProfile!.name:
                            OrdersHomeCubit.get(context).currentAdmin!.email.split("@")[0],
                            createdAt: Timestamp.now().toString(),
                            text: textController.text,
                            senderId: signIn!=null? OrdersHomeCubit.get(context).userProfile!.uid:
                            OrdersHomeCubit.get(context).currentAdmin!.id,
                            dateTime: DateTime.now().toString());
                        textController.text = '';
                      }
                    },
                    child: const Icon(
                      Icons.send,
                      color: Colors.pink,
                      size: 25,
                    )),
              ),
            ],
          ),
        ),
      );

  String getTime(dateTime) {
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
