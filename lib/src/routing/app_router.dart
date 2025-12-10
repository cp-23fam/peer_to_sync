import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:messages/messages.dart';
import 'package:peer_to_sync/src/features/room/presentation/room_creation/room_creation_screen.dart';
import 'package:peer_to_sync/src/features/room/presentation/room_detail/room_detail_screen.dart';
import 'package:peer_to_sync/src/features/room/presentation/room_list/room_list_screen.dart';
import 'package:peer_to_sync/src/features/user/data/user_repository.dart';
import 'package:peer_to_sync/src/features/user/presentation/friends/nav/friends_nav_screen.dart';
import 'package:peer_to_sync/src/features/user/presentation/user_form/user_creation_screen.dart';
import 'package:peer_to_sync/src/features/user/presentation/user_form/user_login_screen.dart';
import 'package:peer_to_sync/src/features/user/presentation/user_form/user_update_screen.dart';
import 'package:peer_to_sync/src/features/user/presentation/user_settings/user_settings_screen.dart';

enum RouteNames { home, create, detail, signup, user, edit, friends, inside }

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
      path: '/in/:id',
      name: RouteNames.inside.name,
      builder: (context, state) => Consumer(
        builder: (context, ref, child) {
          final roomData = ref.watch(
            syncedFutureProvider(state.pathParameters['id']!),
          );
          return roomData.when(
            data: (room) => room!.widget,
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, st) => Center(child: Text(error.toString())),
          );
        },
      ),
    ),
    GoRoute(
      path: '/user',
      name: RouteNames.user.name,
      builder: (context, state) {
        final scope = ProviderScope.containerOf(
          context,
          listen: false,
        ).read(userRepositoryProvider);

        return FutureBuilder(
          future: scope.fetchCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data == null) {
              return UserLoginScreen();
            } else {
              // ? Should be build using a User parameter
              return UserSettingsScreen();
            }
          },
        );
      },
    ),
    GoRoute(
      path: '/signup',
      name: RouteNames.signup.name,
      builder: (context, state) => UserCreationScreen(),
    ),
    GoRoute(
      path: '/edit',
      name: RouteNames.edit.name,
      builder: (context, state) => UserUpdateScreen(),
    ),
    GoRoute(
      path: '/friends',
      name: RouteNames.friends.name,
      builder: (context, state) => FriendsNavScreen(),
    ),
  ],
);
