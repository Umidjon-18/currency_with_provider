import 'package:flutter/material.dart';

import '../model/currency_model.dart';

class CurrencyProvider extends ChangeNotifier {
  final List<CurrencyModel> filterList = [];
  final TextEditingController editingController = TextEditingController();

  updatePage() {
    notifyListeners();
  }

  clear() {
    filterList.clear();
    editingController.clear();
  }

  onDispose() {
    editingController.dispose();
  }
}
