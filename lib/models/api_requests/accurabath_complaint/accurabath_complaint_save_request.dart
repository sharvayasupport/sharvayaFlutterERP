class AccuraBathComplaintSaveRequest {
  String ComplaintDate;

  String ComplaintNo;

  String CustomerEmpName;

  String ReferenceName;

  String ComplaintNotes;

  String ComplaintType;

  String ComplaintStatus;

  String EmployeeID;

  String PreferredDate;

  String TimeFrom;

  String TimeTo;

  String LoginUserID;

  String CompanyId;

  String CustmoreMobileNo;
  String DateOfPurchase;

  String SiteAddress;

  String CityCode;

  String CountryCode;

  String StateCode;

  String Pincode;

  String ConvinientDate;

  String ProductID;

  String SrNo;

  AccuraBathComplaintSaveRequest({
    this.ComplaintDate,
    this.ComplaintNo,
    this.CustomerEmpName,
    this.ReferenceName,
    this.ComplaintNotes,
    this.ComplaintType,
    this.ComplaintStatus,
    this.EmployeeID,
    this.PreferredDate,
    this.TimeFrom,
    this.TimeTo,
    this.LoginUserID,
    this.CompanyId,
    this.CustmoreMobileNo,
    this.DateOfPurchase,
    this.SiteAddress,
    this.CityCode,
    this.CountryCode,
    this.StateCode,
    this.Pincode,
    this.ConvinientDate,
    this.ProductID,
    this.SrNo,
  });

  AccuraBathComplaintSaveRequest.fromJson(Map<String, dynamic> json) {
    ComplaintDate = json['ComplaintDate'];
    ComplaintNo = json['ComplaintNo'];
    CustomerEmpName = json['CustomerEmpName'];
    ReferenceName = json['ReferenceName'];
    ComplaintNotes = json['ComplaintNotes'];
    ComplaintType = json['ComplaintType'];
    ComplaintStatus = json['ComplaintStatus'];
    EmployeeID = json['EmployeeID'];
    PreferredDate = json['PreferredDate'];
    TimeFrom = json['TimeFrom'];
    TimeTo = json['TimeTo'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
    CustmoreMobileNo = json['CustmoreMobileNo'];
    DateOfPurchase = json['DateOfPurchase'];
    SiteAddress = json['SiteAddress'];
    CityCode = json['CityCode'];
    CountryCode = json['CountryCode'];
    StateCode = json['StateCode'];
    Pincode = json['Pincode'];
    ConvinientDate = json['ConvinientDate'];
    ProductID = json['ProductID'];
    SrNo = json['SrNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ComplaintDate'] = this.ComplaintDate;
    data['ComplaintDate'] = this.ComplaintDate;
    data['ComplaintNo'] = this.ComplaintNo;
    data['CustomerEmpName'] = this.CustomerEmpName;
    data['ReferenceName'] = this.ReferenceName;
    data['ComplaintNotes'] = this.ComplaintNotes;
    data['ComplaintType'] = this.ComplaintType;
    data['ComplaintStatus'] = this.ComplaintStatus;
    data['EmployeeID'] = this.EmployeeID;
    data['PreferredDate'] = this.PreferredDate;
    data['TimeFrom'] = this.TimeFrom;
    data['TimeTo'] = this.TimeTo;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;
    data['CustmoreMobileNo'] = this.CustmoreMobileNo;
    data['DateOfPurchase'] = this.DateOfPurchase;
    data['SiteAddress'] = this.SiteAddress;
    data['CityCode'] = this.CityCode;
    data['CountryCode'] = this.CountryCode;
    data['StateCode'] = this.StateCode;
    data['Pincode'] = this.Pincode;
    data['ConvinientDate'] = this.ConvinientDate;
    data['ProductID'] = this.ProductID;
    data['SrNo'] = this.SrNo;

    return data;
  }
}
