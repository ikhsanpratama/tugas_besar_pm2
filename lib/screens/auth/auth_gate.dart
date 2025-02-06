// Monitoring auth State

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tugas_besar_pm2/screens/auth/login.dart';
import 'package:tugas_besar_pm2/screens/home.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        // listen auth state change
        stream: Supabase.instance.client.auth.onAuthStateChange,

        // build page berdasarkan auth state
        builder: (context, snapshot) {
          //loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final session = snapshot.hasData ? snapshot.data!.session : null;

          if (session != null) {
            return HomePage();
          } else {
            return const LoginScreen();
          }
        });
  }
}
