import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:milestracks/core/router/app_router.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:milestracks/features/settings/presentation/language_controller.dart';
import 'package:milestracks/l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setHttpHeaders(const <String, String>{
    'User-Agent': 'Milestracks/1.0 (Flutter mobile app)',
  });
  runApp(const ProviderScope(child: MilestracksApp()));
}

class MilestracksApp extends ConsumerWidget {
  const MilestracksApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(languageControllerProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      theme: MilestracksTheme.light,
      darkTheme: MilestracksTheme.dark,
      themeMode: ThemeMode.light,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
