// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userBadges)
final userBadgesProvider = UserBadgesProvider._();

final class UserBadgesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BadgeDto>>,
          List<BadgeDto>,
          FutureOr<List<BadgeDto>>
        >
    with $FutureModifier<List<BadgeDto>>, $FutureProvider<List<BadgeDto>> {
  UserBadgesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userBadgesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userBadgesHash();

  @$internal
  @override
  $FutureProviderElement<List<BadgeDto>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BadgeDto>> create(Ref ref) {
    return userBadges(ref);
  }
}

String _$userBadgesHash() => r'cbe6ae9c59cc4baa40c9cddebda3a3e2d745a398';
