import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../router/app_router.dart';

/// Settings Screen
/// GoRouter ၏ Advanced Features များပြသည်
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthService>();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Settings & Advanced GoRouter'),
            backgroundColor: theme.colorScheme.surface,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current Route Info
                  _CurrentRouteCard(theme: theme),
                  const SizedBox(height: 20),

                  // GoRouter Features Summary
                  _FeaturesSummaryCard(theme: theme),
                  const SizedBox(height: 20),

                  // Quick Navigation Tests
                  _QuickNavSection(theme: theme),
                  const SizedBox(height: 20),

                  // Deep Link Info
                  _DeepLinkCard(theme: theme),
                  const SizedBox(height: 20),

                  // Logout
                  _SettingsLogoutButton(auth: auth, theme: theme),
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

class _CurrentRouteCard extends StatelessWidget {
  final ThemeData theme;
  const _CurrentRouteCard({required this.theme});

  @override
  Widget build(BuildContext context) {
    final state = GoRouterState.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
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
                  Icons.location_on_rounded,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                // BUG FIX: Text ကို Expanded ဖြင့် မထုပ်ထားလျှင် မျက်နှာပြင်ကျဉ်းသော
                // Device တွင် "RenderFlex overflowed by 4.6 pixels on the right"
                // ဖြစ်သည်။ Expanded ဖြင့် ရရှိသော အကျယ်အတွင်း စာသားခေါက်ပေးမည်။
                Expanded(
                  child: Text(
                    'GoRouterState.of(context) - Current Route Info',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            _infoRow('uri', state.uri.toString()),
            _infoRow('matchedLocation', state.matchedLocation),
            _infoRow('name', state.name ?? 'null'),
            _infoRow(
              'pathParameters',
              state.pathParameters.isEmpty
                  ? '{}'
                  : state.pathParameters.toString(),
            ),
            _infoRow(
              'queryParameters',
              state.uri.queryParameters.isEmpty
                  ? '{}'
                  : state.uri.queryParameters.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 12),
          children: [
            TextSpan(
              text: '$key: ',
              style: TextStyle(
                color: Colors.blue.shade700,
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                color: Colors.green,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturesSummaryCard extends StatelessWidget {
  final ThemeData theme;
  const _FeaturesSummaryCard({required this.theme});

  @override
  Widget build(BuildContext context) {
    final features = [
      ('✅ Route Declaration', 'GoRoute, ShellRoute ဖြင့် Routes သတ်မှတ်သည်'),
      ('✅ Auth Guard', 'redirect() ဖြင့် Protected Routes စီမံသည်'),
      ('✅ Shell Route', 'Bottom Nav Bar Persistent ဖြစ်စေသည်'),
      ('✅ Nested Routes', 'Parent/Child Route Hierarchy'),
      ('✅ Path Parameters', ':id ဖြင့် URL ထဲတွင် Data ပို့သည်'),
      ('✅ Query Parameters', '?key=value ဖြင့် Data ပို့သည်'),
      ('✅ Extra Data', 'state.extra ဖြင့် Object ပို့သည်'),
      ('✅ Named Routes', 'Name ဖြင့် Navigate လုပ်သည်'),
      ('✅ Return Data', 'push() await + pop(data)'),
      ('✅ refreshListenable', 'AuthService ပြောင်းသည်နှင့် Redirect Auto-run'),
      ('✅ Error Route', 'Not Found Page ကို Handle လုပ်သည်'),
      ('✅ GoRouterState', 'Current Route Info ရယူသည်'),
    ];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('🗺️', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                // BUG FIX: Expanded မပါလျှင် ကျဉ်းသော မျက်နှာပြင်တွင်
                // "RenderFlex overflowed by 10.0 pixels on the right" ဖြစ်သည်
                Expanded(
                  child: Text(
                    'ဤ App တွင် သင်ကြားသော GoRouter Features',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            ...features.map(
              (f) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      f.$1,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      f.$2,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickNavSection extends StatelessWidget {
  final ThemeData theme;
  const _QuickNavSection({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '⚡ Quick Navigation Tests',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  [
                        ('🏠 go(Home)', () => context.go(AppRoutes.home)),
                        ('👤 go(Profile)', () => context.go(AppRoutes.profile)),
                        (
                          '❌ go(/not-found)',
                          () => context.go('/this-route-does-not-exist'),
                        ),
                        (
                          '📄 push(p001)',
                          () =>
                              context.push(AppRoutes.productDetailPath('p001')),
                        ),
                        (
                          '🔙 canPop()',
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('canPop() = ${context.canPop()}'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ]
                      .map(
                        (item) => ActionChip(
                          label: Text(
                            item.$1,
                            style: const TextStyle(fontSize: 12),
                          ),
                          onPressed: item.$2,
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeepLinkCard extends StatelessWidget {
  final ThemeData theme;
  const _DeepLinkCard({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(0xFF1E1E2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text('🔗', style: TextStyle(fontSize: 20)),
                SizedBox(width: 8),
                // BUG FIX: Expanded ဖြင့် ကျဉ်းသော မျက်နှာပြင်တွင်
                // စာသားကျော်လွန်ခြင်းကို ကာကွယ်သည်
                Expanded(
                  child: Text(
                    'Deep Link URLs (for Info)',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 16, color: Colors.white24),
            ...[
              '/login',
              '/home',
              '/home/product/p001',
              '/profile',
              '/navigation-demo',
              '/data-passing?tab=query',
              '/settings',
            ].map(
              (url) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Text(
                      '→ ',
                      style: TextStyle(color: Colors.greenAccent, fontSize: 12),
                    ),
                    Expanded(
                      child: Text(
                        url,
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go(url),
                      child: const Icon(
                        Icons.open_in_new_rounded,
                        color: Colors.white38,
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsLogoutButton extends StatelessWidget {
  final AuthService auth;
  final ThemeData theme;

  const _SettingsLogoutButton({required this.auth, required this.theme});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: auth.isLoading ? null : () => auth.logout(),
        icon: const Icon(Icons.logout_rounded),
        label: const Text('Logout (GoRouter Auto-Redirect Demo)'),
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.error,
          side: BorderSide(
            color: theme.colorScheme.error.withValues(alpha: 0.5),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
