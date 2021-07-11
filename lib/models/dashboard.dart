class DashboardData {
  String siteCount;
  String totalIncome;
  String totalExpenses;
  String totalSuppliers;
  num availableAmount;

  DashboardData({this.siteCount, this.totalIncome, this.totalExpenses, this.totalSuppliers, this.availableAmount});

  DashboardData.fromJson(Map<String, dynamic> json) {
    siteCount = json['siteCount'];
    totalIncome = json['totalIncome'];
    totalExpenses = json['totalExpenses'];
    totalSuppliers = json['totalSuppliers'];
    availableAmount = json['availableAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['siteCount'] = this.siteCount;
    data['totalIncome'] = this.totalIncome;
    data['totalExpenses'] = this.totalExpenses;
    data['totalSuppliers'] = this.totalSuppliers;
    data['availableAmount'] = this.availableAmount;
    return data;
  }
}
