/// 錯誤類型枚舉
enum ErrorType {
  network,      // 網路錯誤
  business,     // 業務邏輯錯誤
  system,       // 系統錯誤
  permission,   // 權限錯誤
  validation,   // 驗證錯誤
  unknown,      // 未知錯誤
}

/// 錯誤嚴重程度
enum ErrorSeverity {
  info,         // 資訊
  warning,      // 警告
  error,        // 錯誤
  fatal,        // 致命錯誤
}

/// 錯誤模型
class ErrorModel {
  final String id;                    // 唯一識別碼
  final ErrorType type;               // 錯誤類型
  final ErrorSeverity severity;       // 嚴重程度
  final String title;                 // 錯誤標題
  final String message;               // 錯誤訊息
  final String? details;              // 詳細資訊
  final StackTrace? stackTrace;       // 堆疊追蹤
  final DateTime timestamp;           // 發生時間
  final bool isReported;              // 是否已上報
  final Map<String, dynamic>? metadata; // 額外資料

  const ErrorModel({
    required this.id,
    required this.type,
    required this.severity,
    required this.title,
    required this.message,
    this.details,
    this.stackTrace,
    required this.timestamp,
    this.isReported = false,
    this.metadata,
  });

  ErrorModel copyWith({
    String? id,
    ErrorType? type,
    ErrorSeverity? severity,
    String? title,
    String? message,
    String? details,
    StackTrace? stackTrace,
    DateTime? timestamp,
    bool? isReported,
    Map<String, dynamic>? metadata,
  }) {
    return ErrorModel(
      id: id ?? this.id,
      type: type ?? this.type,
      severity: severity ?? this.severity,
      title: title ?? this.title,
      message: message ?? this.message,
      details: details ?? this.details,
      stackTrace: stackTrace ?? this.stackTrace,
      timestamp: timestamp ?? this.timestamp,
      isReported: isReported ?? this.isReported,
      metadata: metadata ?? this.metadata,
    );
  }

  /// 標記為已上報
  ErrorModel markAsReported() {
    return copyWith(isReported: true);
  }

  @override
  String toString() => 'ErrorModel(id: $id, type: $type, severity: $severity, title: $title)';
}