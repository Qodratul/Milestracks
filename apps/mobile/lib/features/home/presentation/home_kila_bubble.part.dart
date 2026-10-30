part of 'home_screen.dart';

class _KilaBubble extends StatelessWidget {
  const _KilaBubble({
    required this.note,
    required this.safetyScore,
    required this.showDemoScore,
  });

  final String note;
  final int safetyScore;
  final bool showDemoScore;

  @override
  Widget build(BuildContext context) {
    final t = context.milestracksTokens;
    final s = AppLocalizations.of(context)!;
    final compact = MediaQuery.sizeOf(context).width <= 360;
    final artSize = compact ? 42.0 : 46.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: artSize,
          height: artSize,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Color(0xffe7f1e7), Color(0xffffffff)],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(17),
              topRight: Radius.circular(17),
              bottomLeft: Radius.circular(17),
              bottomRight: Radius.circular(7),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: t.primary.withValues(alpha: .09),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: KilaMascot(
            width: compact ? 36 : 40,
            height: compact ? 36 : 40,
          ),
        ),
        SizedBox(width: compact ? 7 : 9),
        Expanded(
          child: _KilaNoteCard(
            note: note,
            safetyScore: safetyScore,
            showDemoScore: showDemoScore,
            compact: compact,
            borderColor: Color.lerp(t.border, t.secondary, .22)!,
            shadowColor: t.primary.withValues(alpha: .09),
            title: s.homeKilaNote,
          ),
        ),
      ],
    );
  }
}

class _KilaNoteCard extends StatelessWidget {
  const _KilaNoteCard({
    required this.note,
    required this.safetyScore,
    required this.showDemoScore,
    required this.compact,
    required this.borderColor,
    required this.shadowColor,
    required this.title,
  });

  final String note;
  final int safetyScore;
  final bool showDemoScore;
  final bool compact;
  final Color borderColor;
  final Color shadowColor;
  final String title;

  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Container(
          constraints: const BoxConstraints(minHeight: 57),
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
          decoration: BoxDecoration(
            color: const Color(0xffffffff),
            border: Border.all(color: borderColor),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(17),
              topRight: Radius.circular(17),
              bottomLeft: Radius.circular(17),
              bottomRight: Radius.circular(5),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: shadowColor,
                blurRadius: 22,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: tokens.textSecondary,
                        fontSize: 7,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .77,
                      ),
                    ),
                  ),
                  if (showDemoScore) ...<Widget>[
                    const SizedBox(width: 8),
                    IconTheme(
                      data: IconThemeData(color: tokens.primary),
                      child: const MilestracksIcon('shield', size: 12),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$safetyScore%',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: tokens.primary,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 3),
              Text(
                note,
                maxLines: compact ? 2 : 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: tokens.textPrimary,
                  fontSize: compact ? 8 : 9,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: -5,
          bottom: 8,
          child: Transform.rotate(
            angle: .785398,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  left: BorderSide(color: borderColor),
                  bottom: BorderSide(color: borderColor),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
