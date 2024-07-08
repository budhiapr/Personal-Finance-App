import 'package:flutter/material.dart';
import 'package:personal_finance_app/ui/screens/home/home_screen.dart';
import 'package:personal_finance_app/utils/errors/navigation_error.dart';

/// Router for navigation in the app
class PersonalFinanceRouter {
  /// Generates the routes for the navigation
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeScreenRouting.routePath:
        return HomeScreenRouting.buildRoute(settings: settings);
      default:
        throw NavigationError(settings.name ?? 'null');
    }
  }
}
