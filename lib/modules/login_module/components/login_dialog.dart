import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/providers.dart';
import 'login_form.dart';

/// LoginDialog：模組提供的一個標準弹窗介面
/// 使用時會包在 ProviderScope 中（在 module 提供的 showLoginDialog 會幫你處理 override）
class LoginDialog extends ConsumerWidget {
  const LoginDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 監聽 auth state（若登入成功可以自動關閉 dialog 等）
    final authState = ref.watch(authNotifierProvider);

    // 如果成功登入（user 不為 null），這裡我們可以自動關閉 Dialog
    // 注意：這是 UI 層決策（模組也可以選擇不自動關閉）
    if (authState.user != null) {
      // pop dialog 並回傳 user 給呼叫方（如果需要）
      // 使用 addPostFrameCallback 確保在 build 後執行 Navigator.pop
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(authState.user);
        }
      });
    }

    return AlertDialog(
      title: const Text('Login'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            // 內含 LoginForm（會使用同一個 ProviderScope）
            LoginForm(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: authState.isLoading
              ? null
              : () {
            Navigator.of(context).pop(); // 取消
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}