# Personal Finance App

[![Powered by Mason][mason_badge]][mason_link]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]

An app for coding assessment at Deveji for Flutter Developer

## Showcase
<img src="https://storage.googleapis.com/deveji-careers/example_data/personalFinanaceApp.gif" width="300" alt="personalFinanaceApp.gif"/>

## Project Overview

This project is designed to run on Android and iOS. It is built using the Flutter framework and 
follows the [Deveji][deveji_link] architecture.

The application ID for the app is: 
- Android `com.deveji.personal_finance`
- iOS `com.deveji.personalFinance`

## Building the project

To rebuild the project run the following commands:
```shell
flutter clean && dart run build_runner build -d && flutter pub get
```

### Internationalization Support 🌍

The project supports [flutter_localizations][localization_docs]. The translations are 
located in the l10n folder. Each new supported locale has to be added in a separate file 
named `app_<LOCALE_CODE>.arb`. To generate the localizations run `flutter pub get`.

To add new entries in the .arb files follow the flutter_localizations documentation. A 
simple entry would look like this (in `app_en.arb`):
```
{
  "helloWorld": "Hello World!",
  "@helloWorld": {
    "description": "The conventional newborn programmer greeting"
  }
} 
```

The the Spanish translation would be located in `app_es.arb` and would look like this:
```
{
    "helloWorld": "¡Hola Mundo!"
}
```

To use the helloWorld text in the app use:
```dart
import 'package:personal_finance_app/utils/extensions/l10n_extension.dart';

@override
Widget build(BuildContext context) {
  return Text(context.l10n.helloWorld);
}
```

NOTE: On iOS to add a new locale update the `CFBundleLocalizations` array in `ios/Runner/Info.plist`.
```xml
<dict>
  ...
  <key>CFBundleLocalizations</key>
  <array>
      <string>en</string>
      <string>es</string>
  </array>
</dict>
```

### Theming 🎨

The app's theme is defined in `lib\utils\style\app_theme.dart`. It is configured to support both 
light and dark mode. To change the color scheme generate new `ColorScheme`s from the 
[Material 3 Builder][material_scheme_builder_link].  

### Logger 📝

The app uses a custom Logger class to log messages. The logger is configured to log messages
to the console and to a file. The Logger can log all types using the `log` method.
```dart
import 'package:personal_finance_app/utils/logger/logger.dart';

void main() {
 Logger.log('Hello World!'); 
}
```

To configure it to use correct outputs use the `init` method during initialization.
```dart
import 'package:personal_finance_app/utils/logger/logger.dart';

void main() {
  Logger.init(logToConsole: true, logToFile: false);
}
```

### Routing

The app has a built in router that uses the Flutter Navigator to move between the pages. To add routing to a page the developer needs to add a page routing abstract class with a static String field _**routePath**_ and a static method _**PageRoute<T> buildRoute<T>**_.

```dart
/// Routing for the ExampleScreen
abstract class ExampleScreenRouting {
  /// Path for the router
  static const String routePath = '/example/page001';

  /// Builder for navigation to screen
  static PageRoute<T> buildRoute<T>({
    RouteSettings? settings,
  }) {
    Logger.log(ExampleScreen);
    return MaterialPageRoute<void>(
      builder: (BuildContext context) => const ExampleScreen(),
      settings: settings,
    ) as PageRoute<T>;
  }
}
```

Once the routing abstract class for the page is implemented, the remaining step is to add the new route to the _PersonalFinanceRouter_. In the _**generateRoute**_ add a new case:

```dart
switch(settings.name){
  // ...
  case ExampleScreenRouting.routePath:
    return ExampleScreenRouting.buildRoute(settings: settings);
  // ...
}
```

To navigate to the newly added screen the developer should use the provided extension of BuildContext.

```dart
context.push(ExampleScreenRouting.routePath);
```

<!-- References -->

[deveji_link]: https://www.deveji.com
[mason_badge]: https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge
[mason_link]: https://github.com/felangel/mason
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[localization_docs]: https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization
[material_scheme_builder_link]: https://m3.material.io/theme-builder