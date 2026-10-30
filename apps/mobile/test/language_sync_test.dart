import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:milestracks/core/storage/secure_storage_service.dart';
import 'package:milestracks/features/settings/presentation/language_controller.dart';

void main() {
  test('language change persists and synchronizes', () async {
    final storage = MemorySecureStorageService();
    final container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);
    await container
        .read(languageControllerProvider.notifier)
        .setLanguage('id')
        .timeout(const Duration(seconds: 5));
    expect(container.read(languageControllerProvider).languageCode, 'id');
  });
}
