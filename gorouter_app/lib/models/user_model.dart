/// User Model - Authentication အတွက် သုံးမည့် Mock User Data
class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final String role;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.role,
  });

  @override
  String toString() =>
      'UserModel(id: $id, name: $name, email: $email, role: $role)';
}
