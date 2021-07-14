class DashboardData {
  var siteCount;
  var totalIncome;
  var totalGeneralExpenses;
  var totalSuppliers;
  var totalSiteExpense;
  var totalSupplierPayManagementAmount;
  var availableAmount;
  var outStandingAmount;

  DashboardData(
      {this.siteCount,
      this.totalIncome,
      this.totalGeneralExpenses,
      this.totalSuppliers,
      this.totalSiteExpense,
      this.totalSupplierPayManagementAmount,
      this.availableAmount,
      this.outStandingAmount});

  DashboardData.fromJson(Map<String, dynamic> json) {
    siteCount = json['siteCount'] ?? 0;
    totalIncome = json['totalIncome'] ?? 0;
    totalGeneralExpenses = json['totalGeneralExpenses'] ?? 0;
    totalSuppliers = json['totalSuppliers'] ?? 0;
    totalSiteExpense = json['totalSiteExpense'] ?? 0;
    totalSupplierPayManagementAmount = json['totalSupplierPayManagementAmount'] ?? 0;
    availableAmount = json['availableAmount'] ?? 0;
    outStandingAmount = json['outStandingAmount'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['siteCount'] = this.siteCount;
    data['totalIncome'] = this.totalIncome;
    data['totalGeneralExpenses'] = this.totalGeneralExpenses;
    data['totalSuppliers'] = this.totalSuppliers;
    data['totalSiteExpense'] = this.totalSiteExpense;
    data['totalSupplierPayManagementAmount'] = this.totalSupplierPayManagementAmount;
    data['availableAmount'] = this.availableAmount;
    data['outStandingAmount'] = this.outStandingAmount;
    return data;
  }
}
