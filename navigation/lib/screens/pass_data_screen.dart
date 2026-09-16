import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../widgets/code_snippet.dart';

class PassDataScreen extends StatefulWidget {
  const PassDataScreen({super.key});

  @override
  State<PassDataScreen> createState() => _PassDataScreenState();
}

class _PassDataScreenState extends State<PassDataScreen> {
  final _nameController = TextEditingController(text: 'Nyo Aung');
  final _emailController = TextEditingController(text: 'nyo@flutter.dev');
  String _selectedRole = 'Flutter Developer';

  final List<String> _roles = [
    'Flutter Developer',
    'UI/UX Designer',
    'Project Manager',
    'Backend Developer',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF8),
      appBar: AppBar(
        title: const Text('Lesson 2: Passing Data'),
        backgroundColor: const Color(0xFF00C896),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Concept Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00C896), Color(0xFF00A878)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.send_rounded, color: Colors.white, size: 40),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Passing Data to Screen',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Constructor parameters မှတဆင့် data ကို\nScreen သို့ pass လုပ်နည်းကို လေ့လာမည်',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              '📝 User Data ဖြည့်ပါ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'ဒီ data တွေကို Profile Screen သို့ pass လုပ်ပြီး ပြသမည်',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 16),

            // Input Form Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: 'Name',
                    icon: Icons.person_outline,
                    color: const Color(0xFF00C896),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email_outlined,
                    color: const Color(0xFF00C896),
                  ),
                  const SizedBox(height: 16),
                  // Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: InputDecoration(
                      labelText: 'Role',
                      prefixIcon: const Icon(Icons.work_outline,
                          color: Color(0xFF00C896)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFF00C896), width: 2),
                      ),
                    ),
                    items: _roles.map((role) {
                      return DropdownMenuItem(
                          value: role, child: Text(role));
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedRole = value);
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Method 1: Constructor
            const Text(
              '📌 Method 1: Constructor Parameter',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142)),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // UserModel object ဖန်တီးပြီး screen သို့ pass
                  final user = UserModel(
                    name: _nameController.text,
                    email: _emailController.text,
                    age: 25,
                    role: _selectedRole,
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // Constructor မှတဆင့် user data ကို pass လုပ်
                      builder: (context) => ProfileScreen(user: user),
                    ),
                  );
                },
                icon: const Icon(Icons.send_rounded),
                label: const Text('Constructor ဖြင့် Profile Screen သို့ Data ပို့'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C896),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const CodeSnippet(
              title: 'pass_via_constructor.dart',
              code: '''// Data Model ဖန်တီးပြီး constructor မှတဆင့် pass
final user = UserModel(
  name: "Nyo Aung",
  email: "nyo@flutter.dev",
  age: 25,
  role: "Flutter Developer",
);

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ProfileScreen(user: user),
    // ↑ user object ကို constructor argument အနေနဲ့ pass
  ),
);

// ProfileScreen ဘက်တွင် receive လုပ်ခြင်း
class ProfileScreen extends StatelessWidget {
  final UserModel user; // ← receive လုပ်သော parameter
  
  const ProfileScreen({required this.user});
}''',
            ),

            const SizedBox(height: 24),

            // Method 2: Route Arguments
            const Text(
              '📌 Method 2: Route Arguments (Named Routes)',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142)),
            ),
            const SizedBox(height: 12),
            const CodeSnippet(
              title: 'pass_via_arguments.dart',
              code: '''// Named route ဖြင့် arguments ကို pass လုပ်ခြင်း
Navigator.pushNamed(
  context,
  '/profile',
  arguments: {  // ← Map အနေနဲ့ data ကို pass
    'name': 'Nyo Aung',
    'email': 'nyo@flutter.dev',
  },
);

// Receive လုပ်သောဘက်တွင်
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // arguments ကို ModalRoute မှ ရယူ
    final args = ModalRoute.of(context)!
        .settings.arguments as Map<String, dynamic>;
    
    final name = args['name'];
    final email = args['email'];
  }
}''',
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: color),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: 2),
        ),
      ),
    );
  }
}

// ============================
// Profile Screen (Data ကို receive လုပ်မည်)
// ============================
class ProfileScreen extends StatelessWidget {
  // Constructor Parameter မှတဆင့် data ကို receive လုပ်
  final UserModel user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF8),
      appBar: AppBar(
        title: const Text('Profile (Received Data)'),
        backgroundColor: const Color(0xFF00C896),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Success Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF00C896).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color(0xFF00C896).withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: Color(0xFF00C896)),
                  SizedBox(width: 8),
                  Text(
                    'Data successfully passed!',
                    style: TextStyle(
                        color: Color(0xFF00C896),
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Avatar
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00C896), Color(0xFF00A878)],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                  style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // User Data Cards
            _DataCard(label: '👤 Name', value: user.name),
            _DataCard(label: '📧 Email', value: user.email),
            _DataCard(label: '🎂 Age', value: '${user.age} years old'),
            _DataCard(label: '💼 Role', value: user.role),

            const SizedBox(height: 24),

            // Code explanation
            const CodeSnippet(
              title: 'receive_data.dart',
              code: '''// ဒီ Screen တွင် receive လုပ်ပုံ
class ProfileScreen extends StatelessWidget {
  // required parameter အနေနဲ့ ကြေငြာ
  final UserModel user;
  
  const ProfileScreen({
    super.key,
    required this.user, // ← ဒီနေရာတွင် receive
  });
  
  @override
  Widget build(BuildContext context) {
    // user.name, user.email, etc. ကို သုံးနိုင်
    return Text(user.name);
  }
}''',
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('ပြန်သွား'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C896),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DataCard extends StatelessWidget {
  final String label;
  final String value;

  const _DataCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Text(label,
              style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xFF2D3142),
            ),
          ),
        ],
      ),
    );
  }
}
