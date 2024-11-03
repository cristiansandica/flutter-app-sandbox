import 'package:flutter/material.dart';
import 'package:flutter_app/pages/weather_page.dart';
import 'package:flutter_app/services/auth_service.dart';

import '../components/custom_button.dart';
import '../components/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    final authService = AuthService();
    try {
      await authService.signInWithEmailPassword(
          emailController.text, passwordController.text);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WeatherPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }
  }

  void googleAuth() async {
    final authService = AuthService();
    try {
      await authService.signInWithGoogle();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WeatherPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Icon(
                  Icons.lock_open_rounded,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  size: 80,
                ),
                const SizedBox(height: 50),
                Text(
                  'Welcome',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                CustomTextField(
                    controller: emailController, placeholder: "Email"),
                const SizedBox(height: 10),
                CustomTextField(
                    controller: passwordController, placeholder: "Password"),
                const SizedBox(height: 25),
                CustomButton(onTap: login, text: "Login", isGoogleAuth: false),
                const SizedBox(height: 25),
                const Text("Or Sign In with"),
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: googleAuth,
                  child: Image.asset(
                    'assets/google_signin.png',
                    width: 200,
                    height: 50,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
