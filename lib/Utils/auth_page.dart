import 'package:flutter/material.dart';
import 'package:park_qr/Pages/login.dart';
import 'package:park_qr/Pages/signup.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) =>
      isLogin ? LoginPage(onClickedSignup: toggle) : SignupPage(onClickedSignIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
