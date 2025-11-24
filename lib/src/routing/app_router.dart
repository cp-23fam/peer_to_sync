import 'package:go_router/go_router.dart';
import 'package:peer_to_sync/src/features/room/presentation/room_creation/room_creation_screen.dart';
import 'package:peer_to_sync/src/features/room/presentation/room_detail/room_detail_screen.dart';
import 'package:peer_to_sync/src/features/room/presentation/room_list/room_list_screen.dart';
import 'package:peer_to_sync/src/features/user/presentation/user_form/user_creation_screen.dart';
import 'package:peer_to_sync/src/features/user/presentation/user_form/user_login_screen.dart';

enum RouteNames { home, create, detail, signup, user }

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: RouteNames.home.name,
      builder: (context, state) => RoomListScreen(),
    ),
    GoRoute(
      path: '/create',
      name: RouteNames.create.name,
      builder: (context, state) => RoomCreationScreen(),
    ),
    GoRoute(
      path: '/detail/:id',
      name: RouteNames.detail.name,
      builder: (context, state) =>
          RoomDetailScreen(roomId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/user',
      name: RouteNames.user.name,
      builder: (context, state) => UserLoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      name: RouteNames.signup.name,
      builder: (context, state) => UserCreationScreen(),
    ),
  ],
);
