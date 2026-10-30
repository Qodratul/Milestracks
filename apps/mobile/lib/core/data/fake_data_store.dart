import 'package:milestracks/shared/models/api_models.dart';

class FakeDataStore {
  FakeDataStore({required this.languageCode});

  final String Function() languageCode;

  UserDto user = const UserDto(
    id: 'fake-user-001',
    email: 'rani@example.com',
    displayName: 'Rani',
    level: 1,
    exp: 4200,
    coins: 4,
    streakDays: 5,
    mascotForm: 'scout',
    onboardingComplete: false,
  );

  int coins = 4;
  final List<InventoryItemDto> inventory = <InventoryItemDto>[
    const InventoryItemDto(
      id: 'inventory-exp-boost-001',
      itemId: 'exp_boost',
      name: 'EXP Boost 1.5x',
      description:
          '1.5x EXP for milestones reached in the first 24 active minutes',
      quantity: 1,
      equipped: true,
    ),
  ];
  final List<LedgerEntryDto> ledger = <LedgerEntryDto>[
    LedgerEntryDto(
      id: 'ledger-run-001',
      currency: 'coin',
      amount: 1,
      reason: 'run_completed',
      refId: 'run-completed-001',
      createdAt: DateTime.utc(2026, 10, 22, 7, 35),
    ),
  ];

  final Map<String, RunDto> runs = <String, RunDto>{
    'history-001': RunDto(
      id: 'history-001',
      trackId: 'track-old-trees',
      status: RunStatus.completed,
      startedAt: DateTime.utc(2026, 10, 25, 6, 7),
      finishedAt: DateTime.utc(2026, 10, 25, 6, 16, 30),
      distanceMeters: 1150,
      durationSeconds: 570,
      paceSecondsPerKm: 495.7,
      netExp: 675,
      coinsEarned: 1,
    ),
    'history-002': RunDto(
      id: 'history-002',
      trackId: 'track-senayan',
      status: RunStatus.safeStopped,
      startedAt: DateTime.utc(2026, 10, 23, 6, 7),
      finishedAt: DateTime.utc(2026, 10, 23, 6, 12, 30),
      distanceMeters: 640,
      durationSeconds: 330,
      paceSecondsPerKm: 515.6,
      netExp: 500,
      coinsEarned: 0,
    ),
    'history-003': RunDto(
      id: 'history-003',
      trackId: 'track-old-trees',
      status: RunStatus.completed,
      startedAt: DateTime.utc(2026, 10, 21, 6, 7),
      finishedAt: DateTime.utc(2026, 10, 21, 6, 24, 30),
      distanceMeters: 2110,
      durationSeconds: 1050,
      paceSecondsPerKm: 497.6,
      netExp: 625,
      coinsEarned: 1,
    ),
    'history-004': RunDto(
      id: 'history-004',
      trackId: 'track-city-park',
      status: RunStatus.completed,
      startedAt: DateTime.utc(2026, 10, 19, 6, 7),
      finishedAt: DateTime.utc(2026, 10, 19, 6, 26, 30),
      distanceMeters: 2200,
      durationSeconds: 1180,
      paceSecondsPerKm: 536.4,
      netExp: 1200,
      coinsEarned: 1,
    ),
    'history-005': RunDto(
      id: 'history-005',
      trackId: 'track-canal-side',
      status: RunStatus.rejected,
      startedAt: DateTime.utc(2026, 10, 13, 6, 7),
      finishedAt: DateTime.utc(2026, 10, 13, 6, 9, 12),
      distanceMeters: 310,
      durationSeconds: 132,
      paceSecondsPerKm: 425.8,
      netExp: 0,
      coinsEarned: 0,
      rejectionCode: 'route_validation_failed',
    ),
    'history-006': RunDto(
      id: 'history-006',
      trackId: 'track-senayan',
      status: RunStatus.completed,
      startedAt: DateTime.utc(2026, 10, 11, 6, 7),
      finishedAt: DateTime.utc(2026, 10, 11, 6, 16, 7),
      distanceMeters: 720,
      durationSeconds: 540,
      paceSecondsPerKm: 750,
      netExp: 280,
      coinsEarned: 0,
    ),
    'history-007': RunDto(
      id: 'history-007',
      trackId: 'track-city-park',
      status: RunStatus.completed,
      startedAt: DateTime.utc(2026, 10, 9, 6, 7),
      finishedAt: DateTime.utc(2026, 10, 9, 6, 17),
      distanceMeters: 600,
      durationSeconds: 600,
      paceSecondsPerKm: 1000,
      netExp: 300,
      coinsEarned: 0,
    ),
    'history-008': RunDto(
      id: 'history-008',
      trackId: 'track-old-trees',
      status: RunStatus.safeStopped,
      startedAt: DateTime.utc(2026, 10, 7, 6, 7),
      finishedAt: DateTime.utc(2026, 10, 7, 6, 17),
      distanceMeters: 800,
      durationSeconds: 600,
      paceSecondsPerKm: 750,
      netExp: 300,
      coinsEarned: 0,
    ),
    'history-009': RunDto(
      id: 'history-009',
      trackId: 'track-canal-side',
      status: RunStatus.completed,
      startedAt: DateTime.utc(2026, 10, 5, 6, 7),
      finishedAt: DateTime.utc(2026, 10, 5, 6, 17),
      distanceMeters: 770,
      durationSeconds: 600,
      paceSecondsPerKm: 779.2,
      netExp: 320,
      coinsEarned: 0,
    ),
  };

