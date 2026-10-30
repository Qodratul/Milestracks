// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fake_repository_behavior.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fakeRepositoryBehavior)
final fakeRepositoryBehaviorProvider = FakeRepositoryBehaviorProvider._();

final class FakeRepositoryBehaviorProvider
    extends
        $FunctionalProvider<
          FakeRepositoryBehavior,
          FakeRepositoryBehavior,
          FakeRepositoryBehavior
        >
    with $Provider<FakeRepositoryBehavior> {
  FakeRepositoryBehaviorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fakeRepositoryBehaviorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fakeRepositoryBehaviorHash();

  @$internal
  @override
  $ProviderElement<FakeRepositoryBehavior> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FakeRepositoryBehavior create(Ref ref) {
    return fakeRepositoryBehavior(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FakeRepositoryBehavior value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FakeRepositoryBehavior>(value),
    );
  }
}

String _$fakeRepositoryBehaviorHash() =>
    r'a7863fcd9c79314a86fa31e6ffa8608007eb40b4';
