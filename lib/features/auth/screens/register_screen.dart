import 'package:betcode_app/features/auth/widgets/auth_form_scaffold.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const AuthFormScaffold(mode: AuthMode.register);
}
