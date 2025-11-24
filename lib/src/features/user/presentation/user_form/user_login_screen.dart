import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peer_to_sync/src/common_widgets/choose_button.dart';
import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
import 'package:peer_to_sync/src/constants/app_sizes.dart';
import 'package:peer_to_sync/src/features/user/data/user_repository.dart';
import 'package:peer_to_sync/src/features/user/domain/email_exception.dart';
import 'package:peer_to_sync/src/features/user/domain/password_exception.dart';
import 'package:peer_to_sync/src/localization/string_hardcoded.dart';
import 'package:peer_to_sync/src/routing/app_router.dart';
import 'package:peer_to_sync/src/theme/theme.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String? emailError;
  String? passwordError;

  late final TextEditingController emailTextController;
  late final TextEditingController passwordTextController;

  @override
  void initState() {
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                    'Connexion'.hardcoded,
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: emailTextController,
                      forceErrorText: emailError,
                      validator: (value) {
                        if (EmailValidator.validate(value ?? '')) {
                          return null;
                        }

                        return 'Mail non valide'.hardcoded;
                      },
                      // maxLength: 20,
                      style: TextStyle(color: AppColors.whiteColor),
                      decoration: InputDecoration(
                        fillColor: AppColors.secondColor,
                        labelText:
                            'Adresse mail / Nom d\'utilisateur'.hardcoded,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Sizes.p4),
                        ),
                      ),
                    ),
                    gapH16,
                    TextFormField(
                      controller: passwordTextController,
                      forceErrorText: passwordError,
                      // maxLength: 20,
                      obscureText: true,
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
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        height: 48,
                        width: 250,
                        child: FloatingActionButton(
                          backgroundColor: AppColors.fourthColor,
                          elevation: 0,
                          onPressed: () {
                            context.goNamed(RouteNames.signup.name);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: StyledText(
                            'Créer un utilisateur'.hardcoded,
                            20.0,
                            bold: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
                  context.goNamed(RouteNames.home.name);
                },
              ),
              gapW16,
              Consumer(
                builder: (context, ref, child) {
                  return ChooseButton(
                    text: 'Connexion',
                    color: AppColors.greenColor,
                    onPressed: () async {
                      setState(() {
                        passwordError = null;
                        emailError = null;
                      });

                      if (_formKey.currentState!.validate()) {
                        try {
                          await ref
                              .read(userRepositoryProvider)
                              .logIn(
                                emailTextController.text,
                                passwordTextController.text,
                              );

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            context.goNamed(RouteNames.home.name);
                          });
                        } on EmailException {
                          setState(() {
                            emailError = 'Email inconnu'.hardcoded;
                          });
                        } on PasswordException {
                          setState(() {
                            passwordError = 'Mot de passe invalide'.hardcoded;
                          });
                        } catch (error) {
                          rethrow;
                        }
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
