import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:milestracks/core/config/app_config.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:milestracks/l10n/app_localizations.dart';
import 'package:milestracks/shared/models/api_models.dart';
import 'package:turf/turf.dart' as turf;

/// Single MapLibre boundary for route maps throughout the app.
class MilestracksMap extends StatefulWidget {
  const MilestracksMap({
    this.track,
    this.routePoints,
    this.currentPosition,
    this.routeProgressMeters,
    super.key,
    this.height,
    this.darkMode = false,
    this.showCurrentLocation = false,
    this.showSafePreview = true,
  }) : assert(track != null || routePoints != null);

  final TrackDto? track;
  final List<GeoPointDto>? routePoints;
  final GeoPointDto? currentPosition;
  final double? routeProgressMeters;
  final double? height;
  final bool darkMode;
  final bool showCurrentLocation;
  final bool showSafePreview;

  @override
  State<MilestracksMap> createState() => _MilestracksMapState();
}

class _MilestracksMapState extends State<MilestracksMap> {
  MapLibreMapController? _controller;
  bool _annotationsAdded = false;
  Line? _routeLine;
  double _furthestRouteProgressMeters = 0;
  String? _routeSourceKey;

  @override
  void didUpdateWidget(covariant MilestracksMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    final sourceKey = _currentRouteSourceKey;
    if (sourceKey != _routeSourceKey) {
      _routeSourceKey = sourceKey;
      _furthestRouteProgressMeters = 0;
    }
    if (oldWidget.currentPosition != widget.currentPosition ||
        oldWidget.routeProgressMeters != widget.routeProgressMeters ||
        oldWidget.track?.revealedPolyline != widget.track?.revealedPolyline) {
      _updateRouteLine();
    }
  }

  String get _currentRouteSourceKey {
    final points =
        widget.routePoints ??
        widget.track?.revealedPolyline ??
        const <GeoPointDto>[];
    if (points.isEmpty) return '${widget.track?.id ?? 'preview'}:empty';
    final first = points.first;
    final last = points.last;
    return '${widget.track?.id ?? 'preview'}:${points.length}:'
        '${first.latitude}:${first.longitude}:${last.latitude}:${last.longitude}';
  }

  String get _style {
    final configuredUrl = widget.darkMode
        ? AppConfig.mapDarkTileUrl
        : AppConfig.mapTileUrl;
    if (configuredUrl.isEmpty) {
      if (AppConfig.isDevelopmentDebug) {
        return widget.darkMode
            ? 'https://tiles.openfreemap.org/styles/dark'
            : 'https://tiles.openfreemap.org/styles/positron';
      }
      return widget.darkMode
          ? 'assets/map/run_mode_style.json'
          : AppConfig.useFakeApi
          ? 'assets/map/route_preview_style.json'
          : 'assets/map/route_preview_offline_style.json';
    }
    return configuredUrl.replaceAll('{key}', AppConfig.mapTileKey);
  }

