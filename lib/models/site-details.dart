class SiteDetails {
  List<Data> data;

  SiteDetails({this.data});

  SiteDetails.fromJson(Map<String, dynamic> json) {
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
  List<EstimationAndBoqFile> estimationAndBoqFile;
  List estimationAndBoqLink;
  List<ThreeDRenderFile> threeDRendersFile;
  List threeDRendersLink;
  List<DrawingFile> drawingsFile;
  List drawingsLink;

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
      this.statusOfProject,
      this.estimationAndBoqFile,
      this.estimationAndBoqLink,
      this.threeDRendersFile,
      this.threeDRendersLink,
      this.drawingsFile,
      this.drawingsLink});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    siteName = json['siteName'] ?? '';
    siteLocation = json['siteLocation'] ?? '';
    clientName = json['clientName'] ?? '';
    clientBillingAddress = json['clientBillingAddress'] ?? '';
    clientGst = json['clientGst'] ?? '';
    contactMailId = json['contactMailId'] ?? '';
    mobileNumber = json['mobileNumber'] ?? '';
    categoryOfWork = json['categoryOfWork'] ?? '';
    projectStartedOn = json['projectStartedOn'] ?? '';
    estimatedCompletionOfProject = json['estimatedCompletionOfProject'] ?? '';
    statusOfProject = json['statusOfProject'] ?? '';
    estimationAndBoqLink = json['estimationAndBoqLink'] ?? [];
    threeDRendersLink = json['threeDRendersLink'] ?? [];
    drawingsLink = json['drawingsLink'] ?? [];
    if (json['estimationAndBoqFile'] != null) {
      estimationAndBoqFile = new List<EstimationAndBoqFile>();
      json['estimationAndBoqFile'].forEach((v) {
        estimationAndBoqFile.add(new EstimationAndBoqFile.fromJson(v));
      });
    }
    if (json['threeDRendersFile'] != null) {
      threeDRendersFile = new List<ThreeDRenderFile>();
      json['threeDRendersFile'].forEach((v) {
        threeDRendersFile.add(new ThreeDRenderFile.fromJson(v));
      });
    }
    if (json['drawingsFile'] != null) {
      drawingsFile = new List<DrawingFile>();
      json['drawingsFile'].forEach((v) {
        drawingsFile.add(new DrawingFile.fromJson(v));
      });
    }
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
    if (this.estimationAndBoqFile != null) {
      data['estimationAndBoqFile'] = this.estimationAndBoqFile.map((v) => v.toJson()).toList();
    }
    if (this.threeDRendersFile != null) {
      data['threeDRendersFile'] = this.threeDRendersFile.map((v) => v.toJson()).toList();
    }
    if (this.drawingsFile != null) {
      data['drawingsFile'] = this.drawingsFile.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EstimationAndBoqFile {
  String id;
  String fileUrl;

  EstimationAndBoqFile({this.id, this.fileUrl});

  EstimationAndBoqFile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fileUrl = json['fileUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fileUrl'] = this.fileUrl;
    return data;
  }
}

class ThreeDRenderFile {
  String id;
  String fileUrl;

  ThreeDRenderFile({this.id, this.fileUrl});

  ThreeDRenderFile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fileUrl = json['fileUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fileUrl'] = this.fileUrl;
    return data;
  }
}

class DrawingFile {
  String id;
  String fileUrl;

  DrawingFile({this.id, this.fileUrl});

  DrawingFile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fileUrl = json['fileUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fileUrl'] = this.fileUrl;
    return data;
  }
}
