import 'package:blog_app/features/auth/domain/entities/user_entities.dart';

class UserModel extends UserEntities {
  const UserModel({
    required super.name,
    required super.email,
    required super.password,
  });

  factory UserModel.formJson(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }
}
