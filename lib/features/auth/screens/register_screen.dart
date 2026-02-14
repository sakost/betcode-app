import 'package:flutter/material.dart';

import '../widgets/auth_form_scaffold.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const AuthFormScaffold(mode: AuthMode.register);
}
