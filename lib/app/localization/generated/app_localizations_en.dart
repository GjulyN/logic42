// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Logic 42';

  @override
  String get continueLabel => 'Continue';

  @override
  String get onboardingTitle => 'Find the hidden rule';

  @override
  String get onboardingBody =>
      'Five complete rows show a pattern. Enter the missing result in row six. Every number stays between 1 and 42.';

  @override
  String get homeTitle => 'Home';

  @override
  String get classic => 'Classic';

  @override
  String get daily => 'Daily';

  @override
  String get speed => 'Speed';

  @override
  String get discovery => 'Discovery';

  @override
  String get stats => 'Statistics';

  @override
  String get achievements => 'Achievements';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get about => 'About';

  @override
  String get privacy => 'Privacy';

  @override
  String get terms => 'Terms';

  @override
  String get worlds => 'Worlds';

  @override
  String get worldBasicPatterns => 'Basic Patterns';

  @override
  String get worldModularRules => 'Modular Rules';

  @override
  String get worldNumberGroups => 'Number Groups';

  @override
  String get worldPrimeLogic => 'Prime Logic';

  @override
  String get worldFortyTwoSymmetry => '42 Symmetry';

  @override
  String get worldMetaRules => 'Meta Rules';

  @override
  String get submit => 'Submit';

  @override
  String get delete => 'Delete';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String get hint => 'Hint';

  @override
  String get giveUp => 'Give up';

  @override
  String get nextPuzzle => 'Next puzzle';

  @override
  String get solution => 'Worked solution';

  @override
  String get correct => 'Correct';

  @override
  String get incorrect => 'Not quite. Try again.';

  @override
  String get xpEarned => 'XP earned';

  @override
  String level(int n) {
    return 'Level $n';
  }

  @override
  String get theme => 'Theme';

  @override
  String get sound => 'Sound';

  @override
  String get haptics => 'Haptics';

  @override
  String get reduceMotion => 'Reduce motion';

  @override
  String get highContrast => 'High contrast';

  @override
  String get signInUpgrade => 'Link account (optional)';

  @override
  String get offlineAccount => 'Playing offline as a local profile.';

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumBody => 'Premium is not for sale in this build.';

  @override
  String get legalPlaceholder =>
      'Owner-supplied legal text will replace this placeholder. This screen does not make legal guarantees.';

  @override
  String get enterNumber => 'Enter a number from 1 to 42';

  @override
  String cellLabel(int row, String col) {
    return 'Row $row, column $col';
  }

  @override
  String get resultColumn => 'Result';

  @override
  String get attempts => 'Attempts';

  @override
  String get hintsUsed => 'Hints used';

  @override
  String get bestTime => 'Best time';

  @override
  String get streak => 'Streak';

  @override
  String get xp => 'XP';

  @override
  String get play => 'Play';

  @override
  String get locked => 'Locked';

  @override
  String get practice => 'Practice';

  @override
  String get rankedUsed =>
      'Ranked attempt already used today. Practice is still open.';

  @override
  String get speedStart => 'Start 5-puzzle run';

  @override
  String get speedPaused =>
      'Timer paused while the app is in the background. Background time does not count.';

  @override
  String get skipOnboarding => 'Skip';

  @override
  String get splashTagline => 'Patterns in 1–42';
}
