import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../router/app_router.dart';

/// Profile Screen
/// User Info ပြသပြီး Logout နှင့် GoRouter Redirect ကိုပြသည်
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthService>();
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Profile'),
            backgroundColor: theme.colorScheme.surface,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // User Avatar Card
                  _UserAvatarCard(user: user, theme: theme),
                  const SizedBox(height: 20),

                  // GoRouter Redirect Explanation
                  _RedirectExplanationCard(theme: theme),
                  const SizedBox(height: 20),

                  // Profile Options
                  _ProfileOptionsList(theme: theme),
                  const SizedBox(height: 20),

                  // Logout Section
                  _LogoutSection(auth: auth, theme: theme),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserAvatarCard extends StatelessWidget {
  // မူလက `dynamic` ဖြစ်ခဲ့သောကြောင့် Typo တစ်ခုခုရှိလျှင် Compile Time တွင်
  // မတွေ့နိုင်၊ Runtime တွင်သာ Error တင်သည်။ ယခု UserModel? ဖြင့် Type-safe ဖြစ်သည်။
  final UserModel? user;
  final ThemeData theme;

  const _UserAvatarCard({this.user, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  user?.avatar ?? '👤',
                  style: const TextStyle(fontSize: 42),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user?.name ?? 'Unknown User',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                // `role` သည် non-nullable ဖြစ်သောကြောင့် `user` တစ်ခုတည်းကိုသာ
                // null-aware (?.) ဖြင့် စစ်ရသည်
                user?.role.toUpperCase() ?? 'GUEST',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RedirectExplanationCard extends StatelessWidget {
  final ThemeData theme;
  const _RedirectExplanationCard({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.shield_rounded,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                // BUG FIX: Expanded မပါလျှင် ကျဉ်းသော မျက်နှာပြင်တွင် Overflow ဖြစ်သည်
                Expanded(
                  child: Text(
                    'GoRouter Redirect (Auth Guard)',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            _redirectStep('1', 'User က /profile သွားမည်'),
            _redirectStep('2', 'GoRouter က redirect() ကို Call'),
            _redirectStep('3', 'authService.isLoggedIn စစ်သည်'),
            _redirectStep('4', 'true ဆိုလျှင် /profile ပြမည်'),
            _redirectStep('5', 'false ဆိုလျှင် /login ကို Redirect'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2E),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '''redirect: (context, state) {
  if (!auth.isLoggedIn && 
      state.uri.path != '/login') {
    return '/login'; // Redirect!
  }
  return null; // Allow navigation
},
refreshListenable: authService,''',
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontFamily: 'monospace',
                  fontSize: 10,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _redirectStep(String num, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: Colors.blue.withValues(alpha: 0.2),
            child: Text(
              num,
              style: const TextStyle(fontSize: 10, color: Colors.blue),
            ),
          ),
          const SizedBox(width: 8),
          // BUG FIX: ရှင်းလင်းချက် စာသား (Myanmar) သည် ရှည်သောကြောင့်
          // Expanded ဖြင့် ရရှိသော အကျယ်အတွင်း ခေါက်ပေးရသည်
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}

class _ProfileOptionsList extends StatelessWidget {
  final ThemeData theme;
  const _ProfileOptionsList({required this.theme});

  @override
  Widget build(BuildContext context) {
    final options = [
      (
        icon: Icons.shopping_bag_outlined,
        label: 'Courses ကြည့်မည်',
        sub: 'Home Page သို့သွားမည် (go)',
        onTap: () => context.go(AppRoutes.home),
      ),
      (
        icon: Icons.data_object_outlined,
        label: 'Data Passing သင်ကြားမည်',
        sub: 'Data Passing Page သို့ push',
        onTap: () => context.push(AppRoutes.dataPassing),
      ),
      (
        icon: Icons.route_outlined,
        label: 'Navigation Demo ကြည့်မည်',
        sub: 'Navigation Demo Page သို့ push',
        onTap: () => context.push(AppRoutes.navigationDemo),
      ),
      (
        icon: Icons.settings_outlined,
        label: 'Settings သွားမည်',
        sub: 'Settings Page သို့ go',
        onTap: () => context.go(AppRoutes.settings),
      ),
    ];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: options.asMap().entries.map((entry) {
          final i = entry.key;
          final opt = entry.value;
          return Column(
            children: [
              ListTile(
                leading: Icon(opt.icon, color: theme.colorScheme.primary),
                title: Text(opt.label),
                subtitle: Text(
                  opt.sub,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    fontFamily: 'monospace',
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                onTap: opt.onTap,
              ),
              if (i < options.length - 1) const Divider(height: 1, indent: 60),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _LogoutSection extends StatelessWidget {
  final AuthService auth;
  final ThemeData theme;

  const _LogoutSection({required this.auth, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: theme.colorScheme.error.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.logout_rounded,
                  color: theme.colorScheme.error,
                  size: 20,
                ),
                const SizedBox(width: 8),
                // BUG FIX: Expanded မပါလျှင် ကျဉ်းသော မျက်နှာပြင်တွင် Overflow ဖြစ်သည်
                Expanded(
                  child: Text(
                    'Logout & GoRouter Redirect',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Logout နှိပ်သည်နှင့် AuthService.logout() ကိုခေါ်မည်\n'
              'ChangeNotifier ကြောင့် GoRouter ၏ redirect() Re-run မည်\n'
              'isLoggedIn = false → /login သို့ Auto-Redirect မည်',
              style: theme.textTheme.bodySmall?.copyWith(
                height: 1.6,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: auth.isLoading
                    ? null
                    : () async {
                        await auth.logout();
                        // Logout ပြီးသည်နှင့် GoRouter က /login ကို Auto-Redirect မည်
                        // Manual navigate မလိုပါ!
                      },
                icon: auth.isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.logout_rounded),
                label: Text(auth.isLoading ? 'Logout လုပ်နေသည်...' : 'Logout'),
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
