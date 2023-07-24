import 'package:flutter/material.dart';

class ManageVehicles extends StatefulWidget {
  const ManageVehicles({Key? key, required List vehicles}) : super(key: key);

  @override
  State<ManageVehicles> createState() => _ManageVehiclesState();
}

class _ManageVehiclesState extends State<ManageVehicles> {
  List<Vehicle> vehicles = [

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage your Vehicles',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
      ),
      body: ListView.builder(
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          final vehicle = vehicles[index];
          return ListTile(
            title: Text(vehicle.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(vehicle.number),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Color.fromRGBO(53, 85, 235, 1)),
              onPressed: () {
                showDeleteConfirmationDialog(context, index);
              },
            ),
          );
        },
      ),
    );
  }

  void addVehicle(String name, String number) {
    setState(() {
      vehicles.add(Vehicle(name: name, number: number));
    });
  }

  void deleteVehicle(int index) {
    setState(() {
      vehicles.removeAt(index);
    });
  }

  Future<void> showDeleteConfirmationDialog(BuildContext context, int index) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Vehicle'),
          content: const Text('Are you sure you want to delete this vehicle?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel',style: TextStyle(color: Colors.red),),
            ),
            TextButton(
              onPressed: () {
                deleteVehicle(index);
                Navigator.of(context).pop();
              },
              child: const Text('Delete',style: TextStyle(color: Color.fromRGBO(53, 85, 235, 1)),),
            ),
          ],
        );
      },
    );
  }
}

class Vehicle {
  final String name;
  final String number;

  Vehicle({required this.name, required this.number});
}

