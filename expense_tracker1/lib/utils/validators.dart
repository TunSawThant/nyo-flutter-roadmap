/// Input validation utilities

/// Valid expense categories
const List<String> validCategories = [
  'Food',
  'Transport',
  'Health',
  'Shopping',
  'Entertainment',
  'Utilities',
  'Other',
];

/// Title စစ်ဆေးသည် (empty မဖြစ်ရ၊ 100 char အောက်)
String? validateTitle(String? title) {
  if (title == null || title.trim().isEmpty) {
    return 'Title မထည့်ရသေး။';
  }
  if (title.trim().length > 100) {
    return 'Title သည် 100 လုံးထက်မပိုရ။';
  }
  return null; // valid
}

/// Amount စစ်ဆေးသည် (positive number ဖြစ်ရမည်)
String? validateAmount(String? input) {
  if (input == null || input.trim().isEmpty) {
    return 'Amount မထည့်ရသေး။';
  }
  final amount = double.tryParse(input.trim());
  if (amount == null) {
    return 'Amount သည် ဂဏန်းဖြစ်ရမည်။';
  }
  if (amount <= 0) {
    return 'Amount သည် သုည (0) ထက် ကြီးရမည်။';
  }
  if (amount > 1000000000) {
    return 'Amount သည် 1,000,000,000 ထက် မကြီးရ။';
  }
  return null;
}

/// Category စစ်ဆေးသည်
String? validateCategory(String? category) {
  if (category == null || category.trim().isEmpty) {
    return 'Category မရွေးရသေး။';
  }
  if (!validCategories
      .map((c) => c.toLowerCase())
      .contains(category.trim().toLowerCase())) {
    return 'Category မမှန်ကန်။ ရွေးချယ်ရန် - ${validCategories.join(', ')}';
  }
  return null;
}

/// Date string စစ်ဆေးသည် (YYYY-MM-DD format)
String? validateDate(String? input) {
  if (input == null || input.trim().isEmpty) {
    return null; // optional - empty ဆိုရင် ယနေ့ကို default သုံးမည်
  }
  try {
    final date = DateTime.parse(input.trim());
    if (date.isAfter(DateTime.now().add(const Duration(days: 1)))) {
      return 'Date သည် နောင်ရက်ဖြစ်၍ မသုံးနိုင်။';
    }
    return null;
  } catch (_) {
    return 'Date format မှားနေသည်။ YYYY-MM-DD format သုံးပါ။';
  }
}

/// ID စစ်ဆေးသည်
String? validateId(String? id) {
  if (id == null || id.trim().isEmpty) {
    return 'ID မထည့်ရသေး။';
  }
  return null;
}

/// Note စစ်ဆေးသည် (optional, 200 char limit)
String? validateNote(String? note) {
  if (note == null || note.trim().isEmpty) {
    return null; // optional
  }
  if (note.trim().length > 200) {
    return 'Note သည် 200 လုံးထက်မပိုရ။';
  }
  return null;
}
