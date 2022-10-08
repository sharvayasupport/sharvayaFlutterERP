/*EmployeeID:
CompanyId:4156*/

class AccuraBathComplaintEmpFollowerListRequest {
  String CompanyId;
  String EmployeeID;

  AccuraBathComplaintEmpFollowerListRequest({this.CompanyId, this.EmployeeID});

  AccuraBathComplaintEmpFollowerListRequest.fromJson(
      Map<String, dynamic> json) {
    CompanyId = json['CompanyId'];
    EmployeeID = json['EmployeeID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyId'] = this.CompanyId;
    data['EmployeeID'] = this.EmployeeID;
    return data;
  }
}
