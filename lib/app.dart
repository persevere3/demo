import 'package:flutter/material.dart';
import 'package:demo/extensions/widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo/providers/configProvider.dart';
import 'package:demo/router/router.dart';

// ✅ 模組相關 import
import '../core/managers/module_manager.dart';
import '../core/services/navigation_service.dart';
import '../modules/dialog_module/dialog_module.dart';
import '../modules/notification_module/notification_module.dart';
import '../modules/error_module/error_module.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _modulesInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeModules();
  }

  /// 只執行一次的模組初始化
  void _initializeModules() {
    if (_modulesInitialized) return;

    try {
      print('🌟 開始初始化模組 (一次性)');

      // 註冊模組
      ModuleManager.registerModule(DialogModule());
      ModuleManager.registerModule(NotificationModule());
      ModuleManager.registerModule(ErrorModule());
      print('✅ 所有模組註冊完成');

      // 測試監聽器
      final listeners = ModuleManager.globalListeners;
      print('📡 全局監聽器數量: ${listeners.length}');

      _modulesInitialized = true;
      print('🎉 模組初始化完成');

    } catch (e, stackTrace) {
      print('❌ 模組初始化失敗: $e');
      print('Stack trace: $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configProvider);
    final primaryColor = config.primaryColor.toColor();

    return MaterialApp(
      // ✅ 使用 NavigationService 的 navigatorKey
      navigatorKey: NavigationService.navigatorKey,

      routes: AppRouter.routes,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: '/',
      title: config.appName,

      // ✅ 實際使用模組監聽器
      builder: (context, child) {
        if (!_modulesInitialized) {
          return child!; // 模組未初始化時，只顯示原始內容
        }

        return Stack(
          children: [
            child!, // 原始應用內容
            // ✅ 載入所有模組的全局監聽器
            ...ModuleManager.globalListeners,
          ],
        );
      },

      theme: ThemeData(
        tabBarTheme: TabBarThemeData(
          labelColor: primaryColor,
          unselectedLabelColor: Colors.black54,
          indicatorColor: primaryColor,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black26),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          labelStyle: TextStyle(color: primaryColor),
        ),

        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.green;
            }
            return Colors.white;
          }),
          side: BorderSide(color: Colors.black26, width: 2),
          checkColor: WidgetStateProperty.all(Colors.white),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor.lighten(0.4),
            foregroundColor: primaryColor.darken(0.2),
          ),
        ),

        dialogTheme: DialogThemeData(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),

        textButtonTheme:  TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: primaryColor.lighten(0.4),
            foregroundColor: primaryColor.darken(0.2),
          ),
        ),

        filledButtonTheme:  FilledButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: primaryColor.lighten(0.4),
            foregroundColor: primaryColor.darken(0.2),
          ),
        ),

        // DatePicker ==================================================
        datePickerTheme: DatePickerThemeData(
          // 一般「被選取」的日期（非今天）
          dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return primaryColor;
            return Colors.transparent;
          }),
          dayForegroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return Colors.white;
            return null;
          }),

          // 「今天」這一格（currentDate）
          todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
            // 如果今天也被選取，讓它跟 selected 一樣吃 primary
            if (states.contains(WidgetState.selected)) return primaryColor;
            // 今天未選取：透明（只留邊框/字色）
            return Colors.transparent;
          }), // todayBackgroundColor 在 DatePickerThemeData 內有定義
          todayForegroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return Colors.white;
            return primaryColor; // 今天未選取：字色用主色
          }), // todayForegroundColor 在 DatePickerThemeData 內有定義
          todayBorder: const BorderSide(width: 1.5), // BorderSide.color 會被忽略
        ),

        timePickerTheme: TimePickerThemeData(
          dialHandColor: primaryColor,          // 指針/中心圓點顏色
          dialBackgroundColor: Colors.white,    // 錶面背景

          // 這些會影響時間盤面與 AM/PM 切換塊的主色系
          hourMinuteTextColor: Colors.white,
          hourMinuteColor: primaryColor,
          dayPeriodTextColor: Colors.white,
          dayPeriodColor: primaryColor, // AM/PM 塊背景
        ),
      ),
    );
  }
}

