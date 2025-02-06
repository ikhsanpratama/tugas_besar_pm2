import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'screens/splash_screen.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);   
  await Supabase.initialize(
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdqcW1rcnpqYXJvb3h6cWVtZ2lmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg3NDE2MzEsImV4cCI6MjA1NDMxNzYzMX0.ZMAU6l0QRpmvbi9ZfLOWh1C-u3mCnTjDlH_Mg2z8euQ",
    url: "https://gjqmkrzjarooxzqemgif.supabase.co",
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: const Color(0xff4C53FB),
            ),
            home: const SplashScreen(),
          );
        });
  }
}
