import 'package:permission_handler/permission_handler.dart';

class AppPermissions {
  static Future<void> requestAll() async {
    await [
      Permission.sms,
      Permission.camera,
      Permission.notification,
    ].request();
  }
}
