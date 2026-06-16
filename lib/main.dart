import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sesan_travel/core/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesan_travel/core/config/env_config.dart';
import 'package:sesan_travel/core/constants/app_config.dart';
import 'package:sesan_travel/core/providers/locale_provider.dart';
import 'package:sesan_travel/core/routes/app_router.dart';

void main() async {
  // Chú ý
  WidgetsFlutterBinding.ensureInitialized();
  const env = String.fromEnvironment('env', defaultValue: 'dev');
  await dotenv.load(fileName: ".env.$env");

  final flavor = env == 'prod' || env == 'production'
      ? Flavor.production
      : (env == 'staging' ? Flavor.staging : Flavor.dev);

  AppConfig.instance = AppConfig(
    flavor: flavor,
    apiBaseUrl: EnvConfig.apiUrl,
    appName: EnvConfig.appName.trim(),
    showDebugBanner: EnvConfig.showDebugBanner,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = AppConfig.instance;
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: config.appName,
      debugShowCheckedModeBanner: config.showDebugBanner,
      routerConfig: appRouter,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
