enum AppFlavor { offlineDemo, development, production }

class AppConfig {
  const AppConfig({
    required this.flavor,
    this.monetizationEnabled = false,
    this.firebaseEnabled = false,
    this.analyticsEnabled = false,
    this.crashlyticsEnabled = false,
    this.appCheckEnabled = false,
    this.leaderboardEnabled = false,
    this.dailySaltVersion = 1,
    this.dailySalt = 'logic42-daily',
  });

  final AppFlavor flavor;
  final bool monetizationEnabled;
  final bool firebaseEnabled;
  final bool analyticsEnabled;
  final bool crashlyticsEnabled;
  final bool appCheckEnabled;
  final bool leaderboardEnabled;
  final int dailySaltVersion;
  final String dailySalt;

  static AppConfig fromEnvironment() {
    const raw = String.fromEnvironment('FLAVOR', defaultValue: 'offlineDemo');
    switch (raw) {
      case 'production':
        return const AppConfig(
          flavor: AppFlavor.production,
          firebaseEnabled: true,
          analyticsEnabled: true,
          crashlyticsEnabled: true,
          appCheckEnabled: true,
          leaderboardEnabled: true,
          monetizationEnabled: false,
        );
      case 'development':
        return const AppConfig(
          flavor: AppFlavor.development,
          firebaseEnabled: true,
          analyticsEnabled: false,
          crashlyticsEnabled: false,
          appCheckEnabled: false,
          leaderboardEnabled: false,
          monetizationEnabled: false,
        );
      default:
        return const AppConfig(
          flavor: AppFlavor.offlineDemo,
          firebaseEnabled: false,
          analyticsEnabled: false,
          crashlyticsEnabled: false,
          appCheckEnabled: false,
          leaderboardEnabled: false,
          monetizationEnabled: false,
        );
    }
  }
}
