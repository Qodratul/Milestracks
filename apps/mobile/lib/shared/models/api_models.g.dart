// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserDto _$UserDtoFromJson(Map<String, dynamic> json) => _UserDto(
  id: json['id'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String,
  level: (json['level'] as num).toInt(),
  exp: (json['exp'] as num).toInt(),
  coins: (json['coins'] as num).toInt(),
  streakDays: (json['streakDays'] as num).toInt(),
  mascotForm: json['mascotForm'] as String,
  onboardingComplete: json['onboardingComplete'] as bool,
);

Map<String, dynamic> _$UserDtoToJson(_UserDto instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'displayName': instance.displayName,
  'level': instance.level,
  'exp': instance.exp,
  'coins': instance.coins,
  'streakDays': instance.streakDays,
  'mascotForm': instance.mascotForm,
  'onboardingComplete': instance.onboardingComplete,
};

_AuthTokensDto _$AuthTokensDtoFromJson(Map<String, dynamic> json) =>
    _AuthTokensDto(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: AuthUserDto.fromJson(json['user'] as Map<String, dynamic>),
      accessTokenExpiresAt: json['accessTokenExpiresAt'] as String?,
      emailVerificationRequired: json['emailVerificationRequired'] as bool?,
    );

Map<String, dynamic> _$AuthTokensDtoToJson(_AuthTokensDto instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'user': instance.user,
      'accessTokenExpiresAt': instance.accessTokenExpiresAt,
      'emailVerificationRequired': instance.emailVerificationRequired,
    };

