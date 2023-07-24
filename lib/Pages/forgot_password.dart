import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:park_qr/Utils/utils.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool isEmailValid = true;
  bool _isSent = false;

  bool validateEmail(String email) {
    if (email.endsWith('@dgvaishnavcollege.edu.in')) {
      String prefix = email.substring(0, email.indexOf('@'));
      return prefix.length == 7;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  fillColor: Colors.transparent,
                  filled: true,
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Color.fromRGBO(53, 85, 235, 1)),
                  hintText: 'Enter your email address',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Color.fromRGBO(53, 85, 235, 1)),
                  ),
                  border: OutlineInputBorder(
                    borderSide: isEmailValid ? BorderSide(color: Colors.grey) : BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Email is required';
                  }
                  final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@dgvaishnavcollege\.edu\.in$');
                  if (!emailRegExp.hasMatch(value)) {
                    return 'Please enter a valid college email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 26.0),
              ElevatedButton(
                onPressed: resetPassword,
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
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Text('Send Password Reset Link'),
                ),
              ),

              const SizedBox(height: 16.0),
              if (_isSent)
                const Text(
                  'Password reset link sent successfully!',
                  style: TextStyle(color: Colors.green),
                ),
              if (!_isSent)
                const Text(
                  'Please enter your email address to receive a password reset link.',
                  style: TextStyle(color: Colors.black),
                ),
              const SizedBox(height: 16.0),
              if (_isSent)
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
                  onPressed: () {
                    // TODO: Implement resend password reset link functionality
                  },
                  child: const Text('Resend Link'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> resetPassword() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
        setState(() {
          _isSent = true;
        });
        Utils.showSnackBar('Password Reset Email sent');
      } on FirebaseAuthException catch (e) {
        print(e);
        Utils.showSnackBar(e.message);
      }
      Navigator.of(context).pop();
    }
  }
}