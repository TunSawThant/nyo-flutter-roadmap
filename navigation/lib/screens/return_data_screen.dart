import 'package:flutter/material.dart';
import '../widgets/code_snippet.dart';

class ReturnDataScreen extends StatefulWidget {
  const ReturnDataScreen({super.key});

  @override
  State<ReturnDataScreen> createState() => _ReturnDataScreenState();
}

class _ReturnDataScreenState extends State<ReturnDataScreen> {
  // Return လုပ်လာသော data ကို ဒီနေရာ store မည်
  String? _returnedColor;
  Map<String, dynamic>? _returnedFormData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      appBar: AppBar(
        title: const Text('Lesson 3: Returning Data'),
        backgroundColor: const Color(0xFFFF6B6B),
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
                  colors: [Color(0xFFFF6B6B), Color(0xFFFF4444)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.reply_rounded, color: Colors.white, size: 40),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Returning Data from Screen',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'pop() တွင် value ထည့်ပြီး ယခင် screen သို့\ndata ကို ပြန်ပို့နည်း လေ့လာမည်',
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

            // ===========================
            // Demo 1: Simple String Return
            // ===========================
            _DemoSection(
              title: '🎨 Demo 1: Color Picker',
              subtitle: 'Screen တစ်ခုမှ String value ပြန်ရနည်း',
              color: const Color(0xFFFF6B6B),
              buttonLabel: 'Color Picker Screen ဖွင့်',
              buttonIcon: Icons.color_lens_outlined,
              returnedDataWidget: _returnedColor != null
                  ? _ReturnedDataBadge(
                      label: 'ရွေးချယ်ထားသော Color:',
                      value: _returnedColor!,
                      color: const Color(0xFFFF6B6B),
                    )
                  : const _WaitingBadge(message: 'Color မရွေးချယ်ရသေး...'),
              onPressed: () async {
                // await ဖြင့် returned value ကို receive လုပ်ခြင်း
                // ★ ဒါဟာ Returning Data ၏ Core Concept ဖြစ်သည် ★
                final selectedColor = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ColorPickerScreen(),
                  ),
                );

                // Screen ပြန်လာပြီးနောက် data ကို check
                if (selectedColor != null && mounted) {
                  setState(() {
                    _returnedColor = selectedColor;
                  });
                }
              },
            ),

            const SizedBox(height: 16),
            const CodeSnippet(
              title: 'return_string_data.dart',
              code: '''// ★ Returning Data - Core Pattern ★

// 1. push() ကို await ဖြင့် call (result ကို စောင့်မည်)
final selectedColor = await Navigator.push<String>(
  context,
  MaterialPageRoute(
    builder: (context) => ColorPickerScreen(),
  ),
);

// 2. returned value ကို check
if (selectedColor != null) {
  setState(() => myColor = selectedColor);
}

// ============ ColorPickerScreen ဘက်တွင် ============

// 3. pop() တွင် value ထည့်ပြီး ပြန်ပို့
ElevatedButton(
  onPressed: () {
    Navigator.pop(context, 'Red'); // ← value ပါ pop
  },
  child: Text('Red'),
)''',
            ),

            const SizedBox(height: 24),

            // ===========================
            // Demo 2: Form Data Return
            // ===========================
            _DemoSection(
              title: '📋 Demo 2: Form Submission',
              subtitle: 'Form data ကို Map အနေနဲ့ ပြန်ပို့နည်း',
              color: const Color(0xFFFF8C42),
              buttonLabel: 'Feedback Form ဖွင့်',
              buttonIcon: Icons.rate_review_outlined,
              returnedDataWidget: _returnedFormData != null
                  ? _FormReturnedWidget(data: _returnedFormData!)
                  : const _WaitingBadge(message: 'Form data မရသေး...'),
              onPressed: () async {
                final formData = await Navigator.push<Map<String, dynamic>>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeedbackFormScreen(),
                  ),
                );

                if (formData != null && mounted) {
                  setState(() {
                    _returnedFormData = formData;
                  });
                }
              },
            ),

            const SizedBox(height: 16),
            const CodeSnippet(
              title: 'return_map_data.dart',
              code: '''// Map အနေနဲ့ multiple data ပြန်ပို့ခြင်း
final formData = await Navigator.push<Map<String, dynamic>>(
  context,
  MaterialPageRoute(builder: (context) => FeedbackFormScreen()),
);

if (formData != null) {
  final name = formData['name'];
  final rating = formData['rating'];
  final feedback = formData['feedback'];
}

// FeedbackFormScreen တွင် pop ဖြင့် data ပြန်ပို့
Navigator.pop(context, {
  'name': nameController.text,
  'rating': selectedRating,
  'feedback': feedbackController.text,
});''',
            ),

            const SizedBox(height: 24),

            // Key Concept
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B6B).withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color(0xFFFF6B6B).withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.lightbulb, color: Color(0xFFFF6B6B)),
                      SizedBox(width: 8),
                      Text('Key Concepts',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF6B6B),
                              fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _KeyPoint('await Navigator.push() → result ကို စောင့်ဆိုင်း'),
                  _KeyPoint('Navigator.pop(context, value) → data ပြန်ပို့'),
                  _KeyPoint('Null check → user cancel လုပ်ရင် null ရနိုင်'),
                  _KeyPoint('mounted check → async gap ပြဿနာကို ကာကွယ်'),
                  _KeyPoint('<Type> generic → type-safe return value'),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ===========================
// Color Picker Screen
// ===========================
class ColorPickerScreen extends StatelessWidget {
  const ColorPickerScreen({super.key});

