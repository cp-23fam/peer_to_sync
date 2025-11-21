import 'package:flutter/material.dart';
import 'package:peer_to_sync/src/routing/app_router.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Peer to Sync',
      theme: blackTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
