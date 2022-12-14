import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:currency_with_provider/utils/hive_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../../utils/constants.dart';
import '../model/currency_model.dart';

enum ComparePageState { isInit, isBusy, isDone, isError }

class CompareProvider extends ChangeNotifier with HiveUtil {
  final TextEditingController editingControllerTop = TextEditingController();
  final TextEditingController editingControllerBottom = TextEditingController();
  final FocusNode topFocus = FocusNode();
  final FocusNode bottomFocus = FocusNode();
  List<CurrencyModel> listCurrency = [];
  CurrencyModel? topCur;
  CurrencyModel? bottomCur;
  ComparePageState state = ComparePageState.isInit;

  focuseChecker() {
    editingControllerTop.addListener(() {
      if (topFocus.hasFocus) {
        if (editingControllerTop.text.isNotEmpty) {
          double sum = double.parse(topCur?.rate ?? '0') /
              double.parse(bottomCur?.rate ?? '0') *
              double.parse(editingControllerTop.text);
          editingControllerBottom.text = sum.toStringAsFixed(2);
        } else {
          editingControllerBottom.clear();
        }
      }
    });
    editingControllerBottom.addListener(() {
      if (bottomFocus.hasFocus) {
        if (editingControllerBottom.text.isNotEmpty) {
          double sum = double.parse(bottomCur?.rate ?? '0') /
              double.parse(topCur?.rate ?? '0') *
              double.parse(editingControllerBottom.text);
          editingControllerTop.text = sum.toStringAsFixed(2);
        } else {
          editingControllerTop.clear();
        }
      }
    });
  }

  Future loadData() async {
    state = ComparePageState.isBusy;
    notifyListeners();
    var isLoad = await loadLocalData();
    if (isLoad) {
      try {
        var response = await get(
            Uri.parse('https://cbu.uz/uz/arkhiv-kursov-valyut/json/'));
        if (response.statusCode == 200) {
          for (final item in jsonDecode(response.body)) {
            var model = CurrencyModel.fromJson(item);
            if (model.ccy == 'USD') {
              topCur = model;
            } else if (model.ccy == 'RUB') {
              bottomCur = model;
            }
            listCurrency.add(model);
            await saveBox<String>(dateBox, topCur?.date ?? '', key: dateKey);
            await saveBox<List<dynamic>>(currencyBox, listCurrency,
                key: currencyListKey);
          }
          state = ComparePageState.isDone;
          notifyListeners();
        } else {
          state = ComparePageState.isError;
          notifyListeners();
        }
      } on SocketException {
        state = ComparePageState.isError;
        notifyListeners();
      } catch (e) {
        state = ComparePageState.isError;
        notifyListeners();
      }
    } else {
      state = ComparePageState.isDone;
      notifyListeners();
    }
  }

  Future<bool> loadLocalData() async {
    try {
      var date = await getBox<String>(dateBox, key: dateKey);
      if (date ==
          DateFormat('dd.MM.yyyy')
              .format(DateTime.now().add(const Duration(days: -1)))) {
        var list =
            await getBox<List<dynamic>>(currencyBox, key: currencyListKey) ??
                [];
        listCurrency = List.castFrom<dynamic, CurrencyModel>(list);
        for (var model in listCurrency) {
          if (model.ccy == 'USD') {
            topCur = model;
          } else if (model.ccy == 'RUB') {
            bottomCur = model;
          }
        }
        return false;
      } else {
        return true;
      }
    } catch (e) {
      log(e.toString());
    }
    return true;
  }

  exchanger() {
    var model = topCur?.copyWith();
    topCur = bottomCur?.copyWith();
    bottomCur = model;
    editingControllerTop.clear();
    editingControllerBottom.clear();
    notifyListeners();
  }

  setValue(int position, value) {
    if (position == 1) {
      topCur = value;
    } else {
      bottomCur = value;
    }
    notifyListeners();
  }

  updatePage() {
    notifyListeners();
  }

  onDispose() {
    editingControllerTop.dispose();
    editingControllerBottom.dispose();
    topFocus.dispose();
    bottomFocus.dispose();
  }
}
