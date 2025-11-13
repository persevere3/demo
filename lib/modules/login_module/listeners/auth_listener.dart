import '../models/user.dart';

/// Abstract listener：模組外的程式可實作這個介面來接收登入/登出事件
/// 好處：模組內部不直接處理外部要做的事情（比如導航、記錄 analytics），由外部實作
abstract class AuthListener {
  /// 當登入成功時呼叫，提供已登入的 User
  void onLogin(User user);

  /// 當登出完成時呼叫
  void onLogout();
}