import 'package:flutter/material.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/localization/string_hardcoded.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

class UserCreationScreen extends StatefulWidget {
  const UserCreationScreen({super.key});

  @override
  State<UserCreationScreen> createState() => _UserCreationScreenState();
}

class _UserCreationScreenState extends State<UserCreationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(Sizes.p12),
              child: StyledText(
                'Création d\'utilisateur'.hardcoded,
                38.0,
                bold: true,
                upper: true,
              ),
            ),
            gapH16,
            Padding(
              padding: const EdgeInsets.all(Sizes.p12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    // maxLength: 20,
                    style: TextStyle(color: AppColors.whiteColor),
                    decoration: InputDecoration(
                      fillColor: AppColors.secondColor,
                      labelText: 'Nom d\'utilisateur'.hardcoded,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Sizes.p12),
                      ),
                    ),
                  ),
                  gapH16,
                  TextFormField(
                    // maxLength: 20,
                    style: TextStyle(color: AppColors.whiteColor),
                    decoration: InputDecoration(
                      fillColor: AppColors.secondColor,
                      labelText: 'Adresse mail'.hardcoded,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Sizes.p12),
                      ),
                    ),
                  ),
                  gapH16,
                  TextFormField(
                    // maxLength: 20,
                    obscureText: true,
                    style: TextStyle(color: AppColors.whiteColor),
                    decoration: InputDecoration(
                      fillColor: AppColors.secondColor,
                      labelText: 'Mot de passe'.hardcoded,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Sizes.p12),
                      ),
                    ),
                  ),
                  gapH16,
                  TextFormField(
                    // maxLength: 20,
                    obscureText: true,
                    style: TextStyle(color: AppColors.whiteColor),
                    decoration: InputDecoration(
                      fillColor: AppColors.secondColor,
                      labelText: 'Confirmer le mot de passe'.hardcoded,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Sizes.p12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(height: 60, color: AppColors.navBackgroundColor),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            height: 60,
            width: 180,
            child: FloatingActionButton(
              backgroundColor: AppColors.redColor,
              elevation: 0,
              onPressed: () {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: StyledText('Annuler'.hardcoded, 40.0, bold: true),
            ),
          ),
          gapW16,
          Container(
            margin: const EdgeInsets.only(top: 10),
            height: 60,
            width: 180,
            child: FloatingActionButton(
              backgroundColor: AppColors.greenColor,
              elevation: 0,
              onPressed: () {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: StyledText('Créer'.hardcoded, 40.0, bold: true),
            ),
          ),
        ],
      ),
    );
  }
}
