part of 'home_screen.dart';

class _FixedHomeHeader extends StatelessWidget {
  const _FixedHomeHeader({
    required this.displayName,
    required this.coins,
    required this.onProfile,
    required this.onNotifications,
    required this.onWallet,
  });
  final String displayName;
  final int coins;
  final VoidCallback onProfile;
  final VoidCallback onNotifications;
  final VoidCallback onWallet;

  @override
  Widget build(BuildContext context) {
    final t = context.milestracksTokens;
    final s = AppLocalizations.of(context)!;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: t.pageMaxWidth),
        child: Padding(
          padding: EdgeInsets.fromLTRB(t.pagePadding, 12, t.pagePadding, 5),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Semantics(
                  button: true,
                  label: s.homeProfileButton,
                  child: InkWell(
                    onTap: onProfile,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 58,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: t.surface.withValues(alpha: .92),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: t.primary.withValues(alpha: .1),
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: t.shadow,
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  alignment: Alignment.center,
                                  color: t.secondary.withValues(alpha: .25),
                                  child: Text(
                                    _profileInitial(displayName),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: t.primary,
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 11,
                                  height: 11,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff73977a),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: t.surface,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  s.homeWelcomeBack.toUpperCase(),
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(fontSize: 8, letterSpacing: 1),
                                ),
                                Text(
                                  s.homeGreeting(displayName),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _HeaderAction(
                label: s.homeNotifications,
                onTap: onNotifications,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    const MilestracksIcon('bell', size: 19),
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xffc94f43),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Semantics(
                button: true,
                label: s.homeWalletLabel(coins),
                child: InkWell(
                  onTap: onWallet,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    height: 41,
                    padding: const EdgeInsets.fromLTRB(5, 4, 8, 4),
                    decoration: BoxDecoration(
                      color: t.secondary.withValues(alpha: .14),
                      border: Border.all(
                        color: t.secondary.withValues(alpha: .32),
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 29,
                          height: 29,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: t.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const MilestracksIcon('coin', size: 24),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          NumberFormat.decimalPattern(
                            Localizations.localeOf(context).toLanguageTag(),
                          ).format(coins),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 19,
                          height: 19,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: t.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _profileInitial(String displayName) {
  final normalized = displayName.trim();
  if (normalized.isEmpty) return 'M';
  return String.fromCharCode(normalized.runes.first).toUpperCase();
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.label,
    required this.onTap,
    required this.child,
  });
  final String label;
  final VoidCallback onTap;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final t = context.milestracksTokens;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: t.surface,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(width: 42, height: 42, child: Center(child: child)),
        ),
      ),
    );
  }
}
