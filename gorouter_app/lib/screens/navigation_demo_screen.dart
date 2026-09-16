import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/app_router.dart';

/// Navigation Demo Screen
/// push, pop, go, replace, pushReplacement တို့ကို Interactive ဖြင့်သင်ကြားသည်
class NavigationDemoScreen extends StatefulWidget {
  const NavigationDemoScreen({super.key});

  @override
  State<NavigationDemoScreen> createState() => _NavigationDemoScreenState();
}

class _NavigationDemoScreenState extends State<NavigationDemoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _navigationLog = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addLog(String entry) {
    setState(() {
      _navigationLog.insert(0, '${DateTime.now().second}s: $entry');
      if (_navigationLog.length > 10) _navigationLog.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Demo'),
        backgroundColor: theme.colorScheme.surface,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(text: 'push/pop'),
            Tab(text: 'go/replace'),
            Tab(text: 'Stack ကြည့်'),
            Tab(text: 'goNamed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PushPopTab(onLog: _addLog, log: _navigationLog),
          _GoReplaceTab(onLog: _addLog, log: _navigationLog),
          _StackVisualTab(),
          _NamedRoutesTab(onLog: _addLog),
        ],
      ),
    );
  }
}

// =====================================================
// TAB 1: Push / Pop Demo
// =====================================================
class _PushPopTab extends StatefulWidget {
  final Function(String) onLog;
  final List<String> log;
  const _PushPopTab({required this.onLog, required this.log});

  @override
  State<_PushPopTab> createState() => _PushPopTabState();
}

class _PushPopTabState extends State<_PushPopTab> {
  String? _returnedData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle('context.push() - Stack ထဲ ထပ်ထည့်သည်'),
          const SizedBox(height: 8),
          _ConceptCard(
            theme: theme,
            icon: '📌',
            color: Colors.blue,
            title: 'push() ဆိုသည်မှာ',
            description:
                'Navigation Stack ထဲတွင် Page အသစ်ထပ်ထည့်သည်။\n'
                'Back Button ဖိလျှင် ယခင် Page ပြန်ရမည်။\n'
                'Stack: [Home] → push → [Home, Detail]',
          ),
          const SizedBox(height: 12),

          // Push Button
          _DemoButton(
            label: 'context.push() → Product Detail',
            icon: Icons.arrow_forward_rounded,
            color: Colors.blue,
            onPressed: () async {
              widget.onLog('push() ကိုနှိပ်ပြီ');
              // push() သည် Future ပြန်ပေးသည် - pop(data) ဖြင့် Data ပြန်လာနိုင်
              final result = await context.push<Map<String, dynamic>>(
                AppRoutes.productDetailPath('p001'),
                extra: {'from': 'push_demo'},
              );
              if (result != null && mounted) {
                setState(() => _returnedData = result.toString());
                widget.onLog('pop() မှ Data ပြန်ရပြီ: $result');
              }
            },
          ),

          if (_returnedData != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('✅ pop() မှ Return ရသော Data:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green)),
                  const SizedBox(height: 4),
                  Text(
                    _returnedData!,
                    style: const TextStyle(
                        fontFamily: 'monospace', fontSize: 12),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),
          _SectionTitle('context.pop() - Back Navigation'),
          const SizedBox(height: 8),
          _ConceptCard(
            theme: theme,
            icon: '⬅️',
            color: Colors.orange,
            title: 'pop() ဆိုသည်မှာ',
            description:
                'Stack ၏ ထိပ်ဆုံး Page ကိုဖျက်ပြီး ယခင် Page သို့ ပြန်သွားသည်။\n'
                'Data ပါ ပြန်ပို့နိုင်သည်: context.pop(myData)\n'
                'canPop() ဖြင့် Pop လုပ်နိုင်/မနိုင် စစ်ဆေးနိုင်သည်',
          ),
          const SizedBox(height: 12),
          _DemoButton(
            label: 'context.canPop() စစ်ကြည့်မည်',
            icon: Icons.help_outline_rounded,
            color: Colors.orange,
            onPressed: () {
              final canPop = context.canPop();
              widget.onLog('canPop() = $canPop');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    canPop
                        ? '✅ canPop() = true → Pop နိုင်သည်'
                        : '❌ canPop() = false → Pop မနိုင် (Root Route)',
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),

          const SizedBox(height: 24),
          _SectionTitle('Navigation Log'),
          const SizedBox(height: 8),
          _LogDisplay(logs: widget.log),
        ],
      ),
    );
  }
}

