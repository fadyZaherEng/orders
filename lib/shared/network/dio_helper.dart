// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;
  static Init() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://fcm.googleapis.com/',
      receiveDataWhenStatusError: true,
    ));
  }
  static Future<Response> postData({
    String url = 'fcm/send',
    required String token,
    required String massage,
  }) {
    dio.options.headers = {
      'Authorization': "key=AAAArmlqDm4:APA91bHkyyMo4fwttJiK_nOp5wideWTSv2-rE3o9C9SuTL4tbXrmoqZqLxAS3vb-z7AzWM0PeFX6O4Bkox-NOWQPgLA7F8PAMD7oSPqq4XpmzjjqvterfxQwbCLVkTXsqNfdtFQpF88f",
      //key server
      'Content-Type': 'application/json',
    };
    return dio.post(
      url,
      data: getData(token, massage),
    );
  }

  static Map<dynamic, dynamic> getData(token, String massage) {
    return {
      "to": token,
      "notification": {
        "title": "New Message",
        "body": massage,
        "sound": "default"
      },
      "android": {
        "priority": "HIGH",
        "notification": {
          "notification_priority": "PRIORITY_MAX",
          "sound": "default",
          "default_sound": true,
          "default_vibrate_timings": true,
          "default_light_settings": true
        }
      },
      "data": {
        "type": "order",
        "id": "87",
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
      }
    };
  }
}
