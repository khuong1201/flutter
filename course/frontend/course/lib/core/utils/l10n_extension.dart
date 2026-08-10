import 'package:course/core/error/failures.dart';
import 'package:course/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

extension L10nExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  String getFailureMessage(Failure failure) {
    final localization = l10n;
    switch (failure.messageKey) {
      case 'errorServer':
        return localization.errorServer;
      case 'errorCache':
        return localization.errorCache;
      case 'errorNetwork':
        return localization.errorNetwork;
      case 'errorInvalidCredentials':
        return localization.errorInvalidCredentials;
      case 'errorUserExists':
        return localization.errorUserExists;
      case 'errorBadRequest':
        return localization.errorBadRequest;
      case 'errorUnauthorized':
        return localization.errorUnauthorized;
      case 'errorUnknown':
      default:
        return localization.errorUnknown;
    }
  }
}