import 'package:flutter/material.dart';
import '../widgets/code_snippet.dart';

class NamedRoutesScreen extends StatefulWidget {
  const NamedRoutesScreen({super.key});

  @override
  State<NamedRoutesScreen> createState() => _NamedRoutesScreenState();
}

class _NamedRoutesScreenState extends State<NamedRoutesScreen> {
  // Demo 3 - WillPopScope result ကို ဒီနေရာ store
  String _popResult = ' မသွားရသေး...';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF0),
      appBar: AppBar(
        title: const Text('Lesson 4: Navigation Patterns'),
        backgroundColor: const Color(0xFFFFAA00),
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
                  colors: [Color(0xFFFFAA00), Color(0xFFFF8800)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.layers_rounded, color: Colors.white, size: 40),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Navigation Patterns',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Navigator.push() အခြေခံ ပုံစံအမျိုးမျိုးကို\n'
                          'လက်တွေ့ Demo နှင့်အတူ လေ့လာမည်',
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

            // ==========================================
            // Pattern 1: pushReplacement
            // ==========================================
            _PatternSection(
              number: '1',
              title: 'pushReplacement()',
              subtitle: 'လက်ရှိ screen ကို အစားထိုး navigate',
              color: const Color(0xFFFFAA00),
              icon: Icons.swap_horiz_rounded,
              description:
                  'Login → Home ကဲ့သို့ back button ဖြင့် မပြန်ချင်သောအခါ သုံးသည်။\n'
                  'Stack မှ လက်ရှိ screen ကို ဖယ်ပြီး screen အသစ် ထည့်သည်။',
              buttonLabel: 'pushReplacement Demo',
              buttonIcon: Icons.swap_horiz_rounded,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PushReplacementDemoScreen(),
                  ),
                );
              },
              codeTitle: 'push_replacement.dart',
              code: '''// Navigator.pushReplacement()
// လက်ရှိ screen ကို stack မှ ဖယ်ပြီး
// screen အသစ် ထပ်ထည့်သည်

Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => HomeScreen(),
  ),
);

// Stack Before: [Login]
// Stack After : [Home]   ← Login ဖယ်သွားသည်''',
            ),

            const SizedBox(height: 20),

            // ==========================================
            // Pattern 2: pushAndRemoveUntil
            // ==========================================
            _PatternSection(
              number: '2',
              title: 'pushAndRemoveUntil()',
              subtitle: 'Navigation stack ကို ရှင်းလင်းပြီး navigate',
              color: const Color(0xFFFF6B6B),
              icon: Icons.layers_clear_rounded,
              description:
                  'Screen history အားလုံး ဖယ်ပြီး home/dashboard သို့ ပြန်သွားချင်သောအခါ သုံးသည်။\n'
                  'Logout → Login flow တွင် အသုံးများသည်။',
              buttonLabel: 'pushAndRemoveUntil Demo',
              buttonIcon: Icons.layers_clear_rounded,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const PushAndRemoveUntilDemoScreen(),
                  ),
                );
              },
              codeTitle: 'push_and_remove_until.dart',
              code: '''// Stack အားလုံး ဖယ်ပြီး navigate
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (context) => HomeScreen(),
  ),
  (route) => false, // ← false = stack clear
);

// Stack Before: [Home, Profile, Settings, EditProfile]
// Stack After : [Home]  ← အားလုံး ဖယ်သွားသည်

// သို့မဟုတ် တစ်ချို့ screen ကိုသာ ဖယ်
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (c) => DetailsScreen()),
  ModalRoute.withName('/home'), // home ထိ ဖယ်
);''',
            ),

            const SizedBox(height: 20),

            // ==========================================
            // Pattern 3: canPop + WillPopScope
            // ==========================================
            _PatternSection(
              number: '3',
              title: 'canPop() + PopScope',
              subtitle: 'Back ကို control လုပ်နည်း',
              color: const Color(0xFF6C63FF),
              icon: Icons.phonelink_lock_rounded,
              description:
                  'Back button ကို intercept လုပ်ပြီး confirm dialog ပြသခြင်း သို့မဟုတ်\n'
                  'data save မလုပ်ဘဲ မထွက်စေဖို့ ကာကွယ်သောအခါ သုံးသည်။',
              buttonLabel: 'PopScope Demo ကြည့်',
              buttonIcon: Icons.shield_rounded,
              onPressed: () async {
                final result = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PopScopeDemoScreen(),
                  ),
                );
                if (mounted) {
                  setState(() {
                    _popResult = result ?? 'Dialog မဖြေဘဲ ပြန်လာသည်';
                  });
                }
              },
              codeTitle: 'pop_scope.dart',
              code: '''// PopScope - back navigation ကို control
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      // canPop: false → back ကို block
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return; // pop ဖြစ်ပြီးဆို ထွက်
        
        // Confirm dialog ပြသ
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('ထွက်မည်လား?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text('မထွက်ဘူး'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text('ထွက်မည်'),
              ),
            ],
          ),
        );
        
        if (shouldPop == true && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(...),
    );
  }
}''',
              extraWidget: _popResult != ' မသွားရသေး...'
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C63FF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color:
                                  const Color(0xFF6C63FF).withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.reply,
                                color: Color(0xFF6C63FF), size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Result: $_popResult',
                                style: const TextStyle(
                                    color: Color(0xFF6C63FF),
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : null,
            ),

            const SizedBox(height: 20),

            // ==========================================
            // Pattern 4: Custom PageRoute (Transition)
            // ==========================================
            _PatternSection(
              number: '4',
              title: 'Custom Page Transition',
              subtitle: 'Animation ကိုယ်တိုင် define လုပ်ပြီး navigate',
              color: const Color(0xFF00C896),
              icon: Icons.animation_rounded,
              description:
                  'Default slide animation မဟုတ်ဘဲ Fade, Scale, Slide animations\n'
                  'ကိုယ်တိုင် customize လုပ်၍ navigate ဆောင်ရွက်နည်း',
              buttonLabel: 'Transitions Demo ကြည့်',
              buttonIcon: Icons.animation_rounded,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TransitionsDemoScreen(),
                  ),
                );
              },
              codeTitle: 'custom_transition.dart',
              code: '''// Fade Transition
Navigator.push(context,
  PageRouteBuilder(
    pageBuilder: (ctx, anim, _) => NextScreen(),
    transitionsBuilder: (ctx, anim, _, child) {
      return FadeTransition(
        opacity: anim,
        child: child,
      );
    },
    transitionDuration: Duration(milliseconds: 400),
  ),
);

// Scale Transition
transitionsBuilder: (ctx, anim, _, child) {
  return ScaleTransition(
    scale: anim,
    child: child,
  );
}

// Slide Transition (Bottom → Top)
transitionsBuilder: (ctx, anim, _, child) {
  final begin = Offset(0.0, 1.0);
  final end = Offset.zero;
  final tween = Tween(begin: begin, end: end);
  return SlideTransition(
    position: anim.drive(tween),
    child: child,
  );
}''',
            ),

            const SizedBox(height: 24),

            // Navigation Stack Cheatsheet
            _NavigationCheatsheet(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// Pattern 1: pushReplacement Demo Screen
// ============================================================
class PushReplacementDemoScreen extends StatelessWidget {
  const PushReplacementDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF0),
      appBar: AppBar(
        title: const Text('Replacement Screen'),
        backgroundColor: const Color(0xFFFFAA00),
        // ← Back button ကို နှိပ်ရင် Lesson 4 မဟုတ်ဘဲ Home သို့ ရောက်မည်
        // (pushReplacement ကြောင့် Lesson 4 stack မှ ဖယ်ထားသည်)
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFAA00), Color(0xFFFF8800)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  Icon(Icons.swap_horiz_rounded,
                      color: Colors.white, size: 60),
                  SizedBox(height: 16),
                  Text(
                    'Replacement Screen',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color(0xFFFFAA00).withOpacity(0.3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('📚 Stack ပြောင်းလဲပုံ:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Before push:\n  [Home] → [Lesson 4 Screen]'),
                  SizedBox(height: 4),
                  Text('pushReplacement() ပြီးနောက်:\n  [Home] → [Replacement Screen]'),
                  SizedBox(height: 4),
                  Text('⚠️ Back ကိုနှိပ်ရင် Home သို့ ရောက်မည်',
                      style: TextStyle(
                          color: Color(0xFFFF8800),
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.home),
                label: const Text('Pop (Home သို့ ပြန်သွား)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFAA00),
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

// ============================================================
// Pattern 2: pushAndRemoveUntil Demo Screen
// ============================================================
class PushAndRemoveUntilDemoScreen extends StatelessWidget {
  const PushAndRemoveUntilDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      appBar: AppBar(
        title: const Text('Step 1 of 3'),
        backgroundColor: const Color(0xFFFF6B6B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Progress
            Row(
              children: [1, 2, 3].map((i) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 6,
                    decoration: BoxDecoration(
                      color: i == 1
                          ? const Color(0xFFFF6B6B)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            const Icon(Icons.looks_one_rounded,
                size: 80, color: Color(0xFFFF6B6B)),
            const SizedBox(height: 16),
            const Text(
              'Step 1: Profile Info',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142)),
            ),
            const SizedBox(height: 8),
            Text(
              'ဤ wizard တွင် 3 steps ရှိသည်။\n'
              'Step 3 ပြီးဆုံးသောအခါ pushAndRemoveUntil() ဖြင့်\n'
              'wizard screens အားလုံး ဖယ်ပြီး Home သို့ ပြန်သွားမည်',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => const _WizardStep2Screen()),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Next: Step 2'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B6B),
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

class _WizardStep2Screen extends StatelessWidget {
  const _WizardStep2Screen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      appBar: AppBar(
        title: const Text('Step 2 of 3'),
        backgroundColor: const Color(0xFFFF6B6B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [1, 2, 3].map((i) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 6,
                    decoration: BoxDecoration(
                      color: i <= 2
                          ? const Color(0xFFFF6B6B)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            const Icon(Icons.looks_two_rounded,
                size: 80, color: Color(0xFFFF6B6B)),
            const SizedBox(height: 16),
            const Text(
              'Step 2: Preferences',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142)),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => const _WizardStep3Screen()),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Next: Step 3'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B6B),
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

class _WizardStep3Screen extends StatelessWidget {
  const _WizardStep3Screen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      appBar: AppBar(
        title: const Text('Step 3 of 3'),
        backgroundColor: const Color(0xFFFF6B6B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [1, 2, 3].map((i) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B6B),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            const Icon(Icons.looks_3_rounded,
                size: 80, color: Color(0xFFFF6B6B)),
            const SizedBox(height: 16),
            const Text(
              'Step 3: Confirm',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142)),
            ),
            const SizedBox(height: 12),
            Text(
              '"Complete" ကို နှိပ်လျှင် pushAndRemoveUntil() ဖြင့်\n'
              'Wizard screens 1, 2, 3 အားလုံး ဖယ်ပြီး Lesson 4 Screen သို့ ပြန်မည်',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            const CodeSnippet(
              title: 'complete_wizard.dart',
              code: '''// Stack clear ပြီး ပြန်သွား
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (c) => HomeScreen(),
  ),
  (route) => false, // ← stack clear
);''',
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Stack ကို clear ပြီး Lesson 4 Screen ထိ ဖယ်
                  // (Lesson 4 ဆီ ပြန်မဟုတ်ဘဲ Wizard screens တွေ ဖယ်)
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (c) => const _WizardCompleteScreen(),
                    ),
                    (route) => route.isFirst, // Home ထိ ဖယ်
                  );
                },
                icon: const Icon(Icons.check_circle),
                label: const Text('Complete! (pushAndRemoveUntil)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B6B),
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

class _WizardCompleteScreen extends StatelessWidget {
  const _WizardCompleteScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF8),
      appBar: AppBar(
        title: const Text('Setup Complete!'),
        backgroundColor: const Color(0xFF00C896),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline_rounded,
                size: 100, color: Color(0xFF00C896)),
            const SizedBox(height: 24),
            const Text(
              '🎉 Setup Complete!',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142)),
            ),
            const SizedBox(height: 12),
            Text(
              'pushAndRemoveUntil() ဖြင့် wizard screens\n'
              'Step 1, 2, 3 အားလုံး stack မှ ဖယ်ထားသည်။\n'
              'Back ကို နှိပ်ရင် Home Screen သို့ တိုက်ရိုက် ရောက်မည်',
              style: TextStyle(color: Colors.grey[600], fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.home),
                label: const Text('Home သို့ ပြန်သွား'),
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

// ============================================================
// Pattern 3: PopScope Demo Screen
// ============================================================
class PopScopeDemoScreen extends StatefulWidget {
  const PopScopeDemoScreen({super.key});

  @override
  State<PopScopeDemoScreen> createState() => _PopScopeDemoScreenState();
}

class _PopScopeDemoScreenState extends State<PopScopeDemoScreen> {
  bool _hasUnsavedChanges = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // canPop: false → back navigation ကို block
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (!_hasUnsavedChanges) {
          // Unsaved changes မရှိရင် တိုက်ရိုက် pop
          if (context.mounted) Navigator.pop(context, 'ဖြေ dialog မပြဘဲ ထွက်');
          return;
        }

        // Unsaved changes ရှိရင် confirm dialog ပြ
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: const Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: Color(0xFFFFAA00)),
                SizedBox(width: 8),
                Text('မသိမ်းဆည်းရသေး!'),
              ],
            ),
            content: const Text(
                'ပြောင်းလဲမှုများ မသိမ်းဆည်းရသေး။\nတကယ် ထွက်မည်လား?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('မထွက်ဘူး'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B6B),
                    foregroundColor: Colors.white),
                child: const Text('ထွက်မည်'),
              ),
            ],
          ),
        );

        if (shouldPop == true && context.mounted) {
          Navigator.pop(context, 'Dialog မှ "ထွက်မည်" ကို ရွေးပြီး ထွက်');
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5FF),
        appBar: AppBar(
          title: const Text('PopScope Demo'),
          backgroundColor: const Color(0xFF6C63FF),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFF6C63FF)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Back button ကို နှိပ်ကြည့်ပါ!\n'
                        '"Unsaved Changes ရှိသည်" toggle ဖွင့်ပြီး\n'
                        'Back ကို နှိပ်ရင် confirm dialog ပေါ်မည်',
                        style: TextStyle(color: Color(0xFF6C63FF)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text('✏️ Unsaved Changes Simulation:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),

              // Toggle
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10)
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      _hasUnsavedChanges
                          ? Icons.edit_document
                          : Icons.description_outlined,
                      color: _hasUnsavedChanges
                          ? const Color(0xFFFFAA00)
                          : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _hasUnsavedChanges
                                ? 'Unsaved Changes ရှိသည်'
                                : 'Changes မရှိသေး',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _hasUnsavedChanges
                                  ? const Color(0xFFFFAA00)
                                  : Colors.grey[600],
                            ),
                          ),
                          Text(
                            _hasUnsavedChanges
                                ? 'Back ကို နှိပ်ရင် dialog ပေါ်မည်'
                                : 'Back ကို နှိပ်ရင် တိုက်ရိုက် ထွက်မည်',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _hasUnsavedChanges,
                      activeColor: const Color(0xFFFFAA00),
                      onChanged: (value) =>
                          setState(() => _hasUnsavedChanges = value),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context, 'Save ပြီး ထွက်');
                  },
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('Save & Exit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
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
      ),
    );
  }
}

// ============================================================
// Pattern 4: Custom Transitions Demo Screen
// ============================================================
class TransitionsDemoScreen extends StatelessWidget {
  const TransitionsDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF8),
      appBar: AppBar(
        title: const Text('Custom Transitions'),
        backgroundColor: const Color(0xFF00C896),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transition အမျိုးအစားများ:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142)),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _TransitionButton(
                    label: '🌫️ Fade Transition',
                    color: const Color(0xFF6C63FF),
                    onTap: () => Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (ctx, anim, _) =>
                            const _TransitionResultScreen(name: 'Fade'),
                        transitionsBuilder: (ctx, anim, _, child) {
                          return FadeTransition(opacity: anim, child: child);
                        },
                        transitionDuration:
                            const Duration(milliseconds: 500),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _TransitionButton(
                    label: '🔍 Scale (Zoom) Transition',
                    color: const Color(0xFFFF6B6B),
                    onTap: () => Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (ctx, anim, _) =>
                            const _TransitionResultScreen(name: 'Scale'),
                        transitionsBuilder: (ctx, anim, _, child) {
                          return ScaleTransition(scale: anim, child: child);
                        },
                        transitionDuration:
                            const Duration(milliseconds: 400),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _TransitionButton(
                    label: '⬆️ Slide (Bottom → Top)',
                    color: const Color(0xFFFFAA00),
                    onTap: () => Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (ctx, anim, _) =>
                            const _TransitionResultScreen(name: 'Slide Up'),
                        transitionsBuilder: (ctx, anim, _, child) {
                          const begin = Offset(0.0, 1.0);
                          const end = Offset.zero;
                          final tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: Curves.easeOutCubic));
                          return SlideTransition(
                              position: anim.drive(tween), child: child);
                        },
                        transitionDuration:
                            const Duration(milliseconds: 400),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _TransitionButton(
                    label: '➡️ Slide (Right → Left)',
                    color: const Color(0xFF00C896),
                    onTap: () => Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (ctx, anim, _) =>
                            const _TransitionResultScreen(
                                name: 'Slide Left'),
                        transitionsBuilder: (ctx, anim, _, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          final tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: Curves.easeInOut));
                          return SlideTransition(
                              position: anim.drive(tween), child: child);
                        },
                        transitionDuration:
                            const Duration(milliseconds: 350),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _TransitionButton(
                    label: '✨ Fade + Scale Combined',
                    color: const Color(0xFF9C5CFF),
                    onTap: () => Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (ctx, anim, _) =>
                            const _TransitionResultScreen(
                                name: 'Fade + Scale'),
                        transitionsBuilder: (ctx, anim, _, child) {
                          return FadeTransition(
                            opacity: anim,
                            child: ScaleTransition(
                              scale: Tween(begin: 0.85, end: 1.0)
                                  .animate(CurvedAnimation(
                                parent: anim,
                                curve: Curves.easeOutBack,
                              )),
                              child: child,
                            ),
                          );
                        },
                        transitionDuration:
                            const Duration(milliseconds: 450),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransitionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _TransitionButton(
      {required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 15)),
      ),
    );
  }
}

