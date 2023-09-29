import 'package:barcode_widget/barcode_widget.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/models/order_model.dart';
//checked
class SearchOrderPhoneScreen extends StatelessWidget {
  var searchController = TextEditingController();

  SearchOrderPhoneScreen({super.key});

  String result = '';

  dynamic totalPrice;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
        listener: (ctx, state) {},
        builder: (ctx, state) {
          return Scaffold(
            appBar: AppBar(
              actions: [Center(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                      '${"Total Price: ".tr()} ${OrdersHomeCubit
                          .get(context)
                          .searchOrderPhonePrice}',style: TextStyle(
                    color: Theme.of(context).primaryColor
                  ),),
                ),
              )],
              title: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                    '${"Total num: ".tr()} ${OrdersHomeCubit
                        .get(context)
                        .searchOrderPhoneNum}',style: TextStyle(
                color: Theme.of(context).primaryColor
              ),),
              ),
              titleSpacing: 0,
              automaticallyImplyLeading: false,
            ),
            body: Column(
              children: [
                //search
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      label: Text('Search Phone'.tr()),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.25)
                        ),
                      ),
                    ),
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyText2,
                    validator: (val) {
                      if (val
                          .toString()
                          .isEmpty) {
                        return "Please Enter phone number".tr();
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    onChanged: (phone) {
                      OrdersHomeCubit.get(context).searchOrdersByPhone(phone);
                    },
                    onFieldSubmitted: (phone) {
                      OrdersHomeCubit.get(context).searchOrdersByPhone(phone);
                    },
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ConditionalBuilder(
                    condition: OrdersHomeCubit
                        .get(context)
                        .searchOrderPhone
                        .isNotEmpty,
                    builder: (ctx) =>
                        ListView.separated(
                          itemBuilder: (context, idx) {
                            return listItem(
                                OrdersHomeCubit
                                    .get(context)
                                    .searchOrderPhone[idx],
                                context);
                          },
                          itemCount:
                          OrdersHomeCubit
                              .get(context)
                              .searchOrderPhone
                              .length,
                          separatorBuilder: (context, idx) =>
                          const SizedBox(
                            height: 30,
                          ),
                        ),
                    fallback: (ctx) => Center(child: Text("Not Orders ".tr())),
                  ),
                ),
              ],
            ),
          );
        });
  }

  listItem(OrderModel orderModel, context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Colors.black12,
        elevation: 10,
        margin: const EdgeInsets.all(5),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('${"Order Name: ".tr()}${orderModel.orderName}'),
              const SizedBox(
                height: 10,
              ),
              Text('${"Order Phone: ".tr()}${orderModel.orderPhone}'),
              const SizedBox(
                height: 10,
              ),
              Text('${"Order City: ".tr()}${orderModel.conservation}'),
              const SizedBox(
                height: 10,
              ),
              Text('${"Order Area: ".tr()}${orderModel.city}'),
              const SizedBox(
                height: 10,
              ),
              Text('${"Order Address: ".tr()} ${orderModel.address}'),
              const SizedBox(
                height: 10,
              ),
              Text('${"Item Name: ".tr()}${orderModel.type}'),
              const SizedBox(
                height: 10,
              ),
              Text('${"Employer Name: ".tr()}${orderModel.employerName}'),
              const SizedBox(
                height: 10,
              ),
              Text('${"Employer Email: ".tr()}${orderModel.employerEmail}'),
              const SizedBox(
                height: 10,
              ),
              Text('${"Employer Phone: ".tr()}${orderModel.employerPhone}'),
              const SizedBox(
                height: 10,
              ),
              Text(orderModel.number != 0
                  ? '${"Order Number: ".tr()}${orderModel.number.toString()}'
                  : ""),
              const SizedBox(
                height: 10,
              ),
              //barcode
              Center(
                child: BarcodeWidget(
                  color: Colors.white,
                  data: orderModel.barCode,
                  barcode: Barcode.qrCode(
                      errorCorrectLevel: BarcodeQRCorrectionLevel.high),
                  width: 200,
                  height: 200,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text('${"Date: ".tr()}${DateTime.parse(orderModel.date)}'),
              const SizedBox(
                height: 10,
              ),
              Text('${"Price".tr()} ${orderModel.price}'),
              const SizedBox(
                height: 10,
              ),
              Text('${"Charging".tr()} ${orderModel.salOfCharging}'),
              const SizedBox(
                height: 10,
              ),
              Text("${"Total Price: ".tr()}${orderModel.totalPrice}"),
            ],
          ),
        ),
      ),
    );
  }
}
