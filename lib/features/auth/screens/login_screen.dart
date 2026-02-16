import 'package:betcode_app/features/auth/widgets/auth_form_scaffold.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const AuthFormScaffold(mode: AuthMode.login);
}
