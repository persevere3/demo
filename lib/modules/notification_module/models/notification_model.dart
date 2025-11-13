class NotificationModel {
  final String id;              // 唯一識別碼
  final String title;           // 標題
  final String content;         // 內容
  final bool isRead;            // 是否已讀
  // final DateTime createdAt;     // 建立時間

  const NotificationModel({
    required this.id,
    required this.title,
    required this.content,
    this.isRead = false,
    // required this.createdAt,
  });

  /// copyWith 方法
  NotificationModel copyWith({
    String? id,
    String? title,
    String? content,
    bool? isRead,
    // DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isRead: isRead ?? this.isRead,
      // createdAt: createdAt ?? this.createdAt,
    );
  }

  /// 標記為已讀
  NotificationModel markAsRead() {
    return copyWith(isRead: true);
  }

  @override
  String toString() => 'Notification(id: $id, title: $title, content: $content, isRead: $isRead)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationModel &&
        other.id == id &&
        other.title == title &&
        other.content == content &&
        other.isRead == isRead;
        // other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(id, title, content, isRead);
}