import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import 'weather_setting_logic.dart';

class WeatherSettingPage extends GetView<WeatherSettingLogic> {
  Widget _item(int index, BuildContext context) {
    final titles = ['Text palette', 'About US'];
    return Container(
      color: Colors.transparent,
      height: 40,
      child: <Widget>[
        Text(titles[index]),
        index == 0
            ? Container(
                width: 40,
                height: 40,
              ).decorated(
                color: controller.customColor,
                borderRadius: BorderRadius.circular(20))
            : const Text("v1.0.0")
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
    ).gestures(onTap: () {
      switch (index) {
        case 0:
          controller.colorSelect(context);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Setting',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(15),
        child: SafeArea(child: GetBuilder<WeatherSettingLogic>(builder: (_) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                child: <Widget>[_item(0, context), _item(1, context)].toColumn(
                    separator: Divider(
                  height: 15,
                  color: Colors.grey.shade300,
                )),
              ).decorated(
                  color: Colors.white, borderRadius: BorderRadius.circular(12))
            ].toColumn(),
          );
        })),
      ).decorated(
          gradient: const LinearGradient(
              colors: [Color(0xff4f7ffa), Color(0xff335fd1)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight)),
    );
  }
}
