import 'package:test/test.dart';

import '../lib/models/expense.dart';
import '../lib/services/storage.dart';
import '../lib/services/tracker.dart';
import '../lib/utils/validators.dart';

void main() {
  // ── Expense Model Tests ────────────────────────────────────────────
  group('Expense Model', () {
    test('toJson / fromJson round-trip', () {
      final expense = Expense(
        id: 'abc123',
        title: 'Lunch',
        amount: 12.50,
        category: 'Food',
        date: DateTime(2024, 3, 15),
        note: 'KFC',
      );

      final json = expense.toJson();
      final restored = Expense.fromJson(json);

      expect(restored.id, equals(expense.id));
      expect(restored.title, equals(expense.title));
      expect(restored.amount, equals(expense.amount));
      expect(restored.category, equals(expense.category));
      expect(restored.note, equals(expense.note));
      expect(restored.date, equals(expense.date));
    });

    test('toJson မှ note null ဖြစ်ပါက key ရှိနေမည်', () {
      final expense = Expense(
        id: '1',
        title: 'T',
        amount: 5,
        category: 'Other',
        date: DateTime.now(),
      );
      final json = expense.toJson();
      expect(json.containsKey('note'), isTrue);
      expect(json['note'], isNull);
    });

    test('summary သည် မှန်ကန်သော format ဖြစ်ရမည်', () {
      final expense = Expense(
        id: 'x1',
        title: 'Coffee',
        amount: 3.75,
        category: 'Food',
        date: DateTime(2024, 1, 5),
      );
      expect(expense.summary, contains('Coffee'));
      expect(expense.summary, contains('3.75'));
      expect(expense.summary, contains('Food'));
    });
  });

  // ── Validators Tests ──────────────────────────────────────────────
  group('Validators', () {
    group('validateTitle', () {
      test('valid title', () => expect(validateTitle('Groceries'), isNull));
      test('empty title', () => expect(validateTitle(''), isNotNull));
      test('null title', () => expect(validateTitle(null), isNotNull));
      test('title too long', () {
        expect(validateTitle('a' * 101), isNotNull);
      });
      test('exactly 100 chars is valid', () {
        expect(validateTitle('a' * 100), isNull);
      });
    });

    group('validateAmount', () {
      test('valid amount', () => expect(validateAmount('99.99'), isNull));
      test('zero amount', () => expect(validateAmount('0'), isNotNull));
      test('negative amount', () => expect(validateAmount('-5'), isNotNull));
      test('non-numeric', () => expect(validateAmount('abc'), isNotNull));
      test('empty', () => expect(validateAmount(''), isNotNull));
      test('very large amount', () {
        expect(validateAmount('2000000000'), isNotNull);
      });
    });

    group('validateCategory', () {
      test('valid category', () => expect(validateCategory('Food'), isNull));
      test('case insensitive', () => expect(validateCategory('food'), isNull));
      test('invalid category',
          () => expect(validateCategory('Luxury'), isNotNull));
      test('empty', () => expect(validateCategory(''), isNotNull));
    });

    group('validateDate', () {
      test('empty is valid (optional)', () {
        expect(validateDate(''), isNull);
      });
      test('valid date', () {
        expect(validateDate('2024-01-15'), isNull);
      });
      test('invalid format', () {
        expect(validateDate('15/01/2024'), isNotNull);
      });
      test('future date', () {
        final future = DateTime.now().add(const Duration(days: 5));
        final str =
            '${future.year}-${future.month.toString().padLeft(2, '0')}-${future.day.toString().padLeft(2, '0')}';
        expect(validateDate(str), isNotNull);
      });
    });

    group('validateNote', () {
      test('empty note is valid', () => expect(validateNote(''), isNull));
      test('valid note', () => expect(validateNote('Test note'), isNull));
      test('note too long', () {
        expect(validateNote('a' * 201), isNotNull);
      });
    });
  });

  // ── ExpenseTracker Tests ───────────────────────────────────────────
  group('ExpenseTracker', () {
    late ExpenseTracker tracker;
    late StorageService storage;
    late String tempFile;

    setUp(() async {
      tempFile = 'test_expenses_${DateTime.now().millisecondsSinceEpoch}.json';
      storage = StorageService(filePath: tempFile);
      tracker = ExpenseTracker(storage: storage);
    });

    tearDown(() async {
      await storage.deleteFile();
    });

    test('addExpense - expense ထည့်သည်', () async {
      final expense = await tracker.addExpense(
        title: 'Coffee',
        amount: 3.50,
        category: 'Food',
      );
      expect(expense.title, equals('Coffee'));
      expect(expense.amount, equals(3.50));
      expect(expense.id, isNotEmpty);
    });

    test('getAllExpenses - list ပြန်ပေးသည်', () async {
      await tracker.addExpense(title: 'A', amount: 10, category: 'Food');
      await tracker.addExpense(title: 'B', amount: 20, category: 'Transport');

      final all = await tracker.getAllExpenses();
      expect(all.length, equals(2));
    });

    test('deleteExpense - ဖျက်ပြီးနောက် မရှိရ', () async {
      final e = await tracker.addExpense(
        title: 'Delete Me',
        amount: 5,
        category: 'Other',
      );
      final deleted = await tracker.deleteExpense(e.id);
      expect(deleted, isTrue);

      final found = await tracker.findById(e.id);
      expect(found, isNull);
    });

    test('deleteExpense - မရှိသော ID false ပြန်ပေးသည်', () async {
      final result = await tracker.deleteExpense('nonexistent');
      expect(result, isFalse);
    });

    test('updateExpense - field ပြင်သည်', () async {
      final e = await tracker.addExpense(
        title: 'Old Title',
        amount: 100,
        category: 'Food',
      );
      final updated =
          await tracker.updateExpense(e.id, title: 'New Title', amount: 150);

      expect(updated, isNotNull);
      expect(updated!.title, equals('New Title'));
      expect(updated.amount, equals(150));
      expect(updated.category, equals('Food')); // unchanged
    });

    test('updateExpense - မရှိသော ID null ပြန်ပေးသည်', () async {
      final result = await tracker.updateExpense('ghost', title: 'X');
      expect(result, isNull);
    });

    test('getTotalAmount - မှန်ကန်သည်', () async {
      await tracker.addExpense(title: 'A', amount: 10, category: 'Food');
      await tracker.addExpense(title: 'B', amount: 25.50, category: 'Food');
      final total = await tracker.getTotalAmount();
      expect(total, closeTo(35.50, 0.001));
    });

    test('getByCategory - filter မှန်ကန်သည်', () async {
      await tracker.addExpense(title: 'Bus', amount: 2, category: 'Transport');
      await tracker.addExpense(title: 'Meal', amount: 8, category: 'Food');
      await tracker.addExpense(
          title: 'Taxi', amount: 15, category: 'Transport');

      final transport = await tracker.getByCategory('Transport');
      expect(transport.length, equals(2));
      expect(transport.every((e) => e.category == 'Transport'), isTrue);
    });

    test('getSummaryByCategory - total + percentage ပါသော records', () async {
      await tracker.addExpense(title: 'Lunch', amount: 10, category: 'Food');
      await tracker.addExpense(title: 'Dinner', amount: 15, category: 'Food');
      await tracker.addExpense(title: 'Bus', amount: 5, category: 'Transport');

      final summary = await tracker.getSummaryByCategory();
      expect(summary, hasLength(2));

      final food = summary.firstWhere((s) => s.category == 'Food');
      expect(food.total, closeTo(25, 0.001));
      expect(food.percentage, closeTo(83.33, 0.01)); // 25 / 30 * 100

      final transport = summary.firstWhere((s) => s.category == 'Transport');
      expect(transport.total, closeTo(5, 0.001));
      expect(transport.percentage, closeTo(16.67, 0.01));

      // total ကြီးသည့်အစဉ် စီထားသည်
      expect(summary.first.category, equals('Food'));
      expect(summary.last.category, equals('Transport'));
    });

    test('getSummaryByCategory - empty ဆိုလျှင် empty list', () async {
      final summary = await tracker.getSummaryByCategory();
      expect(summary, isEmpty);
    });

    test('Persistence - data ကို reload ပြီးမှ ရနိုင်သည်', () async {
      await tracker.addExpense(
          title: 'Persist Me', amount: 99, category: 'Health');

      // Tracker အသစ် တည်ဆောက်ပြီး ဖိုင်မှ ဖတ်မည်
      final tracker2 =
          ExpenseTracker(storage: StorageService(filePath: tempFile));
      final all = await tracker2.getAllExpenses();

      expect(all.any((e) => e.title == 'Persist Me'), isTrue);
    });

    test('count - မှန်ကန်သည်', () async {
      expect(await tracker.count, equals(0));
      await tracker.addExpense(title: 'X', amount: 1, category: 'Other');
      expect(await tracker.count, equals(1));
    });
  });

  // ── StorageService Tests ──────────────────────────────────────────
  group('StorageService', () {
    late StorageService storage;
    late String tempFile;

    setUp(() {
      tempFile = 'test_storage_${DateTime.now().millisecondsSinceEpoch}.json';
      storage = StorageService(filePath: tempFile);
    });

    tearDown(() async {
      await storage.deleteFile();
    });

    test('loadExpenses - ဖိုင်မရှိလျှင် empty list', () async {
      final result = await storage.loadExpenses();
      expect(result, isEmpty);
    });

    test('saveExpenses then loadExpenses - round-trip', () async {
      final expenses = [
        Expense(
          id: 'st1',
          title: 'Storage Test',
          amount: 42.0,
          category: 'Other',
          date: DateTime(2024, 6, 1),
        ),
      ];

      final saved = await storage.saveExpenses(expenses);
      expect(saved, isTrue);

      final loaded = await storage.loadExpenses();
      expect(loaded.length, equals(1));
      expect(loaded.first.title, equals('Storage Test'));
    });

    test('deleteFile - ဖျက်ပြီးနောက် မရှိရ', () async {
      await storage.saveExpenses([]);
      expect(await storage.fileExists(), isTrue);
      await storage.deleteFile();
      expect(await storage.fileExists(), isFalse);
    });
  });
}
