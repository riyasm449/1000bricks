class Expenses {
  List<ExpenseData> data;

  Expenses({this.data});

  Expenses.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<ExpenseData>();
      json['data'].forEach((v) {
        data.add(new ExpenseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ExpenseData {
  String id;
  String dateOfExpense;
  String description;
  String expenseBy;
  String expenseLedger;
  String expenseAmount;
  String remarks;
  String statusOfReimbursement;
  String reimbursementDate;
  String authorisedBy;

  ExpenseData(
      {this.id,
      this.dateOfExpense,
      this.description,
      this.expenseBy,
      this.expenseLedger,
      this.expenseAmount,
      this.remarks,
      this.statusOfReimbursement,
      this.reimbursementDate,
      this.authorisedBy});

  ExpenseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateOfExpense = json['dateOfExpense'];
    description = json['description'];
    expenseBy = json['expenseBy'];
    expenseLedger = json['expenseLedger'];
    expenseAmount = json['expenseAmount'];
    remarks = json['remarks'];
    statusOfReimbursement = json['statusOfReimbursement'];
    reimbursementDate = json['reimbursementDate'];
    authorisedBy = json['authorisedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dateOfExpense'] = this.dateOfExpense;
    data['description'] = this.description;
    data['expenseBy'] = this.expenseBy;
    data['expenseLedger'] = this.expenseLedger;
    data['expenseAmount'] = this.expenseAmount;
    data['remarks'] = this.remarks;
    data['statusOfReimbursement'] = this.statusOfReimbursement;
    data['reimbursementDate'] = this.reimbursementDate;
    data['authorisedBy'] = this.authorisedBy;
    return data;
  }
}
