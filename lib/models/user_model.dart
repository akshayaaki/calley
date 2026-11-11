class UserModel {
  final String id;
  final String username;
  final String email;
  final String? phone;
  final String subscription;
  final String? parentAccount;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.phone,
    this.subscription = 'Calley Personal',
    this.parentAccount = 'NA',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      subscription: json['subscription'] ?? 'Calley Personal',
      parentAccount: json['parentAccount'] ?? 'NA',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'subscription': subscription,
      'parentAccount': parentAccount,
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? phone,
    String? subscription,
    String? parentAccount,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      subscription: subscription ?? this.subscription,
      parentAccount: parentAccount ?? this.parentAccount,
    );
  }
}

