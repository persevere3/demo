import 'package:flutter/material.dart';
import 'package:demo/app.dart';
import 'package:demo/config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = await AppConfig.load('app1');
  runApp(MyApp(config));
}