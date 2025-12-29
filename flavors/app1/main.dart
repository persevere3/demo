import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo/app.dart';
import 'package:demo/config/app_config.dart';
import 'package:demo/providers/configProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = await AppConfig.load('app1');

  runApp(
    ProviderScope(       // 用 ProviderScope 包裹應用
      overrides: [
        configProvider.overrideWithValue(config), // 將 config 注入 Provider
      ],
      child: MyApp(),
    ),
  );
}