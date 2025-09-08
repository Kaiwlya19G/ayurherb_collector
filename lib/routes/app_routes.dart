import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/phone_authentication/phone_authentication.dart';
import '../presentation/qr_code_display/qr_code_display.dart';
import '../presentation/new_collection_entry/new_collection_entry.dart';
import '../presentation/collection_history/collection_history.dart';
import '../presentation/collection_dashboard/collection_dashboard.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String phoneAuthentication = '/phone-authentication';
  static const String qrCodeDisplay = '/qr-code-display';
  static const String newCollectionEntry = '/new-collection-entry';
  static const String collectionHistory = '/collection-history';
  static const String collectionDashboard = '/collection-dashboard';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    phoneAuthentication: (context) => const PhoneAuthentication(),
    qrCodeDisplay: (context) => const QrCodeDisplay(),
    newCollectionEntry: (context) => const NewCollectionEntry(),
    collectionHistory: (context) => const CollectionHistory(),
    collectionDashboard: (context) => const CollectionDashboard(),
    // TODO: Add your other routes here
  };
}
