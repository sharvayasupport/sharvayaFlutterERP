class AccuraBathComplaintEmpFollowerListResponse {
  List<AccuraBathComplaintEmpFollowerListResponseDetails> details;
  int totalCount;

  AccuraBathComplaintEmpFollowerListResponse({this.details, this.totalCount});

  AccuraBathComplaintEmpFollowerListResponse.fromJson(
      Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(
            new AccuraBathComplaintEmpFollowerListResponseDetails.fromJson(v));
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

class AccuraBathComplaintEmpFollowerListResponseDetails {
  int employeeID;
  String employeeName;

  AccuraBathComplaintEmpFollowerListResponseDetails(
      {this.employeeID, this.employeeName});

  AccuraBathComplaintEmpFollowerListResponseDetails.fromJson(
      Map<String, dynamic> json) {
    employeeID = json['EmployeeID'];
    employeeName = json['EmployeeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EmployeeID'] = this.employeeID;
    data['EmployeeName'] = this.employeeName;
    return data;
  }
}
