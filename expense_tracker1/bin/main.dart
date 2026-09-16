import 'dart:io';

import 'package:expense_tracker/services/tracker.dart';
import 'package:expense_tracker/utils/validators.dart';

/// Interactive CLI menu loop
Future<void> main() async {
  final tracker = ExpenseTracker();

  stdout.writeln('');
  stdout.writeln('╔══════════════════════════════════════╗');
  stdout.writeln('║       💰 Expense Tracker CLI          ║');
  stdout.writeln('╚══════════════════════════════════════╝');

  while (true) {
    _printMenu();
    final choice = _prompt('ရွေးချယ်မည်: ').trim();

    switch (choice) {
      case '1':
        await _addExpense(tracker);
      case '2':
        await _listExpenses(tracker);
      case '3':
        await _deleteExpense(tracker);
      case '4':
        await _showSummary(tracker);
      case '5':
        await _searchByCategory(tracker);
      case '6':
        await _updateExpense(tracker);
      case '0':
        stdout.writeln('\nBye! 👋');
        exit(0);
      default:
        _error('မမှန်ကန်သော ရွေးချယ်မှု။ ထပ်ကြိုးစားပါ။');
    }
  }
}

// ── Menu ────────────────────────────────────────────────────────────────

void _printMenu() {
  stdout.writeln('\n┌─────────────────────────────────────┐');
  stdout.writeln('│  1. Expense ထည့်မည်                  │');
  stdout.writeln('│  2. Expense အားလုံးကြည့်မည်           │');
  stdout.writeln('│  3. Expense ဖျက်မည်                  │');
  stdout.writeln('│  4. Summary ကြည့်မည်                  │');
  stdout.writeln('│  5. Category ဖြင့် ရှာမည်             │');
  stdout.writeln('│  6. Expense ပြင်မည်                   │');
  stdout.writeln('│  0. ထွက်မည်                           │');
  stdout.writeln('└─────────────────────────────────────┘');
}

// ── Actions ─────────────────────────────────────────────────────────────

Future<void> _addExpense(ExpenseTracker tracker) async {
  stdout.writeln('\n── Expense အသစ် ထည့်မည် ──');

  // Title
  final title = _promptValidated('Title: ', validateTitle);

  // Amount
  final amountStr = _promptValidated('Amount: ', validateAmount);
  final amount = double.parse(amountStr);

  // Category
  stdout.writeln('Categories: ${validCategories.join(' | ')}');
  final category = _promptValidated('Category: ', validateCategory);

  // Date (optional)
  final dateStr = _promptValidated(
    'Date (YYYY-MM-DD, empty = ယနေ့): ',
    validateDate,
    allowEmpty: true,
  );
  DateTime? date;
  if (dateStr.isNotEmpty) {
    date = DateTime.parse(dateStr);
  }

  // Note (optional)
  final note =
      _promptValidated('Note (optional): ', validateNote, allowEmpty: true);

  final expense = await tracker.addExpense(
    title: title,
    amount: amount,
    category: category,
    date: date,
    note: note.isEmpty ? null : note,
  );

  _success('✓ Expense ထည့်ပြီး! ID: ${expense.id}');
  stdout.writeln('  ${expense.summary}');
}

Future<void> _listExpenses(ExpenseTracker tracker) async {
  final expenses = await tracker.getAllExpenses();
  if (expenses.isEmpty) {
    stdout.writeln('\n  (Expense မရှိသေးပါ)');
    return;
  }

  stdout.writeln('\n── Expenses (${expenses.length}) ──');
  for (final e in expenses) {
    stdout.writeln('  ${e.summary}');
  }

  final total = await tracker.getTotalAmount();
  stdout.writeln('  ─────────────────────────────');
  stdout.writeln('  စုစုပေါင်း: \$${total.toStringAsFixed(2)}');
}

Future<void> _deleteExpense(ExpenseTracker tracker) async {
  stdout.writeln('\n── Expense ဖျက်မည် ──');
  final id = _promptValidated('ဖျက်မည့် ID: ', validateId);

  final existing = await tracker.findById(id);
  if (existing == null) {
    _error('ID "$id" မတွေ့ပါ။');
    return;
  }

  stdout.writeln('  ${existing.summary}');
  final confirm = _prompt('သေချာသလား? (y/N): ').toLowerCase();
  if (confirm != 'y') {
    stdout.writeln('  ဖျက်မည်ကို ရပ်ထားသည်။');
    return;
  }

  await tracker.deleteExpense(id);
  _success('✓ ဖျက်ပြီး!');
}

