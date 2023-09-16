import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/shared/components/components.dart';
//checked
class AddCityScreen extends StatefulWidget {
  @override
  State<AddCityScreen> createState() => _AddCityScreenState();
}

class _AddCityScreenState extends State<AddCityScreen> {
  var formKey = GlobalKey<FormState>();

  String stateValue = "Select State".tr();

  var cityNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Add City".tr()),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton(
                          dropdownColor: Theme.of(context).primaryColor,
                          focusColor: Theme.of(context).scaffoldBackgroundColor,
                          underline: Container(),
                          hint: Text(stateValue),
                          icon: Icon(
                            Icons.baby_changing_station,
                            color: Theme.of(context).primaryColor,
                          ),
                          elevation: 0,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                          items: OrdersHomeCubit.get(context)
                              .states
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      stateValue = e;
                                      setState(() {});
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(e),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              stateValue = val;
                              setState(() {});
                            }
                          }),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    defaultTextForm(
                        context: context,
                        Controller: cityNameController,
                        prefixIcon: const Icon(Icons.category),
                        text: "City Name: ".tr(),
                        validate: (val) {
                          if (val.toString().isEmpty) {
                            return "Please Enter City Name".tr();
                          }
                          if(stateValue == "Select State".tr()){
                            return "Please Enter State Name".tr();
                          }
                          return null;
                        },
                        type: TextInputType.text),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          if (formKey.currentState!.validate()&&stateValue != "Select State".tr()) {
                            OrdersHomeCubit.get(context).addCites(cityNameController.text,stateValue);
                            cityNameController.text = "";
                          }
                        },
                        child: Text(
                          "Add City".tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                    ),
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
