import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:park_qr/Utils/utils.dart';

import '../main.dart';

class SignupPage extends StatefulWidget {
  final Function() onClickedSignIn;

  const SignupPage({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);


  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool isEmailValid = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _password;
  String? _confirmPassword;
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
    });
  }

  bool isFormValid() {
    return isEmailValid &&
        _password != null &&
        _password!.isNotEmpty &&
        _confirmPassword != null &&
        _confirmPassword!.isNotEmpty;
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
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Text(
                'Let\'s get you in',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _emailController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Email is required';
                  }
                  final RegExp emailRegExp =
                  RegExp(r'^[a-zA-Z\d.]+@[a-zA-Z\d]+\.[a-zA-Z]+');
                  if (!emailRegExp.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  suffixIcon: isEmailValid
                      ? const Icon(Icons.check_circle_rounded,
                          color: Colors.green)
                      : const Icon(Icons.error, color: Colors.red),
                  labelText: 'College mail ID',
                  labelStyle:
                      const TextStyle(color: Color.fromRGBO(53, 85, 235, 1)),
                  hintText: 'example@dgvaishnavcollege.edu.in',
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
                  setState(() {}); // To update the UI after email validation
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _passwordController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Create password',
                  labelStyle: const TextStyle(color: Color.fromRGBO(53, 85, 235, 1)),
                  hintText: 'Shush! Don\'t say it out',
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
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Password is required';
                  }
                  if (value.length < 6) {
                    return 'Password should be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _confirmPasswordController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Confirm password',
                  labelStyle: const TextStyle(color: Color.fromRGBO(53, 85, 235, 1)),
                  hintText: 'Once more...',
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
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    child: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                  ),
                ),
                obscureText: _obscureConfirmPassword,
                onChanged: (value) {
                  setState(() {
                    _confirmPassword = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Confirm password is required';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),
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
                      return isFormValid() ? const Color.fromRGBO(53, 85, 235, 1) : Colors.grey; // Enabled color
                    },
                  ),
                ),
                onPressed: signUp, // Call the signUp function when the button is pressed
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Sign up',
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
  Future signUp() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }
}
