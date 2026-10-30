import 'dart:async';
import 'dart:collection';

import 'package:milestracks/core/error/app_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fake_repository_behavior.g.dart';

enum FakeFailure { unauthorized, serverError, timeout, networkError }

enum FakeRunOutcome { completed, rejected }

class FakeRepositoryBehavior {
  FakeRepositoryBehavior({
    this.networkDelay = const Duration(milliseconds: 140),
  });

  final Duration networkDelay;
  final Map<String, Queue<FakeFailure>> _failurePlans =
      <String, Queue<FakeFailure>>{};
  FakeRunOutcome runFinishOutcome = FakeRunOutcome.completed;
  bool trackGenerationFails = false;

  void failNext(String operation, FakeFailure failure) {
    (_failurePlans[operation] ??= Queue<FakeFailure>()).add(failure);
  }

  Future<T> execute<T>(String operation, FutureOr<T> Function() action) async {
    if (networkDelay > Duration.zero) await Future<void>.delayed(networkDelay);
    final plan = _failurePlans[operation];
    if (plan != null && plan.isNotEmpty) {
      _throwFailure(plan.removeFirst());
    }
    return action();
  }

  Never _throwFailure(FakeFailure failure) {
    final kind = switch (failure) {
      FakeFailure.unauthorized => AppExceptionKind.unauthorized,
      FakeFailure.serverError => AppExceptionKind.server,
      FakeFailure.timeout => AppExceptionKind.timeout,
      FakeFailure.networkError => AppExceptionKind.network,
    };
    final statusCode = switch (failure) {
      FakeFailure.unauthorized => 401,
      FakeFailure.serverError => 500,
      _ => null,
    };
    throw AppException(
      kind: kind,
      statusCode: statusCode,
      message: switch (kind) {
        AppExceptionKind.validation => 'validationError',
        AppExceptionKind.unauthorized => 'sessionExpired',
        AppExceptionKind.conflict => 'conflictError',
        AppExceptionKind.rateLimit => 'rateLimitError',
        AppExceptionKind.server => 'serverError',
        AppExceptionKind.timeout => 'requestTimedOut',
        AppExceptionKind.network => 'networkError',
        AppExceptionKind.unknown => 'unknownError',
      },
    );
  }
}

@Riverpod(keepAlive: true)
FakeRepositoryBehavior fakeRepositoryBehavior(Ref ref) =>
    FakeRepositoryBehavior();
