import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../listeners/auth_listener.dart';
import 'auth_notifier.dart';
import '../models/auth_state.dart';

/// Provider 定義檔（DI 層）
/// 這裡把 module 裡需要的 provider 都放這個檔案管理

/// 1) authServiceProvider
///    - 類型：Provider<IAuthService>
///    - 用途：提供一個 IAuthService 的實例（默認回傳 FakeAuthService）
final authServiceProvider = Provider<IAuthService>((ref) {
  // 預設使用 Fake 實作；在整合時可以 override 為 ApiAuthService 等
  return FakeAuthService();
});

/// 2) authListenersProvider
///    - 類型：Provider<List<AuthListener>>
///    - 用途：提供一組 listener（預設為空清單）
///    - 好處：外部可在 ProviderScope 的 overrides 中放入自己的 listeners
final authListenersProvider = Provider<List<AuthListener>>((ref) {
  return const []; // 預設沒有 listener
});

/// 3) authNotifierProvider
///    - 類型：StateNotifierProvider<AuthNotifier, AuthState>
///    - 用途：建立 AuthNotifier 並對外暴露 AuthState（UI 會 watch 這個 provider）
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  // 依賴注入：從 DI 層讀取 service 與 listeners
  final svc = ref.watch(authServiceProvider);           // 依賴：IAuthService
  final listeners = ref.watch(authListenersProvider);   // 依賴：List<AuthListener>

  // 建立 AuthNotifier（此處為註冊與生命周期管理）
  return AuthNotifier(svc, listeners);
});