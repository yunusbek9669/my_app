class UserInfo {
  final String username;
  final String imageUrl;
  final String fullName;
  final String department;
  final String position;
  final String title;
  final String phone;

  final Map<String, dynamic>? token;

  UserInfo(this.username, this.imageUrl, this.fullName, this.department, this.position, this.title, this.phone, this.token);

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      json['username'],
      json['imageUrl'],
      json['fullName'],
      json['department'],
      json['position'],
      json['title'],
      json['phone'],
      json['token'] as Map<String, dynamic>?,
    );
  }
}