// =====================================================
// TAB 2: Go / Replace Demo
// =====================================================
class _GoReplaceTab extends StatelessWidget {
  final Function(String) onLog;
  final List<String> log;
  const _GoReplaceTab({required this.onLog, required this.log});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle('context.go() - Stack Replace'),
          const SizedBox(height: 8),
          _ConceptCard(
            theme: theme,
            icon: '🔄',
            color: Colors.purple,
            title: 'go() ဆိုသည်မှာ',
            description:
                'Navigation Stack ကို Reset လုပ်ပြီး Route သစ်ကို ရောက်သည်။\n'
                'Back ကိုနှိပ်လျှင် App မှ ထွက်မည် (သို့) ယခင် Route မပြန်မည်။\n'
                'Bottom Nav Tab များ ပြောင်းသည်နှင့် go() ကိုသုံးသင့်သည်။\n'
                'Stack: [Home] → go(Profile) → [Profile]',
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _DemoButton(
                  label: 'go(Home)',
                  icon: Icons.home_rounded,
                  color: Colors.purple,
                  onPressed: () {
                    onLog('go(Home) နှိပ်ပြီ');
                    context.go(AppRoutes.home);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DemoButton(
                  label: 'go(Profile)',
                  icon: Icons.person_rounded,
                  color: Colors.purple,
                  onPressed: () {
                    onLog('go(Profile) နှိပ်ပြီ');
                    context.go(AppRoutes.profile);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          _SectionTitle('context.replace() - Current Page Replace'),
          const SizedBox(height: 8),
          _ConceptCard(
            theme: theme,
            icon: '♻️',
            color: Colors.teal,
            title: 'replace() ဆိုသည်မှာ',
            description:
                'Stack ၏ ထိပ်ဆုံး Page ကိုသာ Replace လုပ်သည်။\n'
                'Stack Size မပြောင်းဘဲ Current Page ကို Swap လုပ်သည်။\n'
                'Login → Home Redirect တွင် သုံးလေ့ရှိသည်\n'
                'Stack: [A, B] → replace(C) → [A, C]',
          ),
          const SizedBox(height: 12),
          _DemoButton(
            label: 'replace(Settings) လုပ်ကြည့်မည်',
            icon: Icons.settings_rounded,
            color: Colors.teal,
            onPressed: () {
              onLog('replace(Settings) နှိပ်ပြီ');
              context.replace(AppRoutes.settings);
            },
          ),

          const SizedBox(height: 24),
          _SectionTitle('push vs go ချဉ်းကပ်နည်းအချုပ်'),
          const SizedBox(height: 8),
          _ComparisonTable(theme: theme),

          const SizedBox(height: 24),
          _SectionTitle('Navigation Log'),
          const SizedBox(height: 8),
          _LogDisplay(logs: log),
        ],
      ),
    );
  }
}

// =====================================================
// TAB 3: Stack Visualizer
// =====================================================
class _StackVisualTab extends StatefulWidget {
  @override
  State<_StackVisualTab> createState() => _StackVisualTabState();
}

class _StackVisualTabState extends State<_StackVisualTab> {
  final List<_StackItem> _stack = [
    _StackItem('Home', '🏠', Colors.green),
  ];

  void _push(String name, String emoji, Color color) {
    setState(() => _stack.add(_StackItem(name, emoji, color)));
  }

  void _pop() {
    if (_stack.length > 1) setState(() => _stack.removeLast());
  }

  void _go(String name, String emoji, Color color) {
    setState(() {
      _stack.clear();
      _stack.add(_StackItem(name, emoji, color));
    });
  }

