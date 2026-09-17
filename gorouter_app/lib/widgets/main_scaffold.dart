import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/app_router.dart';

/// Main Scaffold with Bottom Navigation Bar
/// ShellRoute ၏ child ကို ဤ Widget ထဲတွင် ထည့်ပြသမည်
class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  // Bottom Nav Bar Items
  static const _navItems = [
    (icon: Icons.home_rounded, label: 'Home', path: AppRoutes.home),
    (icon: Icons.person_rounded, label: 'Profile', path: AppRoutes.profile),
    (
      icon: Icons.route_rounded,
      label: 'Navigation',
      path: AppRoutes.navigationDemo,
    ),
    (
      icon: Icons.data_object_rounded,
      label: 'Data Pass',
      path: AppRoutes.dataPassing,
    ),
    (icon: Icons.settings_rounded, label: 'Settings', path: AppRoutes.settings),
  ];

  /// Current Location မှ Active Tab Index ရှာသည်
  ///
  /// ရိုးရိုး startsWith() ကိုသုံးပါက `/profile` နှင့် အနာဂတ်တွင် ထည့်မည့်
  /// `/profile-settings` ကဲ့သို့ Route များ မှားယွင်းစွာ Match ဖြစ်နိုင်သည်။
  /// ထို့ကြောင့် Path နှင့် တိတိကျကျတူခြင်း သို့မဟုတ် `/` ဖြင့် ဆက်ထားသော
  /// Child Route (ဥပမာ `/home/product/p001`) ကိုသာ Match လုပ်သည်။
  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    for (int i = 0; i < _navItems.length; i++) {
      final path = _navItems[i].path;
      if (location == path || location.startsWith('$path/')) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              // Tab ပြောင်းသည်နှင့် GoRouter ဖြင့် Navigate လုပ်သည်
              context.go(_navItems[index].path);
            },
            indicatorColor: theme.colorScheme.primaryContainer,
            backgroundColor: Colors.transparent,
            elevation: 0,
            destinations: _navItems
                .map(
                  (item) => NavigationDestination(
                    icon: Icon(item.icon),
                    label: item.label,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
