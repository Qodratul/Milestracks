import 'package:milestracks/core/di/repository_providers.dart';
import 'package:milestracks/shared/models/api_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'history_providers.g.dart';

enum HistoryStatusFilter { all, completed, safeStopped, flagged, rejected }

class HistoryQueryState {
  const HistoryQueryState({
    this.filter = HistoryStatusFilter.all,
    this.search = '',
  });

  final HistoryStatusFilter filter;
  final String search;

  HistoryQueryState copyWith({HistoryStatusFilter? filter, String? search}) =>
      HistoryQueryState(
        filter: filter ?? this.filter,
        search: search ?? this.search,
      );
}

@riverpod
class HistoryQueryController extends _$HistoryQueryController {
  @override
  HistoryQueryState build() => const HistoryQueryState();

  void setFilter(HistoryStatusFilter filter) {
    state = state.copyWith(filter: filter);
  }

  void setSearch(String search) {
    state = state.copyWith(search: search);
  }
}

@riverpod
class RunHistoryController extends _$RunHistoryController {
  bool _loadingMore = false;

  @override
  Future<RunHistoryPageDto> build() =>
      ref.watch(runRepositoryProvider).getRunHistory();

  Future<void> refresh() async {
    state = const AsyncLoading<RunHistoryPageDto>();
    state = await AsyncValue.guard(
      () => ref.read(runRepositoryProvider).getRunHistory(),
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    final cursor = current?.nextCursor;
    if (current == null || cursor == null || _loadingMore) return;
    _loadingMore = true;
    try {
      final page = await ref
          .read(runRepositoryProvider)
          .getRunHistory(cursor: cursor);
      state = AsyncData(
        current.copyWith(
          runs: <RunDto>[...current.runs, ...page.runs],
          nextCursor: page.nextCursor,
        ),
      );
    } finally {
      _loadingMore = false;
    }
  }
}

/// Loads all cursor pages for the Profile summary, which is an aggregate view.
///
/// ASSUMPTION UNCONFIRMED: the API currently has no dedicated run-summary
/// endpoint, so the client derives these preview totals from first-party runs.
@riverpod
Future<List<RunDto>> profileRunSummary(Ref ref) async {
  final repository = ref.watch(runRepositoryProvider);
  final runs = <RunDto>[];
  final seenCursors = <String>{};
  String? cursor;
  do {
    final page = await repository.getRunHistory(cursor: cursor);
    runs.addAll(page.runs);
    cursor = page.nextCursor;
  } while (cursor != null && seenCursors.add(cursor));
  return runs;
}

@riverpod
Future<RunDetailDto> runDetail(Ref ref, String runId) =>
    ref.watch(runRepositoryProvider).getRunDetail(runId);
