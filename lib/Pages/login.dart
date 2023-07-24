import 'package:flutter/material.dart';
import 'package:park_qr/Pages/forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:park_qr/Pages/homepage.dart';
import 'package:park_qr/Pages/onboarding.dart';
import 'package:park_qr/Utils/utils.dart';

import '../main.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onClickedSignup;

  const LoginPage({
    Key? key,
    required this.onClickedSignup,
  })  : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isEmailValid = true;
  bool _obscurePassword = true;
  String? _password;
  bool isFormValid = false;

  bool validateEmail(String email) {
    if (email.endsWith('@dgvaishnavcollege.edu.in')) {
      String prefix = email.substring(0, email.indexOf('@'));
      return prefix.length == 7;
    }
    return false;
  }

  void validateInput() {
    setState(() {
      isEmailValid = validateEmail(_emailController.text);
      isFormValid = isEmailValid && _password != null && _password!.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const OnboardingScreen()));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Text(
                'Welcome back',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 100),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  suffixIcon: isEmailValid
                      ? const Icon(Icons.check_circle_rounded,
                          color: Colors.green)
                      : const Icon(Icons.error, color: Colors.red),
                  labelText: 'College mail ID',
                  labelStyle:
                      const TextStyle(color: Color.fromRGBO(53, 85, 235, 1)),
                  hintText: 'rollno@dgvaishnavcollege.edu.in',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(53, 85, 235, 1)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: isEmailValid ? Colors.grey : Colors.red,
                    ),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                onChanged: (value) {
                  validateInput();
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Color.fromRGBO(53, 85, 235, 1)),
                  hintText: 'Hope you remember it',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(53, 85, 235, 1)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    child: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                  ),
                ),
                obscureText: _obscurePassword,
                onChanged: (value) {
                  setState(() {
                    _password = value;
                    validateInput();
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPassword(),
                      ),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color.fromRGBO(53, 85, 235, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      height: 1,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all<double>(15.0),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey; // Disabled color
                      }
                      return const Color.fromRGBO(53, 85, 235, 1); // Enabled color
                    },
                  ),
                ),
                onPressed: signIn,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pop(context); // Dismiss the progress indicator
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen()));
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
      Navigator.pop(context); // Dismiss the progress indicator
    }
  }
}
