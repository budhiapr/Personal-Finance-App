import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance_app/ui/screens/home/home_screen.dart';
import 'package:personal_finance_app/utils/extensions/l10n_extension.dart';
import 'package:personal_finance_app/utils/logs/logger.dart';
import 'package:personal_finance_app/utils/router/router.dart';
import 'package:personal_finance_app/utils/style/app_theme.dart';

/// The main entry point for the application.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initialize();
  runApp(const ProviderScope(child: PersonalFinanceApp()));
}

/// The main application widget.
class PersonalFinanceApp extends StatelessWidget {
  /// Creates the main application widget.
  const PersonalFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightAppTheme,
      darkTheme: darkAppTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: HomeScreenRouting.routePath,
      onGenerateRoute: PersonalFinanceRouter.generateRoute,
    );
  }
}

Future<void> _initialize() async {
  await Logger.init(logToConsole: true, logToFile: true);
  Logger.log(PersonalFinanceApp);
}
