import 'package:fluttertoast/fluttertoast.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeveloperOptions {
  static Future<void> checkDeveloperOptions() async {
    bool isDeveloperOptionsEnabled = await _isDeveloperOptionsEnabled();

    if (isDeveloperOptionsEnabled) {
      Fluttertoast.showToast(
        msg: "Developer Options is ON!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  static Future<bool> _isDeveloperOptionsEnabled() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    return androidInfo.isPhysicalDevice && androidInfo.version.sdkInt >= 30;
  }
}
