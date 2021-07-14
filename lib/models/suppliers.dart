class Suppliers {
  List<SupplierData> data;

  Suppliers({this.data});

  Suppliers.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<SupplierData>();
      json['data'].forEach((v) {
        data.add(new SupplierData.fromJson(v));
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

class SupplierData {
  String id;
  String companyName;
  String contactPerson;
  String contactNumber;
  String alternateContactNumber;
  String eMail;
  String accountNumber;
  String bankName;
  String bankBranch;
  String ifscCode;
  String stockTotalAmount;
  String supplierPayManagementTotalAmount;
  String address;
  String gstNumber;

  SupplierData(
      {this.id,
      this.companyName,
      this.contactPerson,
      this.contactNumber,
      this.alternateContactNumber,
      this.eMail,
      this.accountNumber,
      this.bankName,
      this.bankBranch,
      this.ifscCode,
      this.stockTotalAmount,
      this.supplierPayManagementTotalAmount,
      this.address,
      this.gstNumber});

  SupplierData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    companyName = json['companyName'] ?? '';
    contactPerson = json['contactPerson'] ?? '';
    contactNumber = json['contactNumber'] ?? '';
    alternateContactNumber = json['alternateContactNumber'] ?? '';
    eMail = json['eMail'] ?? '';
    accountNumber = json['accountNumber'] ?? '';
    bankName = json['bankName'] ?? '';
    bankBranch = json['bankBranch'] ?? '';
    ifscCode = json['ifscCode'] ?? '';
    stockTotalAmount = json['stockTotalAmount'] ?? '';
    supplierPayManagementTotalAmount = json['supplierPayManagementTotalAmount'] ?? '';
    address = json['address'] ?? '0';
    gstNumber = json['gstNumber'] ?? '0';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['companyName'] = this.companyName;
    data['contactPerson'] = this.contactPerson;
    data['contactNumber'] = this.contactNumber;
    data['alternateContactNumber'] = this.alternateContactNumber;
    data['eMail'] = this.eMail;
    data['accountNumber'] = this.accountNumber;
    data['bankName'] = this.bankName;
    data['bankBranch'] = this.bankBranch;
    data['ifscCode'] = this.ifscCode;
    data['stockTotalAmount'] = this.stockTotalAmount;
    data['supplierPayManagementTotalAmount'] = this.supplierPayManagementTotalAmount;
    return data;
  }
}
