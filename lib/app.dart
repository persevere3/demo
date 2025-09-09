import 'package:flutter/material.dart';
import 'config/app_config.dart';
import 'pages/home.dart';

class MyApp extends StatelessWidget {
  final AppConfig config;

  const MyApp(this.config, {super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(int.parse(config.primaryColor.replaceFirst('#', '0xFF')));
    return MaterialApp(
      title: config.appName,
      theme: ThemeData(primarySwatch: createMaterialColor(primaryColor)),
      home: HomeScreen(config: config),
    );
  }

  MaterialColor createMaterialColor(Color color) {
    return MaterialColor(color.value, {
      50: color.withOpacity(.1),
      100: color.withOpacity(.2),
      200: color.withOpacity(.3),
      300: color.withOpacity(.4),
      400: color.withOpacity(.5),
      500: color.withOpacity(.6),
      600: color.withOpacity(.7),
      700: color.withOpacity(.8),
      800: color.withOpacity(.9),
      900: color.withOpacity(1),
    });
  }
}