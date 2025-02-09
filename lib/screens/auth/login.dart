import 'package:flutter/material.dart';
import 'package:tugas_besar_pm2/screens/auth/auth_service.dart';
import 'package:tugas_besar_pm2/screens/auth/register.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //AuthService
  final authService = AuthService();
  //Text Controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // Login Button Pressed
  void _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email & Password tidak boleh kosong")));
      return;
    }
    // login attempt
    try {
      await authService.signInEmailPassword(email, password);
    }

    //catch error
    catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error : $e")));
      }
    }
  }

  // @override
  // void dispose() {
  //   _emailController.dispose();
  //   _passwordController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent overlay
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50.h,
                ),
                const Center(
                    child: Text(
                  "IT INVENTORY MOBILE",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                )),
                SizedBox(
                  height: 20.h,
                ),
                Center(
                    child: Image.asset(
                  "assets/inventory.png",
                  fit: BoxFit.cover,
                  height: 250,
                  width: 400,
                  alignment: Alignment.center,
                )),
                SizedBox(
                  height: 20.h,
                ),
                Card(
                  color: Colors.transparent,
                  borderOnForeground: true,
                  elevation: 10,
                  child: Column(
                    children: [
                      TextFormField(
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        controller: _emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          hintText: 'Email',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 193, 212, 221),
                              fontStyle: FontStyle.italic),
                          prefixIcon: const Icon(Icons.email_outlined,
                              color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextFormField(
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        controller: _passwordController,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          hintText: 'Password',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 193, 212, 221),
                              fontStyle: FontStyle.italic),
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Colors.blue,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Center(
                    child: ElevatedButton.icon(
                  onPressed: _login,
                  icon:
                      const Icon(Icons.verified_outlined, color: Colors.white),
                  label: const Text(
                    'M A S U K',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    backgroundColor: Colors.blueAccent,
                    minimumSize: const Size(double.infinity, 10),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                )),
                SizedBox(
                  height: 20.h,
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen())),
                  child: const Center(
                    child: Text(
                      "belum punya akun ? daftar di sini",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
