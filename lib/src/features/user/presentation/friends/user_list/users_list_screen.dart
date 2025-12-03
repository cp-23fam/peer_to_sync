import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/features/user/data/user_repository.dart';
import 'package:peer_to_sync/src/features/user/presentation/friends/user_list/user_to_add_card.dart';
import 'package:peer_to_sync/src/localization/string_hardcoded.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          gapH8,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p12),
            child: TextField(
              style: TextStyle(color: colors.onSurface),
              decoration: InputDecoration(
                hintText: 'Rechercher un utilisateur...',
                hintStyle: TextStyle(color: colors.onSurface.withAlpha(150)),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Sizes.p4),
                ),
                fillColor: colors.primary,
              ),
              onChanged: (value) {
                // setState(() => _searchQuery = value.toLowerCase());
              },
            ),
          ),
          gapH12,
          StyledText('28 Utilisateurs', 20.0),
          gapH12,

          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final usersData = ref.watch(usersProvider);
                return usersData.when(
                  data: (users) {
                    return users.isEmpty
                        ? Center(
                            child: StyledText(
                              'Aucune demande d\'ami trouvée.'.hardcoded,
                              20.0,
                            ),
                          )
                        : ListView.separated(
                            itemBuilder: (context, index) =>
                                UserToAddCard(user: users[index]!),
                            separatorBuilder: (context, index) => gapH16,
                            itemCount: users.length,
                          );
                  },
                  error: (error, st) => Center(child: Text(error.toString())),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
