import 'package:blog_app/core/common/entities/user_entities.dart';

/* [UserModel] is the data-layer representation of a user.

     - Extends [UserEntities] from the domain layer to keep a consistent structure
       across layers while adding data-handling features.
     - Provides:
       • A `fromJson` factory constructor to create a UserModel from an API/DB response.
       • A `copyWith` method for creating modified copies without altering the original.
    
     Usage:
       final user = UserModel.fromJson(apiResponse);
       final updatedUser = user.copyWith(name: "New Name");
*/

class UserModel extends UserEntities {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory UserModel.formJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }

  UserModel copyWith({String? id, String? name, String? email}) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
    );
  }
}
