import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/shared/components/components.dart';

class AddCityScreen extends StatelessWidget {
  var formKey=GlobalKey<FormState>();

  var cityNameController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title:  Text("Add City".tr()),
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
                    const SizedBox(height: 30,),
                    defaultTextForm(
                        context: context,
                        Controller: cityNameController,
                        prefixIcon: const Icon(Icons.category),
                        text:"City Name: ".tr(),
                        validate: (val) {
                          if (val.toString().isEmpty) {
                            return "Please Enter City Name".tr();
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
                        color: Theme
                            .of(context)
                            .primaryColor,
                        onPressed: () {
                          if(formKey.currentState!.validate()){
                           OrdersHomeCubit.get(context).addCites(cityNameController.text);
                            cityNameController.text="";
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
