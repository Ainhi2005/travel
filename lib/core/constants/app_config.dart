enum Flavor { dev, staging, production }

class AppConfig {
  final Flavor flavor;
  final String apiBaseUrl;
  final String appName;
  final bool showDebugBanner;

  const AppConfig({
    required this.flavor,
    required this.apiBaseUrl,
    required this.appName,
    required this.showDebugBanner,
  });

  static late AppConfig instance;

  // tiện
  bool get isDev => flavor == Flavor.dev;
  bool get isStaging => flavor == Flavor.staging;
  bool get isProduction => flavor == Flavor.production;
}
