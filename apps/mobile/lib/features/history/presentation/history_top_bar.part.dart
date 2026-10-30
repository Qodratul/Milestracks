part of 'history_screen.dart';

class _HistoryTopBar extends StatelessWidget {
  const _HistoryTopBar({required this.brand, required this.title});

  final String brand;
  final String title;

  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    return SizedBox(
      height: 70,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: <Widget>[
            Semantics(
              button: true,
              label: MaterialLocalizations.of(context).backButtonTooltip,
              child: SizedBox(
                width: 48,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/home');
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: EdgeInsets.zero,
                    side: BorderSide(color: tokens.border),
                    backgroundColor: Colors.white,
                    foregroundColor: tokens.textSecondary,
                  ),
                  child: const MilestracksIcon('arrow-left', size: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    brand,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(fontSize: 10),
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontSize: 16, height: 1.2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
