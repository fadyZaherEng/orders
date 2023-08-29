abstract class OrdersAppLogInStates{}

class OrdersAppIsAdminStates extends OrdersAppLogInStates{}

class OrdersAppLogInInitialStates extends OrdersAppLogInStates{}
class OrdersAppLogInLoadingStates extends OrdersAppLogInStates{}
class OrdersAppLogInSuccessStates extends OrdersAppLogInStates{
String uid;

OrdersAppLogInSuccessStates(this.uid);
}
class OrdersAppLogInErrorStates extends OrdersAppLogInStates{
  String error;

  OrdersAppLogInErrorStates(this.error);
}
//admin
class OrdersAppLogInAdminInitialStates extends OrdersAppLogInStates{}
class OrdersAppLogInAdminLoadingStates extends OrdersAppLogInStates{}
class OrdersAppLogInAdminSuccessStates extends OrdersAppLogInStates{
  String uid;

  OrdersAppLogInAdminSuccessStates(this.uid);
}
class OrdersAppLogInAdminErrorStates extends OrdersAppLogInStates{
  String error;

  OrdersAppLogInAdminErrorStates(this.error);
}

class OrdersAppLogInChangeEyeStates extends OrdersAppLogInStates{}
