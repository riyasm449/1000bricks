class Suppliers {
  List<Data> data;

  Suppliers({this.data});

  Suppliers.fromJson(Map<String, dynamic> json) {
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
  String companyName;
  String contactPerson;
  String contactNumber;
  String alternateContactNumber;
  String eMail;
  String bankAccountDetails;
  String address;
  String gstNumber;

  Data(
      {this.id,
      this.companyName,
      this.contactPerson,
      this.contactNumber,
      this.alternateContactNumber,
      this.eMail,
      this.bankAccountDetails,
      this.address,
      this.gstNumber});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['companyName'];
    contactPerson = json['contactPerson'];
    contactNumber = json['contactNumber'];
    alternateContactNumber = json['alternateContactNumber'];
    eMail = json['eMail'];
    bankAccountDetails = json['bankAccountDetails'];
    address = json['address'];
    gstNumber = json['gstNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['companyName'] = this.companyName;
    data['contactPerson'] = this.contactPerson;
    data['contactNumber'] = this.contactNumber;
    data['alternateContactNumber'] = this.alternateContactNumber;
    data['eMail'] = this.eMail;
    data['bankAccountDetails'] = this.bankAccountDetails;
    data['address'] = this.address;
    data['gstNumber'] = this.gstNumber;
    return data;
  }
}
