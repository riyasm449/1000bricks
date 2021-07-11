import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:thousandbricks/models/dashboard.dart';
import 'package:thousandbricks/utils/dio.dart';

class DashboardProvider extends ChangeNotifier {
  DashboardData _dashboardData;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  DashboardData get dashboardData => _dashboardData;
  void getDashboardData() async {
    _isLoading = true;
    notifyListeners();
    try {
      var responce = await dio.get(
        'http://1000bricks.meatmatestore.in/thousandBricksApi/getDataForDashboard.php',
      );
      _dashboardData = DashboardData.fromJson(jsonDecode(responce.data));
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
      _isLoading = false;
      notifyListeners();
    }
  }
}
