import 'dart:async';
import '../models/user.dart';

/// 定義 AuthService 的抽象介面（interface）
/// 這樣上層只依賴介面，不依賴具體實作（利於測試與替換）
abstract class IAuthService {
  /// 嘗試以 email/password 登入；成功回傳 User，失敗丟出 Exception
  Future<User> login(String email, String password);

  /// 登出：清除本地 token 或 session（這裡為示範）
  Future<void> logout();
}

/// FakeAuthService：一個簡單的記憶體/模擬實作，用於開發或測試
class FakeAuthService implements IAuthService {
  // 模擬一個使用者資料庫（通常會向網路呼叫）
  final Map<String, String> _fakeUsers = {
    // email: password
    'alice@example.com': 'password123',
    'bob@example.com': 'abc123',
  };

  @override
  Future<User> login(String email, String password) async {
    // 模擬網路延遲
    await Future.delayed(const Duration(milliseconds: 600));

    // 驗證
    final valid = _fakeUsers[email];
    if (valid != null && valid == password) {
      // 模擬回傳 User
      return User(id: DateTime.now().millisecondsSinceEpoch.toString(), name: email.split('@')[0], email: email);
    }

    // 驗證失敗：拋出 Exception（Notifier 會捕捉並轉為錯誤訊息）
    throw Exception('Invalid credentials');
  }

  @override
  Future<void> logout() async {
    // 模擬清理工作（例如清除 local token）
    await Future.delayed(const Duration(milliseconds: 200));
    return;
  }
}