class _TransitionResultScreen extends StatelessWidget {
  final String name;
  const _TransitionResultScreen({required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF8),
      appBar: AppBar(
        title: Text('$name Transition'),
        backgroundColor: const Color(0xFF00C896),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.animation_rounded,
                size: 80, color: Color(0xFF00C896)),
            const SizedBox(height: 20),
            Text(
              '$name Transition!',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142)),
            ),
            const SizedBox(height: 8),
            Text(
              'PageRouteBuilder ဖြင့် custom animation',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
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
          ],
        ),
      ),
    );
  }
}

// ============================================================
// Helper Widgets
// ============================================================
class _PatternSection extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final String description;
  final String buttonLabel;
  final IconData buttonIcon;
  final VoidCallback onPressed;
  final String codeTitle;
  final String code;
  final Widget? extraWidget;

  const _PatternSection({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.description,
    required this.buttonLabel,
    required this.buttonIcon,
    required this.onPressed,
    required this.codeTitle,
    required this.code,
    this.extraWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      number,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: color)),
                      Text(subtitle,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),
                Icon(icon, color: color, size: 28),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: TextStyle(
                      color: Colors.grey[700], fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onPressed,
                    icon: Icon(buttonIcon, size: 18),
                    label: Text(buttonLabel),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                if (extraWidget != null) extraWidget!,
                const SizedBox(height: 12),
                CodeSnippet(title: codeTitle, code: code),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationCheatsheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final methods = [
      {
        'method': 'push()',
        'desc': 'Screen အသစ် stack ပေါ် ထည့်',
        'color': const Color(0xFF6C63FF),
      },
      {
        'method': 'pop()',
        'desc': 'လက်ရှိ screen ဖယ်ပြီး ပြန်',
        'color': const Color(0xFFFF6B6B),
      },
      {
        'method': 'pushReplacement()',
        'desc': 'လက်ရှိ screen ကို အစားထိုး',
        'color': const Color(0xFFFFAA00),
      },
      {
        'method': 'pushAndRemoveUntil()',
        'desc': 'Stack ဖယ်ပြီး navigate',
        'color': const Color(0xFF00C896),
      },
      {
        'method': 'canPop()',
        'desc': 'Pop နိုင်မနိုင် စစ်',
        'color': const Color(0xFF9C5CFF),
      },
      {
        'method': 'PopScope',
        'desc': 'Back navigation ကို control',
        'color': const Color(0xFF4ECDC4),
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2D3142), Color(0xFF3D4258)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.menu_book_rounded, color: Colors.white, size: 22),
              SizedBox(width: 8),
              Text(
                'Navigation Cheatsheet',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...methods.map((m) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (m['color'] as Color).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: (m['color'] as Color).withOpacity(0.4)),
                    ),
                    child: Text(
                      m['method'] as String,
                      style: TextStyle(
                          fontFamily: 'monospace',
                          color: m['color'] as Color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      m['desc'] as String,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 13),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
