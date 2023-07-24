import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:park_qr/Pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool darkModeEnabled = false; // Declare and initialize the variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Center(
              child: Text(
                "Name",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 60),
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4FF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: ListTile(
                    title: const Text(
                      "Switch to Dark mode",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(53, 85, 235, 1),
                      ),
                    ),
                    // trailing: Switch(
                    //   value: darkModeEnabled,
                    //   onChanged: (value) {
                    //     setState(() {
                    //       darkModeEnabled = value; // Update the variable on switch change
                    //     });
                    //   },
                    //   activeColor: Color.fromRGBO(53, 85, 235, 1), // Set the active color
                    // ),
                    trailing: Padding(
                      padding: const EdgeInsets.all(10),
                      //padding: const EdgeInsets.only(right: 20.0),
                      child: LiteRollingSwitch(
                        value: false,
                        width: 80,
                        colorOn: const Color.fromRGBO(53, 85, 235, 1),
                        colorOff: Colors.grey,
                        iconOn: Icons.dark_mode,
                        iconOff: Icons.sunny,
                        onDoubleTap: () {},
                        onChanged: (bool position) {
                          print("The button is $position");
                        },
                        onTap: () {},
                        onSwipe: () {},
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                print('Logged Out');
                FirebaseAuth.instance.signOut().then((value) => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) =>
                                  LoginPage(onClickedSignup: () {})))
                    });
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(
                    child: Text(
                  'Log Out',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                )),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: MediaQuery.of(context).size.height / 2.19,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4FF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    const Text(
                      'About',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                      'Maecenas maximus augue id elit ultrices varius. '
                      'Vestibulum ut nibh quis est venenatis semper. '
                      'Pellentesque a bibendum felis, sed auctor ligula. '
                      'Nam semper eleifend risus, in sollicitudin lectus convallis non. '
                      'Nulla sed iaculis mi. Nulla facilisi.',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 80),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/dummy_logo.png'),
                        const SizedBox(width: 10),
                        const Text('X'),
                        const SizedBox(width: 10),
                        Image.asset('assets/dgvc_logo.png')
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Initiative by \n   DDGDVC',
                      style: TextStyle(fontWeight: FontWeight.w300),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
