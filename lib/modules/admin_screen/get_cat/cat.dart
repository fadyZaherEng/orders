import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/models/category_model.dart';
import 'package:orders/shared/components/components.dart';
import 'package:orders/shared/lang/arabic.dart';
import 'package:orders/shared/lang/english.dart';
import 'package:orders/shared/network/local/cashe_helper.dart';

class ShowCategoriesScreen extends StatelessWidget {
  const ShowCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: ConditionalBuilder(
              condition: OrdersHomeCubit.get(context).categories.isNotEmpty,
              builder: (context) => ListView.separated(
                itemBuilder: (context, idx) {
                  return listItem(
                      OrdersHomeCubit.get(context).categories[idx], context);
                },
                itemCount: OrdersHomeCubit.get(context).categories.length,
                separatorBuilder: (context, idx) => mySeparator(context),
              ),
              fallback: (context) => const Center(
                  child: CircularProgressIndicator(
                color: Colors.blue,
              )),
            ),
          ),
        );
      },
    );
  }

  Widget listItem(CategoryModel categoryModel, context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Theme.of(context).scaffoldBackgroundColor,
          shadowColor: Theme.of(context).primaryColor,
          elevation: 10,
          shape: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            SharedHelper.get(key: 'lang')=='arabic'?arabic["Category Name"]:english["Category Name"],
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            categoryModel.catName,
                          ),
                        ],
                      ),
                      const SizedBox(width: 10,),
                      Row(
                        children: [
                          Text(
                      SharedHelper.get(key: 'lang')=='arabic'?arabic["Date: "]:english["Date: "],
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            DateFormat.yMMMMd()
                                .format(DateTime.parse(categoryModel.date)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            SharedHelper.get(key: 'lang')=='arabic'?arabic["Amount: "]:english['Amount: '],
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            categoryModel.amount.toString(),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10,),
                      Row(
                        children: [
                          Text(
                            SharedHelper.get(key: 'lang')=='arabic'?arabic["Price: "]:english['Price: '],
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            categoryModel.price.toString(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            SharedHelper.get(key: 'lang')=='arabic'?arabic["Charging: "]:english['Charging: '],
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            categoryModel.salOfCharging.toString(),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10,),
                      Row(
                        children: [
                          Text(
                            SharedHelper.get(key: 'lang')=='arabic'?arabic["Total Price: "]:english['Total Price: '],
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            categoryModel.totalPrice.toString(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Flexible(
                  child: Text(categoryModel.notes),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
