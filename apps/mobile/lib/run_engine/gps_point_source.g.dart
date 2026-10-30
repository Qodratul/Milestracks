// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gps_point_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gpsPointSource)
final gpsPointSourceProvider = GpsPointSourceProvider._();

final class GpsPointSourceProvider
    extends $FunctionalProvider<GpsPointSource, GpsPointSource, GpsPointSource>
    with $Provider<GpsPointSource> {
  GpsPointSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gpsPointSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gpsPointSourceHash();

  @$internal
  @override
  $ProviderElement<GpsPointSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GpsPointSource create(Ref ref) {
    return gpsPointSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GpsPointSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GpsPointSource>(value),
    );
  }
}

String _$gpsPointSourceHash() => r'b6fdfa229ff34c8fc872be359eb728285aca1344';
