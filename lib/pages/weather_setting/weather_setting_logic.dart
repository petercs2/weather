import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:styled_widget/styled_widget.dart';

class WeatherSettingLogic extends GetxController {
  Color customColor = Get.arguments;

  void colorSelect(BuildContext context) {
    var currentColor = customColor;
    showDialog(
        context: context,
        builder: (b) {
          return AlertDialog(
              title: const Text('Select Color'),
              content: GetBuilder<WeatherSettingLogic>(
                  id: 'color',
                  builder: (_) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ColorPicker(
                        pickerColor: currentColor,
                        colorPickerWidth: 240,
                        onColorChanged: (color) {
                          currentColor = color;
                          update(['color']);
                        },
                      ),
                    );
                  }),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black45),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    customColor = currentColor;
                    update(['color']);
                    update();
                    Get.back();
                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString('color', customColor.toHexString());
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ]);
        });
  }

  aboutWeatherUS(BuildContext context) async {
    var info = await PackageInfo.fromPlatform();
    showAboutDialog(
      applicationName: info.appName,
      applicationVersion: info.version,
      applicationIcon: Image.asset(
        'assets/launcher.webp',
        width: 76,
        height: 76,
      ),
      children: [
        const Text("""We can provide you with time"""),
      ],
      context: context,
    );
  }
}
