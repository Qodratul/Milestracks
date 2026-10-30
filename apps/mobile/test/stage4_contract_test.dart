import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:milestracks/features/onboarding/data/remote_onboarding_repository.dart';
import 'package:milestracks/features/profile/data/remote_profile_repository.dart';
import 'package:milestracks/features/run/data/remote_run_repository.dart';
import 'package:milestracks/features/shop/data/remote_shop_repository.dart';
import 'package:milestracks/features/streak/data/remote_streak_repository.dart';
import 'package:milestracks/shared/models/api_models.dart';

void main() {
  test(
    'onboarding update sends the API fields and reads its envelope',
    () async {
      final fixture = _ApiFixture(
        (request) => <String, Object?>{
          'data': <String, Object?>{
            'onboardingComplete': true,
            'locale': 'id',
            'timezone': 'Asia/Jakarta',
          },
          'meta': <String, Object?>{'requestId': 'req_fixture'},
        },
      );
      final repository = RemoteOnboardingRepository(fixture.dio);

      final response = await repository.saveOnboarding(
        const OnboardingRequestDto(
          healthDisclaimerAccepted: true,
          locale: 'id',
          timezone: 'Asia/Jakarta',
        ),
      );

      expect(fixture.requests.single.method, 'PATCH');
      expect(fixture.requests.single.path, '/me/onboarding');
      expect(fixture.requests.single.data, <String, dynamic>{
        'healthDisclaimerAccepted': true,
        'locale': 'id',
        'timezone': 'Asia/Jakarta',
      });
      expect(response.onboardingComplete, isTrue);
      expect(response.locale, 'id');
      expect(response.timezone, 'Asia/Jakarta');
    },
  );

  test('inventory uses the real path and list envelope', () async {
    final fixture = _ApiFixture(
      (_) => <String, Object?>{
        'data': <Object?>[
          <String, Object?>{
            'itemCode': 'exp_boost',
            'name': 'EXP Boost',
            'slot': 'boost',
            'ownedCount': 2,
            'maxStock': 5,
            'autoUse': false,
            'equipped': true,
          },
        ],
        'meta': <String, Object?>{
          'requestId': 'req_fixture',
          'nextCursor': null,
        },
      },
    );
    final repository = RemoteShopRepository(fixture.dio);

    final inventory = await repository.getInventory();

    expect(fixture.requests.single.method, 'GET');
    expect(fixture.requests.single.path, '/me/inventory');
    expect(inventory.single.itemId, 'exp_boost');
    expect(inventory.single.name, 'EXP Boost');
    expect(inventory.single.quantity, 2);
    expect(inventory.single.equipped, isTrue);
  });

  test(
    'shop catalog, coin purchase, and ledger match backend contracts',
    () async {
      final fixture = _ApiFixture((request) {
        if (request.path == '/shop/items') {
          return _envelope(<Object?>[
            <String, Object?>{
              'id': 'exp_boost',
              'name': 'EXP Boost 1.5x',
              'description': 'Boost milestones.',
              'priceCoins': 8,
              'effectCode': 'exp_multiplier',
              'available': true,
              'maxStock': 5,
              'risky': false,
            },
          ]);
        }
        if (request.path == '/shop/purchase') {
          return _envelope(<String, Object?>{
            'inventoryItemId': 'inventory-exp_boost',
            'itemId': 'exp_boost',
            'remainingCoins': 12,
          });
        }
        return <String, Object?>{
          'data': <Object?>[
            <String, Object?>{
              'id': 'evt_1',
              'currency': 'coin',
              'amount': -8,
              'reason': 'shop_purchase',
              'refId': 'exp_boost',
              'createdAt': '2026-10-25T09:40:00Z',
            },
          ],
          'meta': <String, Object?>{
            'requestId': 'req_fixture',
            'timestamp': '2026-10-25T09:40:00Z',
            'nextCursor': null,
            'limit': 20,
          },
        };
      });
      final repository = RemoteShopRepository(fixture.dio);

      final catalog = await repository.getCatalog();
      final purchase = await repository.purchase(
        const PurchaseRequestDto(itemId: 'exp_boost'),
        idempotencyKey: '00000000-0000-4000-8000-000000000001',
      );
      final ledger = await repository.getCoinLedger();

      expect(catalog.single.priceCoins, 8);
      expect(purchase.remainingCoins, 12);
      expect(ledger.entries.single.amount, -8);
      expect(fixture.requests[0].path, '/shop/items');
      expect(fixture.requests[1].path, '/shop/purchase');
      expect(
        fixture.requests[1].headers['Idempotency-Key'],
        '00000000-0000-4000-8000-000000000001',
      );
      expect(fixture.requests[2].path, '/coins/ledger');
    },
  );

  test('badges and streak parse the localized API envelopes', () async {
    final fixture = _ApiFixture((request) {
      if (request.path == '/badges') {
        return _envelope(<Object?>[
          <String, Object?>{
            'id': 'first_run',
            'name': 'Langkah Pertama',
            'description': 'Selesaikan lari pertamamu.',
            'unlocked': true,
            'progress': 1,
            'unlockedAt': '2026-10-25T09:39:30Z',
          },
        ]);
      }
      return _envelope(<String, Object?>{
        'currentDays': 3,
        'bestDays': 5,
        'freezesRemaining': 0,
        'restShieldActive': true,
        'lastQualifiedAt': '2026-10-25T09:39:30Z',
      });
    });
    final badges = RemoteBadgeRepository(fixture.dio);
    final streak = RemoteStreakRepository(fixture.dio);

    final badgeList = await badges.getBadges();
    final summary = await streak.getStreak();

    expect(fixture.requests.map((request) => request.path), [
      '/badges',
      '/streak',
    ]);
    expect(badgeList.single.unlocked, isTrue);
    expect(badgeList.single.name, 'Langkah Pertama');
    expect(summary.currentDays, 3);
    expect(summary.bestDays, 5);
  });

  test(
    'history list and detail parse paged run summaries and GPS trace',
    () async {
      final fixture = _ApiFixture((request) {
        if (request.path == '/runs') {
          return <String, Object?>{
            'data': <Object?>[_historyRun()],
            'meta': <String, Object?>{
              'requestId': 'req_fixture',
              'timestamp': '2026-10-25T09:40:00Z',
              'nextCursor': 'opaque-next-cursor',
              'limit': 20,
            },
          };
        }
        if (request.path.endsWith('/summary')) {
          return _envelope(<String, Object?>{
            'runId': 'run_123',
            'status': 'completed',
            'startedAt': '2026-10-25T09:30:00Z',
            'endedAt': '2026-10-25T09:39:30Z',
            'distanceMeters': 1150,
            'durationSec': 570,
            'avgPaceSecPerKm': 496,
            'levelExpGained': 675,
            'coinsGained': 1,
            'expEarnedBase': 1000,
            'expMultiplier': 1,
            'expPenalty': 325,
            'rpGained': 500,
            'estimatedCalories': 69,
            'milestones': <String, Object?>{'reached': 2, 'total': 3},
            'streakAfter': <String, Object?>{
              'currentDays': 3,
              'bestDays': 5,
              'freezesRemaining': 0,
              'restShieldActive': false,
              'lastQualifiedAt': '2026-10-25T09:39:30Z',
            },
            'itemsUsed': <String>['less_compensation'],
            'claim': <String, Object?>{'claimId': 'claim_123', 'claimed': true},
          });
        }
        if (request.path.endsWith('/trace')) {
          return <String, Object?>{
            'data': <Object?>[
              <String, Object?>{
                'sequence': 1,
                't': 1792920600000,
                'lat': -6.2185,
                'lng': 106.8021,
                'accuracyMeters': 8,
                'mocked': false,
              },
              <String, Object?>{
                'sequence': 2,
                't': 1792920610000,
                'lat': -6.2184,
                'lng': 106.8022,
                'accuracyMeters': 8,
                'mocked': false,
              },
            ],
            'meta': <String, Object?>{
              'requestId': 'req_fixture',
              'timestamp': '2026-10-25T09:40:00Z',
              'nextCursor': null,
              'limit': 2,
            },
          };
        }
        return _envelope(<String, Object?>{
          'runId': 'run_123',
          'routeId': 'route_456',
          'status': 'completed',
          'startedAt': '2026-10-25T09:30:00Z',
          'elapsedSec': 570,
          'activeSec': 570,
          'distanceMeters': 1150,
          'gpsQuality': 'strong',
          'milestones': <String, Object?>{
            'reached': 2,
            'total': 3,
            'nextMilestoneId': null,
          },
          'lastSampleSequence': 2,
          'loadout': <String, Object?>{
            'boostItemCode': null,
            'modifierItemCode': null,
          },
          'claim': null,
        });
      });
      final repository = RemoteRunRepository(fixture.dio);

      final page = await repository.getRunHistory();
      final detail = await repository.getRunDetail('run_123');

      expect(page.runs.single.id, 'run_123');
      expect(page.runs.single.distanceMeters, 1150);
      expect(page.nextCursor, 'opaque-next-cursor');
      expect(detail.run.status, RunStatus.completed);
      expect(detail.trace, hasLength(2));
      expect(detail.trace.last.longitude, closeTo(106.8022, .000001));
    },
  );
}

