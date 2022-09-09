import 'dart:collection';
import 'dart:convert';
import 'dart:io' show Platform, exit;
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_shine/flutter_shine.dart';
import 'package:geolocator/geolocator.dart'
    as geolocator; // or whatever name you want
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:ntp/ntp.dart';
import 'package:soleoserp/blocs/other/bloc_modules/Dashboard/dashboard_user_rights_screen_bloc.dart';
import 'package:soleoserp/firebase_options.dart';
import 'package:soleoserp/models/api_requests/all_employee_list_request.dart';
import 'package:soleoserp/models/api_requests/api_token/api_token_update_request.dart';
import 'package:soleoserp/models/api_requests/attendance_list_request.dart';
import 'package:soleoserp/models/api_requests/attendance_save_request.dart';
import 'package:soleoserp/models/api_requests/follower_employee_list_request.dart';
import 'package:soleoserp/models/api_requests/menu_rights_request.dart';
import 'package:soleoserp/models/api_responses/all_employee_List_response.dart';
import 'package:soleoserp/models/api_responses/company_details_response.dart';
import 'package:soleoserp/models/api_responses/follower_employee_list_response.dart';
import 'package:soleoserp/models/api_responses/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/menu_rights_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/globals.dart';
import 'package:soleoserp/push_notification_service.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/dimen_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Complaint/complaint_pagination_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/ToDo/to_do_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/followup/followup_pagination_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/inquiry_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/leave_request/leave_request_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/quotation/quotation_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salebill/sale_bill_list/sales_bill_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salesorder/salesorder_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/telecaller/telecaller_list/telecaller_list_screen.dart';
import 'package:soleoserp/ui/screens/authentication/first_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../main.dart';

