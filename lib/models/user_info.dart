class UserInfo {
  final String? id;
  final String pinfl;
  final String fullName;
  final String? middleName;
  final String? birthDate;
  final String? gender;
  final String? phone;
  final String? email;
  final String? address;
  final String? imageUrl;

  UserInfo({
    this.id,
    required this.pinfl,
    required this.fullName,
    this.middleName,
    this.birthDate,
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
      pinfl: json['jshshir']?.toString() ?? '',
      fullName: json['first_name']?.toString() ??
          json['full_name']?.toString() ??
          'Noma\'lum',
      middleName: json['middle_name']?.toString() ??
          json['middleName']?.toString(),
      birthDate: json['birth_date']?.toString() ??
          json['birth_date']?.toString(),
      gender: json['gender']?.toString(),
      phone: json['phone']?.toString() ??
          json['phone_number']?.toString(),
      email: json['email']?.toString(),
      address: json['address']?.toString(),
      imageUrl: json['photo_url']?.toString() ??
          json['image_url']?.toString() ??
          json['photo']?.toString(),
    );
  }

  // Object'ni JSON'ga aylantirish
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pinfl': pinfl,
      'full_name': fullName,
      'middle_name': middleName,
      'birth_date': birthDate,
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
    String? fullName,
    String? middleName,
    String? birthDate,
    String? gender,
    String? phone,
    String? email,
    String? address,
    String? imageUrl,
  }) {
    return UserInfo(
      id: id ?? this.id,
      pinfl: pinfl ?? this.pinfl,
      fullName: fullName ?? this.fullName,
      middleName: middleName ?? this.middleName,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  String toString() {
    return 'UserInfo(pinfl: $pinfl, fullName: $fullName, phone: $phone, email: $email)';
  }
}