/// User 資料模型（純資料結構）
/// 這個檔案只負責描述使用者資料，不包含登入邏輯
class User {
  final String id;        // 使用者唯一 id
  final String name;      // 顯示名稱
  final String email;     // 電子郵件

  // 建構子：必須提供 id, name, email
  User({required this.id, required this.name, required this.email});

  // 工具：從 Map 建構（方便未來接 API 回傳時使用）
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }

  // 輔助：轉為 Map（方便存 local 或序列化）
  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'email': email};
}