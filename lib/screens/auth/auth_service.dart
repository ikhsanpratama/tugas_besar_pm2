import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  //sign in email + password
  Future<AuthResponse> signInEmailPassword(
      String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  //register
  Future<AuthResponse> signUpEmailPassword(
      String email, String password) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  //logout
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // get user
  String? getUserEmail() {
    final session = _supabase.auth.currentUser;
    final useremail  = session?.email;        
    return useremail;
  } 

  Future<String?> getUserName() async {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
      if (user == null) return null;
      
      final response = await _supabase
          .from('users')
          .select('name')
          .eq('id', user.id)
          .single();
      return response['name'] as String?;
  } 

  Future<String?> getUserRole() async {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
      if (user == null) return null;
      
      final response = await _supabase
          .from('users')
          .select('role')
          .eq('id', user.id)
          .single();
      return response['role'] as String?;
  } 

}
