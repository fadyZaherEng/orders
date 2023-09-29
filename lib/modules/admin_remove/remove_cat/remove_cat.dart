import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/models/category_model.dart';
import 'package:orders/shared/components/components.dart';

class RemoveCategoriesScreen extends StatefulWidget {
  @override
  State<RemoveCategoriesScreen> createState() => _RemoveCategoriesScreenState();
}

//checked
class _RemoveCategoriesScreenState extends State<RemoveCategoriesScreen> {
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
              fallback: (context) => Center(child: Text("Not Found".tr())),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    "Category Name".tr(),
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
            ),
            TextButton(
                onPressed: () {
                  setState(() {});
                  OrdersHomeCubit.get(context).removeCat(
                      docId: categoryModel.catId, context: context);
                },
                child: const Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}
