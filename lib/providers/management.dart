import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:thousandbricks/models/expenses.dart';
import 'package:thousandbricks/models/income.dart';
import 'package:thousandbricks/models/sites.dart';
import 'package:thousandbricks/models/stock.dart';
import 'package:thousandbricks/models/suppliers.dart';
import 'package:thousandbricks/utils/dio.dart';

class ManagementProvider with ChangeNotifier {
  Sites _siteManagement;
  Sites get siteManagement => _siteManagement;

  Suppliers _supplierManagement;
  Suppliers get supplierManagement => _supplierManagement;

  Income _incomeManagement;
  Income get incomeManagement => _incomeManagement;

  Expenses _generalExpenceManagement;
  Expenses get generalExpenceManagement => _generalExpenceManagement;

  Stocks _stockManagement;
  Stocks get stockManagement => _stockManagement;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void getAllSites() async {
    _isLoading = true;
    notifyListeners();
    try {
      var responce = await dio.get(
        'https://1000bricks.meatmatestore.in/thousandBricksApi/getSiteDetails.php?type=all',
      );
      print(responce);
      _siteManagement = Sites.fromJson(jsonDecode(responce.data));
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  void getAllSuppliers() async {
    _isLoading = true;
    notifyListeners();
    try {
      var responce = await dio.get(
        'http://1000bricks.meatmatestore.in/thousandBricksApi/getSupplierDetails.php?type=all',
      );
      print(responce);
      _supplierManagement = Suppliers.fromJson(jsonDecode(responce.data));
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  void getAllIncome() async {
    _isLoading = true;
    notifyListeners();
    try {
      var responce = await dio.get(
        'http://1000bricks.meatmatestore.in/thousandBricksApi/getIncomeDetails.php?type=all',
      );
      print(responce);
      _incomeManagement = Income.fromJson(jsonDecode(responce.data));
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  void getAllGeneralExpenses() async {
    _isLoading = true;
    notifyListeners();
    try {
      var responce = await dio.get(
        'http://1000bricks.meatmatestore.in/thousandBricksApi/getExpenseDetails.php?type=all',
      );
      print(responce);
      _generalExpenceManagement = Expenses.fromJson(jsonDecode(responce.data));
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  void getAllStock() async {
    _isLoading = true;
    notifyListeners();
    try {
      var responce = await dio.get(
        'https://1000bricks.meatmatestore.in/thousandBricksApi/getStockDetails.php?type=all',
      );
      print(responce);
      _stockManagement = Stocks.fromJson(jsonDecode(responce.data));
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
      _isLoading = false;
      notifyListeners();
    }
  }
}
