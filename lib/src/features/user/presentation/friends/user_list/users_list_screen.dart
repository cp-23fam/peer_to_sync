import 'package:flutter/material.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';

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
        ],
      ),
    );
  }
}
