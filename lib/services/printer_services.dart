import 'dart:developer';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class PrinterServices {
  static void handleBluetoothPermission() async {
    var status = await Permission.bluetoothConnect.status;
    if (status.isDenied) {
      await Permission.bluetoothConnect.request();
    }
  }

  static Future<bool> bluetoothStatus() async {
    final status = await PrintBluetoothThermal.bluetoothEnabled;
    return status;
  }

  static Future<List<BluetoothInfo>> getBluetoothDevices() async {
    var status = await Permission.bluetoothConnect.status;
    if (status.isGranted) {
      final List<BluetoothInfo> listResult =
          await PrintBluetoothThermal.pairedBluetooths;
      log("All bluetooth devices: ${listResult.length}");
      return listResult;
    } else {
      log("Bluetooth permission is failed!");
      handleBluetoothPermission();
      final List<BluetoothInfo> listResult =
          await PrintBluetoothThermal.pairedBluetooths;

      return listResult;
    }
  }

  static Future<bool> connectToPrinter(String mac) async {
    final bool result =
        await PrintBluetoothThermal.connect(macPrinterAddress: mac);
    return result;
  }

  static Future<String> simplePrint(String text, int size) async {
    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      await PrintBluetoothThermal.writeString(
        printText: PrintTextSize(size: size, text: text),
      );

      return "Printing";
    } else {
      return "No connected device";
    }
  }

  Future<String> printBytes(List<int> bytes) async {
    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      await PrintBluetoothThermal.writeBytes(bytes);
      return "Printing";
    }
    return "Connected printer not found";
  }

  static Future<List<int>> printImage(String assetPath) async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    bytes += generator.reset();

    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List bytesImg = data.buffer.asUint8List();
    final image = decodeImage(bytesImg);
    bytes += generator.image(image!);

    return bytes;
  }

  static Future<List<int>> printTextUseStyles() async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    bytes += generator.reset();
    bytes += generator.text(
        'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ',
        styles: const PosStyles());
    bytes += generator.text('Special 1: ñÑ àÀ èÈ éÉ üÜ çÇ ôÔ',
        styles: const PosStyles(codeTable: 'CP1252'));
    bytes += generator.text(
      'Special 2: blåbærgrød',
      styles: const PosStyles(codeTable: 'CP1252'),
    );

    bytes += generator.text('Bold text', styles: const PosStyles(bold: true));
    bytes +=
        generator.text('Reverse text', styles: const PosStyles(reverse: true));
    bytes += generator.text('Underlined text',
        styles: const PosStyles(underline: true), linesAfter: 1);
    bytes += generator.text('Align left',
        styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text('Align center',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Align right',
        styles: const PosStyles(align: PosAlign.right), linesAfter: 1);

    bytes += generator.text(
      'Text size 50%',
      styles: const PosStyles(
        fontType: PosFontType.fontB,
      ),
    );
    bytes += generator.text(
      'Text size 100%',
      styles: const PosStyles(
        fontType: PosFontType.fontA,
      ),
    );
    bytes += generator.text(
      'Text size 200%',
      styles: const PosStyles(
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );

    bytes += generator.row([
      PosColumn(
        text: 'col3',
        width: 3,
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col6',
        width: 6,
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col3',
        width: 3,
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
    ]);

    return bytes;
  }

  Future<List<int>> printQrBarCode() async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    bytes += generator.reset();

    ///Barcode printing
    final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    bytes += generator.barcode(Barcode.upcA(barData));

    ///Qr code printing
    bytes += generator.qrcode('example.com');

    bytes += generator.feed(2);
    return bytes;
  }
}
