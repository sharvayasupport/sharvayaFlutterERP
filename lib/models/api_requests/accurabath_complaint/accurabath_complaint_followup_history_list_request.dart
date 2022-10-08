/*

pkID:16
//CustomerID:
SearchKey:
LoginUserID:admin
CompanyId:4156

*/

class AccuraBathComplaintFollowupHistoryListRequest {
  String pkID;
  String SearchKey;
  String CompanyID;
  String LoginUserID;
  AccuraBathComplaintFollowupHistoryListRequest(
      {this.pkID, this.SearchKey, this.CompanyID, this.LoginUserID});

  AccuraBathComplaintFollowupHistoryListRequest.fromJson(
      Map<String, dynamic> json) {
    pkID = json['pkID'];
    SearchKey = json['SearchKey'];
    CompanyID = json['CompanyId'];
    LoginUserID = json['LoginUserID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['SearchKey'] = this.SearchKey;
    data['CompanyId'] = this.CompanyID;
    data['LoginUserID'] = this.LoginUserID;

    return data;
  }
}
