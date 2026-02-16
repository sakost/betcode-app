import 'package:betcode_app/core/auth/auth.dart';
import 'package:betcode_app/core/grpc/grpc_providers.dart';
import 'package:betcode_app/core/grpc/relay_config.dart';
import 'package:betcode_app/core/grpc/service_providers.dart';
import 'package:betcode_app/generated/betcode/v1/auth.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Whether the auth form is used for login or registration.
enum AuthMode { login, register }

/// Shared scaffold for both the login and register screens.
///
/// The two screens are ~90% identical: same relay-config section, same
/// username/password fields, same submit flow. The only differences are:
///   - Register shows an additional email field.
///   - Different RPC (login vs register).
///   - Different button / link text.
class AuthFormScaffold extends ConsumerStatefulWidget {
  const AuthFormScaffold({required this.mode, super.key});

  final AuthMode mode;

  @override
  ConsumerState<AuthFormScaffold> createState() => _AuthFormScaffoldState();
}

class _AuthFormScaffoldState extends ConsumerState<AuthFormScaffold> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _relayHostController = TextEditingController();
  final _relayPortController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _useTls = true;
  bool _relayInitialized = false;

  bool get _isLogin => widget.mode == AuthMode.login;

  void _initRelayFields() {
    if (_relayInitialized) return;
    _relayInitialized = true;

    final current = ref.read(relayConfigNotifierProvider);
    if (current != null) {
      _relayHostController.text = current.host;
      _relayPortController.text = current.port.toString();
      _useTls = current.useTls;
    } else {
      final defaults = ref.read(relayDefaultsProvider);
      if (defaults.host.isNotEmpty) {
        _relayHostController.text = defaults.host;
      }
      _relayPortController.text = defaults.port.toString();
      _useTls = defaults.useTls;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _relayHostController.dispose();
    _relayPortController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Build relay config from form values
      final relayConfig = RelayConfig(
        host: _relayHostController.text.trim(),
        port: int.tryParse(_relayPortController.text.trim()) ?? 0,
        useTls: _useTls,
      );

      // Connect to relay if not already connected with same config
      final currentRelay = ref.read(relayConfigNotifierProvider);
      if (currentRelay == null || currentRelay != relayConfig) {
        try {
          await ref
              .read(relayConfigNotifierProvider.notifier)
              .connectTo(relayConfig);
        } on Exception catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Relay connection failed: $e'),
              ),
            );
          }
          return;
        }
      }

      final authClient = ref.read(authServiceProvider);

      if (_isLogin) {
        final response = await authClient.login(
          LoginRequest(
            username: _usernameController.text.trim(),
            password: _passwordController.text,
          ),
        );

        await ref
            .read(authNotifierProvider.notifier)
            .setTokens(
              accessToken: response.accessToken,
              refreshToken: response.refreshToken,
              userId: response.userId,
              expiresInSecs: response.expiresInSecs.toInt(),
            );
      } else {
        final response = await authClient.register(
          RegisterRequest(
            username: _usernameController.text.trim(),
            password: _passwordController.text,
            email: _emailController.text.trim(),
          ),
        );

        await ref
            .read(authNotifierProvider.notifier)
            .setTokens(
              accessToken: response.accessToken,
              refreshToken: response.refreshToken,
              userId: response.userId,
              expiresInSecs: response.expiresInSecs.toInt(),
            );
      }
    } on Exception catch (e) {
      if (mounted) {
        final label = _isLogin ? 'Login' : 'Registration';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _initRelayFields();
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.code, size: 64, color: theme.colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    'BetCode',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isLogin
                        ? 'Sign in to your account'
                        : 'Create your account',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ExpansionTile(
                    leading: const Icon(Icons.dns_outlined),
                    title: const Text('Relay Server'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: TextFormField(
                          controller: _relayHostController,
                          decoration: const InputDecoration(
                            labelText: 'Host',
                            prefixIcon: Icon(Icons.language),
                            border: OutlineInputBorder(),
                          ),
                          textInputAction: TextInputAction.next,
                          autocorrect: false,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Relay host is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: TextFormField(
                          controller: _relayPortController,
                          decoration: const InputDecoration(
                            labelText: 'Port',
                            prefixIcon: Icon(Icons.numbers),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Port is required';
                            }
                            final port = int.tryParse(value.trim());
                            if (port == null || port < 1 || port > 65535) {
                              return 'Port must be between 1 and 65535';
                            }
                            return null;
                          },
                        ),
                      ),
                      SwitchListTile(
                        title: const Text('Use TLS'),
                        value: _useTls,
                        onChanged: (value) {
                          setState(() => _useTls = value);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    validator: (value) {
                      if (value == null || value.trim().length < 3) {
                        return 'Username must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                  if (!_isLogin) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      validator: (value) {
                        if (value == null || !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                    ),
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_isLogin ? 'Login' : 'Register'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () => context.go(_isLogin ? '/register' : '/login'),
                    child: Text(
                      _isLogin
                          ? "Don't have an account? Register"
                          : 'Already have an account? Login',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
