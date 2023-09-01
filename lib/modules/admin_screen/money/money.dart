import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:orders/shared/network/local/cashe_helper.dart';

class MoneyScreen extends StatefulWidget {
   MoneyScreen({super.key});

  @override
  State<MoneyScreen> createState() => _MoneyScreenState();
}

class _MoneyScreenState extends State<MoneyScreen> {
  String menuSelected="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Money".tr()),
        titleSpacing: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children:
          [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton(
                dropdownColor: SharedHelper.get(key: 'theme') == 'Light Theme'
                    ? Colors.deepPurple
                    : Colors.white,
                focusColor: Theme
                    .of(context)
                    .scaffoldBackgroundColor,
                underline: Container(),
                icon: Icon(Icons.money, color: Theme
                    .of(context)
                    .primaryColor,),
                elevation: 0,
                style: Theme
                    .of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(
                    color: Theme
                        .of(context)
                        .scaffoldBackgroundColor),
                value: menuSelected,
                items: [
                  DropdownMenuItem(
                    value: "Advertising",
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5,bottom: 5),
                        child: Text("Add the Advertising Money".tr()),
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "Salaries",
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5,bottom: 5),
                        child: Text("Add the Salaries Money".tr()),
                      ),
                    ),
                  ),
                ],
                onChanged: (val) {
                   setState(() {
                     if(val!=null){
                       menuSelected=val;
                     }
                   });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
