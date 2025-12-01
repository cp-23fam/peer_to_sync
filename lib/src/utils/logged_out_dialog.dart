import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:peer_to_sync/src/common_widgets/choose_button.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/localization/string_hardcoded.dart';
import 'package:peer_to_sync/src/routing/app_router.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

Future<dynamic> loggedOutDialog(BuildContext context) {
  final colors = Theme.of(context).colorScheme;
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: colors.secondary,
        title: StyledText('Vous n\'êtes pas connecté'.hardcoded, 30.0),
        content: Text(
          'Veuillez d\'abord vous connecter avant de pouvoir utiliser cette fonctionnalitée.'
              .hardcoded,
        ),
        actions: [
          ChooseButton(
            onPressed: () => context.goNamed(RouteNames.user.name),
            text: 'Connexion',
            color: colors.green,
          ),
          ChooseButton(
            color: colors.primary,
            onPressed: () => Navigator.of(context).pop(),
            text: 'OK',
          ),
        ],
      );
    },
  );
}
