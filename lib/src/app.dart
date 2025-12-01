import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:peer_to_sync/src/routing/app_router.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      initial: AdaptiveThemeMode.system,
      light: lightTheme,
      dark: darkTheme,
      builder: (light, dark) => MaterialApp.router(
        title: 'Peer to Sync',
        theme: light,
        darkTheme: dark,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
