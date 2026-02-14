import 'package:flutter/material.dart';

import '../widgets/auth_form_scaffold.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const AuthFormScaffold(mode: AuthMode.login);
}
