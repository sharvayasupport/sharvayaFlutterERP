class AccuraBathComplaintListResponse {
  List<AccuraBathComplaintListResponseDetails> details;
  int totalCount;

  AccuraBathComplaintListResponse({this.details, this.totalCount});

  AccuraBathComplaintListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new AccuraBathComplaintListResponseDetails.fromJson(v));
      });
    }
    totalCount = json['TotalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['details'] = this.details.map((v) => v.toJson()).toList();
    }
    data['TotalCount'] = this.totalCount;
    return data;
  }
}

class AccuraBathComplaintListResponseDetails {
  int rowNum;
  int pkID;
  String complaintNo;
  String complaintDate;
  String referenceName;
  String complaintStatus;
  String complaintType;
  String customerName;
  String complaintNotes;
  String preferredDate;
  String timeFrom;
  String timeTo;
  String custmoreMobileNo;
  String dateOfPurchase;
  String siteAddress;
  int cityCode;
  String countryCode;
  String countryName;
  int stateCode;
  String pincode;
  String convinientDate;
  String cityName;
  String stateName;
  int productID;
  String productName;
  String srNo;
  String createdBy;
  String createdDate;
  String createdByEmployee;
  String employeeID;
  String employeeName;
  int complaintDays;

  AccuraBathComplaintListResponseDetails(
      {this.rowNum,
      this.pkID,
      this.complaintNo,
      this.complaintDate,
      this.referenceName,
      this.complaintStatus,
      this.complaintType,
      this.customerName,
      this.complaintNotes,
      this.preferredDate,
      this.timeFrom,
      this.timeTo,
      this.custmoreMobileNo,
      this.dateOfPurchase,
      this.siteAddress,
      this.cityCode,
      this.countryCode,
      this.countryName,
      this.stateCode,
      this.pincode,
      this.convinientDate,
      this.cityName,
      this.stateName,
      this.productID,
      this.productName,
      this.srNo,
      this.createdBy,
      this.createdDate,
      this.createdByEmployee,
      this.employeeID,
      this.employeeName,
      this.complaintDays});

  AccuraBathComplaintListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    complaintNo = json['ComplaintNo'] == null ? "" : json['ComplaintNo'];
    complaintDate = json['ComplaintDate'] == null ? "" : json['ComplaintDate'];
    referenceName = json['ReferenceName'] == null ? "" : json['ReferenceName'];
    complaintStatus =
        json['ComplaintStatus'] == null ? "" : json['ComplaintStatus'];
    complaintType = json['ComplaintType'] == null ? "" : json['ComplaintType'];
    customerName = json['CustomerName'] == null ? "" : json['CustomerName'];
    complaintNotes =
        json['ComplaintNotes'] == null ? "" : json['ComplaintNotes'];
    preferredDate = json['PreferredDate'] == null ? "" : json['PreferredDate'];
    timeFrom = json['TimeFrom'] == null ? "" : json['TimeFrom'];
    timeTo = json['TimeTo'] == null ? "" : json['TimeTo'];
    custmoreMobileNo =
        json['CustmoreMobileNo'] == null ? "" : json['CustmoreMobileNo'];
    dateOfPurchase =
        json['DateOfPurchase'] == null ? "" : json['DateOfPurchase'];
    siteAddress = json['SiteAddress'] == null ? "" : json['SiteAddress'];
    cityCode = json['CityCode'] == null ? 0 : json['CityCode'];
    countryCode = json['CountryCode'] == null ? "" : json['CountryCode'];
    countryName = json['CountryName'] == null ? "" : json['CountryName'];
    stateCode = json['StateCode'] == null ? 0 : json['StateCode'];
    pincode = json['Pincode'] == null ? "" : json['Pincode'];
    convinientDate =
        json['ConvinientDate'] == null ? "" : json['ConvinientDate'];
    cityName = json['CityName'] == null ? "" : json['CityName'];
    stateName = json['StateName'] == null ? "" : json['StateName'];
    productID = json['ProductID'] == null ? 0 : json['ProductID'];
    productName = json['ProductName'] == null ? "" : json['ProductName'];
    srNo = json['SrNo'] == null ? "" : json['SrNo'];
    createdBy = json['CreatedBy'] == null ? "" : json['CreatedBy'];
    createdDate = json['CreatedDate'] == null ? "" : json['CreatedDate'];
    createdByEmployee =
        json['CreatedByEmployee'] == null ? "" : json['CreatedByEmployee'];
    employeeID = json['EmployeeID'] == null ? "" : json['EmployeeID'];
    employeeName = json['EmployeeName'] == null ? "" : json['EmployeeName'];
    complaintDays = json['ComplaintDays'] == null ? "" : json['ComplaintDays'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['ComplaintNo'] = this.complaintNo;
    data['ComplaintDate'] = this.complaintDate;
    data['ReferenceName'] = this.referenceName;
    data['ComplaintStatus'] = this.complaintStatus;
    data['ComplaintType'] = this.complaintType;
    data['CustomerName'] = this.customerName;
    data['ComplaintNotes'] = this.complaintNotes;
    data['PreferredDate'] = this.preferredDate;
    data['TimeFrom'] = this.timeFrom;
    data['TimeTo'] = this.timeTo;
    data['CustmoreMobileNo'] = this.custmoreMobileNo;
    data['DateOfPurchase'] = this.dateOfPurchase;
    data['SiteAddress'] = this.siteAddress;
    data['CityCode'] = this.cityCode;
    data['CountryCode'] = this.countryCode;
    data['CountryName'] = this.countryName;
    data['StateCode'] = this.stateCode;
    data['Pincode'] = this.pincode;
    data['ConvinientDate'] = this.convinientDate;
    data['CityName'] = this.cityName;
    data['StateName'] = this.stateName;
    data['ProductID'] = this.productID;
    data['ProductName'] = this.productName;
    data['SrNo'] = this.srNo;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['CreatedByEmployee'] = this.createdByEmployee;
    data['EmployeeID'] = this.employeeID;
    data['EmployeeName'] = this.employeeName;
    data['ComplaintDays'] = this.complaintDays;
    return data;
  }
}
