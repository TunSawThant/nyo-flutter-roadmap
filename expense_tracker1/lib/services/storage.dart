import 'dart:convert';
import 'dart:io';

import '../models/expense.dart';

/// JSON ဖိုင်တွင် Expense data သိမ်းခြင်းနှင့် ဖတ်ခြင်း
class StorageService {
  final String filePath;

  StorageService({this.filePath = 'expenses.json'});

  File get _file => File(filePath);

  /// ဖိုင်မှ expenses list ဖတ်ယူသည် (async)
  Future<List<Expense>> loadExpenses() async {
    try {
      if (!await _file.exists()) {
        return [];
      }

      final content = await _file.readAsString();
      if (content.trim().isEmpty) {
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(content) as List<dynamic>;
      return jsonList
          .map((json) => Expense.fromJson(json as Map<String, dynamic>))
          .toList();
    } on FormatException catch (e) {
      stderr.writeln('[Storage Error] JSON parse မအောင်မြင်: $e');
      return [];
    } on IOException catch (e) {
      stderr.writeln('[Storage Error] ဖိုင်ဖတ်မရ: $e');
      return [];
    }
  }

  /// expenses list ကို ဖိုင်တွင် သိမ်းသည် (async)
  Future<bool> saveExpenses(List<Expense> expenses) async {
    try {
      final jsonList = expenses.map((e) => e.toJson()).toList();
      final content = const JsonEncoder.withIndent('  ').convert(jsonList);
      await _file.writeAsString(content, flush: true);
      return true;
    } on IOException catch (e) {
      stderr.writeln('[Storage Error] ဖိုင်သိမ်းမရ: $e');
      return false;
    }
  }

  /// ဖိုင်ရှိ/မရှိ စစ်ဆေးသည်
  Future<bool> fileExists() => _file.exists();

  /// Data file ဖျက်သည် (testing အတွက်)
  Future<bool> deleteFile() async {
    try {
      if (await _file.exists()) {
        await _file.delete();
      }
      return true;
    } on IOException catch (e) {
      stderr.writeln('[Storage Error] ဖိုင်ဖျက်မရ: $e');
      return false;
    }
  }
}
