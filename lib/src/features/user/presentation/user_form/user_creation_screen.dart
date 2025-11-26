import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peer_to_sync/src/common_widgets/choose_button.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/features/user/data/user_repository.dart';
import 'package:peer_to_sync/src/localization/string_hardcoded.dart';
import 'package:peer_to_sync/src/routing/app_router.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

class UserCreationScreen extends StatefulWidget {
  const UserCreationScreen({super.key});

  @override
  State<UserCreationScreen> createState() => _UserCreationScreenState();
}

class _UserCreationScreenState extends State<UserCreationScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController usernameTextController;
  late final TextEditingController emailTextController;
  late final TextEditingController passwordTextController;
  late final TextEditingController confirmTextController;

  @override
  void initState() {
    usernameTextController = TextEditingController();
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
    confirmTextController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    usernameTextController.dispose();
    emailTextController.dispose();
    passwordTextController.dispose();
    confirmTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: 80,
                padding: const EdgeInsets.all(Sizes.p12),
                color: AppColors.navBackgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StyledText(
                      'Création d\'utilisateur'.hardcoded,
                      30.0,
                      bold: true,
                      upper: true,
                    ),
                  ],
                ),
              ),
              gapH16,
              Padding(
                padding: const EdgeInsets.all(Sizes.p12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: usernameTextController,
                      maxLength: 35,
                      validator: (value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            value.length <= 35) {
                          return null;
                        }

                        return 'Nom d\'utilisateur non valide'.hardcoded;
                      },
                      style: TextStyle(color: AppColors.whiteColor),
                      decoration: InputDecoration(
                        fillColor: AppColors.secondColor,
                        labelText: 'Nom d\'utilisateur'.hardcoded,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Sizes.p4),
                        ),
                      ),
                    ),
                    gapH4,
                    TextFormField(
                      controller: emailTextController,
                      validator: (value) {
                        if (EmailValidator.validate(value ?? '')) {
                          return null;
                        }

                        return 'Mail non valide'.hardcoded;
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: AppColors.whiteColor),
                      decoration: InputDecoration(
                        fillColor: AppColors.secondColor,
                        labelText: 'Adresse mail'.hardcoded,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Sizes.p4),
                        ),
                      ),
                    ),
                    gapH16,
                    TextFormField(
                      controller: passwordTextController,
                      // maxLength: 20,
                      obscureText: true,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          return null;
                        }

                        return 'Veuillez entrer un mot de passe'.hardcoded;
                      },
                      style: TextStyle(color: AppColors.whiteColor),
                      decoration: InputDecoration(
                        fillColor: AppColors.secondColor,
                        labelText: 'Mot de passe'.hardcoded,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Sizes.p4),
                        ),
                      ),
                    ),
                    gapH16,
                    TextFormField(
                      controller: confirmTextController,
                      // maxLength: 20,
                      obscureText: true,
                      validator: (value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            value == passwordTextController.text) {
                          return null;
                        }

                        return 'Le mot de passe fourni est différent'.hardcoded;
                      },
                      style: TextStyle(color: AppColors.whiteColor),
                      decoration: InputDecoration(
                        fillColor: AppColors.secondColor,
                        labelText: 'Confirmer le mot de passe'.hardcoded,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Sizes.p4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ClipRRect(
        child: Container(
          height: 64,
          color: AppColors.navBackgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChooseButton(
                text: 'Annuler',
                color: AppColors.redColor,
                onPressed: () {
                  context.goNamed(RouteNames.user.name);
                },
              ),
              gapW16,
              Consumer(
                builder: (context, ref, child) {
                  return ChooseButton(
                    text: 'Créer',
                    color: AppColors.greenColor,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await ref
                            .read(userRepositoryProvider)
                            .signUp(
                              usernameTextController.text,
                              emailTextController.text,
                              passwordTextController.text,
                            );

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          context.goNamed(RouteNames.home.name);
                        });
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
