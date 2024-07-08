import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Extension for [BuildContext] to access [AppLocalizations] instance.
extension MediaQuerryX on BuildContext {
  /// Returns [AppLocalizations] instance.
  Size get mediaSize => MediaQuery.of(this).size;
}
