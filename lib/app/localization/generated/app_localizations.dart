import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('ar'),
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Logic 42'**
  String get appTitle;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Find the hidden rule'**
  String get onboardingTitle;

  /// No description provided for @onboardingBody.
  ///
  /// In en, this message translates to:
  /// **'Five complete rows show a pattern. Enter the missing result in row six. Every number stays between 1 and 42.'**
  String get onboardingBody;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @classic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get classic;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @speed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speed;

  /// No description provided for @discovery.
  ///
  /// In en, this message translates to:
  /// **'Discovery'**
  String get discovery;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get stats;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get terms;

  /// No description provided for @worlds.
  ///
  /// In en, this message translates to:
  /// **'Worlds'**
  String get worlds;

  /// No description provided for @worldBasicPatterns.
  ///
  /// In en, this message translates to:
  /// **'Basic Patterns'**
  String get worldBasicPatterns;

  /// No description provided for @worldModularRules.
  ///
  /// In en, this message translates to:
  /// **'Modular Rules'**
  String get worldModularRules;

  /// No description provided for @worldNumberGroups.
  ///
  /// In en, this message translates to:
  /// **'Number Groups'**
  String get worldNumberGroups;

  /// No description provided for @worldPrimeLogic.
  ///
  /// In en, this message translates to:
  /// **'Prime Logic'**
  String get worldPrimeLogic;

  /// No description provided for @worldFortyTwoSymmetry.
  ///
  /// In en, this message translates to:
  /// **'42 Symmetry'**
  String get worldFortyTwoSymmetry;

  /// No description provided for @worldMetaRules.
  ///
  /// In en, this message translates to:
  /// **'Meta Rules'**
  String get worldMetaRules;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @hint.
  ///
  /// In en, this message translates to:
  /// **'Hint'**
  String get hint;

  /// No description provided for @giveUp.
  ///
  /// In en, this message translates to:
  /// **'Give up'**
  String get giveUp;

  /// No description provided for @nextPuzzle.
  ///
  /// In en, this message translates to:
  /// **'Next puzzle'**
  String get nextPuzzle;

  /// No description provided for @solution.
  ///
  /// In en, this message translates to:
  /// **'Worked solution'**
  String get solution;

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get correct;

  /// No description provided for @incorrect.
  ///
  /// In en, this message translates to:
  /// **'Not quite. Try again.'**
  String get incorrect;

  /// No description provided for @xpEarned.
  ///
  /// In en, this message translates to:
  /// **'XP earned'**
  String get xpEarned;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level {n}'**
  String level(int n);

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// No description provided for @haptics.
  ///
  /// In en, this message translates to:
  /// **'Haptics'**
  String get haptics;

  /// No description provided for @reduceMotion.
  ///
  /// In en, this message translates to:
  /// **'Reduce motion'**
  String get reduceMotion;

  /// No description provided for @highContrast.
  ///
  /// In en, this message translates to:
  /// **'High contrast'**
  String get highContrast;

  /// No description provided for @signInUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Link account (optional)'**
  String get signInUpgrade;

  /// No description provided for @offlineAccount.
  ///
  /// In en, this message translates to:
  /// **'Playing offline as a local profile.'**
  String get offlineAccount;

  /// No description provided for @premiumTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premiumTitle;

  /// No description provided for @premiumBody.
  ///
  /// In en, this message translates to:
  /// **'Premium is not for sale in this build.'**
  String get premiumBody;

  /// No description provided for @legalPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Owner-supplied legal text will replace this placeholder. This screen does not make legal guarantees.'**
  String get legalPlaceholder;

  /// No description provided for @enterNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a number from 1 to 42'**
  String get enterNumber;

  /// No description provided for @cellLabel.
  ///
  /// In en, this message translates to:
  /// **'Row {row}, column {col}'**
  String cellLabel(int row, String col);

  /// No description provided for @resultColumn.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get resultColumn;

  /// No description provided for @attempts.
  ///
  /// In en, this message translates to:
  /// **'Attempts'**
  String get attempts;

  /// No description provided for @hintsUsed.
  ///
  /// In en, this message translates to:
  /// **'Hints used'**
  String get hintsUsed;

  /// No description provided for @bestTime.
  ///
  /// In en, this message translates to:
  /// **'Best time'**
  String get bestTime;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streak;

  /// No description provided for @xp.
  ///
  /// In en, this message translates to:
  /// **'XP'**
  String get xp;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @practice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get practice;

  /// No description provided for @rankedUsed.
  ///
  /// In en, this message translates to:
  /// **'Ranked attempt already used today. Practice is still open.'**
  String get rankedUsed;

  /// No description provided for @speedStart.
  ///
  /// In en, this message translates to:
  /// **'Start 5-puzzle run'**
  String get speedStart;

  /// No description provided for @speedPaused.
  ///
  /// In en, this message translates to:
  /// **'Timer paused while the app is in the background. Background time does not count.'**
  String get speedPaused;

  /// No description provided for @skipOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipOnboarding;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Patterns in 1–42'**
  String get splashTagline;
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
      <String>['ar', 'de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
