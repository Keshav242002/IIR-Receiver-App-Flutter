import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:iir_receiver/Pages/login_screen.dart';
import '../models/authorize_model.dart';
import '../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen';  // Static id for routing
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Dio _dio;

  @override
  void initState() {
    super.initState();
    _initializeDio();
    _authorize();
  }

  void _initializeDio() {
    _dio = Dio();
    _dio.options.baseUrl = kAPIBaseURL;
    _dio.options.connectTimeout = const Duration(milliseconds: 5000);
    _dio.options.receiveTimeout = const Duration(milliseconds: 5000);
  }

  void _authorize() async {
    const String url = 'authorize.php';
    final formData = FormData.fromMap({
      "clientId": "b50699dc2c1aee1cd0abfa75ac14e3ee",
      "clientSecret": "922c67a32613d40f1c5cf84e474d0314",
    });

    try {
      final response = await _dio.post(url, data: formData);
      var authModel = AuthorizeModel.fromJson(response.data);
      if (authModel.status) {
        glbAuthToken = authModel.token;
        _navigateToLogin(authModel.token);
      } else {
        _showAlert(authModel.message);
      }
    } catch (e) {
      _showAlert('Failed to authorize: $e');
    }
  }

  void _navigateToLogin(String token) {
    Navigator.pushReplacementNamed(context, LoginScreen.id, arguments: token);
  }

  void _showAlert(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();  // Dismiss the dialog
                }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50.0),
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Hero(
              tag: 'logo',
              child: SizedBox(
                height: 100,
                child: Image(
                  image: AssetImage('images/IIFLOGO.jpeg'),  // Ensure you have this asset
                ),
              ),
            ),
            Text(
              'IIF RECEIVER',
              style: kHeadingStyle,
            ),

          ],
        ),
      ),
    );
  }
}
