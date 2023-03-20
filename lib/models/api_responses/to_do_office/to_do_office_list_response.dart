class OfficeToDoListResponse {
  List<OfficeToDoListResponseDetails> details;
  int totalCount;

  OfficeToDoListResponse({this.details, this.totalCount});

  OfficeToDoListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new OfficeToDoListResponseDetails.fromJson(v));
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

class OfficeToDoListResponseDetails {
  int rowNum;
  int pkID;
  String taskDescription;
  String location;
  String taskDescriptionShort;
  String priority;
  int taskCategoryId;
  String taskCategory;
  String startDate;
  String dueDate;
  String completionDate;
  int employeeID;
  String employeeName;
  int customerID;
  String customerName;
  int fromEmployeeID;
  String fromEmployeeName;
  int duration;
  String taskStatus;
  int subTaskCompleted;
  int totalSubTask;
  bool reminder;
  int reminderMonth;
  String closingRemarks;
  String activeTask;
  String ownerShipStatus;

  OfficeToDoListResponseDetails(
      {this.rowNum,
      this.pkID,
      this.taskDescription,
      this.location,
      this.taskDescriptionShort,
      this.priority,
      this.taskCategoryId,
      this.taskCategory,
      this.startDate,
      this.dueDate,
      this.completionDate,
      this.employeeID,
      this.employeeName,
      this.customerID,
      this.customerName,
      this.fromEmployeeID,
      this.fromEmployeeName,
      this.duration,
      this.taskStatus,
      this.subTaskCompleted,
      this.totalSubTask,
      this.reminder,
      this.reminderMonth,
      this.closingRemarks,
      this.activeTask,
      this.ownerShipStatus});

  OfficeToDoListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    taskDescription =
        json['TaskDescription'] == null ? "" : json['TaskDescription'];
    location = json['Location'] == null ? "" : json['Location'];
    taskDescriptionShort = json['TaskDescriptionShort'] == null
        ? ""
        : json['TaskDescriptionShort'];
    priority = json['Priority'] == null ? "" : json['Priority'];
    taskCategoryId =
        json['TaskCategoryId'] == null ? 0 : json['TaskCategoryId'];
    taskCategory = json['TaskCategory'] == null ? "" : json['TaskCategory'];
    startDate = json['StartDate'] == null ? "" : json['StartDate'];
    dueDate = json['DueDate'] == null ? "" : json['DueDate'];
    completionDate =
        json['CompletionDate'] == null ? "" : json['CompletionDate'];
    employeeID = json['EmployeeID'] == null ? 0 : json['EmployeeID'];
    employeeName = json['EmployeeName'] == null ? "" : json['EmployeeName'];
    customerID = json['CustomerID'] == null ? 0 : json['CustomerID'];
    customerName = json['CustomerName'] == null ? "" : json['CustomerName'];
    fromEmployeeID =
        json['FromEmployeeID'] == null ? 0 : json['FromEmployeeID'];
    fromEmployeeName =
        json['FromEmployeeName'] == null ? "" : json['FromEmployeeName'];
    duration = json['Duration'] == null ? 0 : json['Duration'];
    taskStatus = json['TaskStatus'] == null ? "" : json['TaskStatus'];
    subTaskCompleted =
        json['SubTaskCompleted'] == null ? 0 : json['SubTaskCompleted'];
    totalSubTask = json['TotalSubTask'] == null ? 0 : json['TotalSubTask'];
    reminder = json['Reminder'] == null ? false : json['Reminder'];
    reminderMonth = json['ReminderMonth'] == null ? 0 : json['ReminderMonth'];
    closingRemarks =
        json['ClosingRemarks'] == null ? "" : json['ClosingRemarks'];
    activeTask = json['ActiveTask'] == null ? "" : json['ActiveTask'];
    ownerShipStatus =
        json['OwnerShipStatus'] == null ? "" : json['OwnerShipStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['TaskDescription'] = this.taskDescription;
    data['Location'] = this.location;
    data['TaskDescriptionShort'] = this.taskDescriptionShort;
    data['Priority'] = this.priority;
    data['TaskCategoryId'] = this.taskCategoryId;
    data['TaskCategory'] = this.taskCategory;
    data['StartDate'] = this.startDate;
    data['DueDate'] = this.dueDate;
    data['CompletionDate'] = this.completionDate;
    data['EmployeeID'] = this.employeeID;
    data['EmployeeName'] = this.employeeName;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['FromEmployeeID'] = this.fromEmployeeID;
    data['FromEmployeeName'] = this.fromEmployeeName;
    data['Duration'] = this.duration;
    data['TaskStatus'] = this.taskStatus;
    data['SubTaskCompleted'] = this.subTaskCompleted;
    data['TotalSubTask'] = this.totalSubTask;
    data['Reminder'] = this.reminder;
    data['ReminderMonth'] = this.reminderMonth;
    data['ClosingRemarks'] = this.closingRemarks;
    data['ActiveTask'] = this.activeTask;
    data['OwnerShipStatus'] = this.ownerShipStatus;
    return data;
  }
}
