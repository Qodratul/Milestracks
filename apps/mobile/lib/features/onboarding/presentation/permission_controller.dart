import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permission_controller.g.dart';

typedef OnboardingPermissionState = ({bool location, bool notifications});

@riverpod
class PermissionController extends _$PermissionController {
  @override
  Future<OnboardingPermissionState> build() async => (
    location: await Permission.locationWhenInUse.isGranted,
    notifications: await Permission.notification.isGranted,
  );

  Future<void> requestLocation() => _request(Permission.locationWhenInUse);

  Future<void> requestNotifications() => _request(Permission.notification);

  Future<void> refreshStatus() async {
    state = const AsyncLoading<OnboardingPermissionState>();
    state = await AsyncValue.guard(
      () async => (
        location: await Permission.locationWhenInUse.isGranted,
        notifications: await Permission.notification.isGranted,
      ),
    );
  }

  Future<void> _request(Permission permission) async {
    state = const AsyncLoading<OnboardingPermissionState>();
    state = await AsyncValue.guard(() async {
      final result = await permission.request();
      if (result.isPermanentlyDenied) await openAppSettings();
      return (
        location: await Permission.locationWhenInUse.isGranted,
        notifications: await Permission.notification.isGranted,
      );
    });
  }
}
