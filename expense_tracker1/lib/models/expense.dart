import 'dart:convert';

/// Expense ကို ကိုယ်စားပြုသည့် model class
class Expense {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String? note;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
  });

  /// JSON မှ Expense object ပြောင်းသည်
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
      note: json['note'] as String?,
    );
  }

  /// Expense object မှ JSON ပြောင်းသည်
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  /// JSON string ထုတ်သည်
  String toJsonString() => jsonEncode(toJson());

  @override
  String toString() {
    return 'Expense(id: $id, title: $title, amount: $amount, '
        'category: $category, date: ${date.toLocal()}, note: $note)';
  }

  /// ပြသမည့် ရိုးရိုး summary
  String get summary {
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return '[$id] $title | \$${amount.toStringAsFixed(2)} | $category | $dateStr'
        '${note != null ? ' | $note' : ''}';
  }
}
