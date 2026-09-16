import '../models/expense.dart';
import '../services/storage.dart';

/// Category အလိုက် အနှစ်ချုပ် (Dart 3 named record)
/// - `category`: အမျိုးအစား
/// - `total`: ထိုအမျိုးအစား၏ စုစုပေါင်း ပမာဏ
/// - `percentage`: စုစုပေါင်း ငွေထဲမှ ရာခိုင်နှုန်း
typedef CategorySummary = ({String category, double total, double percentage});

/// Expense စီမံခန့်ခွဲသည့် tracker service
class ExpenseTracker {
  final StorageService _storage;
  final List<Expense> _expenses = [];
  bool _loaded = false;

  ExpenseTracker({StorageService? storage})
      : _storage = storage ?? StorageService();

  // ── ဆက်ဆံရေး helper ─────────────────────────────────────────────────
  /// Storage မှ load မလုပ်ရသေးလျှင် load လုပ်သည်
  Future<void> _ensureLoaded() async {
    if (!_loaded) {
      final loaded = await _storage.loadExpenses();
      _expenses
        ..clear()
        ..addAll(loaded);
      _loaded = true;
    }
  }

  /// ပြောင်းလဲမှုတိုင်းကို storage တွင် သိမ်းသည်
  Future<void> _persist() => _storage.saveExpenses(_expenses);

  // ── CRUD Operations ──────────────────────────────────────────────────

  /// Expense အသစ် ထည့်သည်
  Future<Expense> addExpense({
    required String title,
    required double amount,
    required String category,
    DateTime? date,
    String? note,
  }) async {
    await _ensureLoaded();
    final expense = Expense(
      id: _generateId(),
      title: title.trim(),
      amount: amount,
      category: category,
      date: date ?? DateTime.now(),
      note: note?.trim().isEmpty == true ? null : note?.trim(),
    );
    _expenses.add(expense);
    await _persist();
    return expense;
  }

  /// ID ဖြင့် Expense တစ်ခု ရှာသည်
  Future<Expense?> findById(String id) async {
    await _ensureLoaded();
    try {
      return _expenses.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Expense ကို update လုပ်သည်
  Future<Expense?> updateExpense(
    String id, {
    String? title,
    double? amount,
    String? category,
    DateTime? date,
    String? note,
  }) async {
    await _ensureLoaded();
    final index = _expenses.indexWhere((e) => e.id == id);
    if (index == -1) return null;

    final old = _expenses[index];
    final updated = Expense(
      id: old.id,
      title: title?.trim() ?? old.title,
      amount: amount ?? old.amount,
      category: category ?? old.category,
      date: date ?? old.date,
      note: note ?? old.note,
    );
    _expenses[index] = updated;
    await _persist();
    return updated;
  }

  /// Expense ကို ဖျက်သည်
  Future<bool> deleteExpense(String id) async {
    await _ensureLoaded();
    final before = _expenses.length;
    _expenses.removeWhere((e) => e.id == id);
    if (_expenses.length == before) return false;
    await _persist();
    return true;
  }

  // ── Query / Filter ───────────────────────────────────────────────────

  /// Expenses အားလုံး ပြန်ပေးသည် (နောက်ဆုံးကနေ)
  Future<List<Expense>> getAllExpenses() async {
    await _ensureLoaded();
    return List.unmodifiable(
      _expenses.toList()..sort((a, b) => b.date.compareTo(a.date)),
    );
  }

  /// Category ဖြင့် filter
  Future<List<Expense>> getByCategory(String category) async {
    final all = await getAllExpenses();
    return all
        .where((e) => e.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  /// Date range ဖြင့် filter
  Future<List<Expense>> getByDateRange(DateTime from, DateTime to) async {
    final all = await getAllExpenses();
    final end = to.add(const Duration(days: 1)); // inclusive
    return all
        .where((e) => e.date.isAfter(from) && e.date.isBefore(end))
        .toList();
  }

  // ── Summary / Stats ──────────────────────────────────────────────────

  /// Expense အားလုံး၏ စုစုပေါင်း
  Future<double> getTotalAmount() async {
    final all = await getAllExpenses();
    return all.fold<double>(0.0, (sum, e) => sum + e.amount);
  }

  /// Category အလိုက် အနှစ်ချုပ် — (category, total, percentage) records စာရင်း
  /// (total ကြီးသည့်အစဉ်လိုက် sort လုပ်ထားသည်)
  Future<List<CategorySummary>> getSummaryByCategory() async {
    final all = await getAllExpenses();
    final grandTotal = all.fold<double>(0.0, (sum, e) => sum + e.amount);

    final subtotals = <String, double>{};
    for (final e in all) {
      subtotals[e.category] = (subtotals[e.category] ?? 0) + e.amount;
    }

    final entries = subtotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return [
      for (final e in entries)
        (
          category: e.key,
          total: e.value,
          percentage: grandTotal > 0 ? e.value / grandTotal * 100 : 0.0,
        ),
    ];
  }

  /// လက်ရှိ month ၏ expenses
  Future<List<Expense>> getCurrentMonthExpenses() async {
    final now = DateTime.now();
    final from = DateTime(now.year, now.month, 1);
    final to = DateTime(now.year, now.month + 1, 0);
    return getByDateRange(from, to);
  }

  /// Count
  Future<int> get count async {
    await _ensureLoaded();
    return _expenses.length;
  }

  // ── Private Helpers ──────────────────────────────────────────────────
  String _generateId() {
    // Short 8-char ID (uuid ပါမရှိသော environment တွင်လည်း အလုပ်ဖြစ်ရန်)
    final ts = DateTime.now().millisecondsSinceEpoch.toRadixString(36);
    final rand = (DateTime.now().microsecond % 9999).toString().padLeft(4, '0');
    return '$ts$rand';
  }
}
