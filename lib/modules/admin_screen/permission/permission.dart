// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/modules/admin_screen/permission/listItem.dart';
import 'package:orders/shared/components/components.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  // bool showOrders = false,
  //     showCategories = false,
  //     addCat = false,
  //     saveOrder = false,
  //     removeOrder = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        return Scaffold(
          body: SafeArea(
            child: ConditionalBuilder(
              condition: OrdersHomeCubit.get(context).admins.isNotEmpty,
              builder: (ctx) => ListView.separated(
                  itemBuilder: (context, idx) => ListItem(
                        ctx: ctx,
                        admin: OrdersHomeCubit.get(context).admins[idx],
                        addCat: OrdersHomeCubit.get(context).admins[idx].addCat,
                        removeOrder: OrdersHomeCubit.get(context)
                            .admins[idx]
                            .removeOrder,
                        saveOrder:
                            OrdersHomeCubit.get(context).admins[idx].saveOrder,
                        showCategories: OrdersHomeCubit.get(context)
                            .admins[idx]
                            .showCategories,
                        showOrders:
                            OrdersHomeCubit.get(context).admins[idx].saveOrder,
                      ),
                  separatorBuilder: (context, idx) => mySeparator(context),
                  itemCount: OrdersHomeCubit.get(context).admins.length),
              fallback: (ctx) => Center(
                child: Text(
                  "Not Admin Found".tr(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

// Widget listItem(BuildContext ctx, AdminModel admin) {
//   showOrders = admin.showOrders;
//   showCategories = admin.showCategories;
//   addCat = admin.addCat;
//   saveOrder = admin.saveOrder;
//   removeOrder = admin.removeOrder;
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Card(
//       shape: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//           borderSide: BorderSide.none),
//       color: Colors.grey[400],
//       elevation: 15,
//       shadowColor: Theme.of(ctx).primaryColor,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(child: Text("${"Admin Email: ".tr()}${admin.email}")),
//             const SizedBox(
//               height: 20,
//             ),
//             SwitchListTile(
//                 key: UniqueKey(),
//                 value: showOrders,
//                 title: Text("Show Orders".tr()),
//                 onChanged: (value) {
//                   showOrders = value;
//                   OrdersHomeCubit.get(ctx)
//                       .adminShowOrdersPermission(value, admin, ctx);
//                 }),
//             const SizedBox(
//               height: 10,
//             ),
//             SwitchListTile(
//                 key: UniqueKey(),
//                 value: showCategories,
//                 title: Text("Show Categories".tr()),
//                 onChanged: (value) {
//                   showCategories = value;
//                   OrdersHomeCubit.get(ctx)
//                       .adminShowCategoriesPermission(value, admin, ctx);
//                 }),
//             const SizedBox(
//               height: 10,
//             ),
//             SwitchListTile(
//                 key: UniqueKey(),
//                 value: addCat,
//                 title: Text("Add Category".tr()),
//                 onChanged: (value) {
//                   addCat = value;
//                   OrdersHomeCubit.get(ctx)
//                       .adminAddCatPermission(value, admin, ctx);
//                 }),
//             const SizedBox(
//               height: 10,
//             ),
//             SwitchListTile(
//                 key: UniqueKey(),
//                 value: saveOrder,
//                 title: Text("Save".tr()),
//                 onChanged: (value) {
//                   saveOrder = value;
//                   OrdersHomeCubit.get(ctx)
//                       .adminSaveOrderPermission(value, admin, ctx);
//                 }),
//             const SizedBox(
//               height: 10,
//             ),
//             SwitchListTile(
//                 key: UniqueKey(),
//                 value: removeOrder,
//                 title: Text("Delete".tr()),
//                 onChanged: (value) {
//                   removeOrder = value;
//                   OrdersHomeCubit.get(ctx)
//                       .adminRemoveOrderPermission(value, admin, ctx);
//                 }),
//           ],
//         ),
//       ),
//     ),
//   );
// }
}
