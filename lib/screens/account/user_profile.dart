import 'package:flutter/material.dart';
import 'user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserService userService = UserService();
  Map<String, dynamic>? userProfile;
  bool isLoading = true;
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    setState(() => isLoading = true);
    final profile = await userService.getUserProfile();
    if (profile != null) {
      setState(() {
        userProfile = profile;
        nameController.text = profile['name'] ?? '';
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> updateProfile() async {
    bool success = await userService.updateUserProfile(nameController.text);
    if (success) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui!')),
      );
      loadUserProfile(); // Refresh profil setelah update
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui profil!')),
      );
    }
  }

  Future<void> deleteAccount() async {
    bool success = await userService.deleteUser();
    if (success) {
      Navigator.pushReplacementNamed(
          // ignore: use_build_context_synchronously
          context,
          '/login'); // Redirect ke login setelah akun dihapus
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus akun!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil User')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userProfile == null
              ? const Center(child: Text("Profil tidak ditemukan"))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(Icons.account_circle,
                          size: 80, color: Colors.blue),
                      const SizedBox(height: 10),
                      Text(
                        userProfile!['email'],
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Nama'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: updateProfile,
                        child: const Text('Perbarui Profil'),
                      ),
                      // const SizedBox(height: 10),
                      // ElevatedButton(
                      //   onPressed: deleteAccount,
                      //   style: ElevatedButton.styleFrom(
                      //       backgroundColor: Colors.red),
                      //   child: const Text('Hapus Akun',
                      //       style: TextStyle(color: Colors.white)),
                      // ),
                    ],
                  ),
                ),
    );
  }
}
