/*

SearchKey:TK-JUL22-002
ModuleName:
DocName:
KeyValue:TK-JUL22-002
CompanyId:4156
LoginUserID:admin

SearchKey:TK-JUL22-002
ModuleName:
DocName:
KeyValue:TK-JUL22-002
CompanyId:4156
LoginUserID:admin

*/

class FetchAccuraBathComplaintImageListRequest {
  String SearchKey;
  String ModuleName;
  String DocName;
  String KeyValue;
  String CompanyID;
  String LoginUserID;
  FetchAccuraBathComplaintImageListRequest(
      {this.SearchKey,
      this.ModuleName,
      this.DocName,
      this.KeyValue,
      this.CompanyID,
      this.LoginUserID});

  FetchAccuraBathComplaintImageListRequest.fromJson(Map<String, dynamic> json) {
    SearchKey = json['SearchKey'];
    ModuleName = json['ModuleName'];
    DocName = json['DocName'];
    KeyValue = json['KeyValue'];
    CompanyID = json['CompanyId'];
    LoginUserID = json['LoginUserID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SearchKey'] = this.SearchKey;
    data['ModuleName'] = this.ModuleName;
    data['DocName'] = this.DocName;
    data['KeyValue'] = this.KeyValue;
    data['CompanyId'] = this.CompanyID;
    data['LoginUserID'] = this.LoginUserID;

    return data;
  }
}
