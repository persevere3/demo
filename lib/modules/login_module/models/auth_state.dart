import 'user.dart';

/// AuthState：描述登入狀態（這個 state 會被 AuthNotifier 管理）
/// 把 loading / user / error 都包在一起，UI 透過這個物件顯示對應畫面
class AuthState {
  final bool isLoading;    // 是否在執行登入/登出等操作
  final User? user;        // 已登入的使用者，null 表示未登入
  final String? error;     // 發生錯誤時的訊息

  // 建構子 - 預設為未登入且非 loading
  AuthState({this.isLoading = false, this.user, this.error});

  // 初始值的工廠方法
  factory AuthState.initial() => AuthState(isLoading: false, user: null, error: null);

  // copyWith：不可變模型的更新模式
  AuthState copyWith({bool? isLoading, User? user, String? error}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }
}