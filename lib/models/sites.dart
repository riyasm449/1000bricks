class Sites {
  List<Data> data;

  Sites({this.data});

  Sites.fromJson(Map<String, dynamic> json) {
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
  String siteName;
  String siteLocation;
  String clientName;
  String clientBillingAddress;
  String clientGst;
  String contactMailId;
  String mobileNumber;
  String categoryOfWork;
  String projectStartedOn;
  String estimatedCompletionOfProject;
  String statusOfProject;

  Data(
      {this.id,
      this.siteName,
      this.siteLocation,
      this.clientName,
      this.clientBillingAddress,
      this.clientGst,
      this.contactMailId,
      this.mobileNumber,
      this.categoryOfWork,
      this.projectStartedOn,
      this.estimatedCompletionOfProject,
      this.statusOfProject});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    siteName = json['siteName'];
    siteLocation = json['siteLocation'];
    clientName = json['clientName'];
    clientBillingAddress = json['clientBillingAddress'];
    clientGst = json['clientGst'];
    contactMailId = json['contactMailId'];
    mobileNumber = json['mobileNumber'];
    categoryOfWork = json['categoryOfWork'];
    projectStartedOn = json['projectStartedOn'];
    estimatedCompletionOfProject = json['estimatedCompletionOfProject'];
    statusOfProject = json['statusOfProject'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['siteName'] = this.siteName;
    data['siteLocation'] = this.siteLocation;
    data['clientName'] = this.clientName;
    data['clientBillingAddress'] = this.clientBillingAddress;
    data['clientGst'] = this.clientGst;
    data['contactMailId'] = this.contactMailId;
    data['mobileNumber'] = this.mobileNumber;
    data['categoryOfWork'] = this.categoryOfWork;
    data['projectStartedOn'] = this.projectStartedOn;
    data['estimatedCompletionOfProject'] = this.estimatedCompletionOfProject;
    data['statusOfProject'] = this.statusOfProject;
    return data;
  }
}
