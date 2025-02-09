import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final SupabaseClient supabase = Supabase.instance.client;

  // 🔹 1. Ambil Profil User Berdasarkan ID
  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    final response = await supabase
        .from('users')
        .select('id, name, email, role')
        .eq('id', user.id)
        .maybeSingle();

    return response ?? {};
  }

  // 🔹 2. Perbarui Profil User
  Future<bool> updateUserProfile(String name) async {
    final user = supabase.auth.currentUser;
    if (user == null) return false;

    final response = await supabase
        .from('users')
        .update({'name': name})
        .eq('id', user.id)
        .select();

    return response.isNotEmpty;
  }

  // 🔹 3. Hapus Akun User
  Future<bool> deleteUser() async {
    final user = supabase.auth.currentUser;
    if (user == null) return false;

    // Hapus dari tabel users
    await supabase.from('users').delete().eq('id', user.id);

    // Hapus akun dari autentikasi Supabase
    await supabase.auth.signOut();

    return true;
  }
}
