import 'package:go_router/go_router.dart';
import 'package:peer_to_sync/src/features/room/presentation/room_creation/room_creation_screen.dart';
import 'package:peer_to_sync/src/features/room/presentation/room_detail/room_detail_screen.dart';
import 'package:peer_to_sync/src/features/user/presentation/user_form/user_creation_screen.dart';
import 'package:peer_to_sync/src/nav_screen.dart';

enum RouteNames { home, create, detail, signup }

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: RouteNames.home.name,
      builder: (context, state) => NavScreen(),
    ),
    GoRoute(
      path: '/create',
      name: RouteNames.create.name,
      builder: (context, state) => RoomCreationScreen(),
    ),
    GoRoute(
      path: '/detail',
      name: RouteNames.detail.name,
      builder: (context, state) => RoomDetailScreen(),
    ),
    GoRoute(
      path: '/signup',
      name: RouteNames.signup.name,
      builder: (context, state) => UserCreationScreen(),
    ),
  ],
);
