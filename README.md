# Printer App

Printer App — bu Flutter yordamida yaratilgan dastur bo‘lib, u **Bluetooth termal printerlar** bilan ishlash uchun mo‘ljallangan. Ushbu ilova **ESC/POS** printerlari orqali matn, barkod va rasmlar chop etish imkoniyatini beradi.

## 📦 Ishlatilgan paketlar

| Paket | Versiya | Tavsif |
|--------|---------|---------|
| [print_bluetooth_thermal](https://pub.dev/packages/print_bluetooth_thermal) | ^1.1.0 | Bluetooth termal printer bilan ishlash |
| [permission_handler](https://pub.dev/packages/permission_handler) | ^11.3.1 | Ruxsat so‘rash va boshqarish |
| [esc_pos_utils_plus](https://pub.dev/packages/esc_pos_utils_plus) | ^2.0.3 | ESC/POS kodlari yaratish |
| [image](https://pub.dev/packages/image) | ^4.2.0 | Rasmlarni qayta ishlash |

## 📲 O‘rnatish

Dastur kodini klonlash va `pub get` ishlatish:

```sh
git clone https://github.com/USERNAME/printer_app.git
cd printer_app
flutter pub get
```

## 🚀 Foydalanish

1. **Bluetooth printerni ulang**
2. **Ilovada printerni qidirib, ulang**
3. **Matn, barkod yoki rasm chop eting**

## 🛠 Xususiyatlar

✅ **Bluetooth orqali ulanish**
✅ **ESC/POS printer qo‘llab-quvvatlash**
✅ **Matn, barkod va rasmlar chop etish**
✅ **Android va iOS qo‘llab-quvvatlash**

## 📜 Ruxsatlar

Dastur quyidagi ruxsatlardan foydalanadi:

- **Bluetooth ulanishi** → Printerga ulanadi
- **Fayl o‘qish/yozish** → Rasmlarni yuklash

`AndroidManifest.xml` fayliga quyidagilarni qo‘shing:

```xml
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
```

## 📷 Rasm chop etish misoli

```dart
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
...
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

...
```

## 📌 Muammolar

Agar `permission denied` xatosi chiqsa, `permission_handler` sozlamalarini tekshiring va ruxsatlarni qo‘shing.

## 📄 Litsenziya

MIT Litsenziya ostida tarqatiladi. Batafsil ma'lumot uchun `LICENSE` faylini ko'ring.

---

📧 **Aloqa**: Savollaringiz bo‘lsa, [Issues](https://github.com/USERNAME/printer_app/issues) bo‘limida yozib qoldiring!

