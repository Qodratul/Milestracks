// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HistoryQueryController)
final historyQueryControllerProvider = HistoryQueryControllerProvider._();

final class HistoryQueryControllerProvider
    extends $NotifierProvider<HistoryQueryController, HistoryQueryState> {
  HistoryQueryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyQueryControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyQueryControllerHash();

  @$internal
  @override
  HistoryQueryController create() => HistoryQueryController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HistoryQueryState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HistoryQueryState>(value),
    );
  }
}

String _$historyQueryControllerHash() =>
    r'bb4f2787811e1cf4bdc145dec6d455fe4be95e28';

abstract class _$HistoryQueryController extends $Notifier<HistoryQueryState> {
  HistoryQueryState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<HistoryQueryState, HistoryQueryState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HistoryQueryState, HistoryQueryState>,
              HistoryQueryState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(RunHistoryController)
final runHistoryControllerProvider = RunHistoryControllerProvider._();

final class RunHistoryControllerProvider
    extends $AsyncNotifierProvider<RunHistoryController, RunHistoryPageDto> {
  RunHistoryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'runHistoryControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$runHistoryControllerHash();

  @$internal
  @override
  RunHistoryController create() => RunHistoryController();
}

String _$runHistoryControllerHash() =>
    r'1d9487cbefb349f2a874ce001a6b2326cd5fecdd';

abstract class _$RunHistoryController
    extends $AsyncNotifier<RunHistoryPageDto> {
  FutureOr<RunHistoryPageDto> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<RunHistoryPageDto>, RunHistoryPageDto>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<RunHistoryPageDto>, RunHistoryPageDto>,
              AsyncValue<RunHistoryPageDto>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Loads all cursor pages for the Profile summary, which is an aggregate view.
///
/// ASSUMPTION UNCONFIRMED: the API currently has no dedicated run-summary
/// endpoint, so the client derives these preview totals from first-party runs.

@ProviderFor(profileRunSummary)
final profileRunSummaryProvider = ProfileRunSummaryProvider._();

/// Loads all cursor pages for the Profile summary, which is an aggregate view.
///
/// ASSUMPTION UNCONFIRMED: the API currently has no dedicated run-summary
/// endpoint, so the client derives these preview totals from first-party runs.

final class ProfileRunSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RunDto>>,
          List<RunDto>,
          FutureOr<List<RunDto>>
        >
    with $FutureModifier<List<RunDto>>, $FutureProvider<List<RunDto>> {
  /// Loads all cursor pages for the Profile summary, which is an aggregate view.
  ///
  /// ASSUMPTION UNCONFIRMED: the API currently has no dedicated run-summary
  /// endpoint, so the client derives these preview totals from first-party runs.
  ProfileRunSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileRunSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileRunSummaryHash();

  @$internal
  @override
  $FutureProviderElement<List<RunDto>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RunDto>> create(Ref ref) {
    return profileRunSummary(ref);
  }
}

String _$profileRunSummaryHash() => r'b44fc1dd937a0fb70eaa1726d610b223e40360f7';

@ProviderFor(runDetail)
final runDetailProvider = RunDetailFamily._();

final class RunDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<RunDetailDto>,
          RunDetailDto,
          FutureOr<RunDetailDto>
        >
    with $FutureModifier<RunDetailDto>, $FutureProvider<RunDetailDto> {
  RunDetailProvider._({
    required RunDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'runDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$runDetailHash();

  @override
  String toString() {
    return r'runDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<RunDetailDto> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RunDetailDto> create(Ref ref) {
    final argument = this.argument as String;
    return runDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RunDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$runDetailHash() => r'6bf83514e1c5434abc45d763e3480b3cf26afa3a';

final class RunDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<RunDetailDto>, String> {
  RunDetailFamily._()
    : super(
        retry: null,
        name: r'runDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RunDetailProvider call(String runId) =>
      RunDetailProvider._(argument: runId, from: this);

  @override
  String toString() => r'runDetailProvider';
}
