// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Logic 42';

  @override
  String get continueLabel => 'Weiter';

  @override
  String get onboardingTitle => 'Finde die versteckte Regel';

  @override
  String get onboardingBody =>
      'Fünf vollständige Zeilen zeigen ein Muster. Trage das fehlende Ergebnis in Zeile sechs ein. Jede Zahl bleibt zwischen 1 und 42.';

  @override
  String get homeTitle => 'Start';

  @override
  String get classic => 'Klassik';

  @override
  String get daily => 'Täglich';

  @override
  String get speed => 'Tempo';

  @override
  String get discovery => 'Entdeckung';

  @override
  String get stats => 'Statistik';

  @override
  String get achievements => 'Erfolge';

  @override
  String get settings => 'Einstellungen';

  @override
  String get profile => 'Profil';

  @override
  String get about => 'Über';

  @override
  String get privacy => 'Datenschutz';

  @override
  String get terms => 'Nutzungsbedingungen';

  @override
  String get worlds => 'Welten';

  @override
  String get worldBasicPatterns => 'Grundmuster';

  @override
  String get worldModularRules => 'Modulare Regeln';

  @override
  String get worldNumberGroups => 'Zahlengruppen';

  @override
  String get worldPrimeLogic => 'Primzahl-Logik';

  @override
  String get worldFortyTwoSymmetry => '42-Symmetrie';

  @override
  String get worldMetaRules => 'Meta-Regeln';

  @override
  String get submit => 'Prüfen';

  @override
  String get delete => 'Löschen';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Fortsetzen';

  @override
  String get hint => 'Hinweis';

  @override
  String get giveUp => 'Aufgeben';

  @override
  String get nextPuzzle => 'Nächstes Rätsel';

  @override
  String get solution => 'Lösungsweg';

  @override
  String get correct => 'Richtig';

  @override
  String get incorrect => 'Noch nicht. Versuche es erneut.';

  @override
  String get xpEarned => 'XP erhalten';

  @override
  String level(int n) {
    return 'Stufe $n';
  }

  @override
  String get theme => 'Design';

  @override
  String get sound => 'Ton';

  @override
  String get haptics => 'Haptik';

  @override
  String get reduceMotion => 'Bewegung reduzieren';

  @override
  String get highContrast => 'Hoher Kontrast';

  @override
  String get signInUpgrade => 'Konto verknüpfen (optional)';

  @override
  String get offlineAccount => 'Offline mit lokalem Profil.';

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumBody => 'Premium ist in diesem Build nicht kaufbar.';

  @override
  String get legalPlaceholder =>
      'Rechtstext der Eigentümerin ersetzt diesen Platzhalter. Dieser Bildschirm gibt keine Rechtsgarantien.';

  @override
  String get enterNumber => 'Zahl von 1 bis 42 eingeben';

  @override
  String cellLabel(int row, String col) {
    return 'Zeile $row, Spalte $col';
  }

  @override
  String get resultColumn => 'Ergebnis';

  @override
  String get attempts => 'Versuche';

  @override
  String get hintsUsed => 'Hinweise';

  @override
  String get bestTime => 'Beste Zeit';

  @override
  String get streak => 'Serie';

  @override
  String get xp => 'XP';

  @override
  String get play => 'Spielen';

  @override
  String get locked => 'Gesperrt';

  @override
  String get practice => 'Übung';

  @override
  String get rankedUsed =>
      'Ranglistenversuch für heute verbraucht. Übung bleibt offen.';

  @override
  String get speedStart => '5-Rätsel-Lauf starten';

  @override
  String get speedPaused =>
      'Timer pausiert im Hintergrund. Hintergrundzeit zählt nicht.';

  @override
  String get skipOnboarding => 'Überspringen';

  @override
  String get splashTagline => 'Muster in 1–42';
}
