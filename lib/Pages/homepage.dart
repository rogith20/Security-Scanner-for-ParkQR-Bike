import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:park_qr/Pages/generateqr.dart';
import 'package:park_qr/Pages/manage_vehicles.dart';
import 'package:park_qr/Pages/settings.dart';
import 'package:park_qr/Pages/tutorial.dart';
import 'package:park_qr/Pages/viewqr.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController pageController;
  int pageNo = 0;
  late final Timer carouselTimer;
  String name = '';

  Timer getTimer() {
    return Timer.periodic(const Duration(seconds: 3), (timer) {
      if (pageNo == 4) {
        pageNo = 0;
      }
      pageController.animateToPage(pageNo,
          duration:  const Duration(seconds: 1), curve: Curves.easeInOutCirc);
      pageNo++;
    });
  }

  @override
  void initState() {
    pageController = PageController(initialPage: 0, viewportFraction: 0.85);
    carouselTimer = getTimer();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, $name',
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            getGreetingMessage(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => const Settings()));
                          },
                          child: Image.asset(
                            'assets/setting.png',
                            width: 30,
                            height: 30,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 190,
                    child: PageView.builder(
                      controller: pageController,
                      onPageChanged: (index) {
                        pageNo = index;
                        setState(() {});
                      },
                      itemBuilder: (_, index) {
                        String imagePath = 'assets/slider${index + 1}.png';
                        return GestureDetector(
                          // Here
                          child: Container(
                            //padding: EdgeInsets.all(16),
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.all(2),
                            child: Image.asset(imagePath,fit: BoxFit.fitWidth,),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.5),
                            ),
                          ),
                        );
                      },
                      itemCount: 4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          4,
                          (index) => Container(
                                margin: const EdgeInsets.all(3),
                                child: Icon(
                                  Icons.circle,
                                  size: 12,
                                  color: pageNo == index
                                      ? const Color.fromRGBO(53, 85, 235, 1)
                                      : Colors.grey,
                                ),
                              ))),
                  const SizedBox(height: 15),
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F4FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => const GenerateQR()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    SvgPicture.asset('assets/add_vehicle.svg')),
                            const Text(
                              'Add Vehicle',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(53, 85, 235, 1)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F4FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => const ManageVehicles(vehicles: [],)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                    'assets/manage_vehicle.svg')),
                            const Text(
                              'Manage your Vehicles',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(53, 85, 235, 1)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F4FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.asset(
                                        'assets/fakeqr_popup.png',
                                        height: 150,
                                        width: 250,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Sorry, but we have a strict "nope" policy here',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Close',
                                    style: TextStyle(
                                      color: Color.fromRGBO(53, 85, 235, 1),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset('assets/fake_qr.svg')),
                            const Text(
                              'Make a fake QR',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(53, 85, 235, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F4FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => const ViewQR()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset('assets/view_qr.svg')),
                            const Text(
                              'View your QRs',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(53, 85, 235, 1)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F4FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => const Tutorial()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset('assets/help.svg')),
                            const Text(
                              'How it works',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(53, 85, 235, 1)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  String getGreetingMessage() {
    DateTime now = DateTime.now();
    int currentHour = now.hour;
    String greetingMessage = '';

    if (currentHour >= 0 && currentHour < 12) {
      greetingMessage = 'Good Morning';
    } else if (currentHour >= 12 && currentHour < 16) {
      greetingMessage = 'Good Afternoon';
    } else if (currentHour >= 16 && currentHour < 20) {
      greetingMessage = 'Good Evening';
    } else {
      greetingMessage = 'Good Night';
    }

    return greetingMessage;
  }
}
