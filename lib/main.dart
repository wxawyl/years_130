import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:live_to_130/screens/home_screen.dart';
import 'package:live_to_130/services/database_service_unified.dart';
import 'package:live_to_130/services/locale_service.dart';
import 'package:live_to_130/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseServiceUnified().initDatabase();

  final localeService = LocaleService();
  await localeService.loadLocale();

  runApp(
    ChangeNotifierProvider.value(
      value: localeService,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleService>(
      builder: (context, localeService, child) {
        return MaterialApp(
          title: 'Live To 130',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.green,
            fontFamily: 'PingFang SC',
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF2E7D32),
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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