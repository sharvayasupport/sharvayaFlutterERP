class AccuraBathComplaintListRequest {
  String LoginUserID;
  String CompanyId;
  String SearchKey;

  AccuraBathComplaintListRequest(
      {this.LoginUserID, this.CompanyId, this.SearchKey});

  AccuraBathComplaintListRequest.fromJson(Map<String, dynamic> json) {
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
    SearchKey = json['SearchKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;
    data['SearchKey'] = this.SearchKey;
    return data;
  }
}
