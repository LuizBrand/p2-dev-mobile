import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../services/auth_service.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final Stream<Usuario?> _usuarioStream = AuthService().usuarioStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Usuario?>(
      stream: _usuarioStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final usuario = snapshot.data;
        if (usuario == null) {
          return const LoginScreen();
        }
        return HomeScreen(usuario: usuario);
      },
    );
  }
}