class HomeScreen extends BaseStatefulWidget {
  static const routeName = '/homeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseState<HomeScreen>
    with BasicScreen, WidgetsBindingObserver {
  LoginUserDetialsResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;
  ALL_EmployeeList_Response _offlineALLEmployeeListData;
  DashBoardScreenBloc _dashBoardScreenBloc;
  List<MenuDetails> array_MenuRightsList;
  bool isCustomerExist = false;
  bool isInquiryExist = false;
  bool isFollowupExist = false;
  bool isLeaveRequestExist = false;
  bool isLeaveApprovalExist = false;
  bool isAttendanceExist = false;
  bool isExpenseExist = false;
  int CompanyID = 0;
  String LoginUserID = "";

  String MapAPIKey = "";
  String IOSAPPStatus = "";
  String AndroidAppStatus = "";
  bool IsExistInIOS = false;

  List<ALL_Name_ID> arr_ALL_Name_ID_For_HR = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Lead = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Office = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Support = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Purchase = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Production = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Sales = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Account = [];

  String ABC = "HArshit";
  List<String> SplitSTr = [];

  final TextEditingController PuchInTime = TextEditingController();
  final TextEditingController PuchOutTime = TextEditingController();
  final TextEditingController ImgFromTextFiled = TextEditingController();
  String SiteURL = "";
  String Password = "";
  bool isPunchIn = false;
  bool isPunchOut = false;
  TextEditingController EmailTO = TextEditingController();
  TextEditingController EmailBCC = TextEditingController();
  bool isLoading = true;

  bool islodding = true;

  InAppWebViewController webViewController;
  String url = "";

  final urlController = TextEditingController();

  bool onWebLoadingStop = false;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  PullToRefreshController pullToRefreshController;

  ContextMenu contextMenu;

  double progress = 0;
  int prgresss = 0;
  bool isCurrentTime = true;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  var delay = const Duration(seconds: 3);
  FirebaseMessaging _messaging;

  //final FirebaseMessaging _firebaseMessaging;//= FirebaseMessaging();

  String TitleNAme = "";

  String mid = "Default";

  String EmployeeImage = "https://img.icons8.com/color/2x/no-image.png";
  String EmployeeImageNew = "https://img.icons8.com/color/2x/no-image.png";

  PushNotificationService pushNotificationService = PushNotificationService();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  void registerNotification() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: true,
      sound: true,
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('A new onMessageOpenedApp event was published!' +
          message.notification.title);
      print("message Id - onMessageOpenedApp ${message.messageId}");
      if (Globals.objectedNotifications.contains(message.messageId)) {
        return;
      }
      Globals.objectedNotifications.add(message.messageId);
      if (message.data['title'] == "Inquiry") {
        // navigateTo(context, InquiryListScreen.routeName,clearAllStack: true);
        Navigator.pushNamed(
          Globals.context,
          InquiryListScreen.routeName,
          arguments: MessageArguments(message, true),
        );
      } else if (message.data['title'] == "FollowUp") {
        MovetoFollowupScreen(Globals.context, message.notification.title,
            message.notification.body);
      } else if (message.data['title'] == "Quotation") {
        navigateTo(Globals.context, QuotationListScreen.routeName,
            clearAllStack: true);
      } else if (message.data['title'] == "Sales Order") {
        navigateTo(Globals.context, SalesOrderListScreen.routeName,
            clearAllStack: true);
      } else if (message.data['title'] == "Sales Invoice") {
        navigateTo(Globals.context, SalesBillListScreen.routeName,
            clearAllStack: true);
      } else if (message.data['title'] == "Complaint") {
        navigateTo(Globals.context, ComplaintPaginationListScreen.routeName,
            clearAllStack: true);
      } else if (message.data['title'] == "To-Do") {
        navigateTo(Globals.context, ToDoListScreen.routeName,
            clearAllStack: true);
      } else if (message.data['title'] == "Leave Request") {
        navigateTo(Globals.context, LeaveRequestListScreen.routeName,
            clearAllStack: true);
      } else if (message.data['title'] == "TeleCaller") {
        navigateTo(Globals.context, TeleCallerListScreen.routeName,
            clearAllStack: true);
      } else if (message.data['title'] == "Quick Inquiry") {
        navigateTo(Globals.context, InquiryListScreen.routeName,
            clearAllStack: true);
      }
    });

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User Grant the Permission");
    } else {
      print("Permission Decline By User");
    }
  }

  checkIntialMessage() async {
    RemoteMessage intialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (intialMessage != null) {
      print("message Id - intialMessage ${intialMessage.messageId}");
      if (Globals.objectedNotifications.contains(intialMessage.messageId)) {
        return;
      }
      Globals.objectedNotifications.add(intialMessage.messageId);

      /* PushNotification notification = PushNotification(
        title: intialMessage.notification!.title,
        body: intialMessage.notification!.body,
        dataTitle: intialMessage.data['title'],
        databody: intialMessage.data['body']
    );*/

      if (intialMessage.data['title'] == "Inquiry") {
        navigateTo(context, InquiryListScreen.routeName, clearAllStack: true);
      } else if (intialMessage.data['title'] == "FollowUp") {
        MovetoFollowupScreen(
            context, intialMessage.data['title'], intialMessage.data['body']);

        //navigateTo(context, FollowupListScreen.routeName, clearAllStack: true);
      } else if (intialMessage.data['title'] == "Quotation") {
        navigateTo(Globals.context, QuotationListScreen.routeName,
            clearAllStack: true);
      } else if (intialMessage.data['title'] == "Sales Order") {
        navigateTo(Globals.context, SalesOrderListScreen.routeName,
            clearAllStack: true);
      } else if (intialMessage.data['title'] == "Sales Invoice") {
        navigateTo(Globals.context, SalesBillListScreen.routeName,
            clearAllStack: true);
      } else if (intialMessage.data['title'] == "Complaint") {
        navigateTo(Globals.context, ComplaintPaginationListScreen.routeName,
            clearAllStack: true);
      } else if (intialMessage.data['title'] == "To-Do") {
        navigateTo(Globals.context, ToDoListScreen.routeName,
            clearAllStack: true);
      } else if (intialMessage.data['title'] == "Leave Request") {
        navigateTo(Globals.context, LeaveRequestListScreen.routeName,
            clearAllStack: true);
      } else if (intialMessage.data['title'] == "TeleCaller") {
        navigateTo(Globals.context, TeleCallerListScreen.routeName,
            clearAllStack: true);
      } else if (intialMessage.data['title'] == "Quick Inquiry") {
        navigateTo(Globals.context, InquiryListScreen.routeName,
            clearAllStack: true);
      }
      //
    }
  }

  final Geolocator geolocator123 = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String Address;

  @override
  void initState() {
    super.initState();
    imageCache.clear();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    getcurrentTimeInfoFromMaindfd();
    screenStatusBarColor = colorWhite;
    ABC = "Ruchit";
    Xyz(ABC);

    contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(
              androidId: 1,
              iosId: "1",
              title: "Special",
              action: () async {
                print("Menu item Special clicked!");
                print(await webViewController?.getSelectedText());
                await webViewController?.clearFocus();
              })
        ],
        options: ContextMenuOptions(hideDefaultSystemContextMenuItems: false),
        onCreateContextMenu: (hitTestResult) async {
          print("onCreateContextMenu");
          print(hitTestResult.extra);
          print(await webViewController?.getSelectedText());
        },
        onHideContextMenu: () {
          print("onHideContextMenu");
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {
          var id = (Platform.isAndroid)
              ? contextMenuItemClicked.androidId
              : contextMenuItemClicked.iosId;
          print("onContextMenuActionItemClicked: " +
              id.toString() +
              " " +
              contextMenuItemClicked.title);
        });

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );

    EmailTO.text = "";
    //  Email
    //  print("GetGenLatitude" + SharedPrefHelper.instance.getLatitude());

    String Sample = 'Followup Updated For Synchro Electricals By Bhavini Desai';
    var SplitSTr = Sample.split("By");
    print("SplitedValue" +
        " Value : " +
        SplitSTr[0].toString() +
        " 2nd : " +
        SplitSTr[1].toString());

    //When App is in Background

    /*FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
          print('Message127up'+
              "data:"+message.data['title']+// = const <String, dynamic>{},
              "messageId:"+message.messageId+
              "notification:"+message.notification.title+
              "sentTime:"+message.sentTime.timeZoneName+
              "threadId:"+message.threadId.toString()+
              "ttl:"+message.ttl.toString());
          if(message.data['title']=="Inquiry")
          {
              navigateTo(context, InquiryListScreen.routeName,clearAllStack: true);

          }
          else if(message.data['title']=="Followup")
          {
            navigateTo(context, FollowupListScreen.routeName,clearAllStack: true);
          }
        });*/

    //normal Notification
    registerNotification();
    //When App is in Terminated
    checkIntialMessage();

    pushNotificationService.setupInteractedMessage();
    pushNotificationService.enableIOSNotifications();
    pushNotificationService.registerNotificationListeners();
    pushNotificationService.getToken();

    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    MapAPIKey = _offlineCompanyData.details[0].MapApiKey;
    IOSAPPStatus = _offlineCompanyData.details[0].IOSApp;
    AndroidAppStatus = _offlineCompanyData.details[0].AndroidApp;
    SiteURL = _offlineCompanyData.details[0].siteURL;
    Password = _offlineLoggedInData.details[0].userPassword;
    print("SiteURL345" +
        " Site URL : " +
        SiteURL +
        " LoginUserID : " +
        LoginUserID +
        " PassWord : " +
        Password);

    ImgFromTextFiled.text = "https://img.icons8.com/color/2x/no-image.png";

    _dashBoardScreenBloc = DashBoardScreenBloc(baseBloc);
    /*_dashBoardScreenBloc.add(EmployeeListCallEvent(
        1,
        EmployeeListRequest(
          CompanyId: CompanyID.toString(),
          OrgCode: "",
          LoginUserID: LoginUserID,)));*/
    var TokenString = pushNotificationService.getTokenAsString();

    print("lfjflfj" + TokenString.toString());

    FirebaseMessaging.instance.getToken().then((token) {
      final tokenStr = token.toString();
      // do whatever you want with the token here

      print("sfjsdfj" + tokenStr);
      _dashBoardScreenBloc
        ..add(APITokenUpdateRequestEvent(APITokenUpdateRequest(
            CompanyId: CompanyID.toString(),
            UserID: LoginUserID,
            TokenNo: tokenStr)));
    });

    _dashBoardScreenBloc
      ..add(MenuRightsCallEvent(MenuRightsRequest(
          CompanyID: CompanyID.toString(), LoginUserID: LoginUserID)));
    _dashBoardScreenBloc
      ..add(FollowerEmployeeListCallEvent(FollowerEmployeeListRequest(
          CompanyId: CompanyID.toString(), LoginUserID: LoginUserID)));
    _dashBoardScreenBloc
      ..add(ALLEmployeeNameCallEvent(
          ALLEmployeeNameRequest(CompanyId: CompanyID.toString())));
    getLeadListFromDashBoard(arr_ALL_Name_ID_For_Lead);
    getSaleListFromDashBoard(arr_ALL_Name_ID_For_Sales);
    getAccountListFromDashBoard(arr_ALL_Name_ID_For_Account);
    getHRListFromDashBoard(arr_ALL_Name_ID_For_HR);
    getOfficeListFromDashBoard(arr_ALL_Name_ID_For_Office);
    getSupportListFromDashBoard(arr_ALL_Name_ID_For_Support);
    getPurchaseListFromDashBoard(arr_ALL_Name_ID_For_Purchase);

    getProductionListFromDashBoard(arr_ALL_Name_ID_For_Production);
    _dashBoardScreenBloc.add(AttendanceCallEvent(AttendanceApiRequest(
        pkID: "",
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString(),
        Month: selectedDate.month.toString(),
        Year: selectedDate.year.toString(),
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID)));

    /*_dashBoardScreenBloc..add(EmployeeListCallEvent(
        1,
        EmployeeListRequest(
          CompanyId: CompanyID.toString(),
          OrgCode: "",
          LoginUserID: LoginUserID,)));*/

    if (_offlineLoggedInData.details[0].EmployeeImage != "" ||
        _offlineLoggedInData.details[0].EmployeeImage != null) {
      setState(() {
        ImgFromTextFiled.text = _offlineCompanyData.details[0].siteURL +
            _offlineLoggedInData.details[0].EmployeeImage.toString();
      });
    } else {
      ImgFromTextFiled.text = "https://img.icons8.com/color/2x/no-image.png";
    }

    //print("fdg"+_offlineCompanyData.details[0].siteURL+_offlineLoggedInData.details[0].EmployeeImage.toString());

    /*  WidgetsBinding.instance.addPostFrameCallback((_) {
      if(TitleNAme=="Inquiry")
      {
        navigateTo(context, InquiryListScreen.routeName,clearAllStack: true);
      }
    });*/

    /*  if(TitleNAme=="Inquiry")
    {
      navigateTo(context, InquiryListScreen.routeName,clearAllStack: true);
    }*/

    /* showCommonDialogWithSingleOption(Globals.context, "This Is Ios Build",
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {

    });*/

    // bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    // print("ISIOS" + "IOSVersion : " + isIOS.toString());
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    super.dispose();
    SplitSTr = [];
    PuchInTime.dispose();
    PuchOutTime.dispose();
    ImgFromTextFiled.dispose();
  }

  Xyz(String name) {
    return name;
  }

  ///listener and builder to multiple states of bloc to handles api responses
  ///use BlocProvider if need to listen and build
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _dashBoardScreenBloc
        ..add(MenuRightsCallEvent(MenuRightsRequest(
            CompanyID: CompanyID.toString(), LoginUserID: LoginUserID))),
      child: BlocConsumer<DashBoardScreenBloc, DashBoardScreenStates>(
        builder: (BuildContext context, DashBoardScreenStates state) {
          //handle states

          if (state is APITokenUpdateState) {
            _OnTokenUpdateResponse(state);
          }
          if (state is MenuRightsEventResponseState) {
            _onDashBoardCallSuccess(state, context);
          }

          if (state is FollowerEmployeeListByStatusCallResponseState) {
            _onFollowerEmployeeListByStatusCallSuccess(state);
          }

          if (state is ALL_EmployeeNameListResponseState) {
            _onALLEmployeeListByStatusCallSuccess(state);
          }
          if (state is AttendanceListCallResponseState) {
            _OnAttendanceListResponse(state);
          }
          if (state is EmployeeListResponseState) {
            _OnFethEmployeeImage(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          //return true for state for which builder method should be called

          if (currentState is APITokenUpdateState ||
              currentState is MenuRightsEventResponseState ||
              currentState is FollowerEmployeeListByStatusCallResponseState ||
              currentState is ALL_EmployeeNameListResponseState ||
              currentState is AttendanceListCallResponseState ||
              currentState is EmployeeListResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, DashBoardScreenStates state) {
          if (state is AttendanceSaveCallResponseState) {
            _onAttandanceSaveResponse(state);
          }

          if (state is PunchOutWebMethodState) {
            _OnwebSucessResponse(state);
          }
          //handle states
        },
        listenWhen: (oldState, currentState) {
          if (currentState is AttendanceSaveCallResponseState ||
              currentState is PunchOutWebMethodState) {
            return true;
          }
          //return true for state for which listener method should be called
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context123) {
    //getcurrentTimeInfoFromMain(context123);

    if (Platform.isAndroid) {
      // Android-specific code

      // IsExistInIOS = true;
      if (AndroidAppStatus == "Active") {
        IsExistInIOS = true;
      } else {
        IsExistInIOS = false;
      }
      print("ISIOS" + "Android-specific code");
    } else if (Platform.isIOS) {
      // iOS-specific code

      if (IOSAPPStatus == "Active") {
        IsExistInIOS = true;
      } else {
        IsExistInIOS = false;
      }
      print("ISIOS" + "iOS-specific code");
    }

    return IsExistInIOS == true
        ? Scaffold(
            appBar: AppBar(
              leading: Builder(
                builder: (context) => Container(
                  margin: EdgeInsets.only(top: 14, left: 10),
                  child: IconButton(
                    iconSize: 35,
                    icon: Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
              ),
              title: Container(
                margin: EdgeInsets.only(top: 20),
                child: FlutterShine(
                  light: Light(intensity: 1, position: Point(5, 5)),
                  builder: (BuildContext context, ShineShadow shineShadow) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          "DashBoard",
                          style: TextStyle(
                            color: colorPrimary,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              backgroundColor: colorVeryLightGray,
              foregroundColor: colorPrimary,
              elevation: 0,
              primary: false,
              actions: <Widget>[
                GestureDetector(
                  onTap: () {
                    _onTapOfLogOut();
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 20, right: 20),
                    child: Icon(
                      Icons.login,
                      size: 30,
                      color: colorPrimary,
                    ),
                  ),
                )
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                /* _dashBoardScreenBloc..add(EmployeeListCallEvent(
              1,
              EmployeeListRequest(
                CompanyId: CompanyID.toString(),
                OrgCode: "",
                LoginUserID: LoginUserID,)));*/
                _dashBoardScreenBloc.add(AttendanceCallEvent(
                    AttendanceApiRequest(
                        pkID: "",
                        EmployeeID: _offlineLoggedInData.details[0].employeeID
                            .toString(),
                        Month: selectedDate.month.toString(),
                        Year: selectedDate.year.toString(),
                        CompanyId: CompanyID.toString(),
                        LoginUserID: LoginUserID)));
                _dashBoardScreenBloc.add(MenuRightsCallEvent(MenuRightsRequest(
                    CompanyID: CompanyID.toString(),
                    LoginUserID: LoginUserID)));
              },
              child: Container(
                color: colorVeryLightGray,
                padding: EdgeInsets.only(
                  left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                  right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _offlineLoggedInData.details[0].serialKey.toLowerCase() !=
                            "dol2-6uh7-ph03-in5h"
                        ? Container(
                            margin:
                                EdgeInsets.only(left: 15, right: 15, top: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () => isCurrentTime == true
                                        ? isPunchIn == true
                                            ? showCommonDialogWithSingleOption(
                                                context, _offlineLoggedInData.details[0].employeeName + " \n Punch In : " + PuchInTime.text,
                                                positiveButtonTitle: "OK")
                                            : _dashBoardScreenBloc.add(AttendanceSaveCallEvent(AttendanceSaveApiRequest(
                                                EmployeeID: _offlineLoggedInData
                                                    .details[0].employeeID
                                                    .toString(),
                                                PresenceDate: selectedDate.year
                                                        .toString() +
                                                    "-" +
                                                    selectedDate.month
                                                        .toString() +
                                                    "-" +
                                                    selectedDate.day.toString(),
                                                TimeIn: selectedTime.hour.toString() +
                                                    ":" +
                                                    selectedTime.minute
                                                        .toString(),
                                                TimeOut: "",
                                                Latitude: Latitude,
                                                LocationAddress: Address,
                                                Longitude: Longitude,
                                                Notes: "",
                                                LoginUserID: LoginUserID,
                                                CompanyId:
                                                    CompanyID.toString())))
                                        : showCommonDialogWithSingleOption(
                                            context, "Your Device DateTime is not correct as per current DateTime , Kindly Update Your Device Time !",
                                            positiveButtonTitle: "OK",
                                            onTapOfPositiveButton: () {
                                            navigateTo(
                                                context, HomeScreen.routeName,
                                                clearAllStack: true);
                                          }),
                                    child: Card(
                                      elevation: 5,
                                      color: PuchInTime.text == ""
                                          ? colorAbsentfDay
                                          : colorPresentDay,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Container(
                                        height: 35,
                                        width: 100,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Punch In",
                                                  style: TextStyle(
                                                      color: colorWhite,

                                                      // <-- Change this
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: Column(
                                      children: [
                                        /* CachedNetworkImage(
                                    imageUrl: EmployeeImage,
                                    placeholder: (context, url) => new CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => new Icon(Icons.error),
                                    height: 48, width: 48,
                                  ),*/
                                        /* Image.network(
                                    ImgFromTextFiled.text,
                                    fit: BoxFit.fill,
                                    loadingBuilder: (BuildContext context, Widget child,
                                        ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes
                                              : null,
                                        ),
                                      );
                                    },
                                    height: 48, width: 48,
                                  ),*/

                                        Image.network(
                                          ImgFromTextFiled.text,
                                          key: ValueKey(
                                              new Random().nextInt(100)),
                                          height: 48,
                                          width: 48,
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace stackTrace) {
                                            return Image.network(
                                                "https://img.icons8.com/color/2x/no-image.png",
                                                height: 48,
                                                width: 48);
                                          },
                                        ),
                                        // Image.network(ImgFromTextFiled.text,height: 48, width: 48, ),
                                        Text(
                                          _offlineLoggedInData
                                              .details[0].employeeName,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: colorDarkBlue),
                                        ),
                                        Text(
                                          _offlineLoggedInData
                                              .details[0].roleName,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: colorDarkBlue),
                                        )
                                      ],
                                    ),
                                    width: double.infinity,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () => isCurrentTime == true
                                        ? punchoutLogic()
                                        : showCommonDialogWithSingleOption(
                                            context,
                                            "Your Device DateTime is not correct as per current DateTime , Kindly Update Your Device Time !",
                                            positiveButtonTitle: "OK",
                                            onTapOfPositiveButton: () {
                                            navigateTo(
                                                context, HomeScreen.routeName,
                                                clearAllStack: true);
                                          }),
                                    child: Card(
                                      elevation: 5,
                                      color: PuchOutTime.text == ""
                                          ? colorAbsentfDay
                                          : colorPresentDay,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Container(
                                        height: 35,
                                        width: 100,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Punch Out",
                                                  style: TextStyle(
                                                      color: colorWhite,

                                                      // <-- Change this
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    Expanded(
                      child: ListView(
                        children: [
                          ///___________________Leads____________________________
                          arr_ALL_Name_ID_For_Lead.length != 0
                              ? Container(
                                  margin: EdgeInsets.only(
                                      left: 10, top: 20, right: 10),
                                  child: Card(
                                    elevation: 5,
                                    color: colorLightGray,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: Container(
                                      height: 40,
                                      padding: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.indigo,
                                            Colors.blue,
                                            Colors.blue,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.ac_unit,
                                            color: colorWhite,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "  Leads",
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          arr_ALL_Name_ID_For_Lead.length != 0
                              ? SizedBox(
                                  height: 20,
                                )
                              : Container(),
                          arr_ALL_Name_ID_For_Lead.length != 0
                              ? Container(
                                  margin: EdgeInsets.only(
                                      top: 5.0, left: 10, right: 10, bottom: 5),
                                  child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 5.0,
                                      mainAxisSpacing: 5.0,
                                      childAspectRatio: (200 / 200),

                                      ///200,300
                                    ),
                                    itemCount: arr_ALL_Name_ID_For_Lead.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        child: makeDashboardItem(
                                            arr_ALL_Name_ID_For_Lead[index]
                                                .Name,
                                            Icons.person,
                                            context123,
                                            arr_ALL_Name_ID_For_Lead[index]
                                                .Name1),
                                      );
                                    },
                                  ))
                              : Container(),

                          ///___________________Sales______________________________
                          arr_ALL_Name_ID_For_Sales.length != 0
                              ? Container(
                                  margin: EdgeInsets.only(
                                      left: 10, top: 20, right: 10),
                                  child: Card(
                                    elevation: 5,
                                    color: colorLightGray,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: Container(
                                      height: 40,
                                      padding: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.indigo,
                                            Colors.blue,
                                            Colors.blue,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.ac_unit,
                                            color: colorWhite,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "  Sales",
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          arr_ALL_Name_ID_For_Sales.length != 0
                              ? SizedBox(
                                  height: 20,
                                )
                              : Container(),
                          arr_ALL_Name_ID_For_Sales.length != 0
                              ? Container(
                                  margin: EdgeInsets.only(
                                      top: 5.0, left: 10, right: 10, bottom: 5),
                                  child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 5.0,
                                      mainAxisSpacing: 5.0,
                                      childAspectRatio: (200 / 200),

                                      ///200,300
                                    ),
                                    itemCount: arr_ALL_Name_ID_For_Sales.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        child: makeDashboardItem(
                                            arr_ALL_Name_ID_For_Sales[index]
                                                .Name,
                                            Icons.person,
                                            context123,
                                            arr_ALL_Name_ID_For_Sales[index]
                                                .Name1),
                                      );
                                    },
                                  ))
                              : Container(),

                          ///____________________Production_______________________
                          arr_ALL_Name_ID_For_Production.length != 0
                              ? Container(
                                  margin: EdgeInsets.only(
                                      left: 10, top: 20, right: 10),
                                  child: Card(
                                    elevation: 5,
                                    color: colorLightGray,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: Container(
                                      height: 40,
                                      padding: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.indigo,
                                            Colors.blue,
                                            Colors.blue,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.ac_unit,
                                            color: colorWhite,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "  Production",
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          arr_ALL_Name_ID_For_Production.length != 0
                              ? SizedBox(
                                  height: 20,
                                )
                              : Container(),
                          arr_ALL_Name_ID_For_Production.length != 0
                              ? Container(
                                  margin: EdgeInsets.only(
                                      top: 5.0, left: 10, right: 10, bottom: 5),
                                  child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 5.0,
                                      mainAxisSpacing: 5.0,
                                      childAspectRatio: (200 / 200),

                                      ///200,300
                                    ),
                                    itemCount:
                                        arr_ALL_Name_ID_For_Production.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        child: makeDashboardItem(
                                            arr_ALL_Name_ID_For_Production[
                                                    index]
                                                .Name,
                                            Icons.person,
                                            context123,
                                            arr_ALL_Name_ID_For_Production[
                                                    index]
                                                .Name1),
                                      );
                                    },
                                  ))
                              : Container(),

                          ///____________________Account_________________________
                          arr_ALL_Name_ID_For_Account.length != 0
                              ? Container(
                                  margin: EdgeInsets.only(
                                      left: 10, top: 20, right: 10),
                                  child: Card(
                                    elevation: 5,
                                    color: colorLightGray,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: Container(
                                      height: 40,
                                      padding: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.indigo,
                                            Colors.blue,
                                            Colors.blue,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.ac_unit,
                                            color: colorWhite,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "  Account",
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          arr_ALL_Name_ID_For_Account.length != 0
                              ? SizedBox(
                                  height: 20,
                                )
                              : Container(),
                          arr_ALL_Name_ID_For_Account.length != 0
                              ? Container(
                                  margin: EdgeInsets.only(
                                      top: 5.0, left: 10, right: 10, bottom: 5),
                                  child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 5.0,
                                      mainAxisSpacing: 5.0,
                                      childAspectRatio: (200 / 200),

                                      ///200,300
                                    ),
                                    itemCount:
                                        arr_ALL_Name_ID_For_Account.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        child: makeDashboardItem(
                                            arr_ALL_Name_ID_For_Account[index]
                                                .Name,
                                            Icons.person,
                                            context123,
                                            arr_ALL_Name_ID_For_Account[index]
                                                .Name1),
                                      );
                                    },
                                  ))
                              : Container(),

                          ///___________________HR_______________________________
                          arr_ALL_Name_ID_For_HR.length != 0
                              ? Container(
                                  margin: EdgeInsets.only(
                                      left: 10, top: 15, right: 10),
                                  child: Card(
                                    elevation: 5,
                                    color: colorLightGray,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: Container(
                                      height: 40,
                                      padding: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.indigo,
                                            Colors.blue,
                                            Colors.blue,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.ac_unit,
                                            color: colorWhite,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "  HR",
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          arr_ALL_Name_ID_For_HR.length != 0
                              ? SizedBox(
                                  height: 20,
                                )
                              : Container(),
                          arr_ALL_Name_ID_For_HR.length != 0
                              ? Container(
                                  margin: EdgeInsets.only(
                                      top: 5.0, left: 10, right: 10, bottom: 5),
                                  child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 5.0,
                                      mainAxisSpacing: 5.0,
                                      childAspectRatio: (150 / 150),
                                    ),
                                    itemCount: arr_ALL_Name_ID_For_HR.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        child: makeDashboardItem(
                                            arr_ALL_Name_ID_For_HR[index].Name,
                                            Icons.person,
                                            context123,
                                            arr_ALL_Name_ID_For_HR[index]
                                                .Name1),
                                      );
                                    },
                                  ))
                              : Container(),

                          ///__________________Purchase__________________________
                          arr_ALL_Name_ID_For_Purchase.length != 0
                              ? Container(
                                  margin: EdgeInsets.only(
                                      left: 10, top: 15, right: 10),
                                  child: Card(
                                    elevation: 5,
                                    color: colorLightGray,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: Container(
                                      height: 40,
                                      padding: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.indigo,
                                            Colors.blue,
                                            Colors.blue,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.ac_unit,
                                            color: colorWhite,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "  Purchase",
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          arr_ALL_Name_ID_For_Purchase.length != 0
                              ? SizedBox(
                                  height: 20,
                                )
                              : Container(),
                          arr_ALL_Name_ID_For_Purchase.length != 0
                              ? Container(
                                  margin: EdgeInsets.only(
                                      top: 5.0, left: 10, right: 10, bottom: 5),
                                  child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 5.0,
                                      mainAxisSpacing: 5.0,
                                      childAspectRatio: (150 / 150),
                                    ),
                                    itemCount:
                                        arr_ALL_Name_ID_For_Purchase.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        child: makeDashboardItem(
                                            arr_ALL_Name_ID_For_Purchase[index]
                                                .Name,
                                            Icons.person,
                                            context123,
                                            arr_ALL_Name_ID_For_Purchase[index]
                                                .Name1),
                                      );
                                    },
                                  ))
                              : Container(),

                          ///___________________Office____________________________
                          arr_ALL_Name_ID_For_Office.length != 0
                              ? Container(
                                  margin: EdgeInsets.only(
                                      left: 10, top: 15, right: 10),
                                  child: Card(
                                    elevation: 5,
                                    color: colorLightGray,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: Container(
                                      height: 40,
                                      padding: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.indigo,
                                            Colors.blue,
                                            Colors.blue,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.ac_unit,
                                            color: colorWhite,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "  Office",
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          arr_ALL_Name_ID_For_Office.length != 0
                              ? SizedBox(
                                  height: 20,
                                )
                              : Container(),
                          arr_ALL_Name_ID_For_Office.length != 0
                              ? Container(
                                  margin: EdgeInsets.only(
                                      top: 5.0, left: 10, right: 10, bottom: 5),
                                  child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 5.0,
                                      mainAxisSpacing: 5.0,
                                      childAspectRatio: (150 / 150),
                                    ),
                                    itemCount:
                                        arr_ALL_Name_ID_For_Office.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        child: makeDashboardItem(
                                            arr_ALL_Name_ID_For_Office[index]
                                                .Name,
                                            Icons.person,
                                            context123,
                                            arr_ALL_Name_ID_For_Office[index]
                                                .Name1),
                                      );
                                    },
                                  ))
                              : Container(),

                          ///___________________Support____________________________
                          arr_ALL_Name_ID_For_Support.length != 0
                              ? Container(
                                  margin: EdgeInsets.only(
                                      left: 10, top: 15, right: 10),
                                  child: Card(
                                    elevation: 5,
                                    color: colorLightGray,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: Container(
                                      height: 40,
                                      padding: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.indigo,
                                            Colors.blue,
                                            Colors.blue,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.ac_unit,
                                            color: colorWhite,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "  Support",
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          arr_ALL_Name_ID_For_Support.length != 0
                              ? SizedBox(
                                  height: 20,
                                )
                              : Container(),
                          arr_ALL_Name_ID_For_Support.length != 0
                              ? Container(
                                  margin: EdgeInsets.only(
                                      top: 5.0, left: 10, right: 10, bottom: 5),
                                  child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 5.0,
                                      mainAxisSpacing: 5.0,
                                      childAspectRatio: (150 / 150),
                                    ),
                                    itemCount:
                                        arr_ALL_Name_ID_For_Support.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        child: makeDashboardItem(
                                            arr_ALL_Name_ID_For_Support[index]
                                                .Name,
                                            Icons.person,
                                            context123,
                                            arr_ALL_Name_ID_For_Support[index]
                                                .Name1),
                                      );
                                    },
                                  ))
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            drawer: build_Drawer(
              context: context123,
              UserName: _offlineLoggedInData.details[0].userID,
              RolCode: _offlineLoggedInData.details[0].roleName,
            ),
          )
        : Scaffold(
            body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Image.asset(
                IOSBAND,
                height: 200,
                width: 200,
              )),
              Container(
                margin: EdgeInsets.all(20),
                child: Text(
                  "You Are No Longer Available To Use This App !" +
                      "\nIf You want to access this App then Please Contact To Our Department.",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorBlack,
                      fontSize: 12),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Text(
                  "Email: info@sharvayainfotech.com" +
                      "\nContact No.: +91 9099988302",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorPrimary,
                      fontSize: 12),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else if (Platform.isIOS) {
                    exit(0);
                  }
                },
                child: Card(
                    color: colorPrimary,
                    child: Container(
                      // width: double.infinity,
                      margin: EdgeInsets.only(left: 20, right: 20),
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Center(
                        child: Text(
                          "Close App",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: colorWhite),
                        ),
                      ),
                    )),
              )
            ],
          ));
  }

  Future<void> _onTapOfLogOut() async {
    await SharedPrefHelper.instance
        .putBool(SharedPrefHelper.IS_LOGGED_IN_DATA, false);
    _dashBoardScreenBloc
      ..add(APITokenUpdateRequestEvent(APITokenUpdateRequest(
          CompanyId: CompanyID.toString(), UserID: LoginUserID, TokenNo: "")));
    navigateTo(context, FirstScreen.routeName, clearAllStack: true);
  }

  void _onDashBoardCallSuccess(
      MenuRightsEventResponseState response, BuildContext context123) {
    // array_MenuRightsList.clear();
    arr_ALL_Name_ID_For_HR.clear();
    arr_ALL_Name_ID_For_Lead.clear();
    arr_ALL_Name_ID_For_Office.clear();
    arr_ALL_Name_ID_For_Support.clear();
    arr_ALL_Name_ID_For_Purchase.clear();
    arr_ALL_Name_ID_For_Production.clear();
    arr_ALL_Name_ID_For_Sales.clear();
    arr_ALL_Name_ID_For_Account.clear();
    /*response.menuRightsResponse.details
        .sort((a, b) => a.toString().compareTo(b.toString()));*/
    for (var i = 0; i < response.menuRightsResponse.details.length; i++) {
      print("MenuRightsResponseFromScreen : " +
          response.menuRightsResponse.details[i].menuName);

      ///-----------------------------------------Leads----------------------------------------
      if (response.menuRightsResponse.details[i].menuName == "pgInquiry") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Inquiry";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/gen-lead.png";
        ALL_Name_ID all_name_id1 = ALL_Name_ID();
        all_name_id1.Name = "Quick Inquiry";
        all_name_id1.Name1 =
            "http://demo.sharvayainfotech.in/images/quick_inquiry.jpg";
        arr_ALL_Name_ID_For_Lead.add(all_name_id);
        arr_ALL_Name_ID_For_Lead.add(all_name_id1);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgFollowup") {
        /*ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Follow-up";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/contact.png";
        arr_ALL_Name_ID_For_Lead.add(all_name_id);*/

        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                "SW0T-GLA5-IND7-AS71" /*||
            _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                "SI08-SB94-MY45-RY15"*/
            ) {
          ALL_Name_ID all_name_id1 = ALL_Name_ID();
          all_name_id1.Name = "Quick Follow-up";
          all_name_id1.Name1 =
              "http://demo.sharvayainfotech.in/images/contact.png";
          arr_ALL_Name_ID_For_Lead.add(all_name_id1);
        } else {
          ALL_Name_ID all_name_id1 = ALL_Name_ID();
          all_name_id1.Name = "Follow-up";
          all_name_id1.Name1 =
              "http://demo.sharvayainfotech.in/images/contact.png";
          arr_ALL_Name_ID_For_Lead.add(all_name_id1);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgQuotation") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Quotation";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/payment.png";
        arr_ALL_Name_ID_For_Lead.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgExternalLeads") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Portal Leads";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/users.png";
        arr_ALL_Name_ID_For_Lead.add(all_name_id);
        /* if (_offlineLoggedInData.details[0].serialKey.toLowerCase() !=
            "dol2-6uh7-ph03-in5h") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Portal Leads";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/users.png";
          arr_ALL_Name_ID_For_Lead.add(all_name_id);
        }*/
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgTeleCaller") {
        /*  if (_offlineLoggedInData.details[0].serialKey.toLowerCase() !=
            "dol2-6uh7-ph03-in5h") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "TeleCaller";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/telecaller.png";
          arr_ALL_Name_ID_For_Lead.add(all_name_id);
        }*/

        if (_offlineLoggedInData.details[0].serialKey
                .toString()
                .toLowerCase() ==
            "sw0t-gla5-ind7-as71") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Tele Caller";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/telecaller.png";
          arr_ALL_Name_ID_For_Lead.add(all_name_id);
        } else {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "TeleCaller";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/telecaller.png";
          all_name_id.PresentDate = "GeneralTeleCaller";
          arr_ALL_Name_ID_For_Lead.add(all_name_id);
        }
      }

      ///_________________________________Sales____________________________________________________
      else if (response.menuRightsResponse.details[i].menuName ==
          "pgSalesOrder") {
        if (_offlineLoggedInData.details[0].serialKey.toLowerCase() !=
            "dol2-6uh7-ph03-in5h") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "SalesOrder";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/invoice.png";
          arr_ALL_Name_ID_For_Sales.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgSalesBill") {
        if (_offlineLoggedInData.details[0].serialKey.toLowerCase() !=
            "dol2-6uh7-ph03-in5h") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "SalesBill";
          all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/sale.png";
          arr_ALL_Name_ID_For_Sales.add(all_name_id);
        }
      }

      ///__________________________________Production____________________________________________________
      /*else if (response.menuRightsResponse.details[i].menuName ==
          "pgPackingChecklist") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Packing Checklist";
        all_name_id.Name1 =
            "http://dolphin.sharvayainfotech.in/images/inspection.png";
        arr_ALL_Name_ID_For_Production.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgChecking") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Final Checking";
        all_name_id.Name1 =
            "http://dolphin.sharvayainfotech.in/images/Packing.png";
        arr_ALL_Name_ID_For_Production.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgInstallation") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Installation";
        all_name_id.Name1 =
            "http://dolphin.sharvayainfotech.in/images/Packing.png";
        arr_ALL_Name_ID_For_Production.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgProductionActivity") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Production Activity";
        all_name_id.Name1 =
            "http://dolphin.sharvayainfotech.in/images/Worklog.png";
        arr_ALL_Name_ID_For_Production.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgInward") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Material Inward";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/Inward.png";
        arr_ALL_Name_ID_For_Production.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgOutward") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Material Outward";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/Outward.png";
        arr_ALL_Name_ID_For_Production.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgMaterialMovementInward") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Store Inward";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/inbox.png";
        arr_ALL_Name_ID_For_Production.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgMaterialMovementOutward") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Store Outward";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/outbox.png";
        arr_ALL_Name_ID_For_Production.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgMaterialConsumption") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Material Consumption";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/consumption.png";
        arr_ALL_Name_ID_For_Production.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgInspection") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Inspection Check List";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/inspection.png";
        arr_ALL_Name_ID_For_Production.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgJobCardInward") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Job Card Inward";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/inbox.png";
        arr_ALL_Name_ID_For_Production.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgJobCardOutward") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Job Card Outward";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/outbox.png";
        arr_ALL_Name_ID_For_Production.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgIndent") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Material Indent";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/indent.png";
        arr_ALL_Name_ID_For_Production.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgSiteSurvey") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Site Survey";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/survey.png";
        arr_ALL_Name_ID_For_Production.add(all_name_id);

        ALL_Name_ID all_name_id2 = ALL_Name_ID();
        all_name_id2.Name = "Site Survey Report";
        all_name_id2.Name1 =
            "http://demo.sharvayainfotech.in/images/survey.png";
        arr_ALL_Name_ID_For_Production.add(all_name_id2);
      }*/

      ///-------------------------------------Account---------------------------------------------------------

      else if (response.menuRightsResponse.details[i].menuName ==
          "pgBankVoucher") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "BankVoucher";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/bank.png";
        arr_ALL_Name_ID_For_Account.add(all_name_id);
      }
      /*else if (response.menuRightsResponse.details[i].menuName ==
          "pgCashVoucher") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "CashVoucher";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/money.png";
        arr_ALL_Name_ID_For_Account.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgCreditNote") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Credit Note";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/credit.png";
        arr_ALL_Name_ID_For_Account.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgDebitNote") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Debit Note";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/debit.png";
        arr_ALL_Name_ID_For_Account.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgPettyCash") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Petty Cash";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/petty.png";
        arr_ALL_Name_ID_For_Account.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgExpenseVoucher") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Exp.Voucher";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/expenses.png";
        arr_ALL_Name_ID_For_Account.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgJournalVoucher") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Journal Voucher";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/journal.png";
        arr_ALL_Name_ID_For_Account.add(all_name_id);
      }
*/
      ///-------------------------------------HR---------------------------------------------------------
      else if (response.menuRightsResponse.details[i].menuName ==
          "pgLeaveRequest") {
        //isExpenseExist = true;

        //  break;
        ALL_Name_ID all_name_id = ALL_Name_ID();

        all_name_id.Name = "Leave Request";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/leave.png";
        arr_ALL_Name_ID_For_HR.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgLeaveApprovalView") {
        //isExpenseExist = true;

        //  break;
        ALL_Name_ID all_name_id = ALL_Name_ID();

        all_name_id.Name = "Leave Approval";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/approved.png";

        arr_ALL_Name_ID_For_HR.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgAttendance") {
        //isExpenseExist = true;

        //  break;
        ALL_Name_ID all_name_id = ALL_Name_ID();

        all_name_id.Name = "Attendance";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/attendance.png";
        arr_ALL_Name_ID_For_HR.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgExpense") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Expense";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/Expense.png";
        arr_ALL_Name_ID_For_HR.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgEmployee") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Employee";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/participant.png";
        arr_ALL_Name_ID_For_HR.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgLoanApproval") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Loan Approval";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/approved.png";
        arr_ALL_Name_ID_For_HR.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgMissedPunch") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Missed Punch";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/attendance.png";
        arr_ALL_Name_ID_For_HR.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgMissedPunchApproval") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Missed Punch Approval";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/approved.png";
        arr_ALL_Name_ID_For_HR.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgAdvance") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Salary Adv/Upad";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/salary.png";
        arr_ALL_Name_ID_For_HR.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName == "pgLoan") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Loan Installments";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/salary.png";
        arr_ALL_Name_ID_For_HR.add(all_name_id);
      }

      ///----------------------------------Purchase________________________________________________________

      else if (response.menuRightsResponse.details[i].menuName ==
          "pgPurcOrder") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Purchase Order";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/purchaseorder.png";
        arr_ALL_Name_ID_For_Purchase.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgPurchaseOrderApproval") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Purchase Order Approval";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/approved.png";
        arr_ALL_Name_ID_For_Purchase.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgPurchaseBill") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Purchase Bill";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/buy.png";
        arr_ALL_Name_ID_For_Purchase.add(all_name_id);
      }

      ///------------------------------------Office_________________________________________________________
      else if (response.menuRightsResponse.details[i].menuName ==
          "pgDailyActivity") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Daily Activities";
        all_name_id.Name1 =
            "http://demo.sharvayainfotech.in/images/dailyactivity.png";
        arr_ALL_Name_ID_For_Office.add(all_name_id);
      } else if (response.menuRightsResponse.details[i].menuName == "pgToDO") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "To-Do";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/Task.png";
        arr_ALL_Name_ID_For_Office.add(all_name_id);
        /*ALL_Name_ID all_name_id2 = ALL_Name_ID();
        all_name_id2.Name = "Office Task";
        all_name_id2.Name1 = "http://demo.sharvayainfotech.in/images/Task.png";
        arr_ALL_Name_ID_For_Office.add(all_name_id2);*/
      }

      ///------------------------------------Support_________________________________________________________
      else if (response.menuRightsResponse.details[i].menuName ==
          "pgComplaint") {
        if (_offlineLoggedInData.details[0].serialKey.toLowerCase() !=
            "acsi-c803-cup0-shel") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Complaint";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/angry-emoji.jpg";
          arr_ALL_Name_ID_For_Support.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName == "pgVisit") {
        if (_offlineLoggedInData.details[0].serialKey.toLowerCase() !=
            "acsi-c803-cup0-shel") {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = "Attend Visit";
          all_name_id.Name1 =
              "http://demo.sharvayainfotech.in/images/visit.png";
          arr_ALL_Name_ID_For_Support.add(all_name_id);
        }
      } else if (response.menuRightsResponse.details[i].menuName ==
          "pgContractInfo") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "Maintenance Contract";
        all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/amc.png";
        arr_ALL_Name_ID_For_Support.add(all_name_id);
      }
    }
    ALL_Name_ID all_name_id = ALL_Name_ID();
    all_name_id.Name = "Customer";
    all_name_id.Name1 = "http://demo.sharvayainfotech.in/images/profile.png";
    arr_ALL_Name_ID_For_Lead.add(all_name_id);

    if (_offlineLoggedInData.details[0].serialKey.toLowerCase() ==
        "aasi-67ro-h01i-zh6u") {
      arr_ALL_Name_ID_For_HR.clear();
      arr_ALL_Name_ID_For_Lead.clear();
      // arr_ALL_Name_ID_For_Office.clear();
      arr_ALL_Name_ID_For_Support.clear();
      arr_ALL_Name_ID_For_Purchase.clear();
      arr_ALL_Name_ID_For_Production.clear();
      arr_ALL_Name_ID_For_Sales.clear();
      arr_ALL_Name_ID_For_Account.clear();
    }
    arr_ALL_Name_ID_For_Office
        .sort((a, b) => a.Name.toLowerCase().compareTo(b.Name.toLowerCase()));
    arr_ALL_Name_ID_For_HR
        .sort((a, b) => a.Name.toLowerCase().compareTo(b.Name.toLowerCase()));
    arr_ALL_Name_ID_For_Lead
        .sort((a, b) => a.Name.toLowerCase().compareTo(b.Name.toLowerCase()));
    arr_ALL_Name_ID_For_Office
        .sort((a, b) => a.Name.toLowerCase().compareTo(b.Name.toLowerCase()));

    arr_ALL_Name_ID_For_Support
        .sort((a, b) => a.Name.toLowerCase().compareTo(b.Name.toLowerCase()));

    for (var i = 0; i < arr_ALL_Name_ID_For_HR.length; i++) {
      print("MenuRightsHR : " + arr_ALL_Name_ID_For_HR[i].Name);
    }
    for (var i = 0; i < arr_ALL_Name_ID_For_Lead.length; i++) {
      print("MenuRightsSales : " + arr_ALL_Name_ID_For_Lead[i].Name);
    }
    for (var i = 0; i < arr_ALL_Name_ID_For_Office.length; i++) {
      print("MenuRightsOffice : " + arr_ALL_Name_ID_For_Office[i].Name);
    }
    for (var i = 0; i < arr_ALL_Name_ID_For_Support.length; i++) {
      print("MenuRightsSupport : " + arr_ALL_Name_ID_For_Support[i].Name);
    }
  }

  _onFollowerEmployeeListByStatusCallSuccess(
      FollowerEmployeeListByStatusCallResponseState state) {
    print("testweb" + state.response.details[0].employeeName);
    SharedPrefHelper.instance.setFollowerEmployeeListData(state.response);
    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();
    print("_offlineFollowerEmployeeListData" +
        _offlineFollowerEmployeeListData.details[0].employeeName +
        "");
  }

  void _onALLEmployeeListByStatusCallSuccess(
      ALL_EmployeeNameListResponseState state) {
    SharedPrefHelper.instance
        .setALLEmployeeListData(state.all_employeeList_Response);
    _offlineALLEmployeeListData =
        SharedPrefHelper.instance.getALLEmployeeList();
    print("_offlineALLEmployeeListData" +
        _offlineALLEmployeeListData.details[0].employeeName +
        "");
  }

  void _OnAttendanceListResponse(AttendanceListCallResponseState state) {
    String PDate = "";
    String CDate = "";

    if (state.response.details.isNotEmpty) {
      for (int i = 0; i < state.response.details.length; i++) {
        /*PresenceDate*/
        if (state.response.details[i].presenceDate != "") {
          PDate = state.response.details[i].presenceDate.getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
          print("APIDAte" + PDate);

          CDate = selectedDate.day.toString() +
              "-" +
              selectedDate.month.toString() +
              "-" +
              selectedDate.year.toString();
          print("CurrentDAte" + CDate);

          DateTime APIDate = new DateFormat("dd-MM-yyyy").parse(PDate);
          DateTime CurrentDate = new DateFormat("dd-MM-yyyy").parse(CDate);

          if (APIDate == CurrentDate) {
            print("ConditionTrue");

            PuchInTime.text = state.response.details[i].timeIn.toString();
            PuchOutTime.text = state.response.details[i].timeOut.toString();

            if (state.response.details[i].timeIn != "") {
              isPunchIn = true;
            }
            if (state.response.details[i].timeOut != "") {
              isPunchOut = true;
            }
          } else {
            print("ConditionFalse");
          }
        }

        print("TodayAttendance" +
            "Emp_Name : " +
            state.response.details[i].employeeName +
            " InTime : " +
            state.response.details[i].timeIn.toString());
      }
    } else {
      isPunchIn = false;
      isPunchOut = false;
    }
  }

  _getCurrentLocation() {
    geolocator123
        .getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.best)
        .then((Position position) async {
      _currentPosition = position;
      Longitude = position.longitude.toString();
      Latitude = position.latitude.toString();

      Address = await getAddressFromLatLng(Latitude, Longitude, MapAPIKey);
    }).catchError((e) {
      print(e);
    });

    location.onLocationChanged.listen((LocationData currentLocation) async {
      // Use current location
      print("OnLocationChange" +
          " Location : " +
          currentLocation.latitude.toString());
      //  placemarks = await placemarkFromCoordinates(currentLocation.latitude,currentLocation.longitude);
      // final coordinates = new Coordinates(currentLocation.latitude,currentLocation.longitude);
      // var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      // var first = addresses.first;
      //  print("${first.featureName} : ${first.addressLine}");
      Latitude = currentLocation.latitude.toString();
      Longitude = currentLocation.longitude.toString();
      Address = await getAddressFromLatLng(Latitude, Longitude, MapAPIKey);

      //  Address = "${first.featureName} : ${first.addressLine}";
    });

    // _FollowupBloc.add(LocationAddressCallEvent(LocationAddressRequest(key:"",latlng:Latitude+","+Longitude)));
  }

  Future<String> getAddressFromLatLng(
      String lat, String lng, String skey) async {
    String _host = 'https://maps.google.com/maps/api/geocode/json';
    final url = '$_host?key=$skey&latlng=$lat,$lng';
    if (lat != "" && lng != "null") {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        String _formattedAddress = data["results"][0]["formatted_address"];
        //Address = _formattedAddress;
        print("response ==== $_formattedAddress");
        return _formattedAddress;
      } else
        return null;
    } else
      return null;
  }

  void _onAttandanceSaveResponse(AttendanceSaveCallResponseState state) {
    // state.response.details[0].column2

    _dashBoardScreenBloc.add(AttendanceCallEvent(AttendanceApiRequest(
        pkID: "",
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString(),
        Month: selectedDate.month.toString(),
        Year: selectedDate.year.toString(),
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID)));
  }

  showcustomdialogSendEmail({
    BuildContext context1,
    String Email,
    AttendanceSaveApiRequest att
  }) async {
    await showDialog(
      barrierDismissible: false,
      context: context1,
      builder: (BuildContext context123) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorPrimary, //                   <--- border color
                ),
                borderRadius: BorderRadius.all(Radius.circular(
                        15.0) //                 <--- border radius here
                    ),
              ),
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Send Email",
                    style: TextStyle(
                        color: colorPrimary, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ))),
          children: [
            SizedBox(
                width: MediaQuery.of(context123).size.width,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Text("Email To.",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: colorPrimary,
                                    fontWeight: FontWeight
                                        .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Card(
                              elevation: 5,
                              color: colorLightGray,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                width: double.maxFinite,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                          controller: EmailTO,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            hintText: "Tap to enter email To",
                                            labelStyle: TextStyle(
                                              color: Color(0xFF000000),
                                            ),
                                            border: InputBorder.none,
                                          ),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF000000),
                                          ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    /*  Container(
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Text("Email BCC",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: colorPrimary,
                                    fontWeight: FontWeight
                                        .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Card(
                              elevation: 5,
                              color: colorLightGray,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                padding: EdgeInsets.only(left: 25, right: 20),
                                width: double.maxFinite,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                          controller: EmailBCC,
                                          decoration: InputDecoration(
                                            hintText: "Tap to enter email BCC",
                                            labelStyle: TextStyle(
                                              color: Color(0xFF000000),
                                            ),
                                            border: InputBorder.none,
                                          ),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF000000),
                                          ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),*/
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: getCommonButton(
                            baseTheme,
                            () async {
                              if (EmailTO.text != "") {
                                bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(EmailTO.text);

                                if(emailValid==true)
                                  {
                                    String webreq = SiteURL +
                                        "/DashboardDaily.aspx?MobilePdf=yes&userid=" +
                                        LoginUserID +
                                        "&password=" +
                                        Password +
                                        "&emailaddress=" +
                                        EmailTO.text;

                                    print("webreq" + webreq);

                                    _dashBoardScreenBloc
                                        .add(PunchOutWebMethodEvent(webreq));

                                    //APITokenUpdateRequestEvent

                                    _showMyDialog(EmailTO.text,att);
                                  }
                                else
                                  {
                                    showCommonDialogWithSingleOption(
                                        context, "Email is not valid !",
                                        positiveButtonTitle: "OK");
                                  }
                                // GenerateQT(context123, EmailTO.text);



                              } else {
                                showCommonDialogWithSingleOption(
                                    context, "Email TO is Required !",
                                    positiveButtonTitle: "OK");
                              }
                            },
                            "YES",
                            backGroundColor: colorPrimary,
                            textColor: colorWhite,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 100,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: getCommonButton(
                            baseTheme,
                            () {
                              Navigator.pop(context);
                            },
                            "NO",
                            backGroundColor: colorPrimary,
                            textColor: colorWhite,
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialog(String textEmaill, AttendanceSaveApiRequest att) async {
    return showDialog<int>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context123) {
        return AlertDialog(
          title: Text('Please wait ...!'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: true,
                  child: GenerateQT(context123, textEmaill,att),
                ),

                //GetCircular123(),
              ],
            ),
          ),
          /*actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.of(context)
                    .pop(), //  We can return any object from here
                child: Text('NO')),
            */ /* prgresss!=100 ? CircularProgressIndicator() :*/ /* FlatButton(
                onPressed: () => {
                      Navigator.of(context).pop(),
                    }, //  We can return any object from here
                child: Text('YES'))
          ],*/
        );
      },
    );
  }

  void _onLoading(BuildContext contectdislog) {
    showDialog(
      context: contectdislog,
      barrierDismissible: false,
      builder: (BuildContext contectdislog1) {
        return Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              new Text("Loading"),
            ],
          ),
        );
      },
    );
    new Future.delayed(new Duration(seconds: 5), () {
      Navigator.pop(contectdislog); //pop dialog
      //_login();
    });
  }

  GenerateQT(BuildContext context123, String emailTOstr, AttendanceSaveApiRequest att) {
    return Center(
      child: Container(
        child: Stack(
          children: [
            Container(
              height: 20,
              width: 20,
              child: Visibility(
                visible: true,
                child: InAppWebView(
                  initialUrlRequest: URLRequest(
                      url: Uri.parse(SiteURL +
                          "/DashboardDaily.aspx?MobilePdf=yes&userid=" +
                          LoginUserID +
                          "&password=" +
                          Password +
                          "&emailaddress=" +
                          emailTOstr)),
                  // initialFile: "assets/index.html",
                  initialUserScripts: UnmodifiableListView<UserScript>([]),
                  initialOptions: options,
                  pullToRefreshController: pullToRefreshController,

                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },

                  onLoadStart: (controller, url) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },

                  androidOnPermissionRequest:
                      (controller, origin, resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    var uri = navigationAction.request.url;
                    if (![
                      "http",
                      "https",
                      "file",
                      "chrome",
                      "data",
                      "javascript",
                      "about"
                    ].contains(uri.scheme)) {
                      if (await canLaunch(url)) {
                        // Launch the App
                        await launch(
                          url,
                        );
                        //  islodding = false;

                        // and cancel the request
                        return NavigationActionPolicy.CANCEL;
                      }
                    }
                    //islodding = false;

                    return NavigationActionPolicy.CANCEL;
                  },
                  onLoadStop: (controller, url) async {
                    pullToRefreshController.endRefreshing();
                    setState(() {
                      onWebLoadingStop = true;
                      islodding = false;
                    });
                    print("OnLoad" +
                        "On Loading Complted" +
                        onWebLoadingStop.toString());
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                    Navigator.pop(context123);
                    showCommonDialogWithSingleOption(
                        context, "Email Sent Successfully ",
                        onTapOfPositiveButton: () {
                      //Navigator.pop(context);
                      navigateTo(context, HomeScreen.routeName,
                          clearAllStack: true);
                    });
                  },
                  onLoadError: (controller, url, code, message) {
                    pullToRefreshController.endRefreshing();
                    isLoading = false;
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController.endRefreshing();
                      this.prgresss = progress;

                      // _QuotationBloc.add(QuotationPDFGenerateCallEvent(QuotationPDFGenerateRequest(CompanyId: CompanyID.toString(),QuotationNo: model.quotationNo)));

                    }

                    //  EasyLoading.showProgress(progress / 100, status: 'Loading...');

                    setState(() {
                      this.progress = progress / 100;
                      this.prgresss = progress;

                      urlController.text = this.url;
                    });
                  },
                  onUpdateVisitedHistory: (controller, url, androidIsReload) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    print("LoadWeb" + consoleMessage.message.toString());
                  },
                  /*  onPageFinished: (String url) {
                    print('Page finished loading: $url');
                    //hide you progressbar here
                    setState(() {
                      islodding = false;
                    });
                  },*/
                  onPageCommitVisible: (controller, url) {
                    setState(() {
                      islodding = false;
                    });
                  },
                ),
              ),
            ),
            //CircularProgressIndicator(),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Colors.white,
              child: Lottie.asset('assets/lang/sample_kishan_two.json',
                  width: 100, height: 100),
            )
            // LinearProgressIndicator(value: this.progress)
            /* this.progress < 1.0
                ? LinearProgressIndicator(value: this.progress)
                : Container(),*/
            //
          ],
        ),
      ),
    );
  }

  punchoutLogic() {
    if (isPunchIn == true) {
      //EmailTO.text = model.emailAddress;
      AttendanceSaveApiRequest attendanceSaveApiRequest = AttendanceSaveApiRequest(
          EmployeeID:
          _offlineLoggedInData.details[0].employeeID.toString(),
          PresenceDate: selectedDate.year.toString() +
              "-" +
              selectedDate.month.toString() +
              "-" +
              selectedDate.day.toString(),
          TimeIn: PuchInTime.text,
          TimeOut: selectedTime.hour.toString() +
              ":" +
              selectedTime.minute.toString(),
          Latitude: Latitude,
          LocationAddress: Address,
          Longitude: Longitude,
          Notes: "",
          LoginUserID: LoginUserID,
          CompanyId: CompanyID.toString());

      _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
          "SW0T-GLA5-IND7-AS71" ||
          _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
              "SI08-SB94-MY45-RY15" ||
          _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
              "TEST-0000-SI0F-0208"
          ? showcustomdialogSendEmail(context1: context,att:attendanceSaveApiRequest):Container();
      // _showMyDialog();
      isPunchOut == true
          ? /* showCommonDialogWithSingleOption(
              context,
              _offlineLoggedInData.details[0].employeeName +
                  " \n Punch Out : " +
                  PuchOutTime.text,
              positiveButtonTitle: "OK")

              Contract License Information : SI08-SB94-MY45-RY15*/
          _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                      "SW0T-GLA5-IND7-AS71" ||
                  _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                      "SI08-SB94-MY45-RY15" ||
                  _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                      "TEST-0000-SI0F-0208"
              ? showcustomdialogSendEmail(context1: context,att:attendanceSaveApiRequest)
              : showCommonDialogWithSingleOption(
                  context,
                  _offlineLoggedInData.details[0].employeeName +
                      " \n Punch Out : " +
                      PuchOutTime.text,
                  positiveButtonTitle: "OK")
          : _dashBoardScreenBloc.add(AttendanceSaveCallEvent(
              AttendanceSaveApiRequest(
                  EmployeeID:
                      _offlineLoggedInData.details[0].employeeID.toString(),
                  PresenceDate: selectedDate.year.toString() +
                      "-" +
                      selectedDate.month.toString() +
                      "-" +
                      selectedDate.day.toString(),
                  TimeIn: PuchInTime.text,
                  TimeOut: selectedTime.hour.toString() +
                      ":" +
                      selectedTime.minute.toString(),
                  Latitude: Latitude,
                  LocationAddress: Address,
                  Longitude: Longitude,
                  Notes: "",
                  LoginUserID: LoginUserID,
                  CompanyId: CompanyID.toString())));
    } else {
      showCommonDialogWithSingleOption(context, "Punch in Is Required !",
          positiveButtonTitle: "OK");
    }
  }

  void _OnFethEmployeeImage(EmployeeListResponseState state) {
    for (int i = 0; i < state.employeeListResponse.details.length; i++) {
      if (_offlineLoggedInData.details[0].employeeID ==
          state.employeeListResponse.details[i].pkID) {
        if (state.employeeListResponse.details[i].employeeImage != "") {
          ImgFromTextFiled.text = "";
          ImgFromTextFiled.text = _offlineCompanyData.details[0].siteURL +
              state.employeeListResponse.details[i].employeeImage;

          print("rjrjj" + EmployeeImage);
          break;
        }
      }
    }
  }

  void getcurrentTimeInfoFromMaindfd() async {
    DateTime startDate = await NTP.now();
    print('NTP DateTime: ${startDate} ${DateTime.now()}');

    var now = startDate;
    var formatter = new DateFormat('yyyy-MM-ddTHH:mm');
    String currentday = formatter.format(now);
    String PresentDate1 = formatter.format(DateTime.now());
    print(
        'NTP DateTime123456: ${DateTime.parse(currentday)} ${DateTime.parse(PresentDate1)}');

    if (DateTime.parse(currentday) != DateTime.parse(PresentDate1)) {
      //  navigateTo(context, AttendanceListScreen.routeName, clearAllStack: true);
      /*return showCommonDialogWithSingleOption(context,
          "Your Device DateTime is not correct as per current DateTime , Kindly Update Your Device Time !",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
            navigateTo(context, HomeScreen.routeName, clearAllStack: true);
          });*/
      isCurrentTime = false;
    } else {
      isCurrentTime = true;
    }
  }

  void _OnTokenUpdateResponse(APITokenUpdateState state) {
    if (state.firebaseTokenResponse.details[0].column2 != "") {
      print("APDdfd" +
          " API Token Response : " +
          state.firebaseTokenResponse.details[0].column2);
    }
  }

  void MovetoFollowupScreen(
      BuildContext Notifycontext, String Title, String BodyDetails) {
    SplitSTr = BodyDetails.split("By");
    print("NotificationSplitedValue" +
        " Value : " +
        SplitSTr[0].toString() +
        " 2nd : " +
        SplitSTr[1].toString());
    //navigateTo(context, FollowupListScreen.routeName, clearAllStack: true);

    navigateTo(Notifycontext, FollowupListScreen.routeName,
            clearAllStack: true,
            arguments: FollowupListScreenArguments(SplitSTr[1].toString()))
        .then((value) {
      SplitSTr = [];
    });
  }

  onTimerFinished() {}

  void _OnwebSucessResponse(PunchOutWebMethodState state) {
    print("Webresponse" + state.response);
  }
}