  static const _narratives = <String, Map<String, String>>{
    'en': <String, String>{
      'title': 'Morning Trail Beyond the Old Trees',
      'brief': 'Kila follows the scent of rain-soaked earth toward a quiet garden trail.',
      'tip': 'There is one road crossing. Follow signs and watch traffic.',
      'warmup': 'Warm up for 3 minutes, then start with a brisk walk.',
      'cheer': 'A smooth warm-up. Your first milestone is behind you!',
      'continue': 'Feeling steady? Head toward the next point.',
      'rest': 'Take a short pause if your legs need it.',
    },
    'id': <String, String>{
      'title': 'Jalur Pagi di Balik Pepohonan Tua',
      'brief': 'Kila mengikuti aroma tanah sehabis hujan menuju jalur taman yang tenang.',
      'tip':
          'Ada satu persimpangan jalan. Ikuti rambu dan waspadai lalu lintas.',
      'warmup': 'Lakukan pemanasan 3 menit, lalu mulai dengan jalan cepat.',
      'cheer': 'Pemanasan yang mulus. Milestone pertamamu sudah terlewati!',
      'continue': 'Masih nyaman? Lanjutkan menuju titik berikutnya.',
      'rest': 'Beristirahat sejenak jika kakimu mulai terasa lelah.',
    },
  };

  TrackDto track({required bool failed, String id = 'track-fog-001'}) {
    final strings = _narratives[languageCode()] ?? _narratives['en']!;
    return TrackDto(
      id: id,
      status: failed ? TrackStatus.failed : TrackStatus.ready,
      revealMode: RevealMode.nextMilestone,
      narrative: TrackNarrativeDto(
        trackTitle: _trackTitles[languageCode()]?[id] ?? strings['title']!,
        mysteryBrief: strings['brief']!,
        preRunTip: strings['tip']!,
        milestoneDialogues: <MilestoneDialogueDto>[
          MilestoneDialogueDto(
            milestoneOrder: 1,
            cheerLine: strings['cheer']!,
            continuePrompt: strings['continue']!,
            restPrompt: strings['rest']!,
          ),
        ],
      ),
      // Only the currently revealed segment is seeded in Fake mode.
      revealedPolyline: const <GeoPointDto>[
        GeoPointDto(latitude: -6.2010, longitude: 106.8170),
        GeoPointDto(latitude: -6.2030, longitude: 106.8190),
        GeoPointDto(latitude: -6.2010, longitude: 106.8220),
        GeoPointDto(latitude: -6.1980, longitude: 106.8240),
        GeoPointDto(latitude: -6.1940, longitude: 106.8210),
      ],
      milestones: const <TrackMilestoneDto>[
        TrackMilestoneDto(
          id: 'milestone-001',
          order: 1,
          position: GeoPointDto(latitude: -6.2030, longitude: 106.8190),
          reached: false,
          expReward: 500,
        ),
        TrackMilestoneDto(
          id: 'milestone-002',
          order: 2,
          position: GeoPointDto(latitude: -6.2010, longitude: 106.8220),
          reached: false,
          expReward: 500,
        ),
        TrackMilestoneDto(
          id: 'milestone-003',
          order: 3,
          position: GeoPointDto(latitude: -6.1940, longitude: 106.8210),
          reached: false,
          expReward: 500,
        ),
      ],
      serverStartPosition: const GeoPointDto(
        latitude: -6.2010,
        longitude: 106.8170,
      ),
      distanceMeters: 1500,
      estimatedDurationMinutes: 13,
      estimatedCalories: 90,
      safetyScore: 86,
      safetyConfidence: 90,
      distanceToStartMeters: 120,
      routeNote: strings['tip'],
      beforeStartTip: strings['warmup'],
      failureCode: failed ? 'route_generation_failed' : null,
    );
  }

  static const _trackTitles = <String, Map<String, String>>{
    'en': <String, String>{
      'track-old-trees': 'Morning Trail Beyond the Old Trees',
      'track-senayan': 'Senayan Shaded Loop',
      'track-city-park': 'Morning at the City Park',
      'track-canal-side': 'Canal-side Route',
    },
    'id': <String, String>{
      'track-old-trees': 'Jalur Pagi di Balik Pepohonan Tua',
      'track-senayan': 'Jalur Teduh Senayan',
      'track-city-park': 'Pagi di Taman Kota',
      'track-canal-side': 'Rute Tepi Kanal',
    },
  };

