// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FeedbackController)
final feedbackControllerProvider = FeedbackControllerProvider._();

final class FeedbackControllerProvider
    extends $NotifierProvider<FeedbackController, void> {
  FeedbackControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'feedbackControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$feedbackControllerHash();

  @$internal
  @override
  FeedbackController create() => FeedbackController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$feedbackControllerHash() =>
    r'93b8737df3dce54808d12800ad412eeef2a1d454';

abstract class _$FeedbackController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
