// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Milestracks';

  @override
  String get welcomeTitle => 'Welcome to Milestracks';

  @override
  String get welcomeDescription =>
      'Turn every run into a mystery worth uncovering.';

  @override
  String get authTitle => 'Sign in or create an account';

  @override
  String get onboardingTitle => 'A few things before your first run';

  @override
  String get homeTitle => 'Home';

  @override
  String get oauthCallbackTitle => 'Strava connection';

  @override
  String get routePreparingTitle => 'Getting your experience ready';

  @override
  String get routePreparingDescription =>
      'This screen will be available in a later stage.';

  @override
  String get continueLabel => 'Continue';

  @override
  String get onboardingFinishTitle => 'Your running journey starts here.';

  @override
  String get onboardingFinishBody =>
      'Your account and safety preferences are ready. Let’s find your first mystery route.';

  @override
  String get languageLabel => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageIndonesian => 'Indonesian';

  @override
  String get locationPermissionReason =>
      'Milestracks uses your location to record your running route and show your progress while you run.';

  @override
  String get notificationPermissionReason =>
      'Milestracks uses notifications to keep essential run status and safety controls available while you run.';

  @override
  String get runNotificationChannelName => 'Run tracking';

  @override
  String get runNotificationChannelDescription =>
      'Ongoing status and safety controls for your active run.';

  @override
  String get databaseUnavailable =>
      'Local run storage is unavailable. Please restart the app.';

  @override
  String get networkError =>
      'We could not reach the server. Check your connection and try again.';

  @override
  String get sessionExpired =>
      'Your session has expired. Please sign in again.';

  @override
  String get serverError =>
      'The server could not complete the request. Try again shortly.';

  @override
  String get requestTimedOut =>
      'The request took too long. Check your connection and try again.';

  @override
  String get unknownError => 'Something went wrong. Please try again.';

  @override
  String get validationError =>
      'Some information is invalid. Check it and try again.';

  @override
  String get conflictError =>
      'This action conflicts with your current account state.';

  @override
  String get rateLimitError => 'Too many requests. Please wait and try again.';

  @override
  String get authInvalidCredentials => 'The email or password is incorrect.';

  @override
  String get authEmailTaken => 'An account already uses this email address.';

  @override
  String get authGoogleCanceled => 'Google sign-in was canceled.';

  @override
  String get authGoogleFailed =>
      'Google sign-in could not be completed. Try again.';

  @override
  String get insufficientCoins => 'You do not have enough coins for this item.';

  @override
  String get welcomeRouteLabel => 'Mystery Route';

  @override
  String get welcomeRouteDistance => '1.5 km';

  @override
  String get welcomeEyebrow => 'A safer way to run';

  @override
  String get welcomeHeroTitle => 'Every step has a story.';

  @override
  String get welcomeHeroBody =>
      'Explore safer routes, build your rhythm, and celebrate every step.';

  @override
  String get welcomeLegal =>
      'By continuing, you agree to the Milestracks Terms of Service and Privacy Policy.';

  @override
  String get authContinueGoogle => 'Continue with Google';

  @override
  String get authSignUpEmail => 'Sign up with Email';

  @override
  String get authAlreadyAccount => 'Already have an account? Sign in';

  @override
  String get authBack => 'Back';

  @override
  String get authIntroSignInTitle => 'Welcome back';

  @override
  String get authIntroSignInBody => 'Sign in to continue your progress.';

  @override
  String get authIntroSignUpTitle => 'Take your first step';

  @override
  String get authIntroSignUpBody =>
      'Create an account to save every achievement.';

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authSignUp => 'Sign up';

  @override
  String get authEmail => 'Email';

  @override
  String get authEmailHint => 'you@example.com';

  @override
  String get authEmailInvalid => 'Enter a valid email address.';

  @override
  String get authPassword => 'Password';

  @override
  String get authPasswordHint => '8 to 72 characters';

  @override
  String get authPasswordInvalid => 'Password must be 8 to 72 characters.';

  @override
  String get authDisplayName => 'Display name';

  @override
  String get authDisplayNameHint => 'Your name';

  @override
  String get authDisplayNameInvalid => 'Name must be 2 to 30 characters.';

  @override
  String get authShowPassword => 'Show password';

  @override
  String get authHidePassword => 'Hide password';

  @override
  String get authCreateAccount => 'Create Account';

  @override
  String get authTerms =>
      'By continuing, you agree to the Terms of Service and Privacy Policy.';

  @override
  String get authCopyright => '© 2026 Milestracks. All rights reserved.';

  @override
  String get authGoogleNotConfigured =>
      'Google sign-in is not configured for this build.';

  @override
  String get readinessEyebrow => 'PRE-RUN SAFETY';

  @override
  String get readinessTitle => 'Ready to run?';

  @override
  String get readinessDescription =>
      'We ask about heart or joint conditions, chest pain, dizziness, and blood-pressure medication to tailor safer running guidance.';

  @override
  String get readinessOverviewTitle => 'A safer start';

  @override
  String get readinessOverviewBody => 'Five questions, about one minute';

  @override
  String get readinessQuestionHeading => 'Answer honestly';

  @override
  String get readinessQuestionSubheading => 'Choose yes or no for each.';

  @override
  String get readinessCheckCount => '5 checks';

  @override
  String get readinessQuestionHeart => 'Heart condition';

  @override
  String get readinessQuestionChest => 'Chest pain during activity';

  @override
  String get readinessQuestionDizziness => 'Dizziness or loss of balance';

  @override
  String get readinessQuestionJoint => 'Bone or joint problems';

  @override
  String get readinessQuestionMedication => 'Taking blood-pressure medication';

  @override
  String get readinessYes => 'Yes';

  @override
  String get readinessNo => 'No';

  @override
  String get readinessConsent =>
      'I understand the risks and am ready to run safely.';

  @override
  String get readinessNoticeTitle => 'Listen to your body';

  @override
  String get readinessNoticeBody =>
      'Milestracks is not a substitute for medical advice. Stop if you feel unwell.';

  @override
  String get readinessReadyButton => 'I’m Ready';

  @override
  String onboardingStep(int step) {
    return 'Step $step of 3';
  }

  @override
  String get permissionEyebrow => 'SYSTEM PERMISSIONS';

  @override
  String get permissionTitle => 'Enable the best experience';

  @override
  String get permissionDescription =>
      'You can always change these permissions later in Settings.';

  @override
  String get permissionLocationTitle => 'High-Accuracy GPS';

  @override
  String get permissionLocationBody =>
      'Tracks routes and ensures milestones are recorded.';

  @override
  String get permissionNotificationsTitle => 'Notifications';

  @override
  String get permissionNotificationsBody =>
      'Streak and weekly league reminders.';

  @override
  String get permissionAllow => 'Allow';

  @override
  String get permissionActive => 'Active';

  @override
  String get permissionSkipNotifications => 'Not now for notifications';

  @override
  String get permissionMascotTitle => 'Kila says';

  @override
  String get permissionMascotBody =>
      'GPS helps me follow your route. Notifications are optional.';

  @override
  String get permissionError =>
      'We couldn’t check that permission. Please try again in Settings.';

  @override
  String get stravaEyebrow => 'INTEGRATION';

  @override
  String get stravaTitle => 'Take your runs further';

  @override
  String get stravaDescription =>
      'Strava is an optional integration. You can connect it later; it is not required to use Milestracks.';

  @override
  String get stravaDemoRun => 'Morning run';

  @override
  String get stravaBenefitsHeading => 'After connecting';

  @override
  String get stravaBenefitsSubheading => 'What Strava adds to your runs.';

  @override
  String get stravaBenefitOneTitle => 'Automatic run uploads';

  @override
  String get stravaBenefitOneBody => 'Save each activity without extra steps.';

  @override
  String get stravaBenefitTwoTitle => 'Routes and stats together';

  @override
  String get stravaBenefitTwoBody =>
      'Keep every run and its details in one place.';

  @override
  String get stravaBenefitThreeTitle => 'Share with friends';

  @override
  String get stravaBenefitThreeBody => 'Join challenges and stay motivated.';

  @override
  String get stravaContinueWithout => 'Continue without Strava';

  @override
  String get stravaSkip => 'Skip for now';

  @override
  String get homeWelcome => 'WELCOME TO MILESTRACKS';

  @override
  String get homeWelcomeEyebrow => 'WELCOME TO MILESTRACKS';

  @override
  String get homeWelcomeBack => 'Welcome back';

  @override
  String homeGreeting(String name) {
    return 'Hi, $name!';
  }

  @override
  String get homeNotifications => 'Notifications';

  @override
  String get notificationTitle => 'Notifications';

  @override
  String get notificationEyebrow => 'YOUR UPDATES';

  @override
  String get notificationDescription =>
      'Stay in the loop with your running progress.';

  @override
  String get notificationMarkAllRead => 'Mark all read';

  @override
  String get notificationMarkRead => 'Mark notification as read';

  @override
  String get notificationFooter =>
      'Run, route, and reward updates in one place.';

  @override
  String get notificationStreakTitle => 'Your streak is waiting';

  @override
  String get notificationStreakBody =>
      'A short run today will keep your running rhythm alive.';

  @override
  String get notificationStreakTime => '10 min ago';

  @override
  String get notificationRouteTitle => 'A safer track is ready';

  @override
  String get notificationRouteBody => 'Kila found a shaded route near Jakarta.';

  @override
  String get notificationRouteTime => '1 hr ago';

  @override
  String get notificationMilestoneTitle => 'Milestone secured';

  @override
  String get notificationMilestoneBody =>
      'You reached a checkpoint. Your earned EXP is protected.';

  @override
  String get notificationMilestoneTime => '3 hr ago';

  @override
  String get notificationSafetyTitle => 'Crossing ahead';

  @override
  String get notificationSafetyBody =>
      'Your Mystery Track has one road crossing. Follow the signs and watch traffic.';

  @override
  String get notificationSafetyTime => '5 hr ago';

  @override
  String get notificationFriendTitle => 'Ayu invited you to run';

  @override
  String get notificationFriendBody =>
      'Join a short evening jog together this week.';

  @override
  String get notificationFriendTime => 'Yesterday';

  @override
  String get notificationLeagueTitle => 'Weekly league update';

  @override
  String get notificationLeagueBody =>
      'Keep moving toward the top runners in your league.';

  @override
  String get notificationLeagueTime => 'Yesterday';

  @override
  String get notificationRewardTitle => 'EXP Boost is ready';

  @override
  String get notificationRewardBody =>
      'Your boost is ready to equip before your next run.';

  @override
  String get notificationRewardTime => '2 days ago';

  @override
  String get notificationPaymentTitle => 'Top-up confirmed';

  @override
  String get notificationPaymentBody =>
      'Your recent coin top-up has been marked as paid.';

  @override
  String get notificationPaymentTime => '3 days ago';

  @override
  String get homeKilaNote => 'KILA\'S SAFETY NOTE';

  @override
  String get homeSaferRoute => 'A safer route is ready.';

  @override
  String get homeTodaysRoute => 'TODAY\'S ROUTE';

  @override
  String get homeMysteryTrack => 'Today\'s mystery track';

  @override
  String get homeRouteCallout => 'Your next route is waiting.';

  @override
  String get homeRouteDescription =>
      'Let Kila find a safer route and uncover its milestones as you run.';

  @override
  String get homeCheckTrack => 'Check track';

  @override
  String get homeSectionLater => 'This section is coming in a later stage.';

  @override
  String get homeDayStreak => 'DAY STREAK';

  @override
  String get homeStreakTitle => 'RUN STREAK';

  @override
  String get homeStreakRhythm => 'Your rhythm this week';

  @override
  String homeWeekRunCount(int count) {
    return '$count active days this week';
  }

  @override
  String get homeLeagueTeaser => 'Build your weekly points with every run.';

  @override
  String homeLevel(int level) {
    return 'Level $level';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navHistory => 'History';

  @override
  String get navShop => 'Shop';

  @override
  String get navRun => 'Run';

  @override
  String get navLeague => 'League';

  @override
  String get navFriends => 'Friends';

  @override
  String get navProfile => 'Profile';

  @override
  String get trackReady => 'READY';

  @override
  String get trackGeneratingEyebrow => 'TODAY\'S ROUTE';

  @override
  String get trackGeneratingTitle => 'Scouting for a safe route...';

  @override
  String get trackGeneratingDescription => 'Building a shaded route';

  @override
  String get trackGenerationFailed =>
      'We couldn\'t find a route right now. Please try again.';

  @override
  String get trackTryAgain => 'Try again';

  @override
  String get trackCopyright => '© 2026 Milestracks. All rights reserved.';

  @override
  String get trackPreparationTitle => 'Mystery Track Run Preparation';

  @override
  String get trackOverviewEyebrow => 'ROUTE OVERVIEW';

  @override
  String get trackPlanRun => 'Plan your run';

  @override
  String get trackSafe => 'Safe track';

  @override
  String get trackSafePreview => 'Safe track preview';

  @override
  String trackSafetyScore(int score) {
    return '$score% safety';
  }

  @override
  String trackDataConfidence(int percent) {
    return '$percent% data confidence';
  }

  @override
  String get trackEstimatedCalories => 'EST. CALORIES';

  @override
  String get trackEstimatedDuration => 'DURATION';

  @override
  String get trackFullMap => 'Full map';

  @override
  String trackAboutStart(int distance) {
    return 'About $distance m from you';
  }

  @override
  String trackMeters(int distance) {
    return '$distance m';
  }

  @override
  String get trackRunLoadout => 'Run loadout';

  @override
  String get trackLoadoutDescription => 'One EXP boost and one route modifier';

  @override
  String get trackEditLoadout => 'Edit loadout';

  @override
  String get trackExpBoost => 'EXP BOOST';

  @override
  String get trackRouteModifier => 'ROUTE MODIFIER';

  @override
  String trackEquippedCount(int count) {
    return '$count equipped';
  }

  @override
  String get trackStreakFreezeNote =>
      'Streak Freeze auto-activates and does not use a run slot.';

  @override
  String get trackLoadoutUnavailable => 'Loadout editing is not available yet.';

  @override
  String get trackStartPoint => 'Start point';

  @override
  String get trackMilestoneDistanceHint =>
      'Milestone distances are measured along the route';

  @override
  String get trackStartDetailsHidden => 'Details shown when your run begins';

  @override
  String get trackMilestones => 'Milestones';

  @override
  String trackMilestoneCount(int count) {
    return '$count milestones';
  }

  @override
  String get trackRouteNote => 'Route note';

  @override
  String get trackBeforeStart => 'Before you start';

  @override
  String get trackStartRunNextStage => 'Reveal Route & Start';

  @override
  String get trackRunNextStageHint =>
      'Run tracking will be available in the next stage.';

  @override
  String get trackReport => 'Report';

  @override
  String get trackReportLater =>
      'Route reporting will be available in a later stage.';

  @override
  String get trackLocationUnavailable =>
      'Enable location services and allow location access to create a route.';

  @override
  String get mapAttribution => '© OpenStreetMap contributors';

  @override
  String get runNotificationTitle => 'Run in progress';

  @override
  String get runNotificationBody => 'Milestracks is recording your route.';

  @override
  String get runBackgroundLocationRequired =>
      'Allow background location access to keep tracking if you lock your screen.';

  @override
  String get runModeTitle => 'Run Mode';

  @override
  String get runReadyTitle => 'Your route is ready';

  @override
  String get runReadyBody =>
      'Stay aware of traffic and follow the route at a comfortable pace.';

  @override
  String get runWaitingGps => 'Waiting for a reliable GPS signal';

  @override
  String get runDistance => 'DISTANCE';

  @override
  String get runDuration => 'TIME';

  @override
  String get runPace => 'PACE';

  @override
  String get runEstimatedCalories => 'EST. CAL';

  @override
  String get runMinutes => 'min';

  @override
  String runDistanceOf(String distance) {
    return 'of $distance km';
  }

  @override
  String runFinishDistance(String distance) {
    return '$distance m to finish';
  }

  @override
  String runNiceWork(String name) {
    return 'Nice work, $name.';
  }

  @override
  String get runComfortablePace => 'Keep a comfortable pace.';

  @override
  String get runGpsSignal => 'GPS signal';

  @override
  String get runLiveRoute => 'LIVE ROUTE';

  @override
  String get runRunnerLabel => 'Runner';

  @override
  String get runSoundOn => 'Turn sound off';

  @override
  String get runSoundOff => 'Turn sound on';

  @override
  String get runFinishSlider => 'Slide to finish';

  @override
  String runMilestonesProgress(int reached, int total) {
    return 'Milestones reached: $reached of $total';
  }

  @override
  String get runStart => 'Reveal Route & Start';

  @override
  String get runPause => 'Pause';

  @override
  String get runResume => 'Resume';

  @override
  String get runFinish => 'Finish run';

  @override
  String get runSafeStop => 'Safe Stop';

  @override
  String get runSafeStopTitle => 'End this run safely?';

  @override
  String get runSafeStopBody =>
      'You can stop whenever you need to. Safe Stop does not apply a run penalty.';

  @override
  String get runFinishTitle => 'Finish this run?';

  @override
  String get runFinishBody =>
      'Your run will be sent for validation and the server will calculate your results.';

  @override
  String get runCancel => 'Keep running';

  @override
  String get runConfirm => 'End run';

  @override
  String get runCompletedTitle => 'Run complete';

  @override
  String get runSafeStoppedTitle => 'Run ended safely';

  @override
  String get runRejectedTitle => 'Run could not be verified';

  @override
  String get runExpAwarded => 'Net EXP';

  @override
  String get runCoinsAwarded => 'Coins earned';

  @override
  String get runSyncPending =>
      'Saved on this device. Results will sync when you are back online.';

  @override
  String get runBackHome => 'Back to Home';

  @override
  String get runResultYourRoute => 'YOUR ROUTE';

  @override
  String get runResultSaved => 'Saved';

  @override
  String get runResultPrivacy =>
      'Track stats only. Your start location stays private.';

  @override
  String get runResultMovingTime => 'moving time';

  @override
  String get runResultCalories => 'est. cals';

  @override
  String get runResultPrivatePreview => 'PRIVATE TRACK PREVIEW';

  @override
  String get runResultEconomyEyebrow => 'ECONOMY RESULT';

  @override
  String get runResultRewardsTitle => 'Rewards from this run';

  @override
  String runResultLoadout(String loadout) {
    return 'Loadout: $loadout';
  }

  @override
  String get runResultMilestoneExp => 'Milestone EXP';

  @override
  String get runResultMultiplier => 'EXP multiplier';

  @override
  String get runResultPenalty => 'Run penalty';

  @override
  String get runResultDailyCap => 'Daily EXP cap';

  @override
  String get runResultApplied => 'Applied';

  @override
  String get runResultAddedToLevel => 'Added to level progress';

  @override
  String get runResultRolePoints => 'ROLE LEAGUE RP';

  @override
  String get runResultDailyFootnote =>
      'Daily reward limits are reflected in the totals above.';

  @override
  String get runResultSafeStopFootnote =>
      'Safe Stop protected earned EXP from a failed milestone penalty.';

  @override
  String get runResultStreak => 'RUN STREAK';

  @override
  String runResultStreakDay(int day) {
    return 'Day $day - your rhythm keeps growing';
  }

  @override
  String get runResultViewHistory => 'View track history';

  @override
  String get runResultShareProgress => 'Share progress';

  @override
  String get runResultShareTrack => 'Share track';

  @override
  String get runResultClaimFinish => 'Claim & finish';

  @override
  String get runResultRewardsClaimed => 'Rewards claimed';

  @override
  String get runResultShareUnavailable => 'Sharing is not available yet.';

  @override
  String get runMilestoneTitle => 'Milestone reached';

  @override
  String get runContinue => 'Continue';

  @override
  String get runRest => 'Take a rest';

  @override
  String get runPaused => 'Run paused';

  @override
  String get runActive => 'Run in progress';

  @override
  String get runRejectedBody =>
      'The server could not validate this run. No rewards were added.';

  @override
  String get runNoResult => 'Run details are not available.';

  @override
  String get runStartedAt => 'Started';

  @override
  String get historyTitle => 'Track history';

  @override
  String get historyEmpty => 'Your past runs will appear here.';

  @override
  String get historyError => 'Run history could not be loaded.';

  @override
  String get historyRetry => 'Try again';

  @override
  String get historyLoadMore => 'Load more';

  @override
  String get historyDetailTitle => 'Run details';

  @override
  String get historyNoTrace => 'No route trace is available for this run.';

  @override
  String get historyCompleted => 'Completed';

  @override
  String get historySafeStopped => 'Safe Stop';

  @override
  String get historyRejected => 'Rejected';

  @override
  String get historyDistance => 'Distance';

  @override
  String get historyDuration => 'Duration';

  @override
  String get historyPace => 'Pace';

  @override
  String get historyNetExp => 'Net EXP';

  @override
  String get historyBrand => 'Milestracks';

  @override
  String get historyHeroEyebrow => 'YOUR MILESTRACKS JOURNAL';

  @override
  String get historyHeroTitle => 'Every run counts.';

  @override
  String get historyHeroDescription =>
      'Your routes, milestones, and progress in one place.';

  @override
  String get historyRunsCount => 'runs';

  @override
  String get historyDistanceStat => 'distance';

  @override
  String get historyExpEarned => 'EXP earned';

  @override
  String get historyRecentRuns => 'RECENT RUNS';

  @override
  String get historyNewestFirst => 'Newest first';

  @override
  String get historyFilterAll => 'All';

  @override
  String get historyFilterCompleted => 'Completed';

  @override
  String get historyFilterSafeStop => 'Safe stop';

  @override
  String get historyFilterFlagged => 'Flagged';

  @override
  String get historyFilterRejected => 'Rejected';

  @override
  String get historySearchHint => 'Search tracks or dates';

  @override
  String get historySearchLabel => 'Search track history';

  @override
  String get historyClean => 'Clean';

  @override
  String get historyFlaggedTag => 'Flagged';

  @override
  String get historyMoving => 'moving';

  @override
  String get historyNoMatchingRuns => 'No matching runs';

  @override
  String get historyNoMatchingRunsBody =>
      'Choose another status filter to see more runs.';

  @override
  String get historyDataNote =>
      'Run records follow the Milestracks run history fields. Demo data is stored locally.';

  @override
  String get shopTitle => 'Shop';

  @override
  String get shopStoreEyebrow => 'MILESTRACKS STORE';

  @override
  String get shopHeroTitle => 'Find your running edge.';

  @override
  String get shopHeroDescription =>
      'Small boosts and helpful tools for your next run.';

  @override
  String get shopBalanceEyebrow => 'YOUR BALANCE';

  @override
  String get shopCoinName => 'Milestracks Coins';

  @override
  String get shopTopUp => 'Top up';

  @override
  String get shopTopUpUnavailable => 'Coin top up is not available yet.';

  @override
  String get shopCatalogTab => 'Shop';

  @override
  String get shopInventoryTab => 'Inventory';

  @override
  String get shopCatalogEyebrow => 'THE CATALOG';

  @override
  String get shopAvailableItems => 'Available items';

  @override
  String get shopInventoryEyebrow => 'YOUR ITEMS';

  @override
  String get shopInventoryTitle => 'Inventory';

  @override
  String shopItemCount(int count) {
    return '$count items';
  }

  @override
  String shopOwnedCountTotal(int count) {
    return '$count owned';
  }

  @override
  String shopOwnedFraction(int owned, int maximum) {
    return '$owned/$maximum owned';
  }

  @override
  String get shopPopular => 'Popular';

  @override
  String get shopHigherRisk => 'Higher risk';

  @override
  String get shopMaxStock => 'Max';

  @override
  String get shopAutoUse => 'Auto-use';

  @override
  String get shopEquip => 'Equip';

  @override
  String get shopAutoUseNotice =>
      'Streak Freeze is applied automatically when needed.';

  @override
  String get shopEquippedNotice => 'This item is equipped for your next run.';

  @override
  String get shopGoToShop => 'Go to Shop';

  @override
  String get shopInsufficientTitle => 'Not enough coins';

  @override
  String get shopInsufficientDescription =>
      'Complete more milestones to earn coins.';

  @override
  String get shopRunToEarn => 'Run to Earn Coins';

  @override
  String get shopClose => 'Close';

  @override
  String get shopLedgerTab => 'Coin history';

  @override
  String get shopBuy => 'Buy';

  @override
  String shopPurchasePrice(Object price, Object unit) {
    return '$price $unit';
  }

  @override
  String get shopEmpty => 'No items are available right now.';

  @override
  String get inventoryEmpty => 'Your inventory is empty.';

  @override
  String get shopPurchaseSuccess => 'Item added to your inventory.';

  @override
  String get shopInsufficientCoins =>
      'You do not have enough coins for this item.';

  @override
  String get shopPurchaseFailed => 'The purchase could not be completed.';

  @override
  String get shopLedgerEmpty => 'Coin transactions will appear here.';

  @override
  String get shopCoinBalance => 'Coin balance';

  @override
  String get shopCoins => 'coins';

  @override
  String shopOwnedCount(String count) {
    return 'Owned: $count';
  }

  @override
  String get shopEquipped => 'Equipped';

  @override
  String get shopNotEquipped => 'Not equipped';

  @override
  String get shopReasonRun => 'Run reward';

  @override
  String get shopReasonPurchase => 'Shop purchase';

  @override
  String get shopReasonOther => 'Coin transaction';

  @override
  String get profileTitle => 'Profile';

  @override
  String profileLevel(String level) {
    return 'Level $level';
  }

  @override
  String profileExperience(String exp) {
    return '$exp EXP';
  }

  @override
  String get profileStreak => 'Daily streak';

  @override
  String get profileBadges => 'Badges';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileRunHistory => 'Run history';

  @override
  String get profileError => 'Your profile could not be loaded.';

  @override
  String get profileEmptyBadges =>
      'Your first badges will show up here as you run.';

  @override
  String get badgeUnlocked => 'Unlocked';

  @override
  String get badgeLocked => 'In progress';

  @override
  String badgeProgress(String percent) {
    return '$percent% complete';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'App language';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsSignOut => 'Sign out';

  @override
  String get settingsSignOutConfirm => 'Are you sure you want to sign out?';

  @override
  String get settingsSaveFailed =>
      'Your language was saved on this device but could not be synced.';

  @override
  String get appBrand => 'Milestracks';

  @override
  String get profileEyebrow => 'Your Milestracks profile';

  @override
  String get profileJourney => 'Your running journey';

  @override
  String get profileRunnerEyebrow => 'Your runner profile';

  @override
  String get profileBeginnerRunner => 'Beginner runner';

  @override
  String profileLevelBadge(String level) {
    return 'LEVEL $level';
  }

  @override
  String get profileExperienceLabel => 'Experience progress';

  @override
  String get profileNotVerified => 'Email not verified';

  @override
  String get profileCoins => 'coins';

  @override
  String get profileTopUp => 'Top up';

  @override
  String get profileSummaryEyebrow => 'Running summary';

  @override
  String get profileActivityTitle => 'Your activity';

  @override
  String get profileTotalKm => 'Total km';

  @override
  String get profileCompletedRuns => 'Completed runs';

  @override
  String get profileMovingTime => 'Moving time';

  @override
  String get profileAveragePace => 'Average pace';

  @override
  String get profileBestPace => 'Best pace';

  @override
  String get profileLongestRun => 'Longest run';

  @override
  String get profileHistoryError => 'Your run history could not be loaded.';

  @override
  String get profileActivityEyebrow => 'Your activity';

  @override
  String get profileSeeAll => 'See all';

  @override
  String get profileNoRuns => 'Your runs will appear here.';

  @override
  String get profilePaymentHistory => 'Payment history';

  @override
  String get profilePaymentEmpty => 'Your coin purchases will appear here.';

  @override
  String profileCoinPurchase(String count) {
    return '$count Coins';
  }

  @override
  String get profilePaid => 'Paid';

  @override
  String get profileMilestonesEyebrow => 'Your milestones';

  @override
  String get profileAchievements => 'Achievements';

  @override
  String profileAchievedCount(String count) {
    return '$count achieved';
  }

  @override
  String get profileViewBadges => 'View all badges';

  @override
  String get profileCompanion => 'Your run companion';

  @override
  String get profileKilaTitle => 'Kila is cheering you on';

  @override
  String get profileKilaBody => 'Keep your streak going and help Kila evolve.';

  @override
  String get settingsBack => 'Back to profile';

  @override
  String get settingsAccountLoading => 'Loading account';

  @override
  String get settingsEmail => 'Email';

  @override
  String get settingsResend => 'Resend';

  @override
  String get settingsResendUnavailable =>
      'Verification email is not sent in this local preview.';

  @override
  String get settingsTimezone => 'Timezone';

  @override
  String get settingsUnits => 'Units';

  @override
  String get settingsMetric => 'Metric';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsShareProfile => 'Share public profile';

  @override
  String get settingsShowLeague => 'Show on leaderboards';

  @override
  String get settingsReduceMotion => 'Reduce motion';

  @override
  String get settingsDevicePreference => 'Device preference';

  @override
  String get settingsIntegrations => 'Integrations';

  @override
  String get settingsStrava => 'Strava';

  @override
  String get settingsNotConnected => 'Not connected';

  @override
  String get settingsOptional => 'Optional';

  @override
  String get settingsStravaUnavailable =>
      'Strava is optional and is not connected in this preview.';

  @override
  String get settingsDisplayLanguage => 'Display language';

  @override
  String get settingsCurrent => 'Current';

  @override
  String get settingsPermissions => 'Permissions';

  @override
  String get settingsGps => 'GPS';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsPermissionUnknown => 'Permission status unavailable';

  @override
  String get settingsOpen => 'Open Settings';

  @override
  String get settingsPermissionUnavailable =>
      'Open your device settings to change this permission.';

  @override
  String get settingsLocalNote =>
      'Settings mirror account and privacy fields. Changes in this preview are local.';

  @override
  String get settingsDeleteAccount => 'Delete Account';

  @override
  String get settingsDeleteUnavailable =>
      'Account deletion is not available in this preview.';

  @override
  String get streakTitle => 'Daily streak';

  @override
  String get streakError => 'Your streak could not be loaded.';

  @override
  String get streakCurrent => 'Current streak';

  @override
  String get streakBest => 'Best streak';

  @override
  String get streakFreezes => 'Streak freezes available';

  @override
  String get streakShieldActive =>
      'Rest Shield is active. Your streak is protected today.';

  @override
  String get streakShieldInactive => 'Rest Shield is not active.';

  @override
  String get streakLastQualified => 'Last qualifying run';

  @override
  String get streakShop => 'Visit the shop';

  @override
  String get leagueComingSoonTitle => 'Coming soon';

  @override
  String get leagueComingSoonBody =>
      'Weekly leagues are being prepared. Keep running to build your first-party progress.';

  @override
  String get leagueComingSoonSemantics =>
      'League. Coming soon. Weekly leagues are being prepared.';

  @override
  String get friendsComingSoonTitle => 'Coming soon';

  @override
  String get friendsComingSoonBody =>
      'Friends and shared running goals are being prepared.';

  @override
  String get friendsComingSoonSemantics =>
      'Friends. Coming soon. Shared running goals are being prepared.';

  @override
  String get homeProfileButton => 'Open profile';

  @override
  String homeWalletLabel(int count) {
    return 'Top up coins. Current balance: $count';
  }

  @override
  String get homeCity => 'Jakarta';

  @override
  String get homeWeatherToday => 'Today';

  @override
  String get homeWeatherText => '29° · Partly cloudy';

  @override
  String get homeSafetyScore => 'Safety score';

  @override
  String get homeMysteryRoute => 'Mystery route';

  @override
  String get homeDistanceToStart => '120 m to start';

  @override
  String get homeMinutes => 'min';

  @override
  String get homeMilestones => 'milestones';

  @override
  String get homeDailyStatus => 'Daily status';

  @override
  String get homeDailyLimits => 'Your daily limits';

  @override
  String homeRefreshesLeft(int count) {
    return '$count track refreshes left';
  }

  @override
  String get homeExpAvailable => 'EXP available';

  @override
  String get homeLeaguePoints => 'League points';

  @override
  String get homeCoinsAvailable => 'Coins available';

  @override
  String get homeSafeStops => 'Safe stops';

  @override
  String homeOfToday(int count) {
    return 'of $count today';
  }

  @override
  String homeLeft(int count) {
    return '$count left';
  }

  @override
  String homeOfThisWeek(int count) {
    return 'of $count this week';
  }

  @override
  String get homeAtRiskMinimum => 'At risk today · min. 250 m';

  @override
  String homeBestStreak(int count) {
    return 'Best $count · Started May 26, 2026';
  }

  @override
  String get homeFreezeProtection =>
      'No freeze stock · protect up to 2 missed days';

  @override
  String get homeBuy => 'Buy';

  @override
  String get homeWeeklyRhythmFooter => 'Every run builds your rhythm.';

  @override
  String homeDaysOfWeek(int count) {
    return '$count / 7 days';
  }

  @override
  String get homeMonthlyDetails => 'View monthly details';

  @override
  String get homeMonthlyHide => 'Hide monthly history';

  @override
  String get homePreviousMonth => 'Previous month';

  @override
  String get homeNextMonth => 'Next month';

  @override
  String get homeRunDayLegend => 'Run day';

  @override
  String homeMonthlyRunCount(String count) {
    return '$count runs';
  }

  @override
  String get homeThisWeek => 'This week';

  @override
  String get homeWeeklyActivity => 'Your weekly activity';

  @override
  String homeRunsAndExp(int runs, int exp) {
    return '$runs runs  ·  $exp EXP';
  }

  @override
  String get homeLeagueLabel => 'Beginner league · Weekly';

  @override
  String homeLeagueRp(int points) {
    return '$points RP this week';
  }

  @override
  String homeLeagueRank(int rank, int total) {
    return 'Rank $rank of $total runners. Top 3 earn coin prizes.';
  }

  @override
  String homeLeaguePrize(int count) {
    return '$count coins for rank 1';
  }

  @override
  String get homeViewStandings => 'View standings';

  @override
  String get homeInspiredToMove => 'Inspired to move';

  @override
  String get homeSponsored => 'Sponsored';

  @override
  String get homeMilestridePicks => 'Milestracks picks';

  @override
  String get homeAdTitle => 'Make room for a new trail.';

  @override
  String get homeAdBody => 'Explore routes built around your pace.';

  @override
  String get homeExploreTrack => 'Explore a track';

  @override
  String get homePhotoCredit => 'Photo: nobleseed / Unsplash';

  @override
  String get runRecoveryTitle => 'An unfinished run was found';

  @override
  String get runRecoveryBody =>
      'This run is still active on your account. Safely stop it to finish the session before creating another route.';

  @override
  String get runRecoveryConfirm =>
      'Safe Stop will close this run using the location samples already received by the server. You can review its result afterward.';

  @override
  String get runRecoverySafeStop => 'Safe Stop this run';

  @override
  String get runRecoveryContinue => 'Continue this run';

  @override
  String get runRecoverySafeStopHint =>
      'Your locally saved location samples will sync first. This action will not apply a run-failure penalty.';

  @override
  String get runRecoveryFailed =>
      'Could not recover the run. Check your connection and try again.';

  @override
  String get runRecoveryActive => 'Status: active';

  @override
  String get runRecoveryPaused => 'Status: paused';

  @override
  String runRecoveryStartedAt(String date) {
    return 'Started $date';
  }

  @override
  String runRecoveryDistance(String distance) {
    return 'Recorded distance: $distance km';
  }
}
