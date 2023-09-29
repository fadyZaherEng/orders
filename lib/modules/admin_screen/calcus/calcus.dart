// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/models/order_model.dart';
import 'package:orders/shared/components/components.dart';

class CalcusScreen extends StatefulWidget {
  String paper;
  List<OrderModel>? orders;

  CalcusScreen(this.paper, this.orders);

  @override
  State<CalcusScreen> createState() => _CalcusScreenState();
}

class _CalcusScreenState extends State<CalcusScreen> {
  var page = "Show Order".tr();

  var moneyController = TextEditingController();
  double res=0;
  var formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 10, vertical: 10),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Text(
                      '${'Page Name : '.tr()}${widget.paper}',
                      maxLines: 100,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${'Orders Number : '.tr()}${widget.orders!.length.toString()}',
                      maxLines: 100,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DropdownButton(
                        dropdownColor: Theme.of(context).primaryColor,
                        focusColor: Theme.of(context).scaffoldBackgroundColor,
                        underline: Container(),
                        hint: Text(page),
                        icon: const Icon(
                          Icons.newspaper,
                          color: Colors.grey,
                        ),
                        elevation: 0,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).scaffoldBackgroundColor),
                        items: widget.orders!
                            .map(
                              (e) => DropdownMenuItem(
                                value: e.orderName,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    page = e.orderName;
                                    setState(() {});
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(e.orderName),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            page = val.toString();
                            setState(() {});
                          }
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: moneyController,
                      maxLines: 1000,
                      minLines: 1,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.money),
                        label: Text("Money".tr()),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: Theme.of(context).textTheme.bodyText2,
                      validator: (val) {
                        if (val.toString().isEmpty) {
                          return "Please Enter Money".tr();
                        }
                        return null;
                      },
                      onChanged: (val){
                        if(val.toString().isNotEmpty){
                         res= (double.parse(val.toString()) / widget.orders!.length);
                         setState(() {

                         });
                        }
                      },
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    if(res!=0)
                    Text('${'Value Of Order: '.tr()}${res.toString()}',maxLines: 100,),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
