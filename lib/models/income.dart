class Income {
  List<IncomeData> data;

  Income({this.data});

  Income.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<IncomeData>();
      json['data'].forEach((v) {
        data.add(new IncomeData.fromJson(v));
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

class IncomeData {
  String id;
  String site;
  String date;
  String amount;
  String modeOfPayment;
  String comment;

  IncomeData({this.id, this.site, this.date, this.amount, this.modeOfPayment, this.comment});

  IncomeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    site = json['site'];
    date = json['date'];
    amount = json['amount'];
    modeOfPayment = json['modeOfPayment'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['site'] = this.site;
    data['date'] = this.date;
    data['amount'] = this.amount;
    data['modeOfPayment'] = this.modeOfPayment;
    data['comment'] = this.comment;
    return data;
  }
}
