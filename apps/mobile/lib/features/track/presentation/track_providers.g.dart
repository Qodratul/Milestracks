// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(currentUser)
final currentUserProvider = CurrentUserProvider._();

final class CurrentUserProvider
    extends $FunctionalProvider<AsyncValue<UserDto>, UserDto, FutureOr<UserDto>>
    with $FutureModifier<UserDto>, $FutureProvider<UserDto> {
  CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $FutureProviderElement<UserDto> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UserDto> create(Ref ref) {
    return currentUser(ref);
  }
}

String _$currentUserHash() => r'1ce444766f10a0f65e1d769ef413005cb2727076';

@ProviderFor(currentStreak)
final currentStreakProvider = CurrentStreakProvider._();

final class CurrentStreakProvider
    extends
        $FunctionalProvider<
          AsyncValue<StreakDto>,
          StreakDto,
          FutureOr<StreakDto>
        >
    with $FutureModifier<StreakDto>, $FutureProvider<StreakDto> {
  CurrentStreakProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentStreakProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentStreakHash();

  @$internal
  @override
  $FutureProviderElement<StreakDto> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<StreakDto> create(Ref ref) {
    return currentStreak(ref);
  }
}

String _$currentStreakHash() => r'43c2d74d265b147a3815ba19eec0cd4de7cf9ea9';

@ProviderFor(activeRunRecovery)
final activeRunRecoveryProvider = ActiveRunRecoveryProvider._();

final class ActiveRunRecoveryProvider
    extends
        $FunctionalProvider<
          AsyncValue<ActiveRunRecovery?>,
          ActiveRunRecovery?,
          FutureOr<ActiveRunRecovery?>
        >
    with
        $FutureModifier<ActiveRunRecovery?>,
        $FutureProvider<ActiveRunRecovery?> {
  ActiveRunRecoveryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeRunRecoveryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeRunRecoveryHash();

  @$internal
  @override
  $FutureProviderElement<ActiveRunRecovery?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ActiveRunRecovery?> create(Ref ref) {
    return activeRunRecovery(ref);
  }
}

String _$activeRunRecoveryHash() => r'563d81312db9c0efe124f6eec9bf720edbd7a63b';

@ProviderFor(trackById)
final trackByIdProvider = TrackByIdFamily._();

final class TrackByIdProvider
    extends
        $FunctionalProvider<AsyncValue<TrackDto>, TrackDto, FutureOr<TrackDto>>
    with $FutureModifier<TrackDto>, $FutureProvider<TrackDto> {
  TrackByIdProvider._({
    required TrackByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'trackByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$trackByIdHash();

  @override
  String toString() {
    return r'trackByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<TrackDto> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<TrackDto> create(Ref ref) {
    final argument = this.argument as String;
    return trackById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TrackByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$trackByIdHash() => r'872af9f4e1fcc0440801d477b9f2df51d096387d';

final class TrackByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<TrackDto>, String> {
  TrackByIdFamily._()
    : super(
        retry: null,
        name: r'trackByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TrackByIdProvider call(String trackId) =>
      TrackByIdProvider._(argument: trackId, from: this);

  @override
  String toString() => r'trackByIdProvider';
}

@ProviderFor(todayMysteryTrack)
final todayMysteryTrackProvider = TodayMysteryTrackProvider._();

final class TodayMysteryTrackProvider
    extends
        $FunctionalProvider<AsyncValue<TrackDto>, TrackDto, FutureOr<TrackDto>>
    with $FutureModifier<TrackDto>, $FutureProvider<TrackDto> {
  TodayMysteryTrackProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayMysteryTrackProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayMysteryTrackHash();

  @$internal
  @override
  $FutureProviderElement<TrackDto> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<TrackDto> create(Ref ref) {
    return todayMysteryTrack(ref);
  }
}

String _$todayMysteryTrackHash() => r'f5fbfb02e49f9770ae7f52f1a962caf719cd1a06';

@ProviderFor(generateTrack)
final generateTrackProvider = GenerateTrackProvider._();

final class GenerateTrackProvider
    extends
        $FunctionalProvider<AsyncValue<TrackDto>, TrackDto, FutureOr<TrackDto>>
    with $FutureModifier<TrackDto>, $FutureProvider<TrackDto> {
  GenerateTrackProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'generateTrackProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$generateTrackHash();

  @$internal
  @override
  $FutureProviderElement<TrackDto> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<TrackDto> create(Ref ref) {
    return generateTrack(ref);
  }
}

String _$generateTrackHash() => r'a2838d9d572495add53b8185e3aa7bf1c358ca00';
