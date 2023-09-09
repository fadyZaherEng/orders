abstract class OrdersAppAddAdminStates{}


class OrdersAppAddAdminInitialStates extends OrdersAppAddAdminStates{}
class OrdersAppAddAdminLoadingStates extends OrdersAppAddAdminStates{}
class OrdersAppAddAdminSuccessStates extends OrdersAppAddAdminStates{
String uid;

OrdersAppAddAdminSuccessStates(this.uid);
}
class OrdersAppAddAdminErrorStates extends OrdersAppAddAdminStates{
  String error;

  OrdersAppAddAdminErrorStates(this.error);
}
//admin
class OrdersAppAddAdminAdminInitialStates extends OrdersAppAddAdminStates{}
class OrdersAppAddAdminAdminLoadingStates extends OrdersAppAddAdminStates{}
class OrdersAppAddAdminAdminSuccessStates extends OrdersAppAddAdminStates{
  String uid;

  OrdersAppAddAdminAdminSuccessStates(this.uid);
}
class OrdersAppAddAdminAdminErrorStates extends OrdersAppAddAdminStates{
  String error;

  OrdersAppAddAdminAdminErrorStates(this.error);
}

class OrdersAppAddAdminChangeEyeStates extends OrdersAppAddAdminStates{}
