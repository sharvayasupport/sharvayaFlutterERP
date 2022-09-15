/*

ComppkID:1
FollowupDate:2022-07-31
FollowupSource:
MeetingNotes:Test from apis for followup
NextFollowupDate:2022-08-01
PreferredTime:10:00 AM
CustomerID:
InquiryStatusID:32
LoginUserID:admin
CompanyId:4156

*/

class AccuraBathComplaintFollowupSaveRequest {
  String ComppkID;
  String FollowupDate;
  String FollowupSource;
  String MeetingNotes;
  String NextFollowupDate;
  String PreferredTime;
  String CustomerID;
  String InquiryStatusID;
  String LoginUserID;
  String CompanyID;

  AccuraBathComplaintFollowupSaveRequest(
      {this.ComppkID,
      this.FollowupDate,
      this.FollowupSource,
      this.MeetingNotes,
      this.NextFollowupDate,
      this.PreferredTime,
      this.CustomerID,
      this.InquiryStatusID,
      this.LoginUserID,
      this.CompanyID});

  AccuraBathComplaintFollowupSaveRequest.fromJson(Map<String, dynamic> json) {
    ComppkID = json['ComppkID'];
    FollowupDate = json['FollowupDate'];
    FollowupSource = json['FollowupSource'];
    MeetingNotes = json['MeetingNotes'];
    NextFollowupDate = json['NextFollowupDate'];
    PreferredTime = json['PreferredTime'];
    CustomerID = json['CustomerID'];
    InquiryStatusID = json['InquiryStatusID'];
    CompanyID = json['CompanyId'];
    LoginUserID = json['LoginUserID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ComppkID'] = this.ComppkID;
    data['FollowupDate'] = this.FollowupDate;
    data['FollowupSource'] = this.FollowupSource;
    data['MeetingNotes'] = this.MeetingNotes;
    data['NextFollowupDate'] = this.NextFollowupDate;
    data['PreferredTime'] = this.PreferredTime;
    data['CustomerID'] = this.CustomerID;
    data['InquiryStatusID'] = this.InquiryStatusID;
    data['CompanyId'] = this.CompanyID;
    data['LoginUserID'] = this.LoginUserID;

    return data;
  }
}
