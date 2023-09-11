import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/models/category_model.dart';
import 'package:orders/shared/components/components.dart';

class ShowCategoriesScreen extends StatefulWidget {
  const ShowCategoriesScreen({super.key});

  @override
  State<ShowCategoriesScreen> createState() => _ShowCategoriesScreenState();
}

class _ShowCategoriesScreenState extends State<ShowCategoriesScreen> {
  var quantityController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  bool edit = false;

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
        child: Card(
          color: Theme.of(context).scaffoldBackgroundColor,
          shadowColor: Theme.of(context).primaryColor,
          elevation: 10,
          shape: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
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
                      const SizedBox(
                        width: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "Date: ".tr(),
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
                            "Amount: ".tr(),
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
                      const SizedBox(
                        width: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "Price: ".tr(),
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
                            "Charging: ".tr(),
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
                      const SizedBox(
                        width: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "Total Price: ".tr(),
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
                Flexible(child: Text('${"Notes".tr()} ${categoryModel.notes}')),
                Flexible(
                    child: Text('${"Source".tr()} ${categoryModel.source}')),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {});
                          edit = false;
                          OrdersHomeCubit.get(context).removeCat(
                              docId: categoryModel.catId, context: context);
                        },
                        child: Text("Delete".tr())),
                    TextButton(
                        onPressed: () {
                          edit = true;
                          setState(() {});
                        },
                        child: Text("Edit".tr())),
                  ],
                ),
                if (edit)
                  const SizedBox(
                    height: 10,
                  ),
                if (edit)
                  Row(
                    children: [
                      Expanded(
                        child: defaultTextForm(
                            context: context,
                            Controller: quantityController,
                            prefixIcon:
                                const Icon(Icons.production_quantity_limits),
                            text: "Quantity".tr(),
                            validate: (val) {
                              if (val.toString().isEmpty) {
                                return "Please Enter Quantity".tr();
                              }
                              return null;
                            },
                            type: TextInputType.text),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      TextButton(
                          onPressed: () {
                            categoryModel.amount =
                                int.parse(quantityController.text.toString());
                            if (quantityController.text != "") {
                              OrdersHomeCubit.get(context).editCat(
                                  docId: categoryModel.catId,
                                  categoryModel: categoryModel,
                                  context: context);
                            }
                          },
                          child: Text("Edit".tr())),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
