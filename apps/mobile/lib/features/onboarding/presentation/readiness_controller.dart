import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'readiness_controller.g.dart';

@riverpod
class ReadinessAnswers extends _$ReadinessAnswers {
  @override
  Map<int, bool> build() => const <int, bool>{};

  void setAnswer(int index, bool answer) =>
      state = <int, bool>{...state, index: answer};

  void clear() => state = const <int, bool>{};
}

@riverpod
class ReadinessConsent extends _$ReadinessConsent {
  @override
  bool build() => false;

  void setAccepted(bool accepted) => state = accepted;

  void clear() => state = false;
}
