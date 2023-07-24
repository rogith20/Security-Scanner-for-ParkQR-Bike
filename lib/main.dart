import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:park_qr/Pages/homepage.dart';
import 'package:park_qr/Pages/onboarding.dart';
import 'Utils/auth_page.dart';
import 'Pages/verify_email.dart';
import 'Utils/utils.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(fontFamily: 'Poppins'), //create dark theme
    home: HomeScreen(),
    scaffoldMessengerKey: messengerKey,
    navigatorKey: navigatorKey,
  ));
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!'));
          } else if (snapshot.hasData) {
            return const VerifyEmailPage();
          } else {
            return AuthPage();
          }
        },
      ),
    );
  }
}

int mode=0; //mode? Colors.black : Colors.white