  final List<Map<String, dynamic>> _colors = const [
    {'name': 'Violet', 'color': Color(0xFF6C63FF), 'emoji': '💜'},
    {'name': 'Red', 'color': Color(0xFFFF6B6B), 'emoji': '❤️'},
    {'name': 'Green', 'color': Color(0xFF00C896), 'emoji': '💚'},
    {'name': 'Orange', 'color': Color(0xFFFFAA00), 'emoji': '🧡'},
    {'name': 'Blue', 'color': Color(0xFF4ECDC4), 'emoji': '💙'},
    {'name': 'Pink', 'color': Color(0xFFFF69B4), 'emoji': '🩷'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      appBar: AppBar(
        title: const Text('Color Picker'),
        backgroundColor: const Color(0xFFFF6B6B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Color တစ်ခု ရွေးချယ်ပါ',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142)),
            ),
            const SizedBox(height: 8),
            Text(
              'ရွေးချယ်ပြီးနောက် ယခင် screen သို့ ပြန်ပေးပို့မည်',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                ),
                itemCount: _colors.length,
                itemBuilder: (context, index) {
                  final colorData = _colors[index];
                  return GestureDetector(
                    onTap: () {
                      // ★ pop() တွင် color name ကို value အနေနဲ့ ပြန်ပို့ ★
                      Navigator.pop(context, colorData['name'] as String);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorData['color'] as Color,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: (colorData['color'] as Color)
                                .withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(colorData['emoji'] as String,
                              style: const TextStyle(fontSize: 28)),
                          const SizedBox(height: 4),
                          Text(
                            colorData['name'] as String,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Cancel option
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // value မပါဘဲ pop → null return လုပ်မည်
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Cancel (null ပြန်ပို့မည်)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================
// Feedback Form Screen
// ===========================
class FeedbackFormScreen extends StatefulWidget {
  const FeedbackFormScreen({super.key});

  @override
  State<FeedbackFormScreen> createState() => _FeedbackFormScreenState();
}

class _FeedbackFormScreenState extends State<FeedbackFormScreen> {
  final _nameController = TextEditingController();
  final _feedbackController = TextEditingController();
  int _rating = 3;

  @override
  void dispose() {
    _nameController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      appBar: AppBar(
        title: const Text('Feedback Form'),
        backgroundColor: const Color(0xFFFF8C42),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Feedback ပေးပါ',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142)),
            ),
            const SizedBox(height: 20),

            // Name
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Your Name',
                prefixIcon: const Icon(Icons.person_outline,
                    color: Color(0xFFFF8C42)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: Color(0xFFFF8C42), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Rating
            const Text('Rating:',
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    Icons.star_rounded,
                    size: 36,
                    color: index < _rating
                        ? const Color(0xFFFFAA00)
                        : Colors.grey[300],
                  ),
                  onPressed: () => setState(() => _rating = index + 1),
                );
              }),
            ),
            const SizedBox(height: 16),

            // Feedback text
            TextField(
              controller: _feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Your Feedback',
                alignLabelWithHint: true,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 60),
                  child: Icon(Icons.rate_review_outlined,
                      color: Color(0xFFFF8C42)),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: Color(0xFFFF8C42), width: 2),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Submit Button - Data ကို pop ဖြင့် ပြန်ပို့မည်
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // ★ Map အနေနဲ့ form data ကို pop ဖြင့် ပြန်ပို့ ★
                  Navigator.pop(context, {
                    'name': _nameController.text.isEmpty
                        ? 'Anonymous'
                        : _nameController.text,
                    'rating': _rating,
                    'feedback': _feedbackController.text.isEmpty
                        ? 'No feedback provided'
                        : _feedbackController.text,
                    'submittedAt': DateTime.now().toString(),
                  });
                },
                icon: const Icon(Icons.send_rounded),
                label: const Text('Submit & Return Data'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8C42),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================
// Helper Widgets
// ===========================
class _DemoSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final String buttonLabel;
  final IconData buttonIcon;
  final Widget returnedDataWidget;
  final VoidCallback onPressed;

  const _DemoSection({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.buttonLabel,
    required this.buttonIcon,
    required this.returnedDataWidget,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: color)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          const SizedBox(height: 16),
          returnedDataWidget,
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(buttonIcon),
              label: Text(buttonLabel),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReturnedDataBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ReturnedDataBadge(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: color, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text(value,
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}

class _WaitingBadge extends StatelessWidget {
  final String message;
  const _WaitingBadge({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(Icons.hourglass_empty, color: Colors.grey[400], size: 18),
          const SizedBox(width: 8),
          Text(message,
              style: TextStyle(color: Colors.grey[500], fontSize: 14)),
        ],
      ),
    );
  }
}

class _FormReturnedWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  const _FormReturnedWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFF8C42).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFF8C42).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFFFF8C42), size: 20),
              SizedBox(width: 8),
              Text('Form Data Received!',
                  style: TextStyle(
                      color: Color(0xFFFF8C42),
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text('👤 Name: ${data['name']}',
              style: const TextStyle(fontSize: 13)),
          Text('⭐ Rating: ${data['rating']}/5',
              style: const TextStyle(fontSize: 13)),
          Text('💬 "${data['feedback']}"',
              style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

class _KeyPoint extends StatelessWidget {
  final String text;
  const _KeyPoint(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('✓ ',
              style: TextStyle(
                  color: Color(0xFFFF6B6B),
                  fontWeight: FontWeight.bold)),
          Expanded(
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 14, color: Color(0xFF2D3142)))),
        ],
      ),
    );
  }
}
