import 'package:flutter/services.dart';

abstract final class DeviceTimezone {
  static const _channel = MethodChannel('com.milestracks/device');

  static Future<String> getIanaName() async {
    final timezone = await _channel.invokeMethod<String>('getIanaTimezone');
    if (timezone == null || timezone.isEmpty) {
      throw StateError('IANA timezone could not be determined.');
    }
    return timezone;
  }
}
