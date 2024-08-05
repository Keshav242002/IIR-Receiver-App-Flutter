import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:iir_receiver/Pages/login_screen.dart';
import 'package:iir_receiver/Pages/service_list.dart';
import './firebase_options.dart';
import 'Pages/Barcode_Scan.dart';
import 'Pages/event_list.dart';
import 'Pages/forget_password.dart';
import 'Pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {



    return MaterialApp(
      title: 'IIF Receiver',
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        ForgotPassword.id: (context) => const ForgotPassword(),
        SelectEvent.id: (context) =>  const SelectEvent(),
        SelectService.id: (context) => const SelectService(),
        BarcodeScannerPage.id:(context) =>  const BarcodeScannerPage(),


      },
      debugShowCheckedModeBanner: false,
    );
  }
}