Map<String, Object?> _envelope(Object data) => <String, Object?>{
  'data': data,
  'meta': <String, Object?>{
    'requestId': 'req_fixture',
    'timestamp': '2026-10-25T09:40:00Z',
  },
};

Map<String, Object?> _historyRun() => <String, Object?>{
  'runId': 'run_123',
  'routeId': 'route_456',
  'status': 'completed',
  'startedAt': '2026-10-25T09:30:00Z',
  'endedAt': '2026-10-25T09:39:30Z',
  'distanceMeters': 1150,
  'durationSec': 570,
  'avgPaceSecPerKm': 496,
  'levelExpGained': 675,
  'coinsGained': 1,
  'expEarnedBase': 1000,
  'expMultiplier': 1,
  'expPenalty': 325,
  'rpGained': 500,
  'estimatedCalories': 69,
  'streakDays': 3,
  'reachedMilestones': 2,
  'loadoutLabel': 'less_compensation',
  'rejectionCode': null,
  'claimId': 'claim_123',
  'claimed': true,
};

typedef _FixtureResponse = Map<String, Object?> Function(
  RequestOptions request,
);

class _ApiFixture {
  _ApiFixture(this.response) {
    dio = Dio(BaseOptions(baseUrl: 'https://api.fixture.test/api/v1'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            requests.add(options);
            handler.resolve(
              Response<Map<String, dynamic>>(
                requestOptions: options,
                data: response(options).cast<String, dynamic>(),
              ),
            );
          },
        ),
      );
  }

  final _FixtureResponse response;
  final List<RequestOptions> requests = <RequestOptions>[];
  late final Dio dio;
}
