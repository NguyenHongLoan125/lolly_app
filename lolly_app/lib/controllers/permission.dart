import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

Future<void> requestPhotoPermission() async {
  PermissionStatus status;

  if (Platform.isAndroid) {
    // Lấy version SDK
    final sdkInt = (await Permission.storage.status).isGranted
        ? 32 // giả định nếu đã granted mà không biết sdk
        : await _getAndroidSdkInt();

    if (sdkInt >= 33) {
      // Android 13 trở lên
      status = await Permission.photos.request();
    } else {
      // Android thấp hơn
      status = await Permission.storage.request();
    }
  } else if (Platform.isIOS) {
    // iOS
    status = await Permission.photos.request();
  } else {
    // Platform khác (web, desktop)
    return;
  }

  if (status.isGranted) {
    print('✅ Quyền đã được cấp');
  } else if (status.isDenied) {
    print('❌ Quyền bị từ chối');
  } else if (status.isPermanentlyDenied) {
    print('⚠️ Người dùng từ chối vĩnh viễn - cần mở cài đặt');
    openAppSettings();
  }
}

Future<int> _getAndroidSdkInt() async {
  try {
    // Sử dụng package device_info_plus để lấy SDK version
    // Thêm dependency trong pubspec.yaml: device_info_plus: ^9.0.2

    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.sdkInt ?? 0;
  } catch (e) {
    print('Lỗi lấy sdkInt: $e');
    return 0;
  }
}
