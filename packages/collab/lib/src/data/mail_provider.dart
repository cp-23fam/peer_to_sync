import 'dart:async';

import 'package:collab/collab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messages/messages.dart';

final syncedStreamProvider = StreamProvider.family
    .autoDispose<SyncedRoom<Mail, bool>, String>((ref, id) {
      var provider = ref
          .watch(messageRepositoryProvider)
          .fetchSyncedRoom<Mail, bool>(id);

      final timer = Timer.periodic(const Duration(seconds: 1), (_) {
        ref.invalidateSelf();
      });

      ref.onDispose(timer.cancel);

      return provider.asStream();
    });
