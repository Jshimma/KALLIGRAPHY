import 'package:flutter/material.dart';

import '../../services/auth/auth_session.dart';
import 'login_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key, required this.builder});

  final Widget Function(
    BuildContext context,
    AuthSession session,
    VoidCallback logout,
  )
  builder;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  AuthSession? _session;

  void _handleAuthenticated(AuthSession session) {
    setState(() {
      _session = session;
    });
  }

  void _logout() {
    setState(() {
      _session = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = _session;

    if (session == null) {
      return LoginScreen(onAuthenticated: _handleAuthenticated);
    }

    return widget.builder(context, session, _logout);
  }
}
