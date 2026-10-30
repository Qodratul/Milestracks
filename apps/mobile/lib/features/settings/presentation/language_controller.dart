import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:milestracks/core/di/repository_providers.dart';
import 'package:milestracks/core/storage/secure_storage_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'language_controller.g.dart';

@Riverpod(keepAlive: true)
class LanguageController extends _$LanguageController {
  @override
  Locale build() {
    unawaited(_restoreLanguage());
    return const Locale('en');
  }

  Future<void> setLanguage(
    String languageCode, {
    bool syncServer = true,
  }) async {
    if (languageCode != 'en' && languageCode != 'id') {
      throw ArgumentError.value(languageCode, 'languageCode');
    }
    state = Locale(languageCode);
    await ref
        .read(secureStorageProvider)
        .write(SecureStorageKeys.appLanguage, languageCode);
    if (syncServer) {
      await ref.read(onboardingRepositoryProvider).updateLanguage(languageCode);
    }
  }

  Future<void> _restoreLanguage() async {
    final languageCode = await ref
        .read(secureStorageProvider)
        .read(SecureStorageKeys.appLanguage);
    if (languageCode == 'id' || languageCode == 'en') {
      state = Locale(languageCode!);
    }
  }
}
