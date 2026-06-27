import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sesan_travel/core/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesan_travel/core/config/env_config.dart';
import 'package:sesan_travel/core/constants/app_config.dart';
import 'package:sesan_travel/core/providers/locale_provider.dart';
import 'package:sesan_travel/core/routes/app_router.dart';
import 'package:sesan_travel/firebase_options.dart';
import 'package:sesan_travel/features/notifications/service/local_notification_service.dart';

final localNotificationService = LocalNotificationService();

void main() async {
  // Chú ý
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // 2. Khởi tạo Firebase bằng cấu hình tự động từ CLI
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("🎉 KẾT NỐI FIREBASE THÀNH CÔNG RỒI ƠI! 🎉");
    
    // 3. Khởi tạo thông báo sau khi Firebase đã kết nối thành công
    await localNotificationService.init();
  } catch (e) {
    print("❌ LỖI KẾT NỐI FIREBASE: $e");
  }
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
      debugShowCheckedModeBanner: false,
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