  List<ShopItemDto> catalog() {
    final isIndonesian = languageCode() == 'id';
    // Fake seed values only; production prices and item effects come from server config.
    return <ShopItemDto>[
      ShopItemDto(
        id: 'streak_freeze',
        name: isIndonesian ? 'Streak Freeze' : 'Streak Freeze',
        description: isIndonesian
            ? 'Melindungi streak hingga dua hari tanpa lari.'
            : 'Auto-protect up to 2 missed days',
        priceCoins: 10,
        effectCode: 'streak_freeze',
        available: true,
        maxStock: 2,
      ),
      ShopItemDto(
        id: 'exp_boost',
        name: isIndonesian ? 'Peningkat EXP 1,5x' : 'EXP Boost 1.5x',
        description: isIndonesian
            ? 'EXP 1,5x untuk milestone dalam 24 menit aktif pertama.'
            : '1.5x EXP for milestones reached in the first 24 active minutes',
        priceCoins: 8,
        effectCode: 'exp_multiplier',
        available: true,
        maxStock: 5,
      ),
      ShopItemDto(
        id: 'less_compensation',
        name: isIndonesian ? 'Kompensasi Ringan' : 'Less Compensation',
        description: isIndonesian
            ? 'Penalti milestone gagal dikurangi menjadi 65%.'
            : 'Failed milestone penalty is reduced to 65%',
        priceCoins: 6,
        effectCode: 'penalty_reduction',
        available: true,
        maxStock: 5,
      ),
      ShopItemDto(
        id: 'gain_more_risk_more',
        name: isIndonesian
            ? 'Lebih Banyak, Lebih Berisiko'
            : 'Gain More, Risk More',
        description: isIndonesian
            ? 'EXP 2x dan penalti milestone gagal 1,75x.'
            : '2x EXP and 1.75x failed milestone penalty',
        priceCoins: 10,
        effectCode: 'high_risk_multiplier',
        available: true,
        maxStock: 5,
        risky: true,
      ),
    ];
  }

  List<BadgeDto> badges() {
    final isIndonesian = languageCode() == 'id';
    return <BadgeDto>[
      BadgeDto(
        id: 'first_run',
        name: isIndonesian ? 'Langkah Pertama' : 'First Stride',
        description: isIndonesian
            ? 'Selesaikan lari pertamamu.'
            : 'Complete your first run.',
        unlocked: true,
        progress: 1,
      ),
      BadgeDto(
        id: 'five_runs',
        name: isIndonesian ? 'Menemukan Ritme' : 'Finding Your Rhythm',
        description: isIndonesian
            ? 'Selesaikan lima sesi lari.'
            : 'Complete five runs.',
        unlocked: true,
        progress: 1,
      ),
      BadgeDto(
        id: 'first_5k',
        name: 'First 5K',
        description: isIndonesian
            ? 'Tempuh total lima kilometer.'
            : 'Cover five kilometers in total.',
        unlocked: true,
        progress: 1,
      ),
      BadgeDto(
        id: 'first_10k',
        name: '10K Explorer',
        description: isIndonesian
            ? 'Tempuh total sepuluh kilometer.'
            : 'Cover ten kilometers in total.',
        unlocked: true,
        progress: 1,
      ),
      BadgeDto(
        id: 'streak_5',
        name: isIndonesian ? 'Alur Lima Hari' : 'Five Day Flow',
        description: isIndonesian
            ? 'Jaga streak lari selama lima hari.'
            : 'Keep a five-day running streak.',
        unlocked: true,
        progress: 1,
      ),
      BadgeDto(
        id: 'streak_7',
        name: isIndonesian ? 'Pekan Bergerak' : 'Week of Movement',
        description: isIndonesian
            ? 'Jaga streak-mu selama tujuh hari.'
            : 'Keep your streak alive for seven days.',
        unlocked: false,
        progress: 6 / 7,
      ),
      BadgeDto(
        id: 'first_checkpoints',
        name: isIndonesian ? 'Checkpoint Pertama' : 'Checkpoint Starter',
        description: isIndonesian
            ? 'Capai tiga milestone lari.'
            : 'Reach three run milestones.',
        unlocked: true,
        progress: 1,
      ),
      BadgeDto(
        id: 'checkpoint_10',
        name: isIndonesian ? 'Pengumpul Milestone' : 'Milestone Collector',
        description: isIndonesian
            ? 'Capai sepuluh milestone lari.'
            : 'Reach ten run milestones.',
        unlocked: true,
        progress: 1,
      ),
      BadgeDto(
        id: 'safe_stop_1',
        name: isIndonesian ? 'Pilihan Tepat' : 'A Good Call',
        description: isIndonesian
            ? 'Gunakan Safe Stop untuk mengakhiri lari dengan aman.'
            : 'Use Safe Stop to end a run safely.',
        unlocked: true,
        progress: 1,
      ),
      BadgeDto(
        id: 'longest_2k',
        name: isIndonesian ? 'Dua Kilometer' : 'Two Kilometer Stretch',
        description: isIndonesian
            ? 'Selesaikan lari setidaknya dua kilometer.'
            : 'Complete a run of at least 2 km.',
        unlocked: true,
        progress: 1,
      ),
    ];
  }
}
