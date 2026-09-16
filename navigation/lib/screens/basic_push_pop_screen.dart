import 'package:flutter/material.dart';
import '../widgets/code_snippet.dart';

class BasicPushPopScreen extends StatelessWidget {
  const BasicPushPopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      appBar: AppBar(
        title: const Text('Lesson 1: Push / Pop'),
        backgroundColor: const Color(0xFF6C63FF),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Concept Banner
            _ConceptBanner(
              icon: Icons.swap_horiz_rounded,
              color: const Color(0xFF6C63FF),
              title: 'Navigator.push() & pop()',
              description:
                  'Flutter Navigator သည် Stack-based navigation system ဖြစ်သည်။ '
                  'push() ဖြင့် screen အသစ် ထပ်ထည့်ပြီး pop() ဖြင့် ပြန်ဖယ်ရှားသည်။',
            ),

            const SizedBox(height: 24),

            // Push Example
            _SectionTitle(title: '📤 Navigator.push()'),
            const SizedBox(height: 12),
            const Text(
              'ဒီ Button ကို နှိပ်ရင် Second Screen ကို navigate သွားမည်',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 12),

            // Demo Button - Push
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigator.push သုံးပြုပုံ
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SecondScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Go to Second Screen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),

            const SizedBox(height: 16),
            const CodeSnippet(
              title: 'navigator_push.dart',
              code: '''// Navigator.push() - Screen အသစ်သို့ navigate လုပ်
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => SecondScreen(),
  ),
);''',
            ),

            const SizedBox(height: 24),

            // Push Replacement Example
            _SectionTitle(title: '🔄 Navigator.pushReplacement()'),
            const SizedBox(height: 12),
            const Text(
              'လက်ရှိ screen ကို အစားထိုးပြီး navigate လုပ်မည် (back ပြန်မသွားနိုင်)',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReplacedScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Push Replacement'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C5CFF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),

            const SizedBox(height: 16),
            const CodeSnippet(
              title: 'push_replacement.dart',
              code: '''// Navigator.pushReplacement() - လက်ရှိ screen ကို အစားထိုး
// Login -> Home navigate ကဲ့သို့ use cases တွင် သုံးသည်
Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => ReplacedScreen(),
  ),
);''',
            ),

            const SizedBox(height: 24),

            // Stack Visualization
            _SectionTitle(title: '📚 Navigation Stack Visualization'),
            const SizedBox(height: 12),
            _StackVisualization(),

            const SizedBox(height: 24),

            // Key Points
            _KeyPoints(points: const [
              'Navigator.push() → Stack ပေါ် screen ထပ်ထည့်သည်',
              'Navigator.pop() → Stack ပေါ်မှ screen ဖယ်ရှားသည်',
              'MaterialPageRoute → Platform-specific animation ပါသည်',
              'pushReplacement() → Back button မသုံးနိုင်',
              'canPop() → Pop လုပ်နိုင်မနိုင် စစ်ဆေးနိုင်',
            ]),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ============================
// Second Screen
// ============================
class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      appBar: AppBar(
        title: const Text('Second Screen'),
        backgroundColor: const Color(0xFF6C63FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.looks_two_rounded,
                size: 80, color: Color(0xFF6C63FF)),
            const SizedBox(height: 20),
            const Text(
              'ဒါဟာ Second Screen ဖြစ်သည်!',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'AppBar ရှိ back button ကို နှိပ်ရင် Navigator.pop() ကို\n'
              'auto call လုပ်ပြီး ပြန်သွားမည်',
              style: TextStyle(color: Colors.grey[600], fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Manual pop
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Navigator.pop() ဖြင့် ပြန်သွား'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const CodeSnippet(
              title: 'pop.dart',
              code: '''// Navigator.pop() - ပြန်သွားဖို့
Navigator.pop(context);

// သို့မဟုတ် canPop() ဖြင့် စစ်ပြီး
if (Navigator.canPop(context)) {
  Navigator.pop(context);
}''',
            ),
          ],
        ),
      ),
    );
  }
}

// ============================
// Replaced Screen
// ============================
class ReplacedScreen extends StatelessWidget {
  const ReplacedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      appBar: AppBar(
        title: const Text('Replaced Screen'),
        backgroundColor: const Color(0xFF9C5CFF),
        // Back button ကို disable လုပ်ရန် မလိုပါ
        // pushReplacement ကြောင့် back သွားရင် Home သို့ ရောက်မည်
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.swap_horiz, size: 80, color: Color(0xFF9C5CFF)),
            const SizedBox(height: 20),
            const Text(
              'Replacement Screen',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142)),
            ),
            const SizedBox(height: 12),
            Text(
              'ဒီ screen ကို pushReplacement() ဖြင့် ရောက်လာသည်။\n'
              'Back ကို နှိပ်လျှင် Lesson 1 Screen မဟုတ်ဘဲ\n'
              'ယခင် screen (Home) သို့ ပြန်သွားမည်',
              style: TextStyle(color: Colors.grey[600], fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C5CFF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Pop (Home သို့ ပြန်သွား)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================
// Helper Widgets
// ============================
class _ConceptBanner extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;

  const _ConceptBanner({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2D3142),
      ),
    );
  }
}

class _StackVisualization extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          _StackItem(
              label: 'Screen C (Top)', color: const Color(0xFF6C63FF), arrow: true),
          _StackItem(
              label: 'Screen B', color: const Color(0xFF9C5CFF), arrow: true),
          _StackItem(
              label: 'Screen A (Bottom)', color: const Color(0xFFB39DDB), arrow: false),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          const Text(
            'pop() → C ဖယ်, B ကို ပြသမည်\npush(D) → D ကို Stack ထိပ်ထပ်ထည့်မည်',
            style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _StackItem extends StatelessWidget {
  final String label;
  final Color color;
  final bool arrow;

  const _StackItem(
      {required this.label, required this.color, required this.arrow});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (arrow) ...[
          const Icon(Icons.arrow_upward, size: 20, color: Colors.grey),
          const SizedBox(height: 4),
        ],
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}

class _KeyPoints extends StatelessWidget {
  final List<String> points;
  const _KeyPoints({required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF6C63FF).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFF6C63FF).withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb, color: Color(0xFF6C63FF), size: 20),
              SizedBox(width: 8),
              Text(
                'Key Points',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6C63FF),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...points.map((point) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('✓ ',
                        style: TextStyle(
                            color: Color(0xFF6C63FF),
                            fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Text(
                        point,
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xFF2D3142)),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
