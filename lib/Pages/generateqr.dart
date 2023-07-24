import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQR extends StatefulWidget {
  const GenerateQR({Key? key}) : super(key: key);

  @override
  State<GenerateQR> createState() => _GenerateQRState();
}

double getSize(BuildContext context, double size) {
  double sizeFinal = (MediaQuery.of(context).size.width / (7.8 * 50)) * size;
  return sizeFinal;
}

class _GenerateQRState extends State<GenerateQR> {
  TextEditingController nameController = TextEditingController();
  TextEditingController rollnoController = TextEditingController();
  TextEditingController bikeController = TextEditingController();
  TextEditingController vehicleController = TextEditingController();
  String? name;

  @override
  void dispose() {
    nameController.dispose();
    rollnoController.dispose();
    bikeController.dispose();
    vehicleController.dispose();
    super.dispose();
  }

  int selectedGridIndex = 0;

  String selectedYear = 'I';
  List<String> years = ['I', 'II', 'III'];

  String selectedDepartment = 'B.C.A';
  List<String> departments = [
    'B.C.A',
    'B.Sc.',
    'B.com.',
    'B.A',
    'M.C.A.',
    'M.B.A.',
    // ...
  ];

  String selectedsection = 'A';
  List<String> sections = ['A', 'B', 'C'];

  bool isFormValid() {
    if (selectedGridIndex < 3) {
      return name != null &&
          rollnoController.text.isNotEmpty &&
          nameController.text.isNotEmpty &&
          bikeController.text.isNotEmpty &&
          vehicleController.text.isNotEmpty &&
          selectedYear.isNotEmpty &&
          selectedDepartment.isNotEmpty &&
          selectedsection.isNotEmpty;
    }
    return false;
  }

  bool areAllGridsFilled() {
    return nameController.text.isNotEmpty &&
        rollnoController.text.isNotEmpty &&
        bikeController.text.isNotEmpty &&
        vehicleController.text.isNotEmpty &&
        selectedYear.isNotEmpty &&
        selectedDepartment.isNotEmpty &&
        selectedsection.isNotEmpty;
  }

