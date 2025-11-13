import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/error_model.dart';

/// 錯誤狀態
class ErrorState {
  final List<ErrorModel> errors;           // 所有錯誤記錄
  final ErrorModel? latestError;           // 最新錯誤
  final bool showErrorDialog;              // 是否顯示錯誤彈窗

  const ErrorState({
    this.errors = const [],
    this.latestError,
    this.showErrorDialog = false,
  });

  ErrorState copyWith({
    List<ErrorModel>? errors,
    ErrorModel? latestError,
    bool? showErrorDialog,
  }) {
    return ErrorState(
      errors: errors ?? this.errors,
      latestError: latestError ?? this.latestError,
      showErrorDialog: showErrorDialog ?? this.showErrorDialog,
    );
  }

  /// 獲取未上報的錯誤
  List<ErrorModel> get unreportedErrors {
    return errors.where((e) => !e.isReported).toList();
  }

  /// 按嚴重程度統計
  Map<ErrorSeverity, int> get errorCountBySeverity {
    final map = <ErrorSeverity, int>{};
    for (var error in errors) {
      map[error.severity] = (map[error.severity] ?? 0) + 1;
    }
    return map;
  }

  @override
  String toString() => 'ErrorState(total: ${errors.length}, latest: ${latestError?.title})';
}

/// 錯誤 Notifier
class ErrorNotifier extends StateNotifier<ErrorState> {
  ErrorNotifier() : super(const ErrorState());

  /// 記錄錯誤
  void logError({
    required ErrorType type,
    required ErrorSeverity severity,
    required String title,
    required String message,
    String? details,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  }) {
    final error = ErrorModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      severity: severity,
      title: title,
      message: message,
      details: details,
      stackTrace: stackTrace,
      timestamp: DateTime.now(),
      metadata: metadata,
    );

    final newErrors = [error, ...state.errors];

    state = state.copyWith(
      errors: newErrors,
      latestError: error,
      showErrorDialog: _shouldShowDialog(severity),
    );

    print('❌ 錯誤記錄: [$severity] $title - $message');
  }

  /// 從 Exception 記錄錯誤
  void logException(dynamic exception, StackTrace? stackTrace) {
    String title = '系統異常';
    String message = exception.toString();
    ErrorType type = ErrorType.system;

    // 根據異常類型判斷
    if (exception.toString().contains('Socket')) {
      type = ErrorType.network;
      title = '網路異常';
    } else if (exception.toString().contains('Permission')) {
      type = ErrorType.permission;
      title = '權限錯誤';
    }

    logError(
      type: type,
      severity: ErrorSeverity.error,
      title: title,
      message: message,
      stackTrace: stackTrace,
    );
  }

  /// 標記錯誤為已上報
  void markAsReported(String errorId) {
    final updatedErrors = state.errors.map((error) {
      if (error.id == errorId) {
        return error.markAsReported();
      }
      return error;
    }).toList();

    state = state.copyWith(errors: updatedErrors);
    print('✅ 錯誤已上報: $errorId');
  }

  /// 關閉錯誤彈窗
  void dismissErrorDialog() {
    state = state.copyWith(
      showErrorDialog: false,
      latestError: null,
    );
  }

  /// 清空所有錯誤記錄
  void clearAllErrors() {
    state = const ErrorState();
    print('🗑️ 清空所有錯誤記錄');
  }

  /// 刪除單個錯誤
  void deleteError(String errorId) {
    final newErrors = state.errors.where((e) => e.id != errorId).toList();
    state = state.copyWith(errors: newErrors);
    print('🗑️ 刪除錯誤: $errorId');
  }

  /// 判斷是否應該顯示彈窗
  bool _shouldShowDialog(ErrorSeverity severity) {
    // 只有 error 和 fatal 級別才自動彈窗
    return severity == ErrorSeverity.error || severity == ErrorSeverity.fatal;
  }
}

/// Provider 註冊
final errorProvider = StateNotifierProvider<ErrorNotifier, ErrorState>(
      (ref) {
    print('🏗️ ErrorProvider: 正在創建實例');
    return ErrorNotifier();
  },
);