import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_state.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../listeners/auth_listener.dart';

/// AuthNotifier：狀態/業務邏輯層
/// ----------------------------------
/// 繼承（extends）：
///   - StateNotifier<AuthState> （這是 Riverpod 提供的基底類別）
///
/// 依賴（depends on）：
///   - IAuthService （透過建構子注入，表示 notifier 依賴資料邏輯層）
///   - List<AuthListener> （可選，供外部接收登入/登出事件）
///
/// 責任：
///   - 暴露 login/logout 等業務方法
///   - 管理 AuthState（包含 isLoading / user / error）
class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthService _service;            // 依賴：Auth service（資料邏輯）
  final List<AuthListener> _listeners;    // 依賴：外部 listeners（事件回呼）

  // 建構子：將 service 與 listeners 注入進來
  AuthNotifier(this._service, this._listeners) : super(AuthState.initial());

  /// login：執行登入流程
  Future<void> login(String email, String password) async {
    // 更新為 loading 狀態，清除前次錯誤
    state = state.copyWith(isLoading: true, error: null);

    try {
      // 呼叫資料邏輯層：service.login
      final user = await _service.login(email, password);

      // 成功 -> 更新 state 並通知外部 listener
      state = state.copyWith(isLoading: false, user: user, error: null);

      // 通知每個 listener（注意：listener 的實作是在模組外）
      for (final l in _listeners) {
        try {
          l.onLogin(user);
        } catch (_) {
          // 忍受 listener 的錯誤，防止影響主流程
        }
      }
    } catch (e) {
      // 發生例外 -> 更新錯誤訊息並關閉 loading
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// logout：執行登出
  Future<void> logout() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _service.logout();
      state = state.copyWith(isLoading: false, user: null, error: null);

      // 通知 listeners
      for (final l in _listeners) {
        try {
          l.onLogout();
        } catch (_) {}
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// clearError：輔助方法，讓 UI 可以清掉顯示的錯誤訊息
  void clearError() {
    state = state.copyWith(error: null);
  }
}