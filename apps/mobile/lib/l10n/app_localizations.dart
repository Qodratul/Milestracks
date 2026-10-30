import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Milestracks'**
  String get appTitle;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Milestracks'**
  String get welcomeTitle;

  /// No description provided for @welcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Turn every run into a mystery worth uncovering.'**
  String get welcomeDescription;

  /// No description provided for @authTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in or create an account'**
  String get authTitle;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'A few things before your first run'**
  String get onboardingTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @oauthCallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Strava connection'**
  String get oauthCallbackTitle;

  /// No description provided for @routePreparingTitle.
  ///
  /// In en, this message translates to:
  /// **'Getting your experience ready'**
  String get routePreparingTitle;

  /// No description provided for @routePreparingDescription.
  ///
  /// In en, this message translates to:
  /// **'This screen will be available in a later stage.'**
  String get routePreparingDescription;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @onboardingFinishTitle.
  ///
  /// In en, this message translates to:
  /// **'Your running journey starts here.'**
  String get onboardingFinishTitle;

  /// No description provided for @onboardingFinishBody.
  ///
  /// In en, this message translates to:
  /// **'Your account and safety preferences are ready. Let’s find your first mystery route.'**
  String get onboardingFinishBody;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageIndonesian.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get languageIndonesian;

  /// No description provided for @locationPermissionReason.
  ///
  /// In en, this message translates to:
  /// **'Milestracks uses your location to record your running route and show your progress while you run.'**
  String get locationPermissionReason;

  /// No description provided for @notificationPermissionReason.
  ///
  /// In en, this message translates to:
  /// **'Milestracks uses notifications to keep essential run status and safety controls available while you run.'**
  String get notificationPermissionReason;

  /// No description provided for @runNotificationChannelName.
  ///
  /// In en, this message translates to:
  /// **'Run tracking'**
  String get runNotificationChannelName;

  /// No description provided for @runNotificationChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Ongoing status and safety controls for your active run.'**
  String get runNotificationChannelDescription;

  /// No description provided for @databaseUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Local run storage is unavailable. Please restart the app.'**
  String get databaseUnavailable;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'We could not reach the server. Check your connection and try again.'**
  String get networkError;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get sessionExpired;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'The server could not complete the request. Try again shortly.'**
  String get serverError;

  /// No description provided for @requestTimedOut.
  ///
  /// In en, this message translates to:
  /// **'The request took too long. Check your connection and try again.'**
  String get requestTimedOut;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get unknownError;

  /// No description provided for @validationError.
  ///
  /// In en, this message translates to:
  /// **'Some information is invalid. Check it and try again.'**
  String get validationError;

  /// No description provided for @conflictError.
  ///
  /// In en, this message translates to:
  /// **'This action conflicts with your current account state.'**
  String get conflictError;

  /// No description provided for @rateLimitError.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait and try again.'**
  String get rateLimitError;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'The email or password is incorrect.'**
  String get authInvalidCredentials;

  /// No description provided for @authEmailTaken.
  ///
  /// In en, this message translates to:
  /// **'An account already uses this email address.'**
  String get authEmailTaken;

  /// No description provided for @authGoogleCanceled.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in was canceled.'**
  String get authGoogleCanceled;

  /// No description provided for @authGoogleFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in could not be completed. Try again.'**
  String get authGoogleFailed;

  /// No description provided for @insufficientCoins.
  ///
  /// In en, this message translates to:
  /// **'You do not have enough coins for this item.'**
  String get insufficientCoins;

  /// No description provided for @welcomeRouteLabel.
  ///
  /// In en, this message translates to:
  /// **'Mystery Route'**
  String get welcomeRouteLabel;

  /// No description provided for @welcomeRouteDistance.
  ///
  /// In en, this message translates to:
  /// **'1.5 km'**
  String get welcomeRouteDistance;

  /// No description provided for @welcomeEyebrow.
  ///
  /// In en, this message translates to:
  /// **'A safer way to run'**
  String get welcomeEyebrow;

  /// No description provided for @welcomeHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Every step has a story.'**
  String get welcomeHeroTitle;

  /// No description provided for @welcomeHeroBody.
  ///
  /// In en, this message translates to:
  /// **'Explore safer routes, build your rhythm, and celebrate every step.'**
  String get welcomeHeroBody;

  /// No description provided for @welcomeLegal.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to the Milestracks Terms of Service and Privacy Policy.'**
  String get welcomeLegal;

  /// No description provided for @authContinueGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueGoogle;

  /// No description provided for @authSignUpEmail.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Email'**
  String get authSignUpEmail;

  /// No description provided for @authAlreadyAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get authAlreadyAccount;

  /// No description provided for @authBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get authBack;

  /// No description provided for @authIntroSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authIntroSignInTitle;

  /// No description provided for @authIntroSignInBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your progress.'**
  String get authIntroSignInBody;

  /// No description provided for @authIntroSignUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Take your first step'**
  String get authIntroSignUpTitle;

  /// No description provided for @authIntroSignUpBody.
  ///
  /// In en, this message translates to:
  /// **'Create an account to save every achievement.'**
  String get authIntroSignUpBody;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignIn;

  /// No description provided for @authSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get authSignUp;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authEmailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get authEmailHint;

  /// No description provided for @authEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get authEmailInvalid;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'8 to 72 characters'**
  String get authPasswordHint;

  /// No description provided for @authPasswordInvalid.
  ///
  /// In en, this message translates to:
  /// **'Password must be 8 to 72 characters.'**
  String get authPasswordInvalid;

  /// No description provided for @authDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get authDisplayName;

  /// No description provided for @authDisplayNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get authDisplayNameHint;

  /// No description provided for @authDisplayNameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Name must be 2 to 30 characters.'**
  String get authDisplayNameInvalid;

  /// No description provided for @authShowPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get authShowPassword;

  /// No description provided for @authHidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get authHidePassword;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authCreateAccount;

  /// No description provided for @authTerms.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to the Terms of Service and Privacy Policy.'**
  String get authTerms;

  /// No description provided for @authCopyright.
  ///
  /// In en, this message translates to:
  /// **'© 2026 Milestracks. All rights reserved.'**
  String get authCopyright;

  /// No description provided for @authGoogleNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in is not configured for this build.'**
  String get authGoogleNotConfigured;

  /// No description provided for @readinessEyebrow.
  ///
  /// In en, this message translates to:
  /// **'PRE-RUN SAFETY'**
  String get readinessEyebrow;

  /// No description provided for @readinessTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to run?'**
  String get readinessTitle;

  /// No description provided for @readinessDescription.
  ///
  /// In en, this message translates to:
  /// **'We ask about heart or joint conditions, chest pain, dizziness, and blood-pressure medication to tailor safer running guidance.'**
  String get readinessDescription;

  /// No description provided for @readinessOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'A safer start'**
  String get readinessOverviewTitle;

  /// No description provided for @readinessOverviewBody.
  ///
  /// In en, this message translates to:
  /// **'Five questions, about one minute'**
  String get readinessOverviewBody;

  /// No description provided for @readinessQuestionHeading.
  ///
  /// In en, this message translates to:
  /// **'Answer honestly'**
  String get readinessQuestionHeading;

  /// No description provided for @readinessQuestionSubheading.
  ///
  /// In en, this message translates to:
  /// **'Choose yes or no for each.'**
  String get readinessQuestionSubheading;

  /// No description provided for @readinessCheckCount.
  ///
  /// In en, this message translates to:
  /// **'5 checks'**
  String get readinessCheckCount;

  /// No description provided for @readinessQuestionHeart.
  ///
  /// In en, this message translates to:
  /// **'Heart condition'**
  String get readinessQuestionHeart;

  /// No description provided for @readinessQuestionChest.
  ///
  /// In en, this message translates to:
  /// **'Chest pain during activity'**
  String get readinessQuestionChest;

  /// No description provided for @readinessQuestionDizziness.
  ///
  /// In en, this message translates to:
  /// **'Dizziness or loss of balance'**
  String get readinessQuestionDizziness;

  /// No description provided for @readinessQuestionJoint.
  ///
  /// In en, this message translates to:
  /// **'Bone or joint problems'**
  String get readinessQuestionJoint;

  /// No description provided for @readinessQuestionMedication.
  ///
  /// In en, this message translates to:
  /// **'Taking blood-pressure medication'**
  String get readinessQuestionMedication;

  /// No description provided for @readinessYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get readinessYes;

  /// No description provided for @readinessNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get readinessNo;

  /// No description provided for @readinessConsent.
  ///
  /// In en, this message translates to:
  /// **'I understand the risks and am ready to run safely.'**
  String get readinessConsent;

  /// No description provided for @readinessNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Listen to your body'**
  String get readinessNoticeTitle;

  /// No description provided for @readinessNoticeBody.
  ///
  /// In en, this message translates to:
  /// **'Milestracks is not a substitute for medical advice. Stop if you feel unwell.'**
  String get readinessNoticeBody;

  /// No description provided for @readinessReadyButton.
  ///
  /// In en, this message translates to:
  /// **'I’m Ready'**
  String get readinessReadyButton;

  /// Progress indicator for the three onboarding screens.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of 3'**
  String onboardingStep(int step);

  /// No description provided for @permissionEyebrow.
  ///
  /// In en, this message translates to:
  /// **'SYSTEM PERMISSIONS'**
  String get permissionEyebrow;

  /// No description provided for @permissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable the best experience'**
  String get permissionTitle;

  /// No description provided for @permissionDescription.
  ///
  /// In en, this message translates to:
  /// **'You can always change these permissions later in Settings.'**
  String get permissionDescription;

  /// No description provided for @permissionLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'High-Accuracy GPS'**
  String get permissionLocationTitle;

  /// No description provided for @permissionLocationBody.
  ///
  /// In en, this message translates to:
  /// **'Tracks routes and ensures milestones are recorded.'**
  String get permissionLocationBody;

  /// No description provided for @permissionNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get permissionNotificationsTitle;

  /// No description provided for @permissionNotificationsBody.
  ///
  /// In en, this message translates to:
  /// **'Streak and weekly league reminders.'**
  String get permissionNotificationsBody;

  /// No description provided for @permissionAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get permissionAllow;

  /// No description provided for @permissionActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get permissionActive;

  /// No description provided for @permissionSkipNotifications.
  ///
  /// In en, this message translates to:
  /// **'Not now for notifications'**
  String get permissionSkipNotifications;

  /// No description provided for @permissionMascotTitle.
  ///
  /// In en, this message translates to:
  /// **'Kila says'**
  String get permissionMascotTitle;

  /// No description provided for @permissionMascotBody.
  ///
  /// In en, this message translates to:
  /// **'GPS helps me follow your route. Notifications are optional.'**
  String get permissionMascotBody;

  /// No description provided for @permissionError.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t check that permission. Please try again in Settings.'**
  String get permissionError;

  /// No description provided for @stravaEyebrow.
  ///
  /// In en, this message translates to:
  /// **'INTEGRATION'**
  String get stravaEyebrow;

  /// No description provided for @stravaTitle.
  ///
  /// In en, this message translates to:
  /// **'Take your runs further'**
  String get stravaTitle;

  /// No description provided for @stravaDescription.
  ///
  /// In en, this message translates to:
  /// **'Strava is an optional integration. You can connect it later; it is not required to use Milestracks.'**
  String get stravaDescription;

  /// No description provided for @stravaDemoRun.
  ///
  /// In en, this message translates to:
  /// **'Morning run'**
  String get stravaDemoRun;

  /// No description provided for @stravaBenefitsHeading.
  ///
  /// In en, this message translates to:
  /// **'After connecting'**
  String get stravaBenefitsHeading;

  /// No description provided for @stravaBenefitsSubheading.
  ///
  /// In en, this message translates to:
  /// **'What Strava adds to your runs.'**
  String get stravaBenefitsSubheading;

  /// No description provided for @stravaBenefitOneTitle.
  ///
  /// In en, this message translates to:
  /// **'Automatic run uploads'**
  String get stravaBenefitOneTitle;

  /// No description provided for @stravaBenefitOneBody.
  ///
  /// In en, this message translates to:
  /// **'Save each activity without extra steps.'**
  String get stravaBenefitOneBody;

  /// No description provided for @stravaBenefitTwoTitle.
  ///
  /// In en, this message translates to:
  /// **'Routes and stats together'**
  String get stravaBenefitTwoTitle;

  /// No description provided for @stravaBenefitTwoBody.
  ///
  /// In en, this message translates to:
  /// **'Keep every run and its details in one place.'**
  String get stravaBenefitTwoBody;

  /// No description provided for @stravaBenefitThreeTitle.
  ///
  /// In en, this message translates to:
  /// **'Share with friends'**
  String get stravaBenefitThreeTitle;

  /// No description provided for @stravaBenefitThreeBody.
  ///
  /// In en, this message translates to:
  /// **'Join challenges and stay motivated.'**
  String get stravaBenefitThreeBody;

  /// No description provided for @stravaContinueWithout.
  ///
  /// In en, this message translates to:
  /// **'Continue without Strava'**
  String get stravaContinueWithout;

  /// No description provided for @stravaSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get stravaSkip;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'WELCOME TO MILESTRACKS'**
  String get homeWelcome;

  /// No description provided for @homeWelcomeEyebrow.
  ///
  /// In en, this message translates to:
  /// **'WELCOME TO MILESTRACKS'**
  String get homeWelcomeEyebrow;

  /// No description provided for @homeWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get homeWelcomeBack;

  /// Personalized greeting shown in the home header.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}!'**
  String homeGreeting(String name);

  /// No description provided for @homeNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get homeNotifications;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationTitle;

  /// No description provided for @notificationEyebrow.
  ///
  /// In en, this message translates to:
  /// **'YOUR UPDATES'**
  String get notificationEyebrow;

  /// No description provided for @notificationDescription.
  ///
  /// In en, this message translates to:
  /// **'Stay in the loop with your running progress.'**
  String get notificationDescription;

  /// No description provided for @notificationMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get notificationMarkAllRead;

  /// No description provided for @notificationMarkRead.
  ///
  /// In en, this message translates to:
  /// **'Mark notification as read'**
  String get notificationMarkRead;

  /// No description provided for @notificationFooter.
  ///
  /// In en, this message translates to:
  /// **'Run, route, and reward updates in one place.'**
  String get notificationFooter;

  /// No description provided for @notificationStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Your streak is waiting'**
  String get notificationStreakTitle;

  /// No description provided for @notificationStreakBody.
  ///
  /// In en, this message translates to:
  /// **'A short run today will keep your running rhythm alive.'**
  String get notificationStreakBody;

  /// No description provided for @notificationStreakTime.
  ///
  /// In en, this message translates to:
  /// **'10 min ago'**
  String get notificationStreakTime;

  /// No description provided for @notificationRouteTitle.
  ///
  /// In en, this message translates to:
  /// **'A safer track is ready'**
  String get notificationRouteTitle;

  /// No description provided for @notificationRouteBody.
  ///
  /// In en, this message translates to:
  /// **'Kila found a shaded route near Jakarta.'**
  String get notificationRouteBody;

  /// No description provided for @notificationRouteTime.
  ///
  /// In en, this message translates to:
  /// **'1 hr ago'**
  String get notificationRouteTime;

  /// No description provided for @notificationMilestoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Milestone secured'**
  String get notificationMilestoneTitle;

  /// No description provided for @notificationMilestoneBody.
  ///
  /// In en, this message translates to:
  /// **'You reached a checkpoint. Your earned EXP is protected.'**
  String get notificationMilestoneBody;

  /// No description provided for @notificationMilestoneTime.
  ///
  /// In en, this message translates to:
  /// **'3 hr ago'**
  String get notificationMilestoneTime;

  /// No description provided for @notificationSafetyTitle.
  ///
  /// In en, this message translates to:
  /// **'Crossing ahead'**
  String get notificationSafetyTitle;

  /// No description provided for @notificationSafetyBody.
  ///
  /// In en, this message translates to:
  /// **'Your Mystery Track has one road crossing. Follow the signs and watch traffic.'**
  String get notificationSafetyBody;

  /// No description provided for @notificationSafetyTime.
  ///
  /// In en, this message translates to:
  /// **'5 hr ago'**
  String get notificationSafetyTime;

  /// No description provided for @notificationFriendTitle.
  ///
  /// In en, this message translates to:
  /// **'Ayu invited you to run'**
  String get notificationFriendTitle;

  /// No description provided for @notificationFriendBody.
  ///
  /// In en, this message translates to:
  /// **'Join a short evening jog together this week.'**
  String get notificationFriendBody;

  /// No description provided for @notificationFriendTime.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get notificationFriendTime;

  /// No description provided for @notificationLeagueTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly league update'**
  String get notificationLeagueTitle;

  /// No description provided for @notificationLeagueBody.
  ///
  /// In en, this message translates to:
  /// **'Keep moving toward the top runners in your league.'**
  String get notificationLeagueBody;

  /// No description provided for @notificationLeagueTime.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get notificationLeagueTime;

  /// No description provided for @notificationRewardTitle.
  ///
  /// In en, this message translates to:
  /// **'EXP Boost is ready'**
  String get notificationRewardTitle;

  /// No description provided for @notificationRewardBody.
  ///
  /// In en, this message translates to:
  /// **'Your boost is ready to equip before your next run.'**
  String get notificationRewardBody;

  /// No description provided for @notificationRewardTime.
  ///
  /// In en, this message translates to:
  /// **'2 days ago'**
  String get notificationRewardTime;

  /// No description provided for @notificationPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Top-up confirmed'**
  String get notificationPaymentTitle;

  /// No description provided for @notificationPaymentBody.
  ///
  /// In en, this message translates to:
  /// **'Your recent coin top-up has been marked as paid.'**
  String get notificationPaymentBody;

  /// No description provided for @notificationPaymentTime.
  ///
  /// In en, this message translates to:
  /// **'3 days ago'**
  String get notificationPaymentTime;

  /// No description provided for @homeKilaNote.
  ///
  /// In en, this message translates to:
  /// **'KILA\'S SAFETY NOTE'**
  String get homeKilaNote;

  /// No description provided for @homeSaferRoute.
  ///
  /// In en, this message translates to:
  /// **'A safer route is ready.'**
  String get homeSaferRoute;

  /// No description provided for @homeTodaysRoute.
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S ROUTE'**
  String get homeTodaysRoute;

  /// No description provided for @homeMysteryTrack.
  ///
  /// In en, this message translates to:
  /// **'Today\'s mystery track'**
  String get homeMysteryTrack;

  /// No description provided for @homeRouteCallout.
  ///
  /// In en, this message translates to:
  /// **'Your next route is waiting.'**
  String get homeRouteCallout;

  /// No description provided for @homeRouteDescription.
  ///
  /// In en, this message translates to:
  /// **'Let Kila find a safer route and uncover its milestones as you run.'**
  String get homeRouteDescription;

  /// No description provided for @homeCheckTrack.
  ///
  /// In en, this message translates to:
  /// **'Check track'**
  String get homeCheckTrack;

  /// No description provided for @homeSectionLater.
  ///
  /// In en, this message translates to:
  /// **'This section is coming in a later stage.'**
  String get homeSectionLater;

  /// No description provided for @homeDayStreak.
  ///
  /// In en, this message translates to:
  /// **'DAY STREAK'**
  String get homeDayStreak;

  /// No description provided for @homeStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'RUN STREAK'**
  String get homeStreakTitle;

  /// No description provided for @homeStreakRhythm.
  ///
  /// In en, this message translates to:
  /// **'Your rhythm this week'**
  String get homeStreakRhythm;

  /// Number of active days in this week's running streak.
  ///
  /// In en, this message translates to:
  /// **'{count} active days this week'**
  String homeWeekRunCount(int count);

  /// No description provided for @homeLeagueTeaser.
  ///
  /// In en, this message translates to:
  /// **'Build your weekly points with every run.'**
  String get homeLeagueTeaser;

  /// Runner level displayed on the home profile card.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String homeLevel(int level);

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navShop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get navShop;

  /// No description provided for @navRun.
  ///
  /// In en, this message translates to:
  /// **'Run'**
  String get navRun;

  /// No description provided for @navLeague.
  ///
  /// In en, this message translates to:
  /// **'League'**
  String get navLeague;

  /// No description provided for @navFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get navFriends;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @trackReady.
  ///
  /// In en, this message translates to:
  /// **'READY'**
  String get trackReady;

  /// No description provided for @trackGeneratingEyebrow.
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S ROUTE'**
  String get trackGeneratingEyebrow;

  /// No description provided for @trackGeneratingTitle.
  ///
  /// In en, this message translates to:
  /// **'Scouting for a safe route...'**
  String get trackGeneratingTitle;

  /// No description provided for @trackGeneratingDescription.
  ///
  /// In en, this message translates to:
  /// **'Building a shaded route'**
  String get trackGeneratingDescription;

  /// No description provided for @trackGenerationFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find a route right now. Please try again.'**
  String get trackGenerationFailed;

  /// No description provided for @trackTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get trackTryAgain;

  /// No description provided for @trackCopyright.
  ///
  /// In en, this message translates to:
  /// **'© 2026 Milestracks. All rights reserved.'**
  String get trackCopyright;

  /// No description provided for @trackPreparationTitle.
  ///
  /// In en, this message translates to:
  /// **'Mystery Track Run Preparation'**
  String get trackPreparationTitle;

  /// No description provided for @trackOverviewEyebrow.
  ///
  /// In en, this message translates to:
  /// **'ROUTE OVERVIEW'**
  String get trackOverviewEyebrow;

  /// No description provided for @trackPlanRun.
  ///
  /// In en, this message translates to:
  /// **'Plan your run'**
  String get trackPlanRun;

  /// No description provided for @trackSafe.
  ///
  /// In en, this message translates to:
  /// **'Safe track'**
  String get trackSafe;

  /// No description provided for @trackSafePreview.
  ///
  /// In en, this message translates to:
  /// **'Safe track preview'**
  String get trackSafePreview;

  /// Server-provided route safety score shown during preparation.
  ///
  /// In en, this message translates to:
  /// **'{score}% safety'**
  String trackSafetyScore(int score);

  /// Server-provided confidence in the route safety score.
  ///
  /// In en, this message translates to:
  /// **'{percent}% data confidence'**
  String trackDataConfidence(int percent);

  /// No description provided for @trackEstimatedCalories.
  ///
  /// In en, this message translates to:
  /// **'EST. CALORIES'**
  String get trackEstimatedCalories;

  /// No description provided for @trackEstimatedDuration.
  ///
  /// In en, this message translates to:
  /// **'DURATION'**
  String get trackEstimatedDuration;

  /// No description provided for @trackFullMap.
  ///
  /// In en, this message translates to:
  /// **'Full map'**
  String get trackFullMap;

  /// Approximate distance to the server-selected route start; never reveals coordinates.
  ///
  /// In en, this message translates to:
  /// **'About {distance} m from you'**
  String trackAboutStart(int distance);

  /// No description provided for @trackMeters.
  ///
  /// In en, this message translates to:
  /// **'{distance} m'**
  String trackMeters(int distance);

  /// No description provided for @trackRunLoadout.
  ///
  /// In en, this message translates to:
  /// **'Run loadout'**
  String get trackRunLoadout;

  /// No description provided for @trackLoadoutDescription.
  ///
  /// In en, this message translates to:
  /// **'One EXP boost and one route modifier'**
  String get trackLoadoutDescription;

  /// No description provided for @trackEditLoadout.
  ///
  /// In en, this message translates to:
  /// **'Edit loadout'**
  String get trackEditLoadout;

  /// No description provided for @trackExpBoost.
  ///
  /// In en, this message translates to:
  /// **'EXP BOOST'**
  String get trackExpBoost;

  /// No description provided for @trackRouteModifier.
  ///
  /// In en, this message translates to:
  /// **'ROUTE MODIFIER'**
  String get trackRouteModifier;

  /// No description provided for @trackEquippedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} equipped'**
  String trackEquippedCount(int count);

  /// No description provided for @trackStreakFreezeNote.
  ///
  /// In en, this message translates to:
  /// **'Streak Freeze auto-activates and does not use a run slot.'**
  String get trackStreakFreezeNote;

  /// No description provided for @trackLoadoutUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Loadout editing is not available yet.'**
  String get trackLoadoutUnavailable;

  /// No description provided for @trackStartPoint.
  ///
  /// In en, this message translates to:
  /// **'Start point'**
  String get trackStartPoint;

  /// No description provided for @trackMilestoneDistanceHint.
  ///
  /// In en, this message translates to:
  /// **'Milestone distances are measured along the route'**
  String get trackMilestoneDistanceHint;

  /// No description provided for @trackStartDetailsHidden.
  ///
  /// In en, this message translates to:
  /// **'Details shown when your run begins'**
  String get trackStartDetailsHidden;

  /// No description provided for @trackMilestones.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get trackMilestones;

  /// Number of milestones in the route returned by the server.
  ///
  /// In en, this message translates to:
  /// **'{count} milestones'**
  String trackMilestoneCount(int count);

  /// No description provided for @trackRouteNote.
  ///
  /// In en, this message translates to:
  /// **'Route note'**
  String get trackRouteNote;

  /// No description provided for @trackBeforeStart.
  ///
  /// In en, this message translates to:
  /// **'Before you start'**
  String get trackBeforeStart;

  /// No description provided for @trackStartRunNextStage.
  ///
  /// In en, this message translates to:
  /// **'Reveal Route & Start'**
  String get trackStartRunNextStage;

  /// No description provided for @trackRunNextStageHint.
  ///
  /// In en, this message translates to:
  /// **'Run tracking will be available in the next stage.'**
  String get trackRunNextStageHint;

  /// No description provided for @trackReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get trackReport;

  /// No description provided for @trackReportLater.
  ///
  /// In en, this message translates to:
  /// **'Route reporting will be available in a later stage.'**
  String get trackReportLater;

  /// No description provided for @trackLocationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Enable location services and allow location access to create a route.'**
  String get trackLocationUnavailable;

  /// No description provided for @mapAttribution.
  ///
  /// In en, this message translates to:
  /// **'© OpenStreetMap contributors'**
  String get mapAttribution;

  /// No description provided for @runNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Run in progress'**
  String get runNotificationTitle;

  /// No description provided for @runNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'Milestracks is recording your route.'**
  String get runNotificationBody;

  /// No description provided for @runBackgroundLocationRequired.
  ///
  /// In en, this message translates to:
  /// **'Allow background location access to keep tracking if you lock your screen.'**
  String get runBackgroundLocationRequired;

  /// No description provided for @runModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Run Mode'**
  String get runModeTitle;

  /// No description provided for @runReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your route is ready'**
  String get runReadyTitle;

  /// No description provided for @runReadyBody.
  ///
  /// In en, this message translates to:
  /// **'Stay aware of traffic and follow the route at a comfortable pace.'**
  String get runReadyBody;

  /// No description provided for @runWaitingGps.
  ///
  /// In en, this message translates to:
  /// **'Waiting for a reliable GPS signal'**
  String get runWaitingGps;

  /// No description provided for @runDistance.
  ///
  /// In en, this message translates to:
  /// **'DISTANCE'**
  String get runDistance;

  /// No description provided for @runDuration.
  ///
  /// In en, this message translates to:
  /// **'TIME'**
  String get runDuration;

  /// No description provided for @runPace.
  ///
  /// In en, this message translates to:
  /// **'PACE'**
  String get runPace;

  /// No description provided for @runEstimatedCalories.
  ///
  /// In en, this message translates to:
  /// **'EST. CAL'**
  String get runEstimatedCalories;

  /// No description provided for @runMinutes.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get runMinutes;

  /// Planned distance accompanying current live run distance.
  ///
  /// In en, this message translates to:
  /// **'of {distance} km'**
  String runDistanceOf(String distance);

  /// No description provided for @runFinishDistance.
  ///
  /// In en, this message translates to:
  /// **'{distance} m to finish'**
  String runFinishDistance(String distance);

  /// No description provided for @runNiceWork.
  ///
  /// In en, this message translates to:
  /// **'Nice work, {name}.'**
  String runNiceWork(String name);

  /// No description provided for @runComfortablePace.
  ///
  /// In en, this message translates to:
  /// **'Keep a comfortable pace.'**
  String get runComfortablePace;

  /// No description provided for @runGpsSignal.
  ///
  /// In en, this message translates to:
  /// **'GPS signal'**
  String get runGpsSignal;

  /// No description provided for @runLiveRoute.
  ///
  /// In en, this message translates to:
  /// **'LIVE ROUTE'**
  String get runLiveRoute;

  /// No description provided for @runRunnerLabel.
  ///
  /// In en, this message translates to:
  /// **'Runner'**
  String get runRunnerLabel;

  /// No description provided for @runSoundOn.
  ///
  /// In en, this message translates to:
  /// **'Turn sound off'**
  String get runSoundOn;

  /// No description provided for @runSoundOff.
  ///
  /// In en, this message translates to:
  /// **'Turn sound on'**
  String get runSoundOff;

  /// No description provided for @runFinishSlider.
  ///
  /// In en, this message translates to:
  /// **'Slide to finish'**
  String get runFinishSlider;

  /// Progress through the milestones returned by the server.
  ///
  /// In en, this message translates to:
  /// **'Milestones reached: {reached} of {total}'**
  String runMilestonesProgress(int reached, int total);

  /// No description provided for @runStart.
  ///
  /// In en, this message translates to:
  /// **'Reveal Route & Start'**
  String get runStart;

  /// No description provided for @runPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get runPause;

  /// No description provided for @runResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get runResume;

  /// No description provided for @runFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish run'**
  String get runFinish;

  /// No description provided for @runSafeStop.
  ///
  /// In en, this message translates to:
  /// **'Safe Stop'**
  String get runSafeStop;

  /// No description provided for @runSafeStopTitle.
  ///
  /// In en, this message translates to:
  /// **'End this run safely?'**
  String get runSafeStopTitle;

  /// No description provided for @runSafeStopBody.
  ///
  /// In en, this message translates to:
  /// **'You can stop whenever you need to. Safe Stop does not apply a run penalty.'**
  String get runSafeStopBody;

  /// No description provided for @runFinishTitle.
  ///
  /// In en, this message translates to:
  /// **'Finish this run?'**
  String get runFinishTitle;

  /// No description provided for @runFinishBody.
  ///
  /// In en, this message translates to:
  /// **'Your run will be sent for validation and the server will calculate your results.'**
  String get runFinishBody;

  /// No description provided for @runCancel.
  ///
  /// In en, this message translates to:
  /// **'Keep running'**
  String get runCancel;

  /// No description provided for @runConfirm.
  ///
  /// In en, this message translates to:
  /// **'End run'**
  String get runConfirm;

  /// No description provided for @runCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Run complete'**
  String get runCompletedTitle;

  /// No description provided for @runSafeStoppedTitle.
  ///
  /// In en, this message translates to:
  /// **'Run ended safely'**
  String get runSafeStoppedTitle;

  /// No description provided for @runRejectedTitle.
  ///
  /// In en, this message translates to:
  /// **'Run could not be verified'**
  String get runRejectedTitle;

  /// No description provided for @runExpAwarded.
  ///
  /// In en, this message translates to:
  /// **'Net EXP'**
  String get runExpAwarded;

  /// No description provided for @runCoinsAwarded.
  ///
  /// In en, this message translates to:
  /// **'Coins earned'**
  String get runCoinsAwarded;

  /// No description provided for @runSyncPending.
  ///
  /// In en, this message translates to:
  /// **'Saved on this device. Results will sync when you are back online.'**
  String get runSyncPending;

  /// No description provided for @runBackHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get runBackHome;

  /// No description provided for @runResultYourRoute.
  ///
  /// In en, this message translates to:
  /// **'YOUR ROUTE'**
  String get runResultYourRoute;

  /// No description provided for @runResultSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get runResultSaved;

  /// No description provided for @runResultPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Track stats only. Your start location stays private.'**
  String get runResultPrivacy;

  /// No description provided for @runResultMovingTime.
  ///
  /// In en, this message translates to:
  /// **'moving time'**
  String get runResultMovingTime;

  /// No description provided for @runResultCalories.
  ///
  /// In en, this message translates to:
  /// **'est. cals'**
  String get runResultCalories;

  /// No description provided for @runResultPrivatePreview.
  ///
  /// In en, this message translates to:
  /// **'PRIVATE TRACK PREVIEW'**
  String get runResultPrivatePreview;

  /// No description provided for @runResultEconomyEyebrow.
  ///
  /// In en, this message translates to:
  /// **'ECONOMY RESULT'**
  String get runResultEconomyEyebrow;

  /// No description provided for @runResultRewardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Rewards from this run'**
  String get runResultRewardsTitle;

  /// No description provided for @runResultLoadout.
  ///
  /// In en, this message translates to:
  /// **'Loadout: {loadout}'**
  String runResultLoadout(String loadout);

  /// No description provided for @runResultMilestoneExp.
  ///
  /// In en, this message translates to:
  /// **'Milestone EXP'**
  String get runResultMilestoneExp;

  /// No description provided for @runResultMultiplier.
  ///
  /// In en, this message translates to:
  /// **'EXP multiplier'**
  String get runResultMultiplier;

  /// No description provided for @runResultPenalty.
  ///
  /// In en, this message translates to:
  /// **'Run penalty'**
  String get runResultPenalty;

  /// No description provided for @runResultDailyCap.
  ///
  /// In en, this message translates to:
  /// **'Daily EXP cap'**
  String get runResultDailyCap;

  /// No description provided for @runResultApplied.
  ///
  /// In en, this message translates to:
  /// **'Applied'**
  String get runResultApplied;

  /// No description provided for @runResultAddedToLevel.
  ///
  /// In en, this message translates to:
  /// **'Added to level progress'**
  String get runResultAddedToLevel;

  /// No description provided for @runResultRolePoints.
  ///
  /// In en, this message translates to:
  /// **'ROLE LEAGUE RP'**
  String get runResultRolePoints;

  /// No description provided for @runResultDailyFootnote.
  ///
  /// In en, this message translates to:
  /// **'Daily reward limits are reflected in the totals above.'**
  String get runResultDailyFootnote;

  /// No description provided for @runResultSafeStopFootnote.
  ///
  /// In en, this message translates to:
  /// **'Safe Stop protected earned EXP from a failed milestone penalty.'**
  String get runResultSafeStopFootnote;

  /// No description provided for @runResultStreak.
  ///
  /// In en, this message translates to:
  /// **'RUN STREAK'**
  String get runResultStreak;

  /// No description provided for @runResultStreakDay.
  ///
  /// In en, this message translates to:
  /// **'Day {day} - your rhythm keeps growing'**
  String runResultStreakDay(int day);

  /// No description provided for @runResultViewHistory.
  ///
  /// In en, this message translates to:
  /// **'View track history'**
  String get runResultViewHistory;

  /// No description provided for @runResultShareProgress.
  ///
  /// In en, this message translates to:
  /// **'Share progress'**
  String get runResultShareProgress;

  /// No description provided for @runResultShareTrack.
  ///
  /// In en, this message translates to:
  /// **'Share track'**
  String get runResultShareTrack;

  /// No description provided for @runResultClaimFinish.
  ///
  /// In en, this message translates to:
  /// **'Claim & finish'**
  String get runResultClaimFinish;

  /// No description provided for @runResultRewardsClaimed.
  ///
  /// In en, this message translates to:
  /// **'Rewards claimed'**
  String get runResultRewardsClaimed;

  /// No description provided for @runResultShareUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Sharing is not available yet.'**
  String get runResultShareUnavailable;

  /// No description provided for @runMilestoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Milestone reached'**
  String get runMilestoneTitle;

  /// No description provided for @runContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get runContinue;

  /// No description provided for @runRest.
  ///
  /// In en, this message translates to:
  /// **'Take a rest'**
  String get runRest;

  /// No description provided for @runPaused.
  ///
  /// In en, this message translates to:
  /// **'Run paused'**
  String get runPaused;

  /// No description provided for @runActive.
  ///
  /// In en, this message translates to:
  /// **'Run in progress'**
  String get runActive;

  /// No description provided for @runRejectedBody.
  ///
  /// In en, this message translates to:
  /// **'The server could not validate this run. No rewards were added.'**
  String get runRejectedBody;

  /// No description provided for @runNoResult.
  ///
  /// In en, this message translates to:
  /// **'Run details are not available.'**
  String get runNoResult;

  /// No description provided for @runStartedAt.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get runStartedAt;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Track history'**
  String get historyTitle;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your past runs will appear here.'**
  String get historyEmpty;

  /// No description provided for @historyError.
  ///
  /// In en, this message translates to:
  /// **'Run history could not be loaded.'**
  String get historyError;

  /// No description provided for @historyRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get historyRetry;

  /// No description provided for @historyLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get historyLoadMore;

  /// No description provided for @historyDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Run details'**
  String get historyDetailTitle;

  /// No description provided for @historyNoTrace.
  ///
  /// In en, this message translates to:
  /// **'No route trace is available for this run.'**
  String get historyNoTrace;

  /// No description provided for @historyCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get historyCompleted;

  /// No description provided for @historySafeStopped.
  ///
  /// In en, this message translates to:
  /// **'Safe Stop'**
  String get historySafeStopped;

  /// No description provided for @historyRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get historyRejected;

  /// No description provided for @historyDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get historyDistance;

  /// No description provided for @historyDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get historyDuration;

  /// No description provided for @historyPace.
  ///
  /// In en, this message translates to:
  /// **'Pace'**
  String get historyPace;

  /// No description provided for @historyNetExp.
  ///
  /// In en, this message translates to:
  /// **'Net EXP'**
  String get historyNetExp;

  /// No description provided for @historyBrand.
  ///
  /// In en, this message translates to:
  /// **'Milestracks'**
  String get historyBrand;

  /// Small uppercase label above the run history hero heading.
  ///
  /// In en, this message translates to:
  /// **'YOUR MILESTRACKS JOURNAL'**
  String get historyHeroEyebrow;

  /// Headline introducing the user's running history.
  ///
  /// In en, this message translates to:
  /// **'Every run counts.'**
  String get historyHeroTitle;

  /// Short description below the run history hero headline.
  ///
  /// In en, this message translates to:
  /// **'Your routes, milestones, and progress in one place.'**
  String get historyHeroDescription;

  /// No description provided for @historyRunsCount.
  ///
  /// In en, this message translates to:
  /// **'runs'**
  String get historyRunsCount;

  /// No description provided for @historyDistanceStat.
  ///
  /// In en, this message translates to:
  /// **'distance'**
  String get historyDistanceStat;

  /// No description provided for @historyExpEarned.
  ///
  /// In en, this message translates to:
  /// **'EXP earned'**
  String get historyExpEarned;

  /// Section heading above the run history filters and list.
  ///
  /// In en, this message translates to:
  /// **'RECENT RUNS'**
  String get historyRecentRuns;

  /// No description provided for @historyNewestFirst.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get historyNewestFirst;

  /// No description provided for @historyFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get historyFilterAll;

  /// No description provided for @historyFilterCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get historyFilterCompleted;

  /// No description provided for @historyFilterSafeStop.
  ///
  /// In en, this message translates to:
  /// **'Safe stop'**
  String get historyFilterSafeStop;

  /// No description provided for @historyFilterFlagged.
  ///
  /// In en, this message translates to:
  /// **'Flagged'**
  String get historyFilterFlagged;

  /// No description provided for @historyFilterRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get historyFilterRejected;

  /// Placeholder in the run history search field.
  ///
  /// In en, this message translates to:
  /// **'Search tracks or dates'**
  String get historySearchHint;

  /// No description provided for @historySearchLabel.
  ///
  /// In en, this message translates to:
  /// **'Search track history'**
  String get historySearchLabel;

  /// No description provided for @historyClean.
  ///
  /// In en, this message translates to:
  /// **'Clean'**
  String get historyClean;

  /// No description provided for @historyFlaggedTag.
  ///
  /// In en, this message translates to:
  /// **'Flagged'**
  String get historyFlaggedTag;

  /// No description provided for @historyMoving.
  ///
  /// In en, this message translates to:
  /// **'moving'**
  String get historyMoving;

  /// No description provided for @historyNoMatchingRuns.
  ///
  /// In en, this message translates to:
  /// **'No matching runs'**
  String get historyNoMatchingRuns;

  /// No description provided for @historyNoMatchingRunsBody.
  ///
  /// In en, this message translates to:
  /// **'Choose another status filter to see more runs.'**
  String get historyNoMatchingRunsBody;

  /// No description provided for @historyDataNote.
  ///
  /// In en, this message translates to:
  /// **'Run records follow the Milestracks run history fields. Demo data is stored locally.'**
  String get historyDataNote;

  /// No description provided for @shopTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shopTitle;

  /// No description provided for @shopStoreEyebrow.
  ///
  /// In en, this message translates to:
  /// **'MILESTRACKS STORE'**
  String get shopStoreEyebrow;

  /// No description provided for @shopHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Find your running edge.'**
  String get shopHeroTitle;

  /// No description provided for @shopHeroDescription.
  ///
  /// In en, this message translates to:
  /// **'Small boosts and helpful tools for your next run.'**
  String get shopHeroDescription;

  /// No description provided for @shopBalanceEyebrow.
  ///
  /// In en, this message translates to:
  /// **'YOUR BALANCE'**
  String get shopBalanceEyebrow;

  /// No description provided for @shopCoinName.
  ///
  /// In en, this message translates to:
  /// **'Milestracks Coins'**
  String get shopCoinName;

  /// No description provided for @shopTopUp.
  ///
  /// In en, this message translates to:
  /// **'Top up'**
  String get shopTopUp;

  /// No description provided for @shopTopUpUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Coin top up is not available yet.'**
  String get shopTopUpUnavailable;

  /// No description provided for @shopCatalogTab.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shopCatalogTab;

  /// No description provided for @shopInventoryTab.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get shopInventoryTab;

  /// No description provided for @shopCatalogEyebrow.
  ///
  /// In en, this message translates to:
  /// **'THE CATALOG'**
  String get shopCatalogEyebrow;

  /// No description provided for @shopAvailableItems.
  ///
  /// In en, this message translates to:
  /// **'Available items'**
  String get shopAvailableItems;

  /// No description provided for @shopInventoryEyebrow.
  ///
  /// In en, this message translates to:
  /// **'YOUR ITEMS'**
  String get shopInventoryEyebrow;

  /// No description provided for @shopInventoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get shopInventoryTitle;

  /// Number of shop products in the catalog.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String shopItemCount(int count);

  /// Total quantity of items in the player's inventory.
  ///
  /// In en, this message translates to:
  /// **'{count} owned'**
  String shopOwnedCountTotal(int count);

  /// Quantity of an item owned and its server-configured stock limit.
  ///
  /// In en, this message translates to:
  /// **'{owned}/{maximum} owned'**
  String shopOwnedFraction(int owned, int maximum);

  /// No description provided for @shopPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get shopPopular;

  /// No description provided for @shopHigherRisk.
  ///
  /// In en, this message translates to:
  /// **'Higher risk'**
  String get shopHigherRisk;

  /// No description provided for @shopMaxStock.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get shopMaxStock;

  /// No description provided for @shopAutoUse.
  ///
  /// In en, this message translates to:
  /// **'Auto-use'**
  String get shopAutoUse;

  /// No description provided for @shopEquip.
  ///
  /// In en, this message translates to:
  /// **'Equip'**
  String get shopEquip;

  /// No description provided for @shopAutoUseNotice.
  ///
  /// In en, this message translates to:
  /// **'Streak Freeze is applied automatically when needed.'**
  String get shopAutoUseNotice;

  /// No description provided for @shopEquippedNotice.
  ///
  /// In en, this message translates to:
  /// **'This item is equipped for your next run.'**
  String get shopEquippedNotice;

  /// No description provided for @shopGoToShop.
  ///
  /// In en, this message translates to:
  /// **'Go to Shop'**
  String get shopGoToShop;

  /// No description provided for @shopInsufficientTitle.
  ///
  /// In en, this message translates to:
  /// **'Not enough coins'**
  String get shopInsufficientTitle;

  /// No description provided for @shopInsufficientDescription.
  ///
  /// In en, this message translates to:
  /// **'Complete more milestones to earn coins.'**
  String get shopInsufficientDescription;

  /// No description provided for @shopRunToEarn.
  ///
  /// In en, this message translates to:
  /// **'Run to Earn Coins'**
  String get shopRunToEarn;

  /// No description provided for @shopClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get shopClose;

  /// No description provided for @shopLedgerTab.
  ///
  /// In en, this message translates to:
  /// **'Coin history'**
  String get shopLedgerTab;

  /// No description provided for @shopBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get shopBuy;

  /// Price and coin unit shown in the purchase confirmation.
  ///
  /// In en, this message translates to:
  /// **'{price} {unit}'**
  String shopPurchasePrice(Object price, Object unit);

  /// No description provided for @shopEmpty.
  ///
  /// In en, this message translates to:
  /// **'No items are available right now.'**
  String get shopEmpty;

  /// No description provided for @inventoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your inventory is empty.'**
  String get inventoryEmpty;

  /// No description provided for @shopPurchaseSuccess.
  ///
  /// In en, this message translates to:
  /// **'Item added to your inventory.'**
  String get shopPurchaseSuccess;

  /// No description provided for @shopInsufficientCoins.
  ///
  /// In en, this message translates to:
  /// **'You do not have enough coins for this item.'**
  String get shopInsufficientCoins;

  /// No description provided for @shopPurchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'The purchase could not be completed.'**
  String get shopPurchaseFailed;

  /// No description provided for @shopLedgerEmpty.
  ///
  /// In en, this message translates to:
  /// **'Coin transactions will appear here.'**
  String get shopLedgerEmpty;

  /// No description provided for @shopCoinBalance.
  ///
  /// In en, this message translates to:
  /// **'Coin balance'**
  String get shopCoinBalance;

  /// No description provided for @shopCoins.
  ///
  /// In en, this message translates to:
  /// **'coins'**
  String get shopCoins;

  /// Quantity of an inventory item owned by the user.
  ///
  /// In en, this message translates to:
  /// **'Owned: {count}'**
  String shopOwnedCount(String count);

  /// No description provided for @shopEquipped.
  ///
  /// In en, this message translates to:
  /// **'Equipped'**
  String get shopEquipped;

  /// No description provided for @shopNotEquipped.
  ///
  /// In en, this message translates to:
  /// **'Not equipped'**
  String get shopNotEquipped;

  /// No description provided for @shopReasonRun.
  ///
  /// In en, this message translates to:
  /// **'Run reward'**
  String get shopReasonRun;

  /// No description provided for @shopReasonPurchase.
  ///
  /// In en, this message translates to:
  /// **'Shop purchase'**
  String get shopReasonPurchase;

  /// No description provided for @shopReasonOther.
  ///
  /// In en, this message translates to:
  /// **'Coin transaction'**
  String get shopReasonOther;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// The user's current server-assigned level.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String profileLevel(String level);

  /// The user's current EXP balance.
  ///
  /// In en, this message translates to:
  /// **'{exp} EXP'**
  String profileExperience(String exp);

  /// No description provided for @profileStreak.
  ///
  /// In en, this message translates to:
  /// **'Daily streak'**
  String get profileStreak;

  /// No description provided for @profileBadges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get profileBadges;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettings;

  /// No description provided for @profileRunHistory.
  ///
  /// In en, this message translates to:
  /// **'Run history'**
  String get profileRunHistory;

  /// No description provided for @profileError.
  ///
  /// In en, this message translates to:
  /// **'Your profile could not be loaded.'**
  String get profileError;

  /// No description provided for @profileEmptyBadges.
  ///
  /// In en, this message translates to:
  /// **'Your first badges will show up here as you run.'**
  String get profileEmptyBadges;

  /// No description provided for @badgeUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get badgeUnlocked;

  /// No description provided for @badgeLocked.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get badgeLocked;

  /// Progress toward unlocking a badge, provided by the server.
  ///
  /// In en, this message translates to:
  /// **'{percent}% complete'**
  String badgeProgress(String percent);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get settingsLanguage;

  /// No description provided for @settingsAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// No description provided for @settingsSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get settingsSignOut;

  /// No description provided for @settingsSignOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get settingsSignOutConfirm;

  /// No description provided for @settingsSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Your language was saved on this device but could not be synced.'**
  String get settingsSaveFailed;

  /// No description provided for @appBrand.
  ///
  /// In en, this message translates to:
  /// **'Milestracks'**
  String get appBrand;

  /// No description provided for @profileEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Your Milestracks profile'**
  String get profileEyebrow;

  /// No description provided for @profileJourney.
  ///
  /// In en, this message translates to:
  /// **'Your running journey'**
  String get profileJourney;

  /// No description provided for @profileRunnerEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Your runner profile'**
  String get profileRunnerEyebrow;

  /// No description provided for @profileBeginnerRunner.
  ///
  /// In en, this message translates to:
  /// **'Beginner runner'**
  String get profileBeginnerRunner;

  /// Current level badge in the runner profile card.
  ///
  /// In en, this message translates to:
  /// **'LEVEL {level}'**
  String profileLevelBadge(String level);

  /// No description provided for @profileExperienceLabel.
  ///
  /// In en, this message translates to:
  /// **'Experience progress'**
  String get profileExperienceLabel;

  /// No description provided for @profileNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Email not verified'**
  String get profileNotVerified;

  /// No description provided for @profileCoins.
  ///
  /// In en, this message translates to:
  /// **'coins'**
  String get profileCoins;

  /// No description provided for @profileTopUp.
  ///
  /// In en, this message translates to:
  /// **'Top up'**
  String get profileTopUp;

  /// No description provided for @profileSummaryEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Running summary'**
  String get profileSummaryEyebrow;

  /// No description provided for @profileActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Your activity'**
  String get profileActivityTitle;

  /// No description provided for @profileTotalKm.
  ///
  /// In en, this message translates to:
  /// **'Total km'**
  String get profileTotalKm;

  /// No description provided for @profileCompletedRuns.
  ///
  /// In en, this message translates to:
  /// **'Completed runs'**
  String get profileCompletedRuns;

  /// No description provided for @profileMovingTime.
  ///
  /// In en, this message translates to:
  /// **'Moving time'**
  String get profileMovingTime;

  /// No description provided for @profileAveragePace.
  ///
  /// In en, this message translates to:
  /// **'Average pace'**
  String get profileAveragePace;

  /// No description provided for @profileBestPace.
  ///
  /// In en, this message translates to:
  /// **'Best pace'**
  String get profileBestPace;

  /// No description provided for @profileLongestRun.
  ///
  /// In en, this message translates to:
  /// **'Longest run'**
  String get profileLongestRun;

  /// No description provided for @profileHistoryError.
  ///
  /// In en, this message translates to:
  /// **'Your run history could not be loaded.'**
  String get profileHistoryError;

  /// No description provided for @profileActivityEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Your activity'**
  String get profileActivityEyebrow;

  /// No description provided for @profileSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get profileSeeAll;

  /// No description provided for @profileNoRuns.
  ///
  /// In en, this message translates to:
  /// **'Your runs will appear here.'**
  String get profileNoRuns;

  /// No description provided for @profilePaymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment history'**
  String get profilePaymentHistory;

  /// No description provided for @profilePaymentEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your coin purchases will appear here.'**
  String get profilePaymentEmpty;

  /// Number of coins in a completed payment record.
  ///
  /// In en, this message translates to:
  /// **'{count} Coins'**
  String profileCoinPurchase(String count);

  /// No description provided for @profilePaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get profilePaid;

  /// No description provided for @profileMilestonesEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Your milestones'**
  String get profileMilestonesEyebrow;

  /// No description provided for @profileAchievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get profileAchievements;

  /// Number of achievements completed out of the total.
  ///
  /// In en, this message translates to:
  /// **'{count} achieved'**
  String profileAchievedCount(String count);

  /// No description provided for @profileViewBadges.
  ///
  /// In en, this message translates to:
  /// **'View all badges'**
  String get profileViewBadges;

  /// No description provided for @profileCompanion.
  ///
  /// In en, this message translates to:
  /// **'Your run companion'**
  String get profileCompanion;

  /// No description provided for @profileKilaTitle.
  ///
  /// In en, this message translates to:
  /// **'Kila is cheering you on'**
  String get profileKilaTitle;

  /// No description provided for @profileKilaBody.
  ///
  /// In en, this message translates to:
  /// **'Keep your streak going and help Kila evolve.'**
  String get profileKilaBody;

  /// No description provided for @settingsBack.
  ///
  /// In en, this message translates to:
  /// **'Back to profile'**
  String get settingsBack;

  /// No description provided for @settingsAccountLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading account'**
  String get settingsAccountLoading;

  /// No description provided for @settingsEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get settingsEmail;

  /// No description provided for @settingsResend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get settingsResend;

  /// No description provided for @settingsResendUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Verification email is not sent in this local preview.'**
  String get settingsResendUnavailable;

  /// No description provided for @settingsTimezone.
  ///
  /// In en, this message translates to:
  /// **'Timezone'**
  String get settingsTimezone;

  /// No description provided for @settingsUnits.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get settingsUnits;

  /// No description provided for @settingsMetric.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get settingsMetric;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacy;

  /// No description provided for @settingsShareProfile.
  ///
  /// In en, this message translates to:
  /// **'Share public profile'**
  String get settingsShareProfile;

  /// No description provided for @settingsShowLeague.
  ///
  /// In en, this message translates to:
  /// **'Show on leaderboards'**
  String get settingsShowLeague;

  /// No description provided for @settingsReduceMotion.
  ///
  /// In en, this message translates to:
  /// **'Reduce motion'**
  String get settingsReduceMotion;

  /// No description provided for @settingsDevicePreference.
  ///
  /// In en, this message translates to:
  /// **'Device preference'**
  String get settingsDevicePreference;

  /// No description provided for @settingsIntegrations.
  ///
  /// In en, this message translates to:
  /// **'Integrations'**
  String get settingsIntegrations;

  /// No description provided for @settingsStrava.
  ///
  /// In en, this message translates to:
  /// **'Strava'**
  String get settingsStrava;

  /// No description provided for @settingsNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get settingsNotConnected;

  /// No description provided for @settingsOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get settingsOptional;

  /// No description provided for @settingsStravaUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Strava is optional and is not connected in this preview.'**
  String get settingsStravaUnavailable;

  /// No description provided for @settingsDisplayLanguage.
  ///
  /// In en, this message translates to:
  /// **'Display language'**
  String get settingsDisplayLanguage;

  /// No description provided for @settingsCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get settingsCurrent;

  /// No description provided for @settingsPermissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get settingsPermissions;

  /// No description provided for @settingsGps.
  ///
  /// In en, this message translates to:
  /// **'GPS'**
  String get settingsGps;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsPermissionUnknown.
  ///
  /// In en, this message translates to:
  /// **'Permission status unavailable'**
  String get settingsPermissionUnknown;

  /// No description provided for @settingsOpen.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get settingsOpen;

  /// No description provided for @settingsPermissionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Open your device settings to change this permission.'**
  String get settingsPermissionUnavailable;

  /// No description provided for @settingsLocalNote.
  ///
  /// In en, this message translates to:
  /// **'Settings mirror account and privacy fields. Changes in this preview are local.'**
  String get settingsLocalNote;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsDeleteUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Account deletion is not available in this preview.'**
  String get settingsDeleteUnavailable;

  /// No description provided for @streakTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily streak'**
  String get streakTitle;

  /// No description provided for @streakError.
  ///
  /// In en, this message translates to:
  /// **'Your streak could not be loaded.'**
  String get streakError;

  /// No description provided for @streakCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current streak'**
  String get streakCurrent;

  /// No description provided for @streakBest.
  ///
  /// In en, this message translates to:
  /// **'Best streak'**
  String get streakBest;

  /// No description provided for @streakFreezes.
  ///
  /// In en, this message translates to:
  /// **'Streak freezes available'**
  String get streakFreezes;

  /// No description provided for @streakShieldActive.
  ///
  /// In en, this message translates to:
  /// **'Rest Shield is active. Your streak is protected today.'**
  String get streakShieldActive;

  /// No description provided for @streakShieldInactive.
  ///
  /// In en, this message translates to:
  /// **'Rest Shield is not active.'**
  String get streakShieldInactive;

  /// No description provided for @streakLastQualified.
  ///
  /// In en, this message translates to:
  /// **'Last qualifying run'**
  String get streakLastQualified;

  /// No description provided for @streakShop.
  ///
  /// In en, this message translates to:
  /// **'Visit the shop'**
  String get streakShop;

  /// No description provided for @leagueComingSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get leagueComingSoonTitle;

  /// No description provided for @leagueComingSoonBody.
  ///
  /// In en, this message translates to:
  /// **'Weekly leagues are being prepared. Keep running to build your first-party progress.'**
  String get leagueComingSoonBody;

  /// No description provided for @leagueComingSoonSemantics.
  ///
  /// In en, this message translates to:
  /// **'League. Coming soon. Weekly leagues are being prepared.'**
  String get leagueComingSoonSemantics;

  /// No description provided for @friendsComingSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get friendsComingSoonTitle;

  /// No description provided for @friendsComingSoonBody.
  ///
  /// In en, this message translates to:
  /// **'Friends and shared running goals are being prepared.'**
  String get friendsComingSoonBody;

  /// No description provided for @friendsComingSoonSemantics.
  ///
  /// In en, this message translates to:
  /// **'Friends. Coming soon. Shared running goals are being prepared.'**
  String get friendsComingSoonSemantics;

  /// No description provided for @homeProfileButton.
  ///
  /// In en, this message translates to:
  /// **'Open profile'**
  String get homeProfileButton;

  /// Accessible label for the wallet balance and top up action.
  ///
  /// In en, this message translates to:
  /// **'Top up coins. Current balance: {count}'**
  String homeWalletLabel(int count);

  /// No description provided for @homeCity.
  ///
  /// In en, this message translates to:
  /// **'Jakarta'**
  String get homeCity;

  /// No description provided for @homeWeatherToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get homeWeatherToday;

  /// No description provided for @homeWeatherText.
  ///
  /// In en, this message translates to:
  /// **'29° · Partly cloudy'**
  String get homeWeatherText;

  /// No description provided for @homeSafetyScore.
  ///
  /// In en, this message translates to:
  /// **'Safety score'**
  String get homeSafetyScore;

  /// No description provided for @homeMysteryRoute.
  ///
  /// In en, this message translates to:
  /// **'Mystery route'**
  String get homeMysteryRoute;

  /// No description provided for @homeDistanceToStart.
  ///
  /// In en, this message translates to:
  /// **'120 m to start'**
  String get homeDistanceToStart;

  /// No description provided for @homeMinutes.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get homeMinutes;

  /// No description provided for @homeMilestones.
  ///
  /// In en, this message translates to:
  /// **'milestones'**
  String get homeMilestones;

  /// No description provided for @homeDailyStatus.
  ///
  /// In en, this message translates to:
  /// **'Daily status'**
  String get homeDailyStatus;

  /// No description provided for @homeDailyLimits.
  ///
  /// In en, this message translates to:
  /// **'Your daily limits'**
  String get homeDailyLimits;

  /// Remaining daily track refreshes.
  ///
  /// In en, this message translates to:
  /// **'{count} track refreshes left'**
  String homeRefreshesLeft(int count);

  /// No description provided for @homeExpAvailable.
  ///
  /// In en, this message translates to:
  /// **'EXP available'**
  String get homeExpAvailable;

  /// No description provided for @homeLeaguePoints.
  ///
  /// In en, this message translates to:
  /// **'League points'**
  String get homeLeaguePoints;

  /// No description provided for @homeCoinsAvailable.
  ///
  /// In en, this message translates to:
  /// **'Coins available'**
  String get homeCoinsAvailable;

  /// No description provided for @homeSafeStops.
  ///
  /// In en, this message translates to:
  /// **'Safe stops'**
  String get homeSafeStops;

  /// No description provided for @homeOfToday.
  ///
  /// In en, this message translates to:
  /// **'of {count} today'**
  String homeOfToday(int count);

  /// No description provided for @homeLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} left'**
  String homeLeft(int count);

  /// No description provided for @homeOfThisWeek.
  ///
  /// In en, this message translates to:
  /// **'of {count} this week'**
  String homeOfThisWeek(int count);

  /// No description provided for @homeAtRiskMinimum.
  ///
  /// In en, this message translates to:
  /// **'At risk today · min. 250 m'**
  String get homeAtRiskMinimum;

  /// No description provided for @homeBestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best {count} · Started May 26, 2026'**
  String homeBestStreak(int count);

  /// No description provided for @homeFreezeProtection.
  ///
  /// In en, this message translates to:
  /// **'No freeze stock · protect up to 2 missed days'**
  String get homeFreezeProtection;

  /// No description provided for @homeBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get homeBuy;

  /// No description provided for @homeWeeklyRhythmFooter.
  ///
  /// In en, this message translates to:
  /// **'Every run builds your rhythm.'**
  String get homeWeeklyRhythmFooter;

  /// No description provided for @homeDaysOfWeek.
  ///
  /// In en, this message translates to:
  /// **'{count} / 7 days'**
  String homeDaysOfWeek(int count);

  /// No description provided for @homeMonthlyDetails.
  ///
  /// In en, this message translates to:
  /// **'View monthly details'**
  String get homeMonthlyDetails;

  /// No description provided for @homeMonthlyHide.
  ///
  /// In en, this message translates to:
  /// **'Hide monthly history'**
  String get homeMonthlyHide;

  /// No description provided for @homePreviousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get homePreviousMonth;

  /// No description provided for @homeNextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get homeNextMonth;

  /// No description provided for @homeRunDayLegend.
  ///
  /// In en, this message translates to:
  /// **'Run day'**
  String get homeRunDayLegend;

  /// Run days recorded for the visible calendar month.
  ///
  /// In en, this message translates to:
  /// **'{count} runs'**
  String homeMonthlyRunCount(String count);

  /// No description provided for @homeThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get homeThisWeek;

  /// No description provided for @homeWeeklyActivity.
  ///
  /// In en, this message translates to:
  /// **'Your weekly activity'**
  String get homeWeeklyActivity;

  /// No description provided for @homeRunsAndExp.
  ///
  /// In en, this message translates to:
  /// **'{runs} runs  ·  {exp} EXP'**
  String homeRunsAndExp(int runs, int exp);

  /// No description provided for @homeLeagueLabel.
  ///
  /// In en, this message translates to:
  /// **'Beginner league · Weekly'**
  String get homeLeagueLabel;

  /// No description provided for @homeLeagueRp.
  ///
  /// In en, this message translates to:
  /// **'{points} RP this week'**
  String homeLeagueRp(int points);

  /// No description provided for @homeLeagueRank.
  ///
  /// In en, this message translates to:
  /// **'Rank {rank} of {total} runners. Top 3 earn coin prizes.'**
  String homeLeagueRank(int rank, int total);

  /// No description provided for @homeLeaguePrize.
  ///
  /// In en, this message translates to:
  /// **'{count} coins for rank 1'**
  String homeLeaguePrize(int count);

  /// No description provided for @homeViewStandings.
  ///
  /// In en, this message translates to:
  /// **'View standings'**
  String get homeViewStandings;

  /// No description provided for @homeInspiredToMove.
  ///
  /// In en, this message translates to:
  /// **'Inspired to move'**
  String get homeInspiredToMove;

  /// No description provided for @homeSponsored.
  ///
  /// In en, this message translates to:
  /// **'Sponsored'**
  String get homeSponsored;

  /// No description provided for @homeMilestridePicks.
  ///
  /// In en, this message translates to:
  /// **'Milestracks picks'**
  String get homeMilestridePicks;

  /// No description provided for @homeAdTitle.
  ///
  /// In en, this message translates to:
  /// **'Make room for a new trail.'**
  String get homeAdTitle;

  /// No description provided for @homeAdBody.
  ///
  /// In en, this message translates to:
  /// **'Explore routes built around your pace.'**
  String get homeAdBody;

  /// No description provided for @homeExploreTrack.
  ///
  /// In en, this message translates to:
  /// **'Explore a track'**
  String get homeExploreTrack;

  /// No description provided for @homePhotoCredit.
  ///
  /// In en, this message translates to:
  /// **'Photo: nobleseed / Unsplash'**
  String get homePhotoCredit;

  /// No description provided for @runRecoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'An unfinished run was found'**
  String get runRecoveryTitle;

  /// No description provided for @runRecoveryBody.
  ///
  /// In en, this message translates to:
  /// **'This run is still active on your account. Safely stop it to finish the session before creating another route.'**
  String get runRecoveryBody;

  /// No description provided for @runRecoveryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Safe Stop will close this run using the location samples already received by the server. You can review its result afterward.'**
  String get runRecoveryConfirm;

  /// No description provided for @runRecoverySafeStop.
  ///
  /// In en, this message translates to:
  /// **'Safe Stop this run'**
  String get runRecoverySafeStop;

  /// No description provided for @runRecoveryContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue this run'**
  String get runRecoveryContinue;

  /// No description provided for @runRecoverySafeStopHint.
  ///
  /// In en, this message translates to:
  /// **'Your locally saved location samples will sync first. This action will not apply a run-failure penalty.'**
  String get runRecoverySafeStopHint;

  /// No description provided for @runRecoveryFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not recover the run. Check your connection and try again.'**
  String get runRecoveryFailed;

  /// No description provided for @runRecoveryActive.
  ///
  /// In en, this message translates to:
  /// **'Status: active'**
  String get runRecoveryActive;

  /// No description provided for @runRecoveryPaused.
  ///
  /// In en, this message translates to:
  /// **'Status: paused'**
  String get runRecoveryPaused;

  /// No description provided for @runRecoveryStartedAt.
  ///
  /// In en, this message translates to:
  /// **'Started {date}'**
  String runRecoveryStartedAt(String date);

  /// No description provided for @runRecoveryDistance.
  ///
  /// In en, this message translates to:
  /// **'Recorded distance: {distance} km'**
  String runRecoveryDistance(String distance);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
