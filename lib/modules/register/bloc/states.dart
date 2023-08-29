abstract class OrdersAppRegisterStates{}

class OrdersAppRegisterInitialStates extends OrdersAppRegisterStates{}
class OrdersAppRegisterLoadingStates extends OrdersAppRegisterStates{}
class OrdersAppRegisterSuccessStates extends OrdersAppRegisterStates{
  String uid;

  OrdersAppRegisterSuccessStates(this.uid);
}
class OrdersAppRegisterErrorStates extends OrdersAppRegisterStates{
  String error;
  OrdersAppRegisterErrorStates(this.error);
}

class OrdersAppRegisterChangeEyeStates extends OrdersAppRegisterStates{}
class OrdersAppRegisterChangeImageStates extends OrdersAppRegisterStates{}
//image
class OrdersAppRegisterImageSuccessStates extends OrdersAppRegisterStates{}
class OrdersAppRegisterImageErrorStates extends OrdersAppRegisterStates{}