  void _replace(String name, String emoji, Color color) {
    if (_stack.isNotEmpty) {
      setState(() {
        _stack.removeLast();
        _stack.add(_StackItem(name, emoji, color));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Navigation Stack ကို မျက်မြင်တွေ့ကြည့်ပါ',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Stack Visualization
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  'Navigation Stack',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '↑ ထိပ်ဆုံး (Active Page)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 16),

                // Stack Items (reversed = top shows first)
                ...List.generate(_stack.length, (i) {
                  final item = _stack[_stack.length - 1 - i];
                  final isTop = i == 0;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isTop ? item.color : item.color.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                      border: isTop
                          ? Border.all(color: item.color, width: 2)
                          : null,
                      boxShadow: isTop
                          ? [
                              BoxShadow(
                                color: item.color.withOpacity(0.3),
                                blurRadius: 8,
                              )
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item.emoji, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Text(
                          '${item.name} ${isTop ? '← Active' : ''}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: isTop
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('📱 App Root'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Action Buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () =>
                    _push('Detail', '📄', Colors.blue),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('push(Detail)'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
              ElevatedButton.icon(
                onPressed: _stack.length > 1 ? _pop : null,
                icon: const Icon(Icons.remove, size: 16),
                label: const Text('pop()'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange),
              ),
              ElevatedButton.icon(
                onPressed: () => _push('Profile', '👤', Colors.green),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('push(Profile)'),
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
              ElevatedButton.icon(
                onPressed: () => _go('Settings', '⚙️', Colors.purple),
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('go(Settings)'),
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              ),
              ElevatedButton.icon(
                onPressed: () =>
                    _replace('New Page', '🔄', Colors.teal),
                icon: const Icon(Icons.swap_horiz, size: 16),
                label: const Text('replace()'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              ),
              ElevatedButton.icon(
                onPressed: () => _go('Home', '🏠', Colors.green),
                icon: const Icon(Icons.home, size: 16),
                label: const Text('Reset'),
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StackItem {
  final String name;
  final String emoji;
  final Color color;
  _StackItem(this.name, this.emoji, this.color);
}

// =====================================================
// TAB 4: Named Routes Demo
// =====================================================
class _NamedRoutesTab extends StatelessWidget {
  final Function(String) onLog;
  const _NamedRoutesTab({required this.onLog});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle('Named Routes - goNamed() / pushNamed()'),
          const SizedBox(height: 8),
          _ConceptCard(
            theme: theme,
            icon: '🏷️',
            color: Colors.indigo,
            title: 'Named Routes ကောင်းသောအချက်',
            description:
                'Route Path String ကိုမမှတ်မိဘဲ Name ဖြင့်သုံးနိုင်သည်။\n'
                'Path ပြောင်းလဲသည်နှင့် Name ဆက်သုံးနိုင်သည်\n'
                'pathParameters နှင့် queryParameters ထည့်နိုင်သည်',
          ),
          const SizedBox(height: 16),

          // goNamed Demo
          _CodeExampleCard(
            theme: theme,
            title: 'context.goNamed()',
            code: '''context.goNamed(
  'product-detail',
  pathParameters: {'productId': 'p002'},
  queryParameters: {'ref': 'named_demo'},
  extra: {'from': 'named_route'},
);''',
            onRun: () {
              onLog('goNamed(product-detail) နှိပ်ပြီ');
              context.goNamed(
                'product-detail',
                pathParameters: {'productId': 'p002'},
                extra: {'from': 'named_route_demo'},
              );
            },
          ),
          const SizedBox(height: 16),

          _CodeExampleCard(
            theme: theme,
            title: 'context.pushNamed()',
            code: '''context.pushNamed(
  'product-detail',
  pathParameters: {'productId': 'p004'},
  extra: {'from': 'push_named'},
);''',
            onRun: () async {
              onLog('pushNamed(product-detail) နှိပ်ပြီ');
              await context.pushNamed(
                'product-detail',
                pathParameters: {'productId': 'p004'},
                extra: {'from': 'push_named_demo'},
              );
            },
          ),
          const SizedBox(height: 16),

          _CodeExampleCard(
            theme: theme,
            title: 'GoRouter.of(context).go()',
            code: '''// GoRouter Instance တိုက်ရိုက်ရယူနည်း
final router = GoRouter.of(context);
router.go('/home');

// သို့မဟုတ် Extension Method ဖြင့်
context.go('/home');''',
            onRun: () {
              onLog('GoRouter.of().go() နှိပ်ပြီ');
              GoRouter.of(context).go(AppRoutes.home);
            },
          ),
        ],
      ),
    );
  }
}

// =====================================================
// SHARED WIDGETS
// =====================================================

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _ConceptCard extends StatelessWidget {
  final ThemeData theme;
  final String icon;
  final Color color;
  final String title;
  final String description;

  const _ConceptCard({
    required this.theme,
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _DemoButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, textAlign: TextAlign.center),
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _LogDisplay extends StatelessWidget {
  final List<String> logs;
  const _LogDisplay({required this.logs});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: logs.isEmpty
          ? Center(
              child: Text(
                'Button များနှိပ်ပြီး Log ကြည့်ပါ',
                style: TextStyle(color: Colors.green.shade400, fontSize: 12),
              ),
            )
          : ListView.builder(
              itemCount: logs.length,
              itemBuilder: (_, i) => Text(
                '> ${logs[i]}',
                style: TextStyle(
                  color: i == 0 ? Colors.greenAccent : Colors.green.shade700,
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
    );
  }
}

class _ComparisonTable extends StatelessWidget {
  final ThemeData theme;
  const _ComparisonTable({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
        color: theme.colorScheme.outline.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withOpacity(0.5),
          ),
          children: ['Feature', 'push()', 'go()']
              .map(
                (t) => TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      t,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        ...{
          'Stack': ['ထပ်ထည့်', 'Reset'],
          'Back Button': ['ပြန်လာနိုင်', 'မပြန်နိုင်'],
          'Return Data': ['✅ ရနိုင်', '❌ မရ'],
          'Tab Change': ['မသုံးသင့်', '✅ သုံးသင့်'],
          'Use Case': ['Detail View', 'Root Nav'],
        }
            .entries
            .map(
              (e) => TableRow(
                children: [e.key, e.value[0], e.value[1]]
                    .map(
                      (t) => TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(t, textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12)),
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
            .toList(),
      ],
    );
  }
}

class _CodeExampleCard extends StatelessWidget {
  final ThemeData theme;
  final String title;
  final String code;
  final VoidCallback onRun;

  const _CodeExampleCard({
    required this.theme,
    required this.title,
    required this.code,
    required this.onRun,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2E),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Row(
                  children: [Colors.red, Colors.yellow, Colors.green]
                      .map(
                        (c) => Container(
                          margin: const EdgeInsets.only(right: 6),
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF252535),
            child: Text(
              code,
              style: const TextStyle(
                color: Colors.greenAccent,
                fontFamily: 'monospace',
                fontSize: 12,
                height: 1.6,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: FilledButton.icon(
              onPressed: onRun,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Run ကြည့်မည်'),
            ),
          ),
        ],
      ),
    );
  }
}