_AuthUserDto _$AuthUserDtoFromJson(Map<String, dynamic> json) => _AuthUserDto(
  id: json['id'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String,
  emailVerified: json['emailVerified'] as bool,
  locale: json['locale'] as String,
);

Map<String, dynamic> _$AuthUserDtoToJson(_AuthUserDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
      'emailVerified': instance.emailVerified,
      'locale': instance.locale,
    };

_RefreshedTokensDto _$RefreshedTokensDtoFromJson(Map<String, dynamic> json) =>
    _RefreshedTokensDto(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$RefreshedTokensDtoToJson(_RefreshedTokensDto instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };

_CredentialsRequestDto _$CredentialsRequestDtoFromJson(
  Map<String, dynamic> json,
) => _CredentialsRequestDto(
  email: json['email'] as String,
  password: json['password'] as String,
  displayName: json['displayName'] as String?,
  locale: json['locale'] as String?,
  timezone: json['timezone'] as String?,
);

Map<String, dynamic> _$CredentialsRequestDtoToJson(
  _CredentialsRequestDto instance,
) => <String, dynamic>{
  'email': instance.email,
  'password': instance.password,
  'displayName': ?instance.displayName,
  'locale': ?instance.locale,
  'timezone': ?instance.timezone,
};

_GoogleAuthRequestDto _$GoogleAuthRequestDtoFromJson(
  Map<String, dynamic> json,
) => _GoogleAuthRequestDto(
  idToken: json['idToken'] as String,
  locale: json['locale'] as String,
  timezone: json['timezone'] as String,
);

Map<String, dynamic> _$GoogleAuthRequestDtoToJson(
  _GoogleAuthRequestDto instance,
) => <String, dynamic>{
  'idToken': instance.idToken,
  'locale': instance.locale,
  'timezone': instance.timezone,
};

_RefreshRequestDto _$RefreshRequestDtoFromJson(Map<String, dynamic> json) =>
    _RefreshRequestDto(refreshToken: json['refreshToken'] as String);

Map<String, dynamic> _$RefreshRequestDtoToJson(_RefreshRequestDto instance) =>
    <String, dynamic>{'refreshToken': instance.refreshToken};

_OnboardingRequestDto _$OnboardingRequestDtoFromJson(
  Map<String, dynamic> json,
) => _OnboardingRequestDto(
  healthDisclaimerAccepted: json['healthDisclaimerAccepted'] as bool?,
  timezone: json['timezone'] as String?,
  locale: json['locale'] as String?,
);

Map<String, dynamic> _$OnboardingRequestDtoToJson(
  _OnboardingRequestDto instance,
) => <String, dynamic>{
  'healthDisclaimerAccepted': ?instance.healthDisclaimerAccepted,
  'timezone': ?instance.timezone,
  'locale': ?instance.locale,
};

_OnboardingResponseDto _$OnboardingResponseDtoFromJson(
  Map<String, dynamic> json,
) => _OnboardingResponseDto(
  onboardingComplete: json['onboardingComplete'] as bool,
  locale: json['locale'] as String,
  timezone: json['timezone'] as String,
);

Map<String, dynamic> _$OnboardingResponseDtoToJson(
  _OnboardingResponseDto instance,
) => <String, dynamic>{
  'onboardingComplete': instance.onboardingComplete,
  'locale': instance.locale,
  'timezone': instance.timezone,
};

_GeoPointDto _$GeoPointDtoFromJson(Map<String, dynamic> json) => _GeoPointDto(
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
);

Map<String, dynamic> _$GeoPointDtoToJson(_GeoPointDto instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

_TrackStartLocationDto _$TrackStartLocationDtoFromJson(
  Map<String, dynamic> json,
) => _TrackStartLocationDto(
  latitude: (json['lat'] as num).toDouble(),
  longitude: (json['lng'] as num).toDouble(),
  accuracyMeters: (json['accuracyMeters'] as num?)?.toDouble(),
);

Map<String, dynamic> _$TrackStartLocationDtoToJson(
  _TrackStartLocationDto instance,
) => <String, dynamic>{
  'lat': instance.latitude,
  'lng': instance.longitude,
  'accuracyMeters': ?instance.accuracyMeters,
};

_CreateTrackRequestDto _$CreateTrackRequestDtoFromJson(
  Map<String, dynamic> json,
) => _CreateTrackRequestDto(
  location: TrackStartLocationDto.fromJson(
    json['location'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$CreateTrackRequestDtoToJson(
  _CreateTrackRequestDto instance,
) => <String, dynamic>{'location': instance.location};

_TrackMilestoneDto _$TrackMilestoneDtoFromJson(Map<String, dynamic> json) =>
    _TrackMilestoneDto(
      id: json['id'] as String,
      order: (json['order'] as num).toInt(),
      position: json['position'] == null
          ? null
          : GeoPointDto.fromJson(json['position'] as Map<String, dynamic>),
      reached: json['reached'] as bool,
      expReward: (json['expReward'] as num).toInt(),
      distanceMeters: (json['distanceMeters'] as num?)?.toDouble(),
      radiusMeters: (json['radiusMeters'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$TrackMilestoneDtoToJson(_TrackMilestoneDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order': instance.order,
      'position': instance.position,
      'reached': instance.reached,
      'expReward': instance.expReward,
      'distanceMeters': instance.distanceMeters,
      'radiusMeters': instance.radiusMeters,
    };

_MilestoneDialogueDto _$MilestoneDialogueDtoFromJson(
  Map<String, dynamic> json,
) => _MilestoneDialogueDto(
  milestoneOrder: (json['milestoneOrder'] as num).toInt(),
  cheerLine: json['cheerLine'] as String,
  continuePrompt: json['continuePrompt'] as String,
  restPrompt: json['restPrompt'] as String,
);

Map<String, dynamic> _$MilestoneDialogueDtoToJson(
  _MilestoneDialogueDto instance,
) => <String, dynamic>{
  'milestoneOrder': instance.milestoneOrder,
  'cheerLine': instance.cheerLine,
  'continuePrompt': instance.continuePrompt,
  'restPrompt': instance.restPrompt,
};

_TrackNarrativeDto _$TrackNarrativeDtoFromJson(Map<String, dynamic> json) =>
    _TrackNarrativeDto(
      trackTitle: json['trackTitle'] as String,
      mysteryBrief: json['mysteryBrief'] as String,
      preRunTip: json['preRunTip'] as String,
      milestoneDialogues: (json['milestoneDialogues'] as List<dynamic>)
          .map((e) => MilestoneDialogueDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TrackNarrativeDtoToJson(_TrackNarrativeDto instance) =>
    <String, dynamic>{
      'trackTitle': instance.trackTitle,
      'mysteryBrief': instance.mysteryBrief,
      'preRunTip': instance.preRunTip,
      'milestoneDialogues': instance.milestoneDialogues,
    };

_TrackDto _$TrackDtoFromJson(Map<String, dynamic> json) => _TrackDto(
  id: json['id'] as String,
  status: $enumDecode(_$TrackStatusEnumMap, json['status']),
  revealMode: $enumDecode(_$RevealModeEnumMap, json['revealMode']),
  narrative: TrackNarrativeDto.fromJson(
    json['narrative'] as Map<String, dynamic>,
  ),
  revealedPolyline: (json['revealedPolyline'] as List<dynamic>)
      .map((e) => GeoPointDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  milestones: (json['milestones'] as List<dynamic>)
      .map((e) => TrackMilestoneDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  serverStartPosition: json['serverStartPosition'] == null
      ? null
      : GeoPointDto.fromJson(
          json['serverStartPosition'] as Map<String, dynamic>,
        ),
  distanceMeters: (json['distanceMeters'] as num?)?.toDouble(),
  estimatedDurationMinutes: (json['estimatedDurationMinutes'] as num?)?.toInt(),
  estimatedCalories: (json['estimatedCalories'] as num?)?.toInt(),
  safetyScore: (json['safetyScore'] as num?)?.toInt(),
  safetyConfidence: (json['safetyConfidence'] as num?)?.toInt(),
  distanceToStartMeters: (json['distanceToStartMeters'] as num?)?.toInt(),
  routeNote: json['routeNote'] as String?,
  beforeStartTip: json['beforeStartTip'] as String?,
  failureCode: json['failureCode'] as String?,
);

Map<String, dynamic> _$TrackDtoToJson(_TrackDto instance) => <String, dynamic>{
  'id': instance.id,
  'status': _$TrackStatusEnumMap[instance.status]!,
  'revealMode': _$RevealModeEnumMap[instance.revealMode]!,
  'narrative': instance.narrative,
  'revealedPolyline': instance.revealedPolyline,
  'milestones': instance.milestones,
  'serverStartPosition': instance.serverStartPosition,
  'distanceMeters': instance.distanceMeters,
  'estimatedDurationMinutes': instance.estimatedDurationMinutes,
  'estimatedCalories': instance.estimatedCalories,
  'safetyScore': instance.safetyScore,
  'safetyConfidence': instance.safetyConfidence,
  'distanceToStartMeters': instance.distanceToStartMeters,
  'routeNote': instance.routeNote,
  'beforeStartTip': instance.beforeStartTip,
  'failureCode': instance.failureCode,
};

const _$TrackStatusEnumMap = {
  TrackStatus.generating: 'generating',
  TrackStatus.ready: 'ready',
  TrackStatus.failed: 'failed',
};

const _$RevealModeEnumMap = {
  RevealMode.full: 'full',
  RevealMode.nextMilestone: 'next_milestone',
  RevealMode.blind: 'blind',
};

_StartRunRequestDto _$StartRunRequestDtoFromJson(Map<String, dynamic> json) =>
    _StartRunRequestDto(
      trackId: json['routeId'] as String,
      activeItemId: json['activeItemId'] as String?,
      boostItemCode: json['boostItemCode'] as String?,
      modifierItemCode: json['modifierItemCode'] as String?,
      units: json['units'] as String? ?? 'metric',
      startLocation: json['startLocation'] == null
          ? null
          : TrackStartLocationDto.fromJson(
              json['startLocation'] as Map<String, dynamic>,
            ),
      clientCapabilities: json['clientCapabilities'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$StartRunRequestDtoToJson(_StartRunRequestDto instance) =>
    <String, dynamic>{
      'routeId': instance.trackId,
      'activeItemId': instance.activeItemId,
      'boostItemCode': instance.boostItemCode,
      'modifierItemCode': instance.modifierItemCode,
      'units': instance.units,
      'startLocation': instance.startLocation,
      'clientCapabilities': instance.clientCapabilities,
    };

_RunDto _$RunDtoFromJson(Map<String, dynamic> json) => _RunDto(
  id: json['id'] as String,
  trackId: json['trackId'] as String,
  trackTitle: json['trackTitle'] as String?,
  status: $enumDecode(_$RunStatusEnumMap, json['status']),
  startedAt: DateTime.parse(json['startedAt'] as String),
  finishedAt: json['finishedAt'] == null
      ? null
      : DateTime.parse(json['finishedAt'] as String),
  distanceMeters: (json['distanceMeters'] as num?)?.toDouble(),
  durationSeconds: (json['durationSeconds'] as num?)?.toInt(),
  paceSecondsPerKm: (json['paceSecondsPerKm'] as num?)?.toDouble(),
  netExp: (json['netExp'] as num?)?.toInt(),
  coinsEarned: (json['coinsEarned'] as num?)?.toInt(),
  milestoneExp: (json['milestoneExp'] as num?)?.toInt(),
  expMultiplier: (json['expMultiplier'] as num?)?.toDouble(),
  runPenaltyExp: (json['runPenaltyExp'] as num?)?.toInt(),
  roleLeaguePoints: (json['roleLeaguePoints'] as num?)?.toInt(),
  estimatedCalories: (json['estimatedCalories'] as num?)?.toInt(),
  streakDays: (json['streakDays'] as num?)?.toInt(),
  reachedMilestones: (json['reachedMilestones'] as num?)?.toInt(),
  loadoutLabel: json['loadoutLabel'] as String?,
  rejectionCode: json['rejectionCode'] as String?,
  claimId: json['claimId'] as String?,
  claimed: json['claimed'] as bool? ?? false,
  milestones:
      (json['milestones'] as List<dynamic>?)
          ?.map((e) => TrackMilestoneDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <TrackMilestoneDto>[],
  revealMode: $enumDecodeNullable(_$RevealModeEnumMap, json['revealMode']),
  minimumDistanceMeters: (json['minimumDistanceMeters'] as num?)?.toInt(),
);

Map<String, dynamic> _$RunDtoToJson(_RunDto instance) => <String, dynamic>{
  'id': instance.id,
  'trackId': instance.trackId,
  'trackTitle': instance.trackTitle,
  'status': _$RunStatusEnumMap[instance.status]!,
  'startedAt': instance.startedAt.toIso8601String(),
  'finishedAt': instance.finishedAt?.toIso8601String(),
  'distanceMeters': instance.distanceMeters,
  'durationSeconds': instance.durationSeconds,
  'paceSecondsPerKm': instance.paceSecondsPerKm,
  'netExp': instance.netExp,
  'coinsEarned': instance.coinsEarned,
  'milestoneExp': instance.milestoneExp,
  'expMultiplier': instance.expMultiplier,
  'runPenaltyExp': instance.runPenaltyExp,
  'roleLeaguePoints': instance.roleLeaguePoints,
  'estimatedCalories': instance.estimatedCalories,
  'streakDays': instance.streakDays,
  'reachedMilestones': instance.reachedMilestones,
  'loadoutLabel': instance.loadoutLabel,
  'rejectionCode': instance.rejectionCode,
  'claimId': instance.claimId,
  'claimed': instance.claimed,
  'milestones': instance.milestones,
  'revealMode': _$RevealModeEnumMap[instance.revealMode],
  'minimumDistanceMeters': instance.minimumDistanceMeters,
};

const _$RunStatusEnumMap = {
  RunStatus.running: 'active',
  RunStatus.paused: 'paused',
  RunStatus.completed: 'completed',
  RunStatus.safeStopped: 'safe_stopped',
  RunStatus.rejected: 'rejected',
  RunStatus.failed: 'failed',
};

_RunPointDto _$RunPointDtoFromJson(Map<String, dynamic> json) => _RunPointDto(
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  recordedAt: DateTime.parse(json['recordedAt'] as String),
  accuracyMeters: (json['accuracyMeters'] as num?)?.toDouble(),
  speedMetersPerSecond: (json['speedMetersPerSecond'] as num?)?.toDouble(),
  mocked: json['mocked'] as bool? ?? false,
);

Map<String, dynamic> _$RunPointDtoToJson(_RunPointDto instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'recordedAt': instance.recordedAt.toIso8601String(),
      'accuracyMeters': instance.accuracyMeters,
      'speedMetersPerSecond': instance.speedMetersPerSecond,
      'mocked': instance.mocked,
    };

_RunPointsRequestDto _$RunPointsRequestDtoFromJson(Map<String, dynamic> json) =>
    _RunPointsRequestDto(
      points: (json['points'] as List<dynamic>)
          .map((e) => RunPointDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      firstSequence: (json['firstSequence'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$RunPointsRequestDtoToJson(
  _RunPointsRequestDto instance,
) => <String, dynamic>{
  'points': instance.points,
  'firstSequence': instance.firstSequence,
};

_MilestoneCheckRequestDto _$MilestoneCheckRequestDtoFromJson(
  Map<String, dynamic> json,
) => _MilestoneCheckRequestDto(
  milestoneId: json['milestoneId'] as String,
  currentPoint: RunPointDto.fromJson(
    json['currentPoint'] as Map<String, dynamic>,
  ),
  lastSampleSequence: (json['lastSampleSequence'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$MilestoneCheckRequestDtoToJson(
  _MilestoneCheckRequestDto instance,
) => <String, dynamic>{
  'milestoneId': instance.milestoneId,
  'currentPoint': instance.currentPoint,
  'lastSampleSequence': instance.lastSampleSequence,
};

_MilestoneCheckResponseDto _$MilestoneCheckResponseDtoFromJson(
  Map<String, dynamic> json,
) => _MilestoneCheckResponseDto(
  reached: json['reached'] as bool,
  expAwarded: (json['expAwarded'] as num?)?.toInt(),
  safetyMessage: json['safetyMessage'] as String?,
  nextMilestoneId: json['nextMilestoneId'] as String?,
);

Map<String, dynamic> _$MilestoneCheckResponseDtoToJson(
  _MilestoneCheckResponseDto instance,
) => <String, dynamic>{
  'reached': instance.reached,
  'expAwarded': instance.expAwarded,
  'safetyMessage': instance.safetyMessage,
  'nextMilestoneId': instance.nextMilestoneId,
};

_FinishRunRequestDto _$FinishRunRequestDtoFromJson(Map<String, dynamic> json) =>
    _FinishRunRequestDto(
      remainingPoints:
          (json['remainingPoints'] as List<dynamic>?)
              ?.map((e) => RunPointDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <RunPointDto>[],
      endedAt: json['endedAt'] == null
          ? null
          : DateTime.parse(json['endedAt'] as String),
      lastSampleSequence: (json['lastSampleSequence'] as num?)?.toInt() ?? 0,
      distanceMeters: (json['distanceMeters'] as num?)?.toDouble(),
      durationSeconds: (json['durationSeconds'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FinishRunRequestDtoToJson(
  _FinishRunRequestDto instance,
) => <String, dynamic>{
  'remainingPoints': instance.remainingPoints,
  'endedAt': instance.endedAt?.toIso8601String(),
  'lastSampleSequence': instance.lastSampleSequence,
  'distanceMeters': instance.distanceMeters,
  'durationSeconds': instance.durationSeconds,
};

_SafeStopRequestDto _$SafeStopRequestDtoFromJson(Map<String, dynamic> json) =>
    _SafeStopRequestDto(
      reasonCode: json['reasonCode'] as String?,
      lastSampleSequence: (json['lastSampleSequence'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$SafeStopRequestDtoToJson(_SafeStopRequestDto instance) =>
    <String, dynamic>{
      'reasonCode': instance.reasonCode,
      'lastSampleSequence': instance.lastSampleSequence,
    };

_ShopItemDto _$ShopItemDtoFromJson(Map<String, dynamic> json) => _ShopItemDto(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  priceCoins: (json['priceCoins'] as num).toInt(),
  effectCode: json['effectCode'] as String,
  available: json['available'] as bool,
  maxStock: (json['maxStock'] as num?)?.toInt() ?? 0,
  risky: json['risky'] as bool? ?? false,
);

Map<String, dynamic> _$ShopItemDtoToJson(_ShopItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'priceCoins': instance.priceCoins,
      'effectCode': instance.effectCode,
      'available': instance.available,
      'maxStock': instance.maxStock,
      'risky': instance.risky,
    };

_PurchaseRequestDto _$PurchaseRequestDtoFromJson(Map<String, dynamic> json) =>
    _PurchaseRequestDto(itemId: json['itemId'] as String);

Map<String, dynamic> _$PurchaseRequestDtoToJson(_PurchaseRequestDto instance) =>
    <String, dynamic>{'itemId': instance.itemId};

_PurchaseResultDto _$PurchaseResultDtoFromJson(Map<String, dynamic> json) =>
    _PurchaseResultDto(
      inventoryItemId: json['inventoryItemId'] as String,
      itemId: json['itemId'] as String,
      remainingCoins: (json['remainingCoins'] as num).toInt(),
    );

Map<String, dynamic> _$PurchaseResultDtoToJson(_PurchaseResultDto instance) =>
    <String, dynamic>{
      'inventoryItemId': instance.inventoryItemId,
      'itemId': instance.itemId,
      'remainingCoins': instance.remainingCoins,
    };

_InventoryItemDto _$InventoryItemDtoFromJson(Map<String, dynamic> json) =>
    _InventoryItemDto(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      quantity: (json['quantity'] as num).toInt(),
      equipped: json['equipped'] as bool,
    );

Map<String, dynamic> _$InventoryItemDtoToJson(_InventoryItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemId': instance.itemId,
      'name': instance.name,
      'description': instance.description,
      'quantity': instance.quantity,
      'equipped': instance.equipped,
    };

_LedgerEntryDto _$LedgerEntryDtoFromJson(Map<String, dynamic> json) =>
    _LedgerEntryDto(
      id: json['id'] as String,
      currency: json['currency'] as String,
      amount: (json['amount'] as num).toInt(),
      reason: json['reason'] as String,
      refId: json['refId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$LedgerEntryDtoToJson(_LedgerEntryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'currency': instance.currency,
      'amount': instance.amount,
      'reason': instance.reason,
      'refId': instance.refId,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_LedgerPageDto _$LedgerPageDtoFromJson(Map<String, dynamic> json) =>
    _LedgerPageDto(
      entries: (json['entries'] as List<dynamic>)
          .map((e) => LedgerEntryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['nextCursor'] as String?,
    );

Map<String, dynamic> _$LedgerPageDtoToJson(_LedgerPageDto instance) =>
    <String, dynamic>{
      'entries': instance.entries,
      'nextCursor': instance.nextCursor,
    };

_StreakDto _$StreakDtoFromJson(Map<String, dynamic> json) => _StreakDto(
  currentDays: (json['currentDays'] as num).toInt(),
  bestDays: (json['bestDays'] as num).toInt(),
  freezesRemaining: (json['freezesRemaining'] as num).toInt(),
  restShieldActive: json['restShieldActive'] as bool,
  lastQualifiedAt: json['lastQualifiedAt'] == null
      ? null
      : DateTime.parse(json['lastQualifiedAt'] as String),
);

Map<String, dynamic> _$StreakDtoToJson(_StreakDto instance) =>
    <String, dynamic>{
      'currentDays': instance.currentDays,
      'bestDays': instance.bestDays,
      'freezesRemaining': instance.freezesRemaining,
      'restShieldActive': instance.restShieldActive,
      'lastQualifiedAt': instance.lastQualifiedAt?.toIso8601String(),
    };

_BadgeDto _$BadgeDtoFromJson(Map<String, dynamic> json) => _BadgeDto(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  unlocked: json['unlocked'] as bool,
  progress: (json['progress'] as num?)?.toDouble(),
  unlockedAt: json['unlockedAt'] == null
      ? null
      : DateTime.parse(json['unlockedAt'] as String),
);

Map<String, dynamic> _$BadgeDtoToJson(_BadgeDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'unlocked': instance.unlocked,
  'progress': instance.progress,
  'unlockedAt': instance.unlockedAt?.toIso8601String(),
};

_StravaConnectRequestDto _$StravaConnectRequestDtoFromJson(
  Map<String, dynamic> json,
) => _StravaConnectRequestDto(
  authorizationCode: json['authorizationCode'] as String,
);

Map<String, dynamic> _$StravaConnectRequestDtoToJson(
  _StravaConnectRequestDto instance,
) => <String, dynamic>{'authorizationCode': instance.authorizationCode};

_StravaConnectResponseDto _$StravaConnectResponseDtoFromJson(
  Map<String, dynamic> json,
) => _StravaConnectResponseDto(
  connected: json['connected'] as bool,
  athleteName: json['athleteName'] as String?,
);

Map<String, dynamic> _$StravaConnectResponseDtoToJson(
  _StravaConnectResponseDto instance,
) => <String, dynamic>{
  'connected': instance.connected,
  'athleteName': instance.athleteName,
};

_RunHistoryPageDto _$RunHistoryPageDtoFromJson(Map<String, dynamic> json) =>
    _RunHistoryPageDto(
      runs: (json['runs'] as List<dynamic>)
          .map((e) => RunDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['nextCursor'] as String?,
    );

Map<String, dynamic> _$RunHistoryPageDtoToJson(_RunHistoryPageDto instance) =>
    <String, dynamic>{'runs': instance.runs, 'nextCursor': instance.nextCursor};

_RunDetailDto _$RunDetailDtoFromJson(Map<String, dynamic> json) =>
    _RunDetailDto(
      run: RunDto.fromJson(json['run'] as Map<String, dynamic>),
      trace: (json['trace'] as List<dynamic>)
          .map((e) => RunPointDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RunDetailDtoToJson(_RunDetailDto instance) =>
    <String, dynamic>{'run': instance.run, 'trace': instance.trace};
