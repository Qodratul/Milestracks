// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PermissionController)
final permissionControllerProvider = PermissionControllerProvider._();

final class PermissionControllerProvider
    extends
        $AsyncNotifierProvider<
          PermissionController,
          OnboardingPermissionState
        > {
  PermissionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'permissionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$permissionControllerHash();

  @$internal
  @override
  PermissionController create() => PermissionController();
}

String _$permissionControllerHash() =>
    r'4306505bbd07a18c1879266d635785340bba173a';

abstract class _$PermissionController
    extends $AsyncNotifier<OnboardingPermissionState> {
  FutureOr<OnboardingPermissionState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<OnboardingPermissionState>,
              OnboardingPermissionState
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<OnboardingPermissionState>,
                OnboardingPermissionState
              >,
              AsyncValue<OnboardingPermissionState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