  Future<void> _addRouteAnnotations() async {
    final controller = _controller;
    if (controller == null || _annotationsAdded) return;
    _annotationsAdded = true;
    final tokens = context.milestracksTokens;
    // Keep the start icon visible when a loop ends at the same coordinate as
    // its final milestone. The start receives a small visual offset below.
    await controller.setSymbolIconAllowOverlap(true);
    await controller.setSymbolIconIgnorePlacement(true);
    final points =
        (widget.routePoints ??
                widget.track?.revealedPolyline ??
                const <GeoPointDto>[])
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList(growable: false);
    final visibleRoutePoints = _visibleRouteCoordinates();
    if (visibleRoutePoints.length > 1) {
      _routeLine = await controller.addLine(
        _routeLineOptions(visibleRoutePoints),
      );
    }
    final start = widget.routePoints == null
        ? widget.track?.serverStartPosition
        : null;
    final milestones = widget.routePoints == null
        ? (widget.track?.milestones ?? const <TrackMilestoneDto>[]).where(
            (item) => item.position != null,
          )
        : const <TrackMilestoneDto>[];
    final lastMilestone = milestones.isEmpty ? null : milestones.last;
    final startAndFinishOverlap =
        start != null &&
        lastMilestone?.position != null &&
        _distanceMeters(start, lastMilestone!.position!) < 45;
    for (final milestone in milestones) {
      final position = milestone.position!;
      final imageName = 'milestracks-milestone-${milestone.order}';
      await controller.addImage(
        imageName,
        await _markerImage(
          '${milestone.order}',
          fill: milestone.reached ? tokens.accent : tokens.primary,
          foreground: milestone.reached ? tokens.primary : tokens.surface,
          outline: tokens.surface,
        ),
      );
      await controller.addSymbol(
        SymbolOptions(
          geometry: LatLng(position.latitude, position.longitude),
          iconImage: imageName,
          iconSize: 1.2,
          iconAnchor: 'center',
          iconOffset: Offset.zero,
          zIndex: 4,
        ),
      );
    }
    if (start != null) {
      const startLabel = 'S';
      const startImageName = 'milestracks-start';
      await controller.addImage(
        startImageName,
        await _markerImage(
          startLabel,
          fill: tokens.primary,
          foreground: tokens.surface,
          outline: tokens.surface,
        ),
      );
      await controller.addSymbol(
        SymbolOptions(
          geometry: LatLng(start.latitude, start.longitude),
          iconImage: startImageName,
          iconSize: 1.2,
          iconAnchor: 'center',
          iconOffset: startAndFinishOverlap
              ? const Offset(22, -18)
              : Offset.zero,
          zIndex: 5,
        ),
      );
    }
    final cameraPoints = <LatLng>[
      ...points,
      if (start case final position?)
        LatLng(position.latitude, position.longitude),
      ...milestones.map(
        (milestone) =>
            LatLng(milestone.position!.latitude, milestone.position!.longitude),
      ),
    ];
    if (cameraPoints.length > 1) {
      final latitudes = cameraPoints.map((point) => point.latitude);
      final longitudes = cameraPoints.map((point) => point.longitude);
      await controller.moveCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(
              latitudes.reduce((a, b) => math.min(a, b).toDouble()),
              longitudes.reduce((a, b) => math.min(a, b).toDouble()),
            ),
            northeast: LatLng(
              latitudes.reduce((a, b) => math.max(a, b).toDouble()),
              longitudes.reduce((a, b) => math.max(a, b).toDouble()),
            ),
          ),
          left: 28,
          top: 28,
          right: 28,
          bottom: 28,
        ),
      );
    }
  }

  void _updateRouteLine() {
    final controller = _controller;
    final line = _routeLine;
    if (controller == null || line == null) return;
    final points = _visibleRouteCoordinates();
    if (points.length < 2) return;
    unawaited(controller.updateLine(line, _routeLineOptions(points)));
  }

  LineOptions _routeLineOptions(List<LatLng> points) => LineOptions(
    geometry: points,
    lineColor: _hex(context.milestracksTokens.primary),
    lineWidth: 3,
    lineOpacity: 1,
    lineJoin: 'round',
  );

  List<LatLng> _visibleRouteCoordinates() {
    final route =
        widget.routePoints ??
        widget.track?.revealedPolyline ??
        const <GeoPointDto>[];
    final location = widget.currentPosition;
    if (route.length < 2 || location == null || widget.routePoints != null) {
      return route
          .map((item) => LatLng(item.latitude, item.longitude))
          .toList(growable: false);
    }
    final line = turf.LineString(
      coordinates: route
          .map((item) => turf.Position(item.longitude, item.latitude))
          .toList(growable: false),
    );
    final current = turf.Point(
      coordinates: turf.Position(location.longitude, location.latitude),
    );
    final projection = turf.nearestPointOnLine(line, current, turf.Unit.meters);
    final lateralDistance =
        (projection.properties?['dist'] as num?)?.toDouble() ?? double.infinity;
    final projectedProgress =
        (projection.properties?['location'] as num?)?.toDouble() ?? 0;
    // Do not cut the route when GPS is still away from it or has jumped to a
    // parallel street. Cap projection progress by the distance accepted by the
    // GPS filter so a single noisy fix cannot reveal a large part of the loop.
    if (lateralDistance > 60) {
      return route
          .map((item) => LatLng(item.latitude, item.longitude))
          .toList(growable: false);
    }
    final acceptedProgress = widget.routeProgressMeters;
    final cappedProgress = acceptedProgress == null
        ? projectedProgress
        : math.min(projectedProgress, acceptedProgress + 25);
    _furthestRouteProgressMeters = math.max(
      _furthestRouteProgressMeters,
      cappedProgress,
    );
    final totalLength = turf
        .length(turf.Feature<turf.LineString>(geometry: line), turf.Unit.meters)
        .toDouble();
    if (totalLength <= 2 || _furthestRouteProgressMeters >= totalLength - 2) {
      return route
          .map((item) => LatLng(item.latitude, item.longitude))
          .toList(growable: false);
    }
    final remaining = turf.lineSliceAlongRaw(
      line,
      _furthestRouteProgressMeters,
      totalLength,
      turf.Unit.meters,
    );
    return remaining.coordinates
        .map((point) => LatLng(point.lat.toDouble(), point.lng.toDouble()))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    final strings = AppLocalizations.of(context)!;
    final points =
        widget.routePoints ??
        widget.track?.revealedPolyline ??
        const <GeoPointDto>[];
    final center = widget.routePoints != null && points.isNotEmpty
        ? points.first
        : widget.track?.serverStartPosition ??
              (points.isNotEmpty
                  ? points.first
                  : const GeoPointDto(latitude: 0, longitude: 0));
    return SizedBox(
      height: widget.height ?? 248,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(tokens.radiusCard),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            MapLibreMap(
              styleString: _style,
              initialCameraPosition: CameraPosition(
                target: LatLng(center.latitude, center.longitude),
                zoom: 15,
              ),
              onMapCreated: (controller) => _controller = controller,
              onStyleLoadedCallback: () {
                _annotationsAdded = false;
                _routeLine = null;
                unawaited(_addRouteAnnotations());
              },
              compassEnabled: false,
              rotateGesturesEnabled: false,
              tiltGesturesEnabled: false,
              myLocationEnabled: widget.showCurrentLocation,
              myLocationTrackingMode: widget.showCurrentLocation
                  ? MyLocationTrackingMode.tracking
                  : MyLocationTrackingMode.none,
              scrollGesturesEnabled: !widget.showCurrentLocation,
              zoomGesturesEnabled: !widget.showCurrentLocation,
              attributionButtonPosition: AttributionButtonPosition.topLeft,
            ),
            if (widget.showSafePreview)
              Positioned(
                left: tokens.space10,
                top: tokens.space10,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: tokens.surface.withValues(alpha: .92),
                    borderRadius: BorderRadius.circular(tokens.radiusPill),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.shield_outlined,
                          size: 14,
                          color: tokens.primary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          strings.trackSafePreview,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Positioned(
              right: tokens.space6,
              bottom: tokens.space6,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: tokens.surface.withValues(alpha: .88),
                  borderRadius: BorderRadius.circular(tokens.radiusSmall),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  child: Text(
                    AppConfig.mapTileAttribution.isEmpty
                        ? strings.mapAttribution
                        : '${strings.mapAttribution} · ${AppConfig.mapTileAttribution}',
                    style: Theme.of(context).textTheme.labelSmall
                        ?.copyWith(fontSize: 9),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _hex(Color color) =>
    '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';

double _distanceMeters(GeoPointDto first, GeoPointDto second) {
  const earthRadius = 6371000.0;
  double radians(double value) => value * math.pi / 180;
  final latitudeDelta = radians(second.latitude - first.latitude);
  final longitudeDelta = radians(second.longitude - first.longitude);
  final a =
      math.sin(latitudeDelta / 2) * math.sin(latitudeDelta / 2) +
      math.cos(radians(first.latitude)) *
          math.cos(radians(second.latitude)) *
          math.sin(longitudeDelta / 2) *
          math.sin(longitudeDelta / 2);
  return earthRadius * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
}

Future<Uint8List> _markerImage(
  String label, {
  required Color fill,
  required Color foreground,
  required Color outline,
}) async {
  const logicalSize = 32.0;
  const pixelRatio = 2.0;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder)
    ..scale(pixelRatio)
    ..drawCircle(
      const Offset(logicalSize / 2, logicalSize / 2),
      14,
      Paint()..color = outline,
    )
    ..drawCircle(
      const Offset(logicalSize / 2, logicalSize / 2),
      11.5,
      Paint()..color = fill,
    );
  final textPainter = TextPainter(
    text: TextSpan(
      text: label,
      style: TextStyle(
        color: foreground,
        fontSize: label.length > 1 ? 11 : 13,
        fontWeight: FontWeight.w800,
        height: 1,
      ),
    ),
    textDirection: TextDirection.ltr,
    textAlign: TextAlign.center,
  )..layout(maxWidth: logicalSize);
  textPainter.paint(
    canvas,
    Offset(
      (logicalSize - textPainter.width) / 2,
      (logicalSize - textPainter.height) / 2,
    ),
  );
  final image = await recorder.endRecording().toImage(
    (logicalSize * pixelRatio).round(),
    (logicalSize * pixelRatio).round(),
  );
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  return data!.buffer.asUint8List();
}
