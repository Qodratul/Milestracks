// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'run_engine_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RunEngineController)
final runEngineControllerProvider = RunEngineControllerProvider._();

final class RunEngineControllerProvider
    extends $NotifierProvider<RunEngineController, RunEngineState> {
  RunEngineControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'runEngineControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$runEngineControllerHash();

  @$internal
  @override
  RunEngineController create() => RunEngineController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RunEngineState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RunEngineState>(value),
    );
  }
}

String _$runEngineControllerHash() =>
    r'c5b383f8dc3d4d499381f027a582999198abb967';

abstract class _$RunEngineController extends $Notifier<RunEngineState> {
  RunEngineState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RunEngineState, RunEngineState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RunEngineState, RunEngineState>,
              RunEngineState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
