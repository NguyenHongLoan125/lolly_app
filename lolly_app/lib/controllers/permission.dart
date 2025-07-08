import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

Future<void> requestPhotoPermission() async {
  PermissionStatus status;

  if (Platform.isAndroid) {
    final sdkInt = await _getAndroidSdkInt();
    print('📱 Android SDK version: $sdkInt');

    if (sdkInt >= 33) {
      // Android 13+ yêu cầu quyền ảnh riêng
      status = await Permission.photos.request(); // hoặc Permission.mediaLibrary nếu dùng media khác
    } else {
      // Android < 13 dùng quyền storage truyền thống
      status = await Permission.storage.request();
    }
  } else if (Platform.isIOS) {
    // iOS dùng quyền ảnh
    status = await Permission.photos.request();
  } else {
    print("⚠️ Không hỗ trợ platform này: ${Platform.operatingSystem}");
    return;
  }

  // Ghi log tình trạng quyền
  print('🔐 Trạng thái quyền: $status');
  print(' - isGranted: ${status.isGranted}');
  print(' - isDenied: ${status.isDenied}');
  print(' - isPermanentlyDenied: ${status.isPermanentlyDenied}');
  print(' - isRestricted: ${status.isRestricted}');

  // Xử lý logic quyền
  if (status.isGranted) {
    print('✅ Quyền đã được cấp');
  } else if (status.isDenied) {
    print('❌ Quyền bị từ chối (tạm thời)');
  } else if (status.isPermanentlyDenied || status.isRestricted) {
    print('⚠️ Quyền bị từ chối vĩnh viễn hoặc bị hạn chế — mở cài đặt');
    await openAppSettings();
  }
}

Future<int> _getAndroidSdkInt() async {
  try {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.sdkInt;
  } catch (e) {
    print('❌ Lỗi khi lấy SDK version: $e');
    return 0; // fallback
  }
}