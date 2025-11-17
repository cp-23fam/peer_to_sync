import 'package:flutter/material.dart';
import 'package:peer_to_sync/src/features/room/presentation/room_list/room_list_screen.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peer to Sync',
      theme: blackTheme,
      home: RoomListScreen(),
      // routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
