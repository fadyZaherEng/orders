import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/models/state_model.dart';
import 'package:orders/shared/components/components.dart';
//checked
class AddStatesScreen extends StatelessWidget {
  var formKey=GlobalKey<FormState>();

  var stateNameController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title:  Text("Add State".tr()),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10,),
                  defaultTextForm(
                      context: context,
                      Controller: stateNameController,
                      prefixIcon: const Icon(Icons.category),
                      text:"State Name: ".tr(),
                      validate: (val) {
                        if (val.toString().isEmpty) {
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
                      color: Theme
                          .of(context)
                          .primaryColor,
                      onPressed: () {
                        if(formKey.currentState!.validate()){
                          OrdersHomeCubit.get(context).addStates(stateNameController.text);
                          stateNameController.text="";
                        }
                      },
                      child: Text(
                        "Add State".tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color:
                          Theme
                              .of(context)
                              .scaffoldBackgroundColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ConditionalBuilder(
                    condition: OrdersHomeCubit.get(context).states.isNotEmpty,
                    builder: (context) => Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, idx) {
                          return listItem(
                              OrdersHomeCubit.get(context).states[idx], context);
                        },
                        itemCount: OrdersHomeCubit.get(context).states.length,
                        separatorBuilder: (context, idx) => const SizedBox(height: 20,),
                      ),
                    ),
                    fallback: (context) => Center(child: Text("Not".tr())),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  Widget listItem(StateModel stateModel, context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Text(
                "State".tr(),
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 30,),
              Text(
                stateModel.state,
              ),
              const SizedBox(width: 30,),
              TextButton(
                  onPressed: () {
                    OrdersHomeCubit.get(context).removeState(
                        docId: stateModel.id, context: context);
                  },
                  child: const Icon(Icons.delete)),
            ],
          ),
        ),
      ),
    );
  }

}
