import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qrcode/screens/home_screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFFAFAFA),
          appBarTheme:  const AppBarTheme(
              titleTextStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white
              ),
              elevation: 0.0),
          primarySwatch: Colors.indigo),
      home: const HomeScreen(),
      builder: EasyLoading.init(),
    );
  }
}
