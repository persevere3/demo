import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'listeners/auth_listener.dart';
import 'provider/providers.dart';
import 'components/login_dialog.dart';

/// LoginModule：模組的入口檔（提供一個簡單的 API 給外部使用）
class LoginModule {
  /// showLoginDialog：
  ///  - context：需要一個 BuildContext
  ///  - listeners：可選，傳入一組 AuthListener 讓呼叫方在登入成功/登出時收到通知
  ///  - serviceOverride：可選，若需在呼叫方替換 AuthService（例如換成實際 Api 實作），可傳入 ProviderOverride
  ///
  /// 回傳值：
  ///  - 當使用者登入成功時，此 dialog 會 pop(user)，所以回傳值為 User 或 null（取消）
  static Future<dynamic> showLoginDialog(
      BuildContext context, {
        List<AuthListener>? listeners,
        List<Override>? overrides,
      }) {
    // 準備 provider overrides：將外部傳入的 listeners 注入到 authListenersProvider
    final _overrides = <Override>[
      if (listeners != null) authListenersProvider.overrideWithValue(listeners),
      if (overrides != null) ...overrides, // 允許呼叫方同時傳入其他 overrides（例如換 service 實作）
    ];

    // 在本地建立一個 ProviderScope，避免影響到 App 的全域 ProviderScope
    // 並將 overrides 注入（這樣 dialog 內會使用我們覆寫過的 providers）
    return showDialog(
      context: context,
      builder: (ctx) => ProviderScope(
        overrides: _overrides,
        child: const LoginDialog(),
      ),
    );
  }
}