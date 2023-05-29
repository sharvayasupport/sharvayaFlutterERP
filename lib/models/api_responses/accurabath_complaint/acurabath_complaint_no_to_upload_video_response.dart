class AccuraBathComplaintVideoUploadResponse {
  List<AccuraBathComplaintVideoUploadResponseDetails> details;
  int totalCount;

  AccuraBathComplaintVideoUploadResponse({this.details, this.totalCount});

  AccuraBathComplaintVideoUploadResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details
            .add(new AccuraBathComplaintVideoUploadResponseDetails.fromJson(v));
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

class AccuraBathComplaintVideoUploadResponseDetails {
  String column1;

  AccuraBathComplaintVideoUploadResponseDetails({this.column1});

  AccuraBathComplaintVideoUploadResponseDetails.fromJson(
      Map<String, dynamic> json) {
    column1 = json['Column1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Column1'] = this.column1;
    return data;
  }
}