  String QRData(String name, String rollno, String bikeModel,
      String vehicleNumber, String year, String department, String section) {
    return 'Student name: $name\nRollno: $rollno\nBike Model: $bikeModel\nVehicle Number: $vehicleNumber\nYear: $year\n**Department: $department**\nSection: $section';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            getAppBarTitle(selectedGridIndex),
            style: const TextStyle(color: Colors.black),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
            child: Column(
              children: [
                if (selectedGridIndex == 0)
                  buildStudentDetailsWidget()
                else if (selectedGridIndex == 1)
                  buildBikeInfoWidget()
                else if (selectedGridIndex == 2)
                  buildDepartmentDetailsWidget(),
                if (WidgetsBinding.instance.window.viewInsets.bottom > 0.0)
                  SizedBox(
                    height: MediaQuery.of(context).viewInsets.bottom - 180,
                  )
                else
                  SizedBox(
                    height: MediaQuery.of(context).viewInsets.bottom +
                        MediaQuery.of(context).size.height / 2.5,
                  ),
                Container(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.1,
                      mainAxisSpacing: 16.0,
                      crossAxisSpacing: 20.0,
                    ),
                    padding: const EdgeInsets.all(16.0),
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      IconData icon;
                      String text;
                      Color backgroundColor;
                      Color borderColor;
                      Color iconColor;
                      Color textColor;
                      if (index == selectedGridIndex) {
                        backgroundColor = Colors.transparent;
                        borderColor = const Color.fromRGBO(53, 85, 235, 1);
                        iconColor = const Color.fromRGBO(53, 85, 235, 1);
                        textColor = const Color.fromRGBO(53, 85, 235, 1);
                      } else {
                        backgroundColor = const Color(0xFFF2F4FF);
                        borderColor = const Color(0xFFF2F4FF);
                        iconColor = const Color(0xFF666791);
                        textColor = const Color(0xFF666791);
                      }
                      if (index == 0) {
                        icon = Icons.person;
                        text = 'Student';
                      } else if (index == 1) {
                        icon = Icons.directions_bike;
                        text = 'Bike';
                      } else {
                        icon = Icons.school;
                        text = 'Department';
                      }
                      return GridItem(
                        icon: icon,
                        text: text,
                        backgroundColor: backgroundColor,
                        borderColor: borderColor,
                        iconColor: iconColor,
                        textColor: textColor,
                        onTap: () {
                          setState(() {
                            selectedGridIndex = index;
                          });
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(15.0),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        isFormValid() && areAllGridsFilled()
                            ? const Color.fromRGBO(53, 85, 235, 1)
                            : Colors.grey,
                      ),
                    ),
                    onPressed: isFormValid() && areAllGridsFilled()
                        ? () {
                            // Generate QR code
                            String qrData = QRData(
                              nameController.text,
                              rollnoController.text,
                              bikeController.text,
                              vehicleController.text,
                              selectedYear,
                              selectedDepartment,
                              selectedsection,
                            );
                            if (qrData.isNotEmpty) {
                              // Show dialog box with QR code
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('QR Code'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text('Your QR has been created:'),
                                        const SizedBox(height: 10),
                                        QrImageView(
                                          data: qrData,
                                          version: QrVersions.auto,
                                          size: 200.0,
                                        ),
                                        const SizedBox(
                                          width: double.infinity,
                                        )
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        : null,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Generate QR',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildStudentDetailsWidget() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Enter your name',
              labelStyle: TextStyle(color: Color.fromRGBO(53, 85, 235, 1)),
              hintText: 'What should we call you?',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(53, 85, 235, 1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            onChanged: (value) {
              setState(() {
                name = value;
              });
            },
            textCapitalization: TextCapitalization
                .words, // Capitalize first letter of each word
            inputFormatters: [
              TextInputFormatter.withFunction((oldValue, newValue) {
                if (newValue.text.isNotEmpty) {
                  return TextEditingValue(
                    text: newValue.text
                        .split(' ')
                        .map((word) =>
                            word.substring(0, 1).toUpperCase() +
                            word.substring(1))
                        .join(' '),
                    selection: newValue.selection,
                  );
                }
                return newValue;
              }),
            ],
          ),
          const SizedBox(height: 40),
          TextFormField(
            controller: rollnoController,
            decoration: const InputDecoration(
              labelText: 'Enter your roll no.',
              labelStyle: TextStyle(color: Color.fromRGBO(53, 85, 235, 1)),
              hintText: 'Roll no.',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(53, 85, 235, 1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            onChanged: (value) {},
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }

  Widget buildBikeInfoWidget() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          TextFormField(
            controller: bikeController,
            decoration: const InputDecoration(
              labelText: 'Enter your bike model',
              labelStyle: TextStyle(color: Color.fromRGBO(53, 85, 235, 1)),
              hintText: 'Eg: Royal Enfield Classic 350',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(53, 85, 235, 1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            onChanged: (value) {
              setState(() {
                name = value;
              });
            },
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            inputFormatters: [
              TextInputFormatter.withFunction((oldValue, newValue) {
                if (newValue.text.isNotEmpty) {
                  return TextEditingValue(
                    text: newValue.text
                        .split(' ')
                        .map((word) =>
                            word.substring(0, 1).toUpperCase() +
                            word.substring(1))
                        .join(' '),
                    selection: newValue.selection,
                  );
                }
                return newValue;
              }),
            ],
          ),
          const SizedBox(height: 40),
          TextFormField(
            controller: vehicleController,
            decoration: const InputDecoration(
              labelText: 'Vehicle number',
              labelStyle: TextStyle(color: Color.fromRGBO(53, 85, 235, 1)),
              hintText: 'Eg: TN 18 AB 1234',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(53, 85, 235, 1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            onChanged: (value) {
              setState(() {
                vehicleController.text = value.toUpperCase();
                vehicleController.selection = TextSelection.fromPosition(
                  TextPosition(offset: vehicleController.text.length),
                );
              });
            },
          )
        ],
      ),
    );
  }

  Widget buildDepartmentDetailsWidget() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            children: [
              Flexible(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Select Year',
                    labelStyle:
                        TextStyle(color: Color.fromRGBO(53, 85, 235, 1)),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(53, 85, 235, 1)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  value: selectedYear,
                  onChanged: (value) {
                    setState(() {
                      selectedYear = value!;
                    });
                  },
                  items: years.map((String department) {
                    return DropdownMenuItem<String>(
                      value: department,
                      child: Text(department),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Select Department',
                    labelStyle:
                        TextStyle(color: Color.fromRGBO(53, 85, 235, 1)),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(53, 85, 235, 1)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  value: selectedDepartment,
                  onChanged: (value) {
                    setState(() {
                      selectedDepartment = value!;
                    });
                  },
                  items: departments.map((String department) {
                    return DropdownMenuItem<String>(
                      value: department,
                      child: Text(department),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Select Section',
                    labelStyle:
                        TextStyle(color: Color.fromRGBO(53, 85, 235, 1)),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(53, 85, 235, 1)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  value: selectedsection,
                  onChanged: (value) {
                    setState(() {
                      selectedsection = value!;
                    });
                  },
                  items: sections.map((String department) {
                    return DropdownMenuItem<String>(
                      value: department,
                      child: Text(department),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          SizedBox(
            height: getSize(context, 73)
          )
        ],
      ),
    );
  }
}

String getAppBarTitle(int gridIndex) {
  if (gridIndex == 0) {
    return 'Student details';
  } else if (gridIndex == 1) {
    return 'Bike Info';
  } else if (gridIndex == 2) {
    return 'Your Department';
  }
  return 'Generate QR';
}

class GridItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color textColor;
  final VoidCallback onTap;

  const GridItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.textColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor),
          color: backgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 25.0,
              color: iconColor,
            ),
            const SizedBox(height: 5.0),
            Text(
              text,
              style: TextStyle(fontSize: 12.0, color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
