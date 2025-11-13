import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/providers.dart';

/// LoginForm：負責顯示 email/password 欄位與送出按鈕
/// 注意：這個 widget 只處理 UI 與使用者互動（不直接處理登入邏輯）
class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _emailCtrl = TextEditingController();    // email 輸入控制器
  final _passCtrl = TextEditingController();     // password 輸入控制器

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 取得 AuthState（用於顯示 loading / 錯誤 / 已登入資訊）
    final authState = ref.watch(authNotifierProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // email 輸入框
        TextField(
          controller: _emailCtrl,
          decoration: InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
        ),

        // 密碼輸入框
        TextField(
          controller: _passCtrl,
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),

        const SizedBox(height: 12),

        // 錯誤訊息顯示（如果有）
        if (authState.error != null)
          Text(
            authState.error!,
            style: TextStyle(color: Colors.red),
          ),

        const SizedBox(height: 8),

        // 按鈕：根據 isLoading 顯示進度或按鈕
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: authState.isLoading
                ? null
                : () async {
              // 呼叫 notifier 的 login 方法（使用 read(...notifier)）
              await ref.read(authNotifierProvider.notifier).login(
                _emailCtrl.text.trim(),
                _passCtrl.text.trim(),
              );
            },
            child: authState.isLoading
                ? SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
                : Text('Login'),
          ),
        ),
      ],
    );
  }
}