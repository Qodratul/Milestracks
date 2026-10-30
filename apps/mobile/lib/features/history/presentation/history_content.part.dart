part of 'history_screen.dart';

class _HistoryContent extends ConsumerWidget {
  const _HistoryContent({required this.runs, required this.nextCursor});

  final List<RunDto> runs;
  final String? nextCursor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final query = ref.watch(historyQueryControllerProvider);
    final queryController = ref.read(historyQueryControllerProvider.notifier);
    final historyController = ref.read(runHistoryControllerProvider.notifier);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final matchingRuns = runs.where((run) {
      final matchesFilter = switch (query.filter) {
        HistoryStatusFilter.all => true,
        HistoryStatusFilter.completed => run.status == RunStatus.completed,
        HistoryStatusFilter.safeStopped => run.status == RunStatus.safeStopped,
        HistoryStatusFilter.flagged =>
          HistoryDashboardPreview.flaggedRunIds.contains(run.id),
        HistoryStatusFilter.rejected => run.status == RunStatus.rejected,
      };
      final searchable = <String>[
        run.id,
        run.trackId,
        run.trackTitle ?? _fakeTrackTitle(run.trackId, strings),
        DateFormat.yMMMd(locale).add_jm().format(run.startedAt.toLocal()),
      ].join(' ').toLowerCase();
      return matchesFilter &&
          searchable.contains(query.search.trim().toLowerCase());
    }).toList();

    return RefreshIndicator(
      onRefresh: historyController.refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 13, 20, 32),
        children: <Widget>[
          const _HistoryHero(),
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  strings.historyRecentRuns,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: context.milestracksTokens.textMuted,
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .8,
                  ),
                ),
              ),
              Text(
                strings.historyNewestFirst,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.milestracksTokens.textSecondary,
                  fontSize: 8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                for (final filter in HistoryStatusFilter.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 7),
                    child: _HistoryFilterChip(
                      label: _filterLabel(filter, strings),
                      selected: query.filter == filter,
                      onTap: () => queryController.setFilter(filter),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _HistorySearch(
            hint: strings.historySearchHint,
            label: strings.historySearchLabel,
            onChanged: (value) {
              queryController.setSearch(value);
            },
          ),
          const SizedBox(height: 13),
          if (matchingRuns.isEmpty)
            _NoMatchingRuns(
              title: runs.isEmpty
                  ? strings.historyEmpty
                  : strings.historyNoMatchingRuns,
              detail: runs.isEmpty ? '' : strings.historyNoMatchingRunsBody,
            )
          else ...<Widget>[
            for (final run in matchingRuns)
              Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: _RunHistoryCard(
                  run: run,
                  onTap: () => context.go('/history/${run.id}'),
                ),
              ),
          ],
          const SizedBox(height: 8),
          Text(
            strings.historyDataNote,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.milestracksTokens.textMuted,
              fontSize: 7,
              height: 1.4,
            ),
          ),
          if (nextCursor != null)
            Center(
              child: TextButton(
                onPressed: () => unawaited(historyController.loadMore()),
                child: Text(strings.historyLoadMore),
              ),
            ),
        ],
      ),
    );
  }
}
