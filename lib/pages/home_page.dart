import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:printer_app/pages/print_text_page.dart';
import 'package:printer_app/screens/loading_screen.dart';
import 'package:printer_app/services/printer_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();
  List<BluetoothInfo> devices = [];

  void initBluetooth() async {
    PrinterServices.handleBluetoothPermission();
    await PrinterServices.getBluetoothDevices().then((value) {
      log("Devices success scanned");
      setState(() => devices = value);
    });
  }

  void refreshBluetoothScan() async {
    setState(() {});
    await PrinterServices.getBluetoothDevices().then((value) {
      log("Refresh scanning");
      setState(() => devices = value);
    });
  }

  @override
  void initState() {
    super.initState();
    initBluetooth();
  }

  Widget bluetoothCheckerWidget() {
    return FutureBuilder(
      future: PrinterServices.bluetoothStatus(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!) {
            return bluetoothOnScreen();
          } else {
            return bluetoothOffScreen();
          }
        } else {
          return const LoadingScreen();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return bluetoothCheckerWidget();
  }

  Widget bluetoothOffScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Please, turn on bluetooth",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: refreshBluetoothScan,
              icon: const Icon(Icons.refresh),
            )
          ],
        ),
      ),
    );
  }

  Widget bluetoothOnScreen() {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text("Bluetooth Printer"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          initBluetooth();
          return Future.value();
        },
        child: FutureBuilder(
          future: PrintBluetoothThermal.connectionStatus,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final bool status = snapshot.data ?? false;
              if (!status) {
                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: devices.length,
                  itemBuilder: (context, index) {
                    final device = devices[index];
                    return ListTile(
                      title: Text(
                        device.name,
                        style: const TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        device.macAdress,
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 12),
                      ),
                      onTap: () => connectDevice(device.macAdress),
                    );
                  },
                );
              } else {
                return const PrintTextPage();
              }
            } else {
              return const LoadingScreen();
            }
          },
        ),
      ),
    );
  }

  void connectDevice(String macAdress) async {
    showLoadingDialog(context);
    PrinterServices.connectToPrinter(macAdress).then((state) {
      Navigator.pop(context);
      if (state) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Successfully connected",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Connection failed!",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      }
    });
  }
}