Future<void> _showSummary(ExpenseTracker tracker) async {
  stdout.writeln('\n── Summary ──');
  final total = await tracker.getTotalAmount();
  final byCategory = await tracker.getSummaryByCategory();
  final count = await tracker.count;
  final monthExpenses = await tracker.getCurrentMonthExpenses();
  final monthTotal = monthExpenses.fold(0.0, (sum, e) => sum + e.amount);

  stdout.writeln('  စုစုပေါင်း Expense: $count ခု');
  stdout.writeln('  စုစုပေါင်း ငွေပမာဏ: \$${total.toStringAsFixed(2)}');
  stdout.writeln('  ဒီလ ငွေပမာဏ:       \$${monthTotal.toStringAsFixed(2)}');
  stdout.writeln('\n  Category အလိုက်:');
  for (final s in byCategory) {
    stdout.writeln('    ${s.category.padRight(14)} '
        '\$${s.total.toStringAsFixed(2).padLeft(10)} '
        '(${s.percentage.toStringAsFixed(1)}%)');
  }
}

Future<void> _searchByCategory(ExpenseTracker tracker) async {
  stdout.writeln('\n── Category ဖြင့် ရှာမည် ──');
  stdout.writeln('Categories: ${validCategories.join(' | ')}');
  final category = _promptValidated('Category: ', validateCategory);

  final results = await tracker.getByCategory(category);
  if (results.isEmpty) {
    stdout.writeln('  ($category တွင် Expense မရှိပါ)');
    return;
  }

  stdout.writeln('  "$category" - ${results.length} ခု:');
  for (final e in results) {
    stdout.writeln('  ${e.summary}');
  }
  final total = results.fold(0.0, (sum, e) => sum + e.amount);
  stdout.writeln('  စုစုပေါင်း: \$${total.toStringAsFixed(2)}');
}

Future<void> _updateExpense(ExpenseTracker tracker) async {
  stdout.writeln('\n── Expense ပြင်မည် ──');
  final id = _promptValidated('ပြင်မည့် ID: ', validateId);

  final existing = await tracker.findById(id);
  if (existing == null) {
    _error('ID "$id" မတွေ့ပါ။');
    return;
  }

  stdout.writeln('  လက်ရှိ: ${existing.summary}');
  stdout.writeln('  (ပြောင်းလဲရန် ရိုက်ထည့်ပါ၊ မပြောင်းလဲလျှင် Enter နှိပ်ပါ)');

  final titleInput = _prompt('Title [${existing.title}]: ');
  final amountInput = _prompt('Amount [${existing.amount}]: ');
  stdout.writeln('Categories: ${validCategories.join(' | ')}');
  final categoryInput = _prompt('Category [${existing.category}]: ');
  final noteInput = _prompt('Note [${existing.note ?? ''}]: ');

  // Validate only if provided
  if (titleInput.isNotEmpty) {
    final err = validateTitle(titleInput);
    if (err != null) {
      _error(err);
      return;
    }
  }
  double? newAmount;
  if (amountInput.isNotEmpty) {
    final err = validateAmount(amountInput);
    if (err != null) {
      _error(err);
      return;
    }
    newAmount = double.parse(amountInput);
  }
  if (categoryInput.isNotEmpty) {
    final err = validateCategory(categoryInput);
    if (err != null) {
      _error(err);
      return;
    }
  }
  if (noteInput.isNotEmpty) {
    final err = validateNote(noteInput);
    if (err != null) {
      _error(err);
      return;
    }
  }

  final updated = await tracker.updateExpense(
    id,
    title: titleInput.isEmpty ? null : titleInput,
    amount: newAmount,
    category: categoryInput.isEmpty ? null : categoryInput,
    note: noteInput.isEmpty ? null : noteInput,
  );

  if (updated != null) {
    _success('✓ ပြင်ဆင်မှု အောင်မြင်သည်!');
    stdout.writeln('  ${updated.summary}');
  } else {
    _error('ပြင်ဆင်မှု မအောင်မြင်ပါ။');
  }
}

// ── UI Helpers ──────────────────────────────────────────────────────────

String _prompt(String label) {
  stdout.write(label);
  return stdin.readLineSync() ?? '';
}

/// Validation ဖြင့် prompt (valid မဖြစ်မချင်း ထပ်မြောက်မေးသည်)
String _promptValidated(
  String label,
  String? Function(String?) validator, {
  bool allowEmpty = false,
}) {
  while (true) {
    final input = _prompt(label);
    if (allowEmpty && input.trim().isEmpty) return '';
    final error = validator(input);
    if (error == null) return input.trim();
    _error(error);
  }
}

void _success(String msg) => stdout.writeln('\x1B[32m$msg\x1B[0m');
void _error(String msg) => stderr.writeln('\x1B[31m✗ $msg\x1B[0m');
