abstract class OrdersHomeStates {}

class OrdersHomeInitialStates extends OrdersHomeStates {}
class OrderAddOrderLoadingStates extends OrdersHomeStates {}
class OrderUpdateOrderLoadingStates extends OrdersHomeStates {}

class OrdersHomeChangeBottomNavStates extends OrdersHomeStates {}

class OrdersHomeGetUserProfileLoadingStates extends OrdersHomeStates {}

class OrdersHomeGetUserProfileSuccessStates extends OrdersHomeStates {}

class OrdersHomeGetUserProfileErrorStates extends OrdersHomeStates {}
class OrdersHomeValidtePhoneOrderStates extends OrdersHomeStates {
  String? validate;
  OrdersHomeValidtePhoneOrderStates({required this.validate});
}

class OrdersUpdateProfileDataWaitingImageToFinishUploadStates
    extends OrdersHomeStates {}

class OrdersUpdateProfileDataWaitingImageToFinishUploadErrorStates
    extends OrdersHomeStates {}

class OrdersUpdateProfileDataWaitingImageToFinishSuccessStates
    extends OrdersHomeStates {}

class OrdersUpdateProfileDataWaitingImageToFinishErrorStates
    extends OrdersHomeStates {}

class OrdersGetAllUsersLoadingStates extends OrdersHomeStates {}

class OrdersGetAllUsersSuccessStates extends OrdersHomeStates {}

class OrdersGetAllUsersErrorStates extends OrdersHomeStates {}

class SocialGetUserStatusSuccessStates extends OrdersHomeStates {}

class SocialGetUserStatusErrorStates extends OrdersHomeStates {}

class OrdersEditProfileErrorStates extends OrdersHomeStates {}

class OrdersEditProfileSuccessStates extends OrdersHomeStates {}

//add massages
class SocialAddMassageLoadingStates extends OrdersHomeStates {}

class SocialAddMassageSuccessStates extends OrdersHomeStates {}

class SocialAddMassageErrorStates extends OrdersHomeStates {}

class SocialDeleteMassageSuccessStates extends OrdersHomeStates {}

class SocialDeleteMassageErrorStates extends OrdersHomeStates {}

class OrdersGetMassageErrorStates extends OrdersHomeStates {}

class OrdersGetMassageSuccessStates extends OrdersHomeStates {}

//image massage
class OrdersUploadImageLoadingSuccessStates extends OrdersHomeStates {}

class OrdersUploadImageLoadingErrorStates extends OrdersHomeStates {}

class OrdersChangeModeStates extends OrdersHomeStates {}

//files
class GetFileLoadingStates extends OrdersHomeStates {}

class GetFileSuccessStates extends OrdersHomeStates {}

class GetFileErrorStates extends OrdersHomeStates {}

class ViewFileLoadingStates extends OrdersHomeStates {}

class ViewFileSuccessStates extends OrdersHomeStates {}

class ViewFileErrorStates extends OrdersHomeStates {}

//files user reject
class RejectFileLoadingStates extends OrdersHomeStates {}

class RejectFileSuccessStates extends OrdersHomeStates {}

class RejectFileErrorStates extends OrdersHomeStates {}

//files user accept
class AcceptFileLoadingStates extends OrdersHomeStates {}

class AcceptFileSuccessStates extends OrdersHomeStates {}

class AcceptFileErrorStates extends OrdersHomeStates {}

//get user waiting
class GetUserWaitingLoadingStates extends OrdersHomeStates {}

class GetUserWaitingSuccessStates extends OrdersHomeStates {}

class GetUserWaitingErrorStates extends OrdersHomeStates {}

//get user accept account waiting
class GetUserAcceptWaitingLoadingStates extends OrdersHomeStates {}

class GetUserAcceptWaitingSuccessStates extends OrdersHomeStates {}

class GetUserAcceptWaitingErrorStates extends OrdersHomeStates {}

//get user reject account waiting
class GetUserRejectWaitingLoadingStates extends OrdersHomeStates {}

class GetUserRejectWaitingSuccessStates extends OrdersHomeStates {}

class GetUserRejectWaitingErrorStates extends OrdersHomeStates {}

class PhoneState extends OrdersHomeStates {}

class GetVedioLoadingStates extends OrdersHomeStates {}

class GetVedioSuccessStates extends OrdersHomeStates {}

class GetVedioErrorStates extends OrdersHomeStates {}

class GetImageLoadingStates extends OrdersHomeStates {}

class GetImageSuccessStates extends OrdersHomeStates {}

class GetImageErrorStates extends OrdersHomeStates {}

class ViewVedioLoadingStates extends OrdersHomeStates {}

class ViewVedioSuccessStates extends OrdersHomeStates {}

class ViewVedioErrorStates extends OrdersHomeStates {}

class ViewImageLoadingStates extends OrdersHomeStates {}

class ViewImageSuccessStates extends OrdersHomeStates {}

class ViewImageErrorStates extends OrdersHomeStates {}
