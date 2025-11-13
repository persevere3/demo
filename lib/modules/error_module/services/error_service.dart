import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/error_providers.dart';
import '../models/error_model.dart';
import '../components/error_dialog.dart';
import '../../../core/services/navigation_service.dart';

/// 錯誤服務介面
abstract class IErrorService {
  void logError({
    required ErrorType type,
    required ErrorSeverity severity,
    required String title,
    required String message,
    String? details,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  });

  void logException(dynamic exception, StackTrace? stackTrace);
  void showErrorDialog();
  void showErrorHistory();
  Future<void> reportError(String errorId);
  void clearErrors();
}

/// 錯誤服務實作
class ErrorService implements IErrorService {
  final Ref _ref;

  ErrorService(this._ref);

  @override
  void logError({
    required ErrorType type,
    required ErrorSeverity severity,
    required String title,
    required String message,
    String? details,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  }) {
    _ref.read(errorProvider.notifier).logError(
      type: type,
      severity: severity,
      title: title,
      message: message,
      details: details,
      stackTrace: stackTrace,
      metadata: metadata,
    );
  }

  @override
  void logException(dynamic exception, StackTrace? stackTrace) {
    _ref.read(errorProvider.notifier).logException(exception, stackTrace);
  }

  @override
  void showErrorDialog() {
    final context = NavigationService.currentContext;
    if (context == null) {
      print('❌ Context 不可用，無法顯示錯誤彈窗');
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const ErrorDialog(),
    );
  }

  @override
  void showErrorHistory() {
    final context = NavigationService.currentContext;
    if (context == null) return;

    showDialog(
      context: context,
      builder: (context) => const ErrorHistoryDialog(),
    );
  }

  @override
  Future<void> reportError(String errorId) async {
    print('📡 上報錯誤: $errorId');

    try {
      // 模擬上報到後端或第三方服務（如 Sentry, Firebase Crashlytics）
      await Future.delayed(const Duration(seconds: 1));

      // 這裡可以實作實際的上報邏輯
      // await http.post('/api/errors', body: errorData);
      // await FirebaseCrashlytics.instance.recordError(error, stackTrace);

      _ref.read(errorProvider.notifier).markAsReported(errorId);
      print('✅ 錯誤上報成功');
    } catch (e) {
      print('❌ 錯誤上報失敗: $e');
    }
  }

  @override
  void clearErrors() {
    _ref.read(errorProvider.notifier).clearAllErrors();
  }
}

final errorServiceProvider = Provider<IErrorService>(
      (ref) {
    print('🔧 ErrorServiceProvider: 正在創建實例');
    return ErrorService(ref);
  },
);