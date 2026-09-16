// ============================================================
// USER MODEL
// Login user ၏ data ကို ထိန်းသိမ်းသည်
// ============================================================

class UserModel {
  final String id;
  final String username;
  final String email;
  final String password;
  final String avatarUrl;
  final String role;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.avatarUrl,
    required this.role,
  });

  // Object မှ Map သို့ ပြောင်းခြင်း
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'avatarUrl': avatarUrl,
      'role': role,
    };
  }

  // Map မှ Object သို့ ပြောင်းခြင်း (factory constructor)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      avatarUrl: map['avatarUrl'],
      role: map['role'],
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, email: $email, role: $role)';
  }
}

// ============================================================
// MOCK DATA - စစ်မှန်သော database မရှိသောကြောင့် hardcode လုပ်ထားသည်
// ============================================================
final List<UserModel> mockUsers = [
  const UserModel(
    id: 'u001',
    username: 'Mg Mg',
    email: 'mgmg@example.com',
    password: '123456',
    avatarUrl: 'https://i.pravatar.cc/150?img=1',
    role: 'Admin',
  ),
  const UserModel(
    id: 'u002',
    username: 'Ma Hnin',
    email: 'mahnin@example.com',
    password: 'abcdef',
    avatarUrl: 'https://i.pravatar.cc/150?img=5',
    role: 'User',
  ),
  const UserModel(
    id: 'u003',
    username: 'Ko Ko',
    email: 'koko@example.com',
    password: 'pass123',
    avatarUrl: 'https://i.pravatar.cc/150?img=8',
    role: 'Editor',
  ),
];
