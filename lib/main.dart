import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:live_to_130/screens/home_screen.dart';
import 'package:live_to_130/services/database_service.dart';
import 'package:live_to_130/services/locale_service.dart';
import 'package:live_to_130/services/encryption_service.dart';
import 'package:live_to_130/services/model_router_service.dart';
import 'package:live_to_130/l10n/app_localizations.dart';
import 'package:live_to_130/providers/theme_provider.dart';
import 'package:live_to_130/theme/mood_colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService().database;
  
  final encryptionService = EncryptionService();
  await encryptionService.initialize();

  final localeService = LocaleService();
  await localeService.loadLocale();

  final modelConfig = UserModelConfig();
  
  final themeProvider = ThemeProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: localeService),
        ChangeNotifierProvider.value(value: modelConfig),
        ChangeNotifierProvider.value(value: themeProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<LocaleService, UserModelConfig, ThemeProvider>(
      builder: (context, localeService, modelConfig, themeProvider, child) {
        return MaterialApp(
          title: 'Live To 130',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.currentTheme.themeData,
          locale: localeService.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: LocaleService.supportedLocales,
          home: const HomeScreen(),
        );
      },
    );
  }
}