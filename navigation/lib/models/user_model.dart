class UserModel {
  final String name;
  final String email;
  final int age;
  final String role;

  const UserModel({
    required this.name,
    required this.email,
    required this.age,
    required this.role,
  });

  // copyWith method - data update လုပ်ဖို့
  UserModel copyWith({
    String? name,
    String? email,
    int? age,
    String? role,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      role: role ?? this.role,
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, age: $age, role: $role)';
  }
}
