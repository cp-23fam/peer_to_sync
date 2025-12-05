import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peer_to_sync/src/common_widgets/choose_button.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/features/room/data/room_repository.dart';
import 'package:peer_to_sync/src/features/room/domain/room.dart';
import 'package:peer_to_sync/src/localization/string_hardcoded.dart';
import 'package:peer_to_sync/src/routing/app_router.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

Future<dynamic> privateRoomDialog(BuildContext context, Room room) {
  final colors = Theme.of(context).colorScheme;
  String password = '';
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: colors.secondary,
        title: StyledText('Mot de passe'.hardcoded, 30.0),
        content: TextFormField(
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              return null;
            }

            return 'Veuillez entrer un mot de passe'.hardcoded;
          },
          style: TextStyle(color: colors.onSurface),
          decoration: InputDecoration(
            fillColor: colors.secondary,
            labelText: 'Mot de passe de la salle'.hardcoded,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Sizes.p4),
            ),
          ),
          onChanged: (value) {
            password = value;
          },
        ),
        actions: [
          ChooseButton(
            color: colors.error,
            onPressed: () => Navigator.of(context).pop(),
            text: 'Annuler',
          ),
          Consumer(
            builder: (context, ref, child) {
              return ChooseButton(
                onPressed: () async {
                  if (room.password == password) {
                    await ref
                        .read(roomRepositoryProvider)
                        .joinRoom(room.id, password: password);

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.goNamed(
                        RouteNames.detail.name,
                        pathParameters: {'id': room.id},
                      );
                    });
                  }
                },
                text: 'Confirmer',
                color: colors.green,
              );
            },
          ),
        ],
      );
    },
  );
}
