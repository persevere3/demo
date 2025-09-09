import 'dart:convert';
import 'package:flutter/services.dart';

class AppConfig {
  final String appName;
  final String primaryColor;
  final String secondColor;

  // final String logo;
  // final String loading;
  // final String apiBaseUrl;
  // final String defaultLanguage;

  AppConfig({
    required this.appName,
    required this.primaryColor,
    required this.secondColor,
    // required this.logo,
    // required this.loading,
    // required this.apiBaseUrl,
    // required this.defaultLanguage,
  });

  static Future<AppConfig> load(String flavor) async {
    final commonJson = await rootBundle.loadString('assets/config/common.json');
    final flavorJson = await rootBundle.loadString('assets/config/$flavor.json');

    final commonMap = json.decode(commonJson);
    final flavorMap = json.decode(flavorJson);

    return AppConfig(
      appName: flavorMap['appName'],
      primaryColor: flavorMap['primaryColor'],
      secondColor: flavorMap['primaryColor'],
      // logo: flavor['logo'],
      // loading: flavor['loading'],
      // apiBaseUrl: common['apiBaseUrl'],
      // defaultLanguage: common['defaultLanguage'],
    );
  }
}