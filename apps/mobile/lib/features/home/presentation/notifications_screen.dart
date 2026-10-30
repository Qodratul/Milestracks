import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:milestracks/core/theme/milestracks_tokens.dart';
import 'package:milestracks/l10n/app_localizations.dart';
import 'package:milestracks/shared/widgets/milestracks_bottom_navigation.dart';
import 'package:milestracks/shared/widgets/milestracks_icon.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key, this.showBottomNavigation = true});

  final bool showBottomNavigation;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final Set<int> _readItems = <int>{5, 6, 7};

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final tokens = context.milestracksTokens;
    final notices = <(String, String, String, String)>[
      (
        strings.notificationStreakTitle,
        strings.notificationStreakBody,
        strings.notificationStreakTime,
        'flame',
      ),
      (
        strings.notificationRouteTitle,
        strings.notificationRouteBody,
        strings.notificationRouteTime,
        'route',
      ),
      (
        strings.notificationMilestoneTitle,
        strings.notificationMilestoneBody,
        strings.notificationMilestoneTime,
        'check',
      ),
      (
        strings.notificationSafetyTitle,
        strings.notificationSafetyBody,
        strings.notificationSafetyTime,
        'shield',
      ),
      (
        strings.notificationFriendTitle,
        strings.notificationFriendBody,
        strings.notificationFriendTime,
        'friends',
      ),
      (
        strings.notificationLeagueTitle,
        strings.notificationLeagueBody,
        strings.notificationLeagueTime,
        'league',
      ),
      (
        strings.notificationRewardTitle,
        strings.notificationRewardBody,
        strings.notificationRewardTime,
        'coin',
      ),
      (
        strings.notificationPaymentTitle,
        strings.notificationPaymentBody,
        strings.notificationPaymentTime,
        'receipt',
      ),
    ];
    final allRead = _readItems.length == notices.length;
    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        toolbarHeight: 70,
        titleSpacing: 4,
        leading: IconButton(
          tooltip: strings.authBack,
          onPressed: () => context.go('/home'),
          icon: const MilestracksIcon('arrow-left'),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              strings.historyBrand,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              strings.notificationTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: tokens.pageMaxWidth),
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                tokens.pagePadding,
                12,
                tokens.pagePadding,
                24,
              ),
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            strings.notificationEyebrow,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            strings.notificationTitle,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            strings.notificationDescription,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    if (!allRead)
                      TextButton(
                        onPressed: () => setState(() {
                          _readItems.addAll(
                            List<int>.generate(notices.length, (i) => i),
                          );
                        }),
                        child: Text(strings.notificationMarkAllRead),
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: tokens.surface,
                    borderRadius: BorderRadius.circular(19),
                    border: Border.all(color: tokens.border),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: tokens.shadow,
                        blurRadius: 18,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      for (var i = 0; i < notices.length; i++) ...<Widget>[
                        _NotificationCard(
                          title: notices[i].$1,
                          body: notices[i].$2,
                          time: notices[i].$3,
                          icon: notices[i].$4,
                          read: _readItems.contains(i),
                          onRead: () => setState(() => _readItems.add(i)),
                        ),
                        if (i < notices.length - 1)
                          Divider(
                            height: 1,
                            indent: 52,
                            color: tokens.hairline,
                          ),
                      ],
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: tokens.surface,
                    border: Border.all(color: tokens.border),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.shield_outlined,
                        color: tokens.primary,
                        size: 18,
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          strings.notificationFooter,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: widget.showBottomNavigation
          ? const MilestracksBottomNavigation(
              selected: MainDestination.home,
              homeStyle: true,
            )
          : null,
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.title,
    required this.body,
    required this.time,
    required this.icon,
    required this.read,
    required this.onRead,
  });

  final String title;
  final String body;
  final String time;
  final String icon;
  final bool read;
  final VoidCallback onRead;

  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    return Material(
      color: read ? tokens.surface : MilestracksTokens.notificationUnread,
      child: InkWell(
        onTap: onRead,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: tokens.primary.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Center(child: MilestracksIcon(icon, size: 20)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            title,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        if (!read)
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: tokens.primary,
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(body, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 5),
                    Text(
                      time,
                      style: Theme.of(context).textTheme.labelSmall
                          ?.copyWith(fontSize: 9, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 32,
                height: 32,
                child: Center(
                  child: IconTheme(
                    data: IconThemeData(
                      color: read ? tokens.textMuted : tokens.success,
                    ),
                    child: const MilestracksIcon('check', size: 15),
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
