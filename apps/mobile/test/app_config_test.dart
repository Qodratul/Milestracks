import 'package:flutter_test/flutter_test.dart';
import 'package:milestracks/core/config/app_config.dart';

void main() {
  test('test command selects Fake repositories explicitly', () {
    expect(AppConfig.useFakeApi, isTrue);
  });
}
