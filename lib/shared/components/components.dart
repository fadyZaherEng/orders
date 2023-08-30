import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';


void navigateToWithoutReturn(context,Widget screen)
=> Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
        builder: (context)=>screen
    ),
        (Route<dynamic>route) => false);
void navigateToWithReturn(context,Widget screen)
=> Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context)=>screen
    ));
Widget defaultTextForm({
  required context,
  required TextEditingController Controller,
  Widget? suffixIcon,
  required Widget prefixIcon,
  required String text,
  required FormFieldValidator validate,
  bool obscure=false,
  required TextInputType type,
})
=> TextFormField(
  controller: Controller,
  maxLines: 1000,
  minLines: 1,
  decoration: InputDecoration(
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    label: Text(text),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  style:Theme.of(context).textTheme.bodyText2,
  validator: validate,
  obscureText:obscure ,
  keyboardType: type,
);
enum ToastState {SUCCESS,ERROR,WARNING}
Future<bool?> showToast({
  required String message,
  required ToastState state,
})
=> Fluttertoast.showToast(
  msg:message,
  gravity: ToastGravity.BOTTOM,
  textColor: Colors.white,
  toastLength: Toast.LENGTH_LONG,
  timeInSecForIosWeb: 5,
  backgroundColor: chooseToastColor(state),
);

Color chooseToastColor(ToastState state)
{
  late Color color;
  switch(state){
    case ToastState.SUCCESS:
      color=HexColor('180040');
      break;
    case ToastState.ERROR:
      color=Colors.red;
      break;
    case ToastState.WARNING:
      color=Colors.amber;
      break;
  }
  return color;
}

Widget mySeparator(context)
=>Container(
  padding: const EdgeInsets.all(8),
  margin: const EdgeInsets.all(8),
  color: HexColor('180040'),
  width: double.infinity,
  height: 1,
);
Widget verifyEmail(context)
  => Padding(
    padding: const EdgeInsets.all(5),
    child: Container(
      color: Colors.amber.withOpacity(0.7),
      padding: const EdgeInsetsDirectional.only(start: 10, top: 10),
      child:Row(
        children: [
          const Icon(
            Icons.info_outline,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            'Please Verify Your Account',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.currentUser!
                  .sendEmailVerification()
                  .then((value) {
                showToast(message:'Email Verification sent', state: ToastState.SUCCESS);
                // SharedHelper.save(value: true, key: 'isVerified');
                // SocialCubit.get(context).verifyClose();
              }).catchError((onError) {
                showToast(message:onError.toString(), state: ToastState.ERROR);
              });
            },
            child: Text(
              'Send',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ],
      ),
    ),
  );
