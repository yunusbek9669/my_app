class UserInfo {
  final String? id;
  final String pinfl;
  final String full_name;
  final String? middleName;
  final String? birth_date;
  final String? gender;
  final String? phone;
  final String? email;
  final String? address;
  final String? imageUrl;

  UserInfo({
    this.id,
    required this.pinfl,
    required this.full_name,
    this.middleName,
    this.birth_date,
    this.gender,
    this.phone,
    this.email,
    this.address,
    this.imageUrl,
  });

  // JSON'dan object yaratish
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id']?.toString(),
      pinfl: json['pinfl']?.toString() ?? '',
      full_name: json['first_name']?.toString() ??
          json['full_name']?.toString() ??
          'Noma\'lum',
      middleName: json['middle_name']?.toString() ??
          json['middleName']?.toString(),
      birth_date: json['birth_date']?.toString() ??
          json['birth_date']?.toString(),
      gender: json['gender']?.toString(),
      phone: json['phone']?.toString() ??
          json['phone_number']?.toString(),
      email: json['email']?.toString(),
      address: json['address']?.toString(),
      imageUrl: json['photo_url']?.toString() ??
          json['imageUrl']?.toString() ??
          json['photo']?.toString(),
    );
  }

  // Object'ni JSON'ga aylantirish
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pinfl': pinfl,
      'first_name': full_name,
      'middle_name': middleName,
      'birth_date': birth_date,
      'gender': gender,
      'phone': phone,
      'email': email,
      'address': address,
      'photo_url': imageUrl,
    };
  }

  // Copy with
  UserInfo copyWith({
    String? id,
    String? pinfl,
    String? full_name,
    String? middleName,
    String? birth_date,
    String? gender,
    String? phone,
    String? email,
    String? address,
    String? imageUrl,
  }) {
    return UserInfo(
      id: id ?? this.id,
      pinfl: pinfl ?? this.pinfl,
      full_name: full_name ?? this.full_name,
      middleName: middleName ?? this.middleName,
      birth_date: birth_date ?? this.birth_date,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  String toString() {
    return 'UserInfo(pinfl: $pinfl, full_name: $full_name, phone: $phone, email: $email)';
  }
}