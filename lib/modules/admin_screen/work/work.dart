import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/models/category_model.dart';
import 'package:orders/models/source_model.dart';
import 'package:orders/shared/components/components.dart';

class ShowSourceScreen extends StatefulWidget {
  const ShowSourceScreen({super.key});

  @override
  State<ShowSourceScreen> createState() => _ShowSourceScreenState();
}

//checked
class _ShowSourceScreenState extends State<ShowSourceScreen> {

  String import = "Select".tr();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton(
                      dropdownColor: Theme.of(context).primaryColor,
                      focusColor:
                      Theme.of(context).scaffoldBackgroundColor,
                      underline: Container(),
                      hint: Text(import),
                      icon: Icon(
                        Icons.medical_services_sharp,
                        color: Theme.of(context).primaryColor,
                      ),
                      elevation: 0,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(
                          color: Theme.of(context)
                              .scaffoldBackgroundColor),
                      items: OrdersHomeCubit.get(context).imports
                          .map(
                            (e) => DropdownMenuItem(
                          value: e.import,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              import = e.import;
                              OrdersHomeCubit.get(context).getSource(import);
                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(e.import),
                            ),
                          ),
                        ),
                      ).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          import = val;
                          setState(() {});
                          OrdersHomeCubit.get(context).getSource(import);
                        }
                      }),
                ),
                const SizedBox(
                  height: 20,
                ),
                ConditionalBuilder(
                  condition: OrdersHomeCubit.get(context).sources.isNotEmpty,
                  builder: (context) => Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, idx) {
                        return listItem(
                            OrdersHomeCubit.get(context).sources[idx], context);
                      },
                      itemCount: OrdersHomeCubit.get(context).sources.length,
                      separatorBuilder: (context, idx) => mySeparator(context),
                    ),
                  ),
                  fallback: (context) => Center(child: Text("Not Found".tr())),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget listItem(SourceModel sourceModel, context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Theme.of(context).scaffoldBackgroundColor,
          shadowColor: Theme.of(context).primaryColor,
          elevation: 10,
          shape: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
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
                            "Source Name".tr(),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            import,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Row(
                        children:
                        [
                          Text(
                            "Date: ".tr(),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            DateFormat.yMMMMd()
                                .format(DateTime.parse(sourceModel.date)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children:
                  [
                    Text(
                      "Price: ".tr(),
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      sourceModel.price.toString(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children:
                  [
                    Text(
                      "Total Price: ".tr(),
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      sourceModel.total.toString(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children:
                  [
                    Text(
                      "Category Quantity: ".tr(),
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      sourceModel.num.toString(),
                    ),
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
