part of 'todo_bloc.dart';

@immutable
abstract class ToDoEvents {}

///all events of AuthenticationEvents
class ToDoListCallEvent extends ToDoEvents {
  final ToDoListApiRequest toDoListApiRequest;
  ToDoListCallEvent(this.toDoListApiRequest);
}

class ToDoTodayListCallEvent extends ToDoEvents {
  final ToDoListApiRequest toDoListApiRequest;
  ToDoTodayListCallEvent(this.toDoListApiRequest);
}

class ToDoOverDueListCallEvent extends ToDoEvents {
  final ToDoListApiRequest toDoListApiRequest;
  ToDoOverDueListCallEvent(this.toDoListApiRequest);
}

class ToDoTComplitedListCallEvent extends ToDoEvents {
  final ToDoListApiRequest toDoListApiRequest;
  ToDoTComplitedListCallEvent(this.toDoListApiRequest);
}

class TaskCategoryListCallEvent extends ToDoEvents {
  final TaskCategoryListRequest taskCategoryListRequest;

  TaskCategoryListCallEvent(this.taskCategoryListRequest);
}

class ToDoSaveHeaderEvent extends ToDoEvents {
  BuildContext context;
  final ToDoHeaderSaveRequest toDoHeaderSaveRequest;
  final int pkID;

  ToDoSaveHeaderEvent(this.context,this.pkID, this.toDoHeaderSaveRequest);
}

class ToDoSaveSubDetailsEvent extends ToDoEvents {
  BuildContext context;
  final ToDoSaveSubDetailsRequest toDoSaveSubDetailsRequest;
  final int pkID;

  ToDoSaveSubDetailsEvent(this.context,this.pkID, this.toDoSaveSubDetailsRequest);
}

class ToDoWorkLogListEvent extends ToDoEvents {
  final ToDoWorkLogListRequest toDoWorkLogListRequest;

  ToDoWorkLogListEvent(this.toDoWorkLogListRequest);
}

class ToDoDeleteEvent extends ToDoEvents {
  final ToDoDeleteRequest toDoDeleteRequest;
  final int pkID;

  ToDoDeleteEvent(this.pkID, this.toDoDeleteRequest);
}

class SearchFollowupCustomerListByNameCallEvent extends ToDoEvents {
  final CustomerLabelValueRequest request;

  SearchFollowupCustomerListByNameCallEvent(this.request);
}

class FCMNotificationRequestEvent extends ToDoEvents {
  //final FCMNotificationRequest request;
  var request123;
  FCMNotificationRequestEvent(this.request123);
}
class GetReportToTokenRequestEvent extends ToDoEvents {
  final GetReportToTokenRequest request;

  GetReportToTokenRequestEvent(this.request);
}
class UserMenuRightsRequestEvent extends ToDoEvents {
  String MenuID;

  final UserMenuRightsRequest userMenuRightsRequest;
  UserMenuRightsRequestEvent(this.MenuID, this.userMenuRightsRequest);
}