import 'package:flutter/material.dart';
import 'package:printer_app/screens/loading_screen.dart';
import 'package:printer_app/services/printer_services.dart';

class PrintTextPage extends StatefulWidget {
  const PrintTextPage({super.key});

  @override
  State<PrintTextPage> createState() => _PrintTextPageState();
}

class _PrintTextPageState extends State<PrintTextPage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Enter text for print",
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: printText,
            child: const Text("Print"),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: printText,
            child: const Text("Print"),
          ),
        ],
      ),
    );
  }

  void printText() async {
    showLoadingDialog(context);
    PrinterServices.simplePrint(controller.text.trim(), 12).then((state) {
      Navigator.pop(context);
      if (state == "Printing") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              state,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              state,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    });
  }
}
