import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messages/messages.dart';
import 'package:sync_clash/sync_clash.dart';

final gameStreamProvider = StreamProvider.family
    .autoDispose<SyncedRoom<Game, GameStatus>, String>((ref, id) {
      final provider = ref
          .watch(messageRepositoryProvider)
          .fetchSyncedRoom<Game, GameStatus>(id);

      final timer = Timer.periodic(const Duration(seconds: 1), (_) {
        ref.invalidateSelf();
      });

      ref.onDispose(timer.cancel);

      return provider.asStream();
    });
