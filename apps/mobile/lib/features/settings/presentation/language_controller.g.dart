// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LanguageController)
final languageControllerProvider = LanguageControllerProvider._();

final class LanguageControllerProvider
    extends $NotifierProvider<LanguageController, Locale> {
  LanguageControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'languageControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$languageControllerHash();

  @$internal
  @override
  LanguageController create() => LanguageController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale>(value),
    );
  }
}

String _$languageControllerHash() =>
    r'b644fdd55273e781b897898921fb1eeebc64d7ff';

abstract class _$LanguageController extends $Notifier<Locale> {
  Locale build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Locale, Locale>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale, Locale>,
              Locale,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
