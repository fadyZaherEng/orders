import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/shared/components/components.dart';

//checked
class AddPapersScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  var paperNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Add Paper".tr()),
          ),
          body: Padding(
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
                  defaultTextForm(
                      context: context,
                      Controller: paperNameController,
                      prefixIcon: const Icon(Icons.newspaper),
                      text: "Paper Name: ".tr(),
                      validate: (val) {
                        if (val.toString().isEmpty) {
                          return "Please Enter Paper Name".tr();
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
                        if (formKey.currentState!.validate()) {
                          OrdersHomeCubit.get(context)
                              .addPapers(paperNameController.text);
                          paperNameController.text = "";
                        }
                      },
                      child: Text(
                        "Add Paper".tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return buildItem(
                              OrdersHomeCubit.get(context).papers[index],context);
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 20,
                            ),
                        itemCount: OrdersHomeCubit.get(context).papers.length),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildItem(String paper,context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
        [
          Text(paper),
          TextButton(onPressed: (){
            OrdersHomeCubit.get(context).removePaper(paper: paper, context: context);
          }, child: const Icon(Icons.delete)),
        ],
      ),
    );
  }
}
