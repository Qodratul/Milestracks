import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_models.freezed.dart';
part 'api_models.g.dart';

@freezed
abstract class UserDto with _$UserDto {
  // ASSUMPTION UNCONFIRMED: detailed GET /me response fields are not specified.
  const factory UserDto({
    required String id,
    required String email,
    required String displayName,
    required int level,
    required int exp,
    required int coins,
    required int streakDays,
    required String mascotForm,
    required bool onboardingComplete,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}

@freezed
abstract class AuthTokensDto with _$AuthTokensDto {
  const factory AuthTokensDto({
    required String accessToken,
    required String refreshToken,
    required AuthUserDto user,
    String? accessTokenExpiresAt,
    bool? emailVerificationRequired,
  }) = _AuthTokensDto;

  factory AuthTokensDto.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensDtoFromJson(json);
}

@freezed
abstract class AuthUserDto with _$AuthUserDto {
  const factory AuthUserDto({
    required String id,
    required String email,
    required String displayName,
    required bool emailVerified,
    required String locale,
  }) = _AuthUserDto;

  factory AuthUserDto.fromJson(Map<String, dynamic> json) =>
      _$AuthUserDtoFromJson(json);
}

@freezed
abstract class RefreshedTokensDto with _$RefreshedTokensDto {
  const factory RefreshedTokensDto({
    required String accessToken,
    required String refreshToken,
  }) = _RefreshedTokensDto;

  factory RefreshedTokensDto.fromJson(Map<String, dynamic> json) =>
      _$RefreshedTokensDtoFromJson(json);
}

@freezed
abstract class CredentialsRequestDto with _$CredentialsRequestDto {
  // ASSUMPTION UNCONFIRMED: registration/login JSON body fields are not listed.
  const factory CredentialsRequestDto({
    required String email,
    required String password,
    @JsonKey(includeIfNull: false) String? displayName,
    @JsonKey(includeIfNull: false) String? locale,
    @JsonKey(includeIfNull: false) String? timezone,
  }) = _CredentialsRequestDto;

  factory CredentialsRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CredentialsRequestDtoFromJson(json);
}

@freezed
abstract class GoogleAuthRequestDto with _$GoogleAuthRequestDto {
  const factory GoogleAuthRequestDto({
    required String idToken,
    required String locale,
    required String timezone,
  }) = _GoogleAuthRequestDto;

  factory GoogleAuthRequestDto.fromJson(Map<String, dynamic> json) =>
      _$GoogleAuthRequestDtoFromJson(json);
}

@freezed
abstract class RefreshRequestDto with _$RefreshRequestDto {
  const factory RefreshRequestDto({required String refreshToken}) =
      _RefreshRequestDto;

  factory RefreshRequestDto.fromJson(Map<String, dynamic> json) =>
      _$RefreshRequestDtoFromJson(json);
}

@freezed
abstract class OnboardingRequestDto with _$OnboardingRequestDto {
  const factory OnboardingRequestDto({
    @JsonKey(includeIfNull: false) bool? healthDisclaimerAccepted,
    @JsonKey(includeIfNull: false) String? timezone,
    @JsonKey(includeIfNull: false) String? locale,
  }) = _OnboardingRequestDto;

  factory OnboardingRequestDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingRequestDtoFromJson(json);
}

@freezed
abstract class OnboardingResponseDto with _$OnboardingResponseDto {
  const factory OnboardingResponseDto({
    required bool onboardingComplete,
    required String locale,
    required String timezone,
  }) = _OnboardingResponseDto;

  factory OnboardingResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingResponseDtoFromJson(json);
}

@freezed
abstract class GeoPointDto with _$GeoPointDto {
  const factory GeoPointDto({
    required double latitude,
    required double longitude,
  }) = _GeoPointDto;

  factory GeoPointDto.fromJson(Map<String, dynamic> json) =>
      _$GeoPointDtoFromJson(json);
}

@freezed
abstract class TrackStartLocationDto with _$TrackStartLocationDto {
  const factory TrackStartLocationDto({
    @JsonKey(name: 'lat') required double latitude,
    @JsonKey(name: 'lng') required double longitude,
    @JsonKey(includeIfNull: false) double? accuracyMeters,
  }) = _TrackStartLocationDto;

  factory TrackStartLocationDto.fromJson(Map<String, dynamic> json) =>
      _$TrackStartLocationDtoFromJson(json);
}

enum TrackStatus {
  @JsonValue('generating')
  generating,
  @JsonValue('ready')
  ready,
  @JsonValue('failed')
  failed,
}

enum RevealMode {
  @JsonValue('full')
  full,
  @JsonValue('next_milestone')
  nextMilestone,
  @JsonValue('blind')
  blind,
}

@freezed
abstract class CreateTrackRequestDto with _$CreateTrackRequestDto {
  const factory CreateTrackRequestDto({
    required TrackStartLocationDto location,
  }) = _CreateTrackRequestDto;

  factory CreateTrackRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateTrackRequestDtoFromJson(json);
}

@freezed
abstract class TrackMilestoneDto with _$TrackMilestoneDto {
  const factory TrackMilestoneDto({
    required String id,
    required int order,
    GeoPointDto? position,
    required bool reached,
    required int expReward,
    double? distanceMeters,
    double? radiusMeters,
  }) = _TrackMilestoneDto;

  factory TrackMilestoneDto.fromJson(Map<String, dynamic> json) =>
      _$TrackMilestoneDtoFromJson(json);
}

@freezed
abstract class MilestoneDialogueDto with _$MilestoneDialogueDto {
  const factory MilestoneDialogueDto({
    required int milestoneOrder,
    required String cheerLine,
    required String continuePrompt,
    required String restPrompt,
  }) = _MilestoneDialogueDto;

  factory MilestoneDialogueDto.fromJson(Map<String, dynamic> json) =>
      _$MilestoneDialogueDtoFromJson(json);
}

@freezed
abstract class TrackNarrativeDto with _$TrackNarrativeDto {
  const factory TrackNarrativeDto({
    required String trackTitle,
    required String mysteryBrief,
    required String preRunTip,
    required List<MilestoneDialogueDto> milestoneDialogues,
  }) = _TrackNarrativeDto;

  factory TrackNarrativeDto.fromJson(Map<String, dynamic> json) =>
      _$TrackNarrativeDtoFromJson(json);
}

@freezed
abstract class TrackDto with _$TrackDto {
  // ASSUMPTION UNCONFIRMED: 11.3 does not publish the complete track schema.
  const factory TrackDto({
    required String id,
    required TrackStatus status,
    required RevealMode revealMode,
    required TrackNarrativeDto narrative,
    // ASSUMPTION UNCONFIRMED: PRD says polyline but does not specify JSON shape.
    required List<GeoPointDto> revealedPolyline,
    required List<TrackMilestoneDto> milestones,
    GeoPointDto? serverStartPosition,
    // ASSUMPTION UNCONFIRMED: these preview fields are present in the React
    // fixture but are not enumerated in PRD 11.3. Values remain server-owned.
    double? distanceMeters,
    int? estimatedDurationMinutes,
    int? estimatedCalories,
    int? safetyScore,
    int? safetyConfidence,
    int? distanceToStartMeters,
    String? routeNote,
    String? beforeStartTip,
    String? failureCode,
  }) = _TrackDto;

  factory TrackDto.fromJson(Map<String, dynamic> json) =>
      _$TrackDtoFromJson(json);
}

enum RunStatus {
  @JsonValue('active')
  running,
  @JsonValue('paused')
  paused,
  @JsonValue('completed')
  completed,
  @JsonValue('safe_stopped')
  safeStopped,
  @JsonValue('rejected')
  rejected,
  @JsonValue('failed')
  failed,
}

@freezed
abstract class StartRunRequestDto with _$StartRunRequestDto {
  const factory StartRunRequestDto({
    @JsonKey(name: 'routeId') required String trackId,
    String? activeItemId,
    String? boostItemCode,
    String? modifierItemCode,
    @Default('metric') String units,
    TrackStartLocationDto? startLocation,
    Map<String, dynamic>? clientCapabilities,
  }) = _StartRunRequestDto;

  factory StartRunRequestDto.fromJson(Map<String, dynamic> json) =>
      _$StartRunRequestDtoFromJson(json);
}

@freezed
abstract class RunDto with _$RunDto {
  const factory RunDto({
    required String id,
    required String trackId,
    String? trackTitle,
    required RunStatus status,
    required DateTime startedAt,
    DateTime? finishedAt,
    double? distanceMeters,
    int? durationSeconds,
    double? paceSecondsPerKm,
    int? netExp,
    int? coinsEarned,
    // ASSUMPTION UNCONFIRMED: the result breakdown fields are absent from
    // PRD 11.3; the server remains authoritative for these values.
    int? milestoneExp,
    double? expMultiplier,
    int? runPenaltyExp,
    int? roleLeaguePoints,
    int? estimatedCalories,
    int? streakDays,
    int? reachedMilestones,
    String? loadoutLabel,
    String? rejectionCode,
    String? claimId,
    @Default(false) bool claimed,
    @Default(<TrackMilestoneDto>[]) List<TrackMilestoneDto> milestones,
    RevealMode? revealMode,
    int? minimumDistanceMeters,
  }) = _RunDto;

  factory RunDto.fromJson(Map<String, dynamic> json) => _$RunDtoFromJson(json);
}

@freezed
abstract class RunPointDto with _$RunPointDto {
  // ASSUMPTION UNCONFIRMED: point field names and timestamp format are absent.
  const factory RunPointDto({
    required double latitude,
    required double longitude,
    required DateTime recordedAt,
    double? accuracyMeters,
    double? speedMetersPerSecond,
    @Default(false) bool mocked,
  }) = _RunPointDto;

  factory RunPointDto.fromJson(Map<String, dynamic> json) =>
      _$RunPointDtoFromJson(json);
}

@freezed
abstract class RunPointsRequestDto with _$RunPointsRequestDto {
  const factory RunPointsRequestDto({
    required List<RunPointDto> points,
    @Default(1) int firstSequence,
  }) = _RunPointsRequestDto;

  factory RunPointsRequestDto.fromJson(Map<String, dynamic> json) =>
      _$RunPointsRequestDtoFromJson(json);
}

@freezed
abstract class MilestoneCheckRequestDto with _$MilestoneCheckRequestDto {
  const factory MilestoneCheckRequestDto({
    required String milestoneId,
    required RunPointDto currentPoint,
    @Default(0) int lastSampleSequence,
  }) = _MilestoneCheckRequestDto;

  factory MilestoneCheckRequestDto.fromJson(Map<String, dynamic> json) =>
      _$MilestoneCheckRequestDtoFromJson(json);
}

@freezed
abstract class MilestoneCheckResponseDto with _$MilestoneCheckResponseDto {
  const factory MilestoneCheckResponseDto({
    required bool reached,
    int? expAwarded,
    String? safetyMessage,
    String? nextMilestoneId,
  }) = _MilestoneCheckResponseDto;

  factory MilestoneCheckResponseDto.fromJson(Map<String, dynamic> json) =>
      _$MilestoneCheckResponseDtoFromJson(json);
}

@freezed
abstract class FinishRunRequestDto with _$FinishRunRequestDto {
  const factory FinishRunRequestDto({
    @Default(<RunPointDto>[]) List<RunPointDto> remainingPoints,
    DateTime? endedAt,
    @Default(0) int lastSampleSequence,
    double? distanceMeters,
    int? durationSeconds,
  }) = _FinishRunRequestDto;

  factory FinishRunRequestDto.fromJson(Map<String, dynamic> json) =>
      _$FinishRunRequestDtoFromJson(json);
}

@freezed
abstract class SafeStopRequestDto with _$SafeStopRequestDto {
  const factory SafeStopRequestDto({
    String? reasonCode,
    @Default(0) int lastSampleSequence,
  }) = _SafeStopRequestDto;

  factory SafeStopRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SafeStopRequestDtoFromJson(json);
}

@freezed
abstract class ShopItemDto with _$ShopItemDto {
  // ASSUMPTION UNCONFIRMED: item DTO schema is not enumerated in 11.3.
  const factory ShopItemDto({
    required String id,
    required String name,
    required String description,
    required int priceCoins,
    required String effectCode,
    required bool available,
    // ASSUMPTION UNCONFIRMED: stock ceiling and risk badge are not specified
    // by PRD 11.3; these are server-owned shop configuration fields.
    @Default(0) int maxStock,
    @Default(false) bool risky,
  }) = _ShopItemDto;

  factory ShopItemDto.fromJson(Map<String, dynamic> json) =>
      _$ShopItemDtoFromJson(json);
}

@freezed
abstract class PurchaseRequestDto with _$PurchaseRequestDto {
  // ASSUMPTION UNCONFIRMED: purchase body is not enumerated in 11.3.
  const factory PurchaseRequestDto({required String itemId}) =
      _PurchaseRequestDto;

  factory PurchaseRequestDto.fromJson(Map<String, dynamic> json) =>
      _$PurchaseRequestDtoFromJson(json);
}

@freezed
abstract class PurchaseResultDto with _$PurchaseResultDto {
  const factory PurchaseResultDto({
    required String inventoryItemId,
    required String itemId,
    required int remainingCoins,
  }) = _PurchaseResultDto;

  factory PurchaseResultDto.fromJson(Map<String, dynamic> json) =>
      _$PurchaseResultDtoFromJson(json);
}

@freezed
abstract class InventoryItemDto with _$InventoryItemDto {
  // ASSUMPTION UNCONFIRMED: inventory response fields are not specified.
  const factory InventoryItemDto({
    required String id,
    required String itemId,
    required String name,
    required String description,
    required int quantity,
    required bool equipped,
  }) = _InventoryItemDto;

  factory InventoryItemDto.fromJson(Map<String, dynamic> json) =>
      _$InventoryItemDtoFromJson(json);
}

@freezed
abstract class LedgerEntryDto with _$LedgerEntryDto {
  // ASSUMPTION UNCONFIRMED: ledger response fields are not specified.
  const factory LedgerEntryDto({
    required String id,
    required String currency,
    required int amount,
    required String reason,
    String? refId,
    required DateTime createdAt,
  }) = _LedgerEntryDto;

  factory LedgerEntryDto.fromJson(Map<String, dynamic> json) =>
      _$LedgerEntryDtoFromJson(json);
}

@freezed
abstract class LedgerPageDto with _$LedgerPageDto {
  const factory LedgerPageDto({
    required List<LedgerEntryDto> entries,
    String? nextCursor,
  }) = _LedgerPageDto;

  factory LedgerPageDto.fromJson(Map<String, dynamic> json) =>
      _$LedgerPageDtoFromJson(json);
}

@freezed
abstract class StreakDto with _$StreakDto {
  // ASSUMPTION UNCONFIRMED: streak response fields are not specified.
  const factory StreakDto({
    required int currentDays,
    required int bestDays,
    required int freezesRemaining,
    required bool restShieldActive,
    DateTime? lastQualifiedAt,
  }) = _StreakDto;

  factory StreakDto.fromJson(Map<String, dynamic> json) =>
      _$StreakDtoFromJson(json);
}

@freezed
abstract class BadgeDto with _$BadgeDto {
  // ASSUMPTION UNCONFIRMED: badge response fields are not specified.
  const factory BadgeDto({
    required String id,
    required String name,
    required String description,
    required bool unlocked,
    double? progress,
    DateTime? unlockedAt,
  }) = _BadgeDto;

  factory BadgeDto.fromJson(Map<String, dynamic> json) =>
      _$BadgeDtoFromJson(json);
}

@freezed
abstract class StravaConnectRequestDto with _$StravaConnectRequestDto {
  const factory StravaConnectRequestDto({required String authorizationCode}) =
      _StravaConnectRequestDto;

  factory StravaConnectRequestDto.fromJson(Map<String, dynamic> json) =>
      _$StravaConnectRequestDtoFromJson(json);
}

@freezed
abstract class StravaConnectResponseDto with _$StravaConnectResponseDto {
  const factory StravaConnectResponseDto({
    required bool connected,
    String? athleteName,
  }) = _StravaConnectResponseDto;

  factory StravaConnectResponseDto.fromJson(Map<String, dynamic> json) =>
      _$StravaConnectResponseDtoFromJson(json);
}

// ASSUMPTION UNCONFIRMED: history endpoints and pagination are absent from PRD.
@freezed
abstract class RunHistoryPageDto with _$RunHistoryPageDto {
  const factory RunHistoryPageDto({
    required List<RunDto> runs,
    String? nextCursor,
  }) = _RunHistoryPageDto;

  factory RunHistoryPageDto.fromJson(Map<String, dynamic> json) =>
      _$RunHistoryPageDtoFromJson(json);
}

@freezed
abstract class RunDetailDto with _$RunDetailDto {
  const factory RunDetailDto({
    required RunDto run,
    required List<RunPointDto> trace,
  }) = _RunDetailDto;

  factory RunDetailDto.fromJson(Map<String, dynamic> json) =>
      _$RunDetailDtoFromJson(json);
}
