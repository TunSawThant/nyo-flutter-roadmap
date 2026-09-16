import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/navigation_card.dart';
import 'basic_push_pop_screen.dart';
import 'pass_data_screen.dart';
import 'return_data_screen.dart';
import 'named_routes_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5FF),
        body: CustomScrollView(
          slivers: [
            // Hero Header
            SliverAppBar(
              expandedHeight: 220,
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFF6C63FF),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFF9C5CFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.school, color: Colors.white, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'Flutter Learning',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Navigation\nMaster Class',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Navigator.push/pop • Passing Data • Returning Data',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Content
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Section Label
                  const _SectionLabel(
                      label: '🚀 Navigator Lessons', count: '4 Topics'),
                  const SizedBox(height: 16),

                  // Lesson 1: Basic Push/Pop
                  NavigationCard(
                    title: '1. Basic Push / Pop',
                    subtitle: 'Screen တစ်ခုကနေ တစ်ခုသို့ navigate လုပ်နည်း',
                    icon: Icons.swap_horiz_rounded,
                    color: const Color(0xFF6C63FF),
                    badgeText: 'Beginner',
                    onTap: () {
                      // Navigator.push သုံးပြုပုံ
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BasicPushPopScreen(),
                        ),
                      );
                    },
                  ),

                  // Lesson 2: Pass Data
                  NavigationCard(
                    title: '2. Passing Data',
                    subtitle: 'Screen တစ်ခုကနေ data ကို တစ်ခုသို့ pass လုပ်နည်း',
                    icon: Icons.send_rounded,
                    color: const Color(0xFF00C896),
                    badgeText: 'Intermediate',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PassDataScreen(),
                        ),
                      );
                    },
                  ),

                  // Lesson 3: Return Data
                  NavigationCard(
                    title: '3. Returning Data',
                    subtitle: 'Screen ကနေ data ကို ပြန်လာပြီး receive လုပ်နည်း',
                    icon: Icons.reply_rounded,
                    color: const Color(0xFFFF6B6B),
                    badgeText: 'Intermediate',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReturnDataScreen(),
                        ),
                      );
                    },
                  ),

                  // Lesson 4: Navigation Patterns
                  NavigationCard(
                    title: '4. Navigation Patterns',
                    subtitle: 'pushReplacement, pushAndRemoveUntil, PopScope, Transitions',
                    icon: Icons.layers_rounded,
                    color: const Color(0xFFFFAA00),
                    badgeText: 'Advanced',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NamedRoutesScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 8),
                  const _SectionLabel(
                      label: '💡 Quick Tips', count: 'Important'),
                  const SizedBox(height: 16),

                  // Tips Card
                  _TipsCard(),

                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final String count;
  const _SectionLabel({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3142),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF6C63FF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6C63FF),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _TipsCard extends StatelessWidget {
  final List<Map<String, String>> tips = const [
    {
      'icon': '📌',
      'title': 'Navigator.push()',
      'desc': 'Screen အသစ် stack ပေါ် push လုပ်တယ်'
    },
    {
      'icon': '🔙',
      'title': 'Navigator.pop()',
      'desc': 'လက်ရှိ screen ကို stack ကနေ ဖယ်ရှားတယ်'
    },
    {
      'icon': '📤',
      'title': 'Pass Data',
      'desc': 'Constructor မှတဆင့် data ကို screen သို့ pass လုပ်'
    },
    {
      'icon': '📥',
      'title': 'Return Data',
      'desc': 'pop() တွင် value ထည့်၍ data ကို ပြန်ပို့'
    },
    {
      'icon': '🗺️',
      'title': 'Named Routes',
      'desc': 'pushNamed() ဖြင့် route name ကို သုံးပြည်'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: tips.map((tip) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Text(tip['icon']!, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip['title']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                      Text(
                        tip['desc']!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
