// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'readiness_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ReadinessAnswers)
final readinessAnswersProvider = ReadinessAnswersProvider._();

final class ReadinessAnswersProvider
    extends $NotifierProvider<ReadinessAnswers, Map<int, bool>> {
  ReadinessAnswersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readinessAnswersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readinessAnswersHash();

  @$internal
  @override
  ReadinessAnswers create() => ReadinessAnswers();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<int, bool> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<int, bool>>(value),
    );
  }
}

String _$readinessAnswersHash() => r'2949e3fea39a5ad2cd91bb55b7efea84217753ed';

abstract class _$ReadinessAnswers extends $Notifier<Map<int, bool>> {
  Map<int, bool> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Map<int, bool>, Map<int, bool>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<int, bool>, Map<int, bool>>,
              Map<int, bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(ReadinessConsent)
final readinessConsentProvider = ReadinessConsentProvider._();

final class ReadinessConsentProvider
    extends $NotifierProvider<ReadinessConsent, bool> {
  ReadinessConsentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readinessConsentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readinessConsentHash();

  @$internal
  @override
  ReadinessConsent create() => ReadinessConsent();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$readinessConsentHash() => r'7c76ca0f62e160009fecc655f054c96dbe88960b';

abstract class _$ReadinessConsent extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
