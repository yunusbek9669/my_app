class User {
  final String username;
  final String imageUrl;
  final String fullName;
  final String department;
  final String position;
  final String title;
  final String phone;

  User(this.username, this.imageUrl, this.fullName, this.department, this.position, this.title, this.phone);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['username'],
      json['imageUrl'],
      json['fullName'],
      json['department'],
      json['position'],
      json['title'],
      json['phone'],
    );
  }
}