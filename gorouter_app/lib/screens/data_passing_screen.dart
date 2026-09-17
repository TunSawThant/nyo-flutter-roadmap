import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/app_router.dart';

/// Data Passing Screen
/// Query Parameters, Extra Data, Path Parameters ဖြင့် Data ပေးပို့နည်းများ
class DataPassingScreen extends StatefulWidget {
  final String initialTab;

  const DataPassingScreen({super.key, this.initialTab = 'query'});

  @override
  State<DataPassingScreen> createState() => _DataPassingScreenState();
}

class _DataPassingScreenState extends State<DataPassingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const _tabs = ['query', 'extra', 'path', 'return'];

  /// Query Param မှ ရလာသော Tab Name ကို Index အဖြစ် ပြောင်းသည်
  /// မသိသော Tab Name ဖြစ်လျှင် ပထမ Tab (0) ကို ပြန်ပေးသည်
  int _tabIndexFor(String tab) {
    final index = _tabs.indexOf(tab);
    return index >= 0 ? index : 0;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: _tabIndexFor(widget.initialTab),
    );
  }

  @override
  void didUpdateWidget(covariant DataPassingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // BUG FIX: Route Path သည် တူညီသော်လည်း Query Param (?tab=...) ပြောင်းလျှင်
    // Flutter သည် State ကို ပြန်မဖန်တီးသောကြောင့် initState() ပြန်မလုပ်ပါ။
    // ထို့ကြောင့် Tab အသစ်သို့ ဤနေရာတွင်လိုက်ပြောင်းပေးရသည်။
    if (oldWidget.initialTab != widget.initialTab) {
      _animateToTab(widget.initialTab);
    }
  }

  /// Tab သို့ ရွှေ့သည်။
  /// TabController.animateTo() သည် notifyListeners() ကို ချက်ချင်း ခေါ်သောကြောင့်
  /// build/didUpdateWidget အတွင်းမှ တိုက်ရိုက်ခေါ်လျှင် Error တင်နိုင်သည်။
  /// ထို့ကြောင့် Frame ပြီးဆုံးမှ ရွှေ့ပေးသည်။
  void _animateToTab(String tab) {
    final index = _tabIndexFor(tab);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _tabController.index == index) return;
      _tabController.animateTo(index);
    });
  }

  /// Query Param Button များမှ Tab ပြောင်းရန်
  /// URL ကိုပါ တစ်ခါတည်း Update လုပ်သည် (URL သည် Tab ၏ Source of Truth)
  void _selectTab(String tab) {
    final index = _tabIndexFor(tab);
    if (_tabController.index != index) {
      _tabController.animateTo(index);
    }
    final location = '${AppRoutes.dataPassing}?tab=$tab';
    if (GoRouterState.of(context).uri.toString() != location) {
      context.go(location);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Passing Methods'),
        backgroundColor: theme.colorScheme.surface,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Query'),
            Tab(text: 'Extra'),
            Tab(text: 'Path'),
            Tab(text: 'Return'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _QueryParamsTab(onSelectTab: _selectTab),
          _ExtraDataTab(),
          _PathParamsTab(),
          _ReturnDataTab(),
        ],
      ),
    );
  }
}

// =====================================================
// QUERY PARAMETERS TAB
// =====================================================
class _QueryParamsTab extends StatefulWidget {
  /// Parent (DataPassingScreen) မှ Tab ကို ပြောင်းပေးမည့် Callback
  final ValueChanged<String> onSelectTab;

  const _QueryParamsTab({required this.onSelectTab});

  @override
  State<_QueryParamsTab> createState() => _QueryParamsTabState();
}

class _QueryParamsTabState extends State<_QueryParamsTab> {
  String? _currentQuery;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Current Query Params ကိုဖတ်သည်
    final state = GoRouterState.of(context);
    _currentQuery = state.uri.queryParameters['tab'];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoCard(
            icon: '🔍',
            color: Colors.blue,
            title: 'Query Parameters',
            description:
                'URL ၏ ? သင်္ကေတနောက်တွင် Key=Value ပုံစံဖြင့်ထည့်သည်\n'
                'Example: /data-passing?tab=query&sort=asc\n'
                'state.uri.queryParameters["tab"] ဖြင့်ရယူသည်',
          ),
          const SizedBox(height: 16),

          Card(
            elevation: 0,
            color: theme.colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📊 Current Query Parameters',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Current URL: /data-passing?tab=${_currentQuery ?? 'none'}',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'tab value = "${_currentQuery ?? 'null'}"',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Query Parameter ဖြင့် Navigate လုပ်ကြည့်မည်:',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 12),

          ...['query', 'extra', 'path', 'return'].map((tab) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: OutlinedButton.icon(
                onPressed: () {
                  // Query Parameter ဖြင့် Navigate လုပ်နည်း
                  // URL သာမက Tab ကိုပါ ချက်ချင်းပြောင်းပေးသည်
                  widget.onSelectTab(tab);
                },
                icon: const Icon(Icons.link, size: 16),
                label: Text('/data-passing?tab=$tab'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                  alignment: Alignment.centerLeft,
                ),
              ),
            );
          }),

          const SizedBox(height: 16),
          _CodeBlock(
            code: '''// Navigate with Query Params
context.go('/data-passing?tab=query');

// Router တွင် Query Params ဖတ်နည်း
GoRoute(
  path: '/data-passing',
  builder: (context, state) {
    final tab = state.uri.queryParameters['tab'];
    return DataPassingScreen(initialTab: tab ?? 'query');
  },
);''',
          ),
        ],
      ),
    );
  }
}

// =====================================================
// EXTRA DATA TAB
// =====================================================
class _ExtraDataTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoCard(
            icon: '📦',
            color: Colors.orange,
            title: 'Extra Data (state.extra)',
            description:
                'Dart Object တစ်ခုကို Extra ဖြင့်ပို့နိုင်သည်\n'
                'Type-safe မဟုတ်သောကြောင့် Cast လုပ်ရမည်\n'
                'Deep Link တွင် Extra Data မပါ - Web မသုံးသင့်\n'
                'In-App Navigation တွင်သာ သင့်လျော်သည်',
          ),
          const SizedBox(height: 16),

          _CodeBlock(
            code: '''// Extra Data ပေးပို့နည်း
context.push(
  '/home/product/p001',
  extra: {
    'from': 'home_screen',
    'category': 'Education',
    'timestamp': DateTime.now(),
  },
);

// Router တွင် Extra Data ဖတ်နည်း
builder: (context, state) {
  final extra = state.extra as Map<String, dynamic>?;
  final from = extra?['from'] as String?;
  return ProductDetail(from: from);
},''',
          ),
          const SizedBox(height: 16),

          FilledButton.icon(
            onPressed: () {
              context.push(
                AppRoutes.productDetailPath('p003'),
                extra: {
                  'from': 'extra_data_demo',
                  'timestamp': DateTime.now().toString(),
                  'data': {'key': 'value', 'nested': true},
                },
              );
            },
            icon: const Icon(Icons.send_rounded),
            label: const Text('Extra Data ဖြင့် push() ကြည့်မည်'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              backgroundColor: Colors.orange,
            ),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '⚠️ Extra Data ၏ အားနည်းချက်',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '• Deep Link မှတဆင့် App ဖွင့်သည်နှင့် Extra Data ပျောက်သည်\n'
                  '• Type-safe မဟုတ်သောကြောင့် Runtime Error ဖြစ်နိုင်\n'
                  '• Web Platform တွင် အလုပ်မလုပ်နိုင်\n'
                  '• ကြီးမားသော Data အတွက် မသင့်လျော်',
                  style: TextStyle(fontSize: 12, height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// PATH PARAMETERS TAB
// =====================================================
class _PathParamsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoCard(
            icon: '🛣️',
            color: Colors.green,
            title: 'Path Parameters (:paramName)',
            description:
                'URL Path ၏ Segment တစ်ခုကို Variable ဖြစ်စေသည်\n'
                'Example: /product/:productId → /product/p001\n'
                'Type-safe ဖြစ်ပြီး Deep Link တွင်လည်းအလုပ်လုပ်သည်\n'
                'Router ID ကဲ့သို့ Unique Identifier များအတွက်သုံးသည်',
          ),
          const SizedBox(height: 16),

          _CodeBlock(
            code: '''// Router Definition တွင်
GoRoute(
  path: 'product/:productId',
  builder: (context, state) {
    // Path Parameter ရယူနည်း
    final id = state.pathParameters['productId']!;
    return ProductDetail(productId: id);
  },
),

// Navigate သည်နှင့်
context.push('/home/product/p001');
// pathParameters['productId'] = 'p001'

// goNamed ဖြင့်
context.pushNamed(
  'product-detail',
  pathParameters: {'productId': 'p001'},
);''',
          ),
          const SizedBox(height: 16),

          Text(
            'Product ID ဖြင့် Navigate လုပ်ကြည့်မည်:',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 12),

          ...['p001', 'p002', 'p003', 'p004', 'p005'].map((id) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(id),
                ),
                title: Text('/home/product/$id'),
                subtitle: Text(
                  'pathParameters["productId"] = "$id"',
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                ),
                trailing: const Icon(Icons.arrow_forward_rounded),
                onTap: () {
                  context.push(
                    AppRoutes.productDetailPath(id),
                    extra: {'from': 'path_param_demo'},
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

// =====================================================
// RETURN DATA TAB
// =====================================================
class _ReturnDataTab extends StatefulWidget {
  @override
  State<_ReturnDataTab> createState() => _ReturnDataTabState();
}

class _ReturnDataTabState extends State<_ReturnDataTab> {
  dynamic _returnedData;
  String _status = 'waiting';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoCard(
            icon: '↩️',
            color: Colors.purple,
            title: 'Returning Data from Routes',
            description:
                'push() သည် Future ပြန်ပေးသောကြောင့် await ဖြင့်စောင့်နိုင်သည်\n'
                'pop(data) ဖြင့် Data ပြန်ပို့နိုင်သည်\n'
                'Dialog, BottomSheet ကဲ့သို့ Data ပြန်ရရသောနည်းနှင့်တူသည်',
          ),
          const SizedBox(height: 16),

          _CodeBlock(
            code: '''// Page A တွင် (Caller)
Future<void> openDetail() async {
  // push() ကို await ဖြင့်စောင့်သည်
  final result = await context.push<Map<String, dynamic>>(
    '/home/product/p001',
  );
  
  if (result != null) {
    print('Return data: \$result');
    // result['action'] == 'purchased'
    // result['quantity'] == 2
  }
}

// Page B တွင် (Callee)
void goBack() {
  context.pop({
    'action': 'purchased',
    'quantity': 2,
    'productId': 'p001',
  });
}''',
          ),
          const SizedBox(height: 16),

          // Status Indicator
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _status == 'waiting'
                  ? theme.colorScheme.surfaceContainerHighest
                  : _status == 'loading'
                  ? Colors.blue.withValues(alpha: 0.1)
                  : Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _status == 'waiting'
                    ? theme.colorScheme.outline.withValues(alpha: 0.3)
                    : _status == 'loading'
                    ? Colors.blue.withValues(alpha: 0.3)
                    : Colors.green.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (_status == 'loading')
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      Text(
                        _status == 'waiting' ? '⏳' : '✅',
                        style: const TextStyle(fontSize: 16),
                      ),
                    const SizedBox(width: 8),
                    // BUG FIX: စာသား ရှည်သောကြောင့် ကျဉ်းသော မျက်နှာပြင်တွင်
                    // Overflow မဖြစ်စေရန် Expanded ဖြင့် ခေါက်ပေးသည်
                    Expanded(
                      child: Text(
                        _status == 'waiting'
                            ? 'Button နှိပ်ပြီး Demo ကြည့်ပါ'
                            : _status == 'loading'
                            ? 'Page မှ Return Data စောင့်နေသည်...'
                            : 'Return Data ရပြီ!',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_returnedData != null) ...[
                  const Divider(height: 16),
                  Text(
                    'Received: $_returnedData',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: Colors.green,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          FilledButton.icon(
            onPressed: () async {
              setState(() {
                _status = 'loading';
                _returnedData = null;
              });

              // push() ကို await ဖြင့်စောင့်သည်
              final result = await context.push<Map<String, dynamic>>(
                AppRoutes.productDetailPath('p005'),
                extra: {'from': 'return_data_demo'},
              );

              if (mounted) {
                setState(() {
                  _returnedData = result;
                  _status = result != null ? 'received' : 'waiting';
                });
              }
            },
            icon: const Icon(Icons.open_in_new_rounded),
            label: const Text('Product Detail ဖွင့်ပြီး Data ပြန်ရမည်'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              backgroundColor: Colors.purple,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '💡 Detail Page ၏ "pop(data)" Button နှိပ်လျှင် Data ပြန်ရမည်',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// =====================================================
// SHARED WIDGETS
// =====================================================
class _InfoCard extends StatelessWidget {
  final String icon;
  final Color color;
  final String title;
  final String description;

  const _InfoCard({
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
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
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
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  final String code;
  const _CodeBlock({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        code,
        style: const TextStyle(
          color: Colors.greenAccent,
          fontFamily: 'monospace',
          fontSize: 11,
          height: 1.6,
        ),
      ),
    );
  }
}
