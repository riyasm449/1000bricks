class Stocks {
  List<Data> data;

  Stocks({this.data});

  Stocks.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
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

class Data {
  String id;
  String siteId;
  String siteName;
  String supplierId;
  String supplierName;
  String date;
  String category;
  String subCategory;
  String quantity;
  String amount;
  String totalAmount;
  String comment;

  Data(
      {this.id,
      this.siteId,
      this.siteName,
      this.supplierId,
      this.supplierName,
      this.date,
      this.category,
      this.subCategory,
      this.quantity,
      this.amount,
      this.totalAmount,
      this.comment});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    siteId = json['siteId'];
    siteName = json['siteName'];
    supplierId = json['supplierId'];
    supplierName = json['supplierName'];
    date = json['date'];
    category = json['category'];
    subCategory = json['subCategory'];
    quantity = json['quantity'];
    amount = json['amount'];
    totalAmount = json['totalAmount'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['siteId'] = this.siteId;
    data['siteName'] = this.siteName;
    data['supplierId'] = this.supplierId;
    data['supplierName'] = this.supplierName;
    data['date'] = this.date;
    data['category'] = this.category;
    data['subCategory'] = this.subCategory;
    data['quantity'] = this.quantity;
    data['amount'] = this.amount;
    data['totalAmount'] = this.totalAmount;
    data['comment'] = this.comment;
    return data;
  }
}
