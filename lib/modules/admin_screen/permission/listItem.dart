// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/models/admin_model.dart';

class ListItem extends StatefulWidget {
  BuildContext ctx;
  AdminModel admin;
  bool showOrders, showCategories, addCat, saveOrder, removeOrder;

  ListItem({
    required this.ctx,
    required this.admin,
    required this.showOrders,
    required this.showCategories,
    required this.addCat,
    required this.saveOrder,
    required this.removeOrder,
  });
  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide.none),
        color: Colors.grey[400],
        elevation: 15,
        shadowColor: Theme.of(widget.ctx).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "${"Admin Email: ".tr()}${widget.admin.email}",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SwitchListTile(
                key: ValueKey('${widget.admin.id}kllhgfbhjgcfxdfjgkh'),
                value: widget.showOrders,
                title: Text("Show Orders".tr()),
                onChanged: (value) {
                  widget.showOrders = value;
                  OrdersHomeCubit.get(widget.ctx).adminShowOrdersPermission(
                    value,
                    widget.admin,
                    widget.ctx,
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              SwitchListTile(
                key: ValueKey('${widget.admin.id}kjkhgfcgkhljhig'),
                value: widget.showCategories,
                title: Text("Show Categories".tr()),
                onChanged: (value) {
                  widget.showCategories = value;
                  OrdersHomeCubit.get(widget.ctx).adminShowCategoriesPermission(
                    value,
                    widget.admin,
                    widget.ctx,
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              SwitchListTile(
                key: ValueKey('${widget.admin.id}ddddddddlkjuhg'),
                value: widget.addCat,
                title: Text("Add Category".tr()),
                onChanged: (value) {
                  widget.addCat = value;
                  OrdersHomeCubit.get(widget.ctx).adminAddCatPermission(
                    value,
                    widget.admin,
                    widget.ctx,
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              SwitchListTile(
                key: ValueKey(
                  '${widget.admin.id}njhgkoihuyftxgchjkjkhlj',
                ),
                value: widget.saveOrder,
                title: Text("Save".tr()),
                onChanged: (value) {
                  widget.saveOrder = value;
                  OrdersHomeCubit.get(widget.ctx).adminSaveOrderPermission(
                    value,
                    widget.admin,
                    widget.ctx,
                  );
                },
              ),
              const SizedBox(height: 10),
              SwitchListTile(
                key: ValueKey('${widget.admin.id}1dssssssssssvv'),
                value: widget.removeOrder,
                title: Text("Delete".tr()),
                onChanged: (value) {
                  widget.removeOrder = value;
                  OrdersHomeCubit.get(widget.ctx).adminRemoveOrderPermission(
                    value,
                    widget.admin,
                    widget.ctx,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
