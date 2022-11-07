import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:lottie/lottie.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/other/bloc_modules/attend_visit/attend_visit_bloc.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/follower_employee_list_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/hema_automation/api_request/quick_complaint/quick_complaint_list_request.dart';
import 'package:soleoserp/models/hema_automation/api_response/quick_complaint/quick_complaint_list_response.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/dimen_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/hema_auto_attend_visit/hema_attend_visit_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class HemaAttendVisitListScreen extends BaseStatefulWidget {
  static const routeName = '/HemaAttendVisitListScreen';

  @override
  BaseState<HemaAttendVisitListScreen> createState() =>
      _HemaAttendVisitListScreenState();
}

enum Share {
  facebook,
  twitter,
  whatsapp,
  whatsapp_personal,
  whatsapp_business,
  share_system,
  share_instagram,
  share_telegram
}

class _HemaAttendVisitListScreenState
    extends BaseState<HemaAttendVisitListScreen>
    with BasicScreen, WidgetsBindingObserver {
  double sizeboxsize = 12;
  double _fontSize_Label = 9;
  double _fontSize_Title = 11;
  int label_color = 0xFF504F4F; //0x66666666;
  int title_color = 0xFF000000;

  AttendVisitBloc _complaintScreenBloc;
  QucikComplaintListResponse _qucikComplaintListResponse;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_Priority = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_EmplyeeList = [];

  final TextEditingController edt_Status = TextEditingController();
  final TextEditingController edt_FollowupEmployeeList =
      TextEditingController();
  final TextEditingController edt_FollowupEmployeeUserID =
      TextEditingController();

  bool isExpand = false;
  final TextEditingController edt_FollowUpDate = TextEditingController();
  final TextEditingController edt_ReverseFollowUpDate = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  bool isListExist = false;
  int selected = 0; //attention
  int TotalCount = 0;

  @override
  void initState() {
    super.initState();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    FetchFollowupPriorityDetails();
    _complaintScreenBloc = AttendVisitBloc(baseBloc);
    edt_Status.text = "active";
    _onFollowerEmployeeListByStatusCallSuccess(
        _offlineFollowerEmployeeListData);

    edt_FollowupEmployeeList.text =
        _offlineLoggedInData.details[0].employeeName;
    edt_FollowupEmployeeUserID.text = _offlineLoggedInData.details[0].userID;

    isExpand = false;
    edt_FollowUpDate.text = selectedDate.day.toString() +
        "-" +
        selectedDate.month.toString() +
        "-" +
        selectedDate.year.toString();
    edt_ReverseFollowUpDate.text = selectedDate.year.toString() +
        "-" +
        selectedDate.month.toString() +
        "-" +
        selectedDate.day.toString();

    edt_Status.addListener(() {
      _complaintScreenBloc.add(QuickComplaintListRequestCallEvent(
          QuickComplaintListRequest(
              Status: edt_Status.text, CompanyId: CompanyID.toString())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _complaintScreenBloc
        ..add(QuickComplaintListRequestCallEvent(QuickComplaintListRequest(
            Status: edt_Status.text, CompanyId: CompanyID.toString()))),
      child: BlocConsumer<AttendVisitBloc, AttendVisitStates>(
        builder: (BuildContext context, AttendVisitStates state) {
          //handle states

          if (state is QuickComplaintListResponseState) {
            _onComplaintListCallSuccess(state);
          }

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          //return true for state for which builder method should be called

          if (currentState is QuickComplaintListResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, AttendVisitStates state) {
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          //return true for state for which listener method should be called
          if (currentState is AttendVisitDeleteResponseState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: NewGradientAppBar(
          title: Text('Hema_AttendVisit List'),
          gradient:
              LinearGradient(colors: [Colors.blue, Colors.purple, Colors.red]),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.water_damage_sharp,
                  color: colorWhite,
                ),
                onPressed: () {
                  //_onTapOfLogOut();
                  navigateTo(context, HomeScreen.routeName,
                      clearAllStack: true);
                })
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _complaintScreenBloc.add(QuickComplaintListRequestCallEvent(
                        QuickComplaintListRequest(
                            Status: edt_Status.text,
                            CompanyId: CompanyID.toString())));
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                      right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                      top: 25,
                    ),
                    child: Column(
                      children: [
                        CustomDropDown1("Status",
                            enable1: false,
                            title: "Status",
                            hintTextvalue: "Tap to Select Status",
                            icon: Icon(Icons.arrow_drop_down),
                            controllerForLeft: edt_Status,
                            Custom_values1:
                                arr_ALL_Name_ID_For_Folowup_Priority),
                        Expanded(child: _buildFollowupList())
                      ],
                    ),
                  ),
                ),
              ),

              /*  Padding(
                padding: const EdgeInsets.all(18.0),
                child: _buildSearchView(),//searchUI(Custom_values1),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: _buildFollowupList(),
              ),*/
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
            navigateTo(context, HemaAttendVisitAddEditScreen.routeName);
          },
          child: const Icon(Icons.add),
          backgroundColor: colorPrimary,
        ),
        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: LoginUserID),
      ),
    );
  }

  Widget _buildFollowupList() {
    if (isListExist) {
      return ListView.builder(
        key: Key('selected $selected'),
        itemBuilder: (context, index) {
          return _buildFollowupListItem(index); //_buildFollowupListItem(index);
        },
        shrinkWrap: true,
        itemCount: _qucikComplaintListResponse.details.length,
      );
    } else {
      return Container(
        alignment: Alignment.center,
        child: Lottie.asset(NO_SEARCH_RESULT_FOUND, height: 200, width: 200),
      );
    }
  }

  Widget _buildFollowupListItem(int index) {
    //FilterDetails model = _FollowupListResponse.details[index];

    return ExpantionCustomer(context, index);
  }

  ExpantionCustomer(BuildContext context, int index) {
    QucikComplaintListResponseDetails model =
        _qucikComplaintListResponse.details[index];

    //Totcount= _FollowupListResponse.totalCount;
    //  if(_FollowupListResponse.details[index].employeeName == edt_FollowupEmployeeList.text) {
    return Container(
      padding: EdgeInsets.all(15),
      child: ExpansionTileCard(
        initialElevation: 5.0,
        elevation: 5.0,
        elevationCurve: Curves.easeInOut,
        // initiallyExpanded: index == selected,
        shadowColor: Color(0xFF504F4F),
        baseColor: Color(0xFFFCFCFC),
        expandedColor: Color(0xFFC1E0FA),
        //Colors.deepOrange[50],ADD8E6
        leading: CircleAvatar(
            backgroundColor: Color(0xFF504F4F),
            child: Image.network(
              "http://demo.sharvayainfotech.in/images/profile.png",
              height: 35,
              fit: BoxFit.fill,
              width: 35,
            )),

        title: Text(
          "model.customerName",
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              model.complaintStatus,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
            ),
            model.timeIn != "" || model.timeOut != ""
                ? Divider(
                    thickness: 1,
                  )
                : Container(),
            model.timeIn != "" || model.timeOut != ""
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        children: [
                          Text("In-Time : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 10)),
                          Text(
                            getTime(model.timeIn),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                color: colorPrimary),
                          ),
                        ],
                      ),
                      model.timeOut != ""
                          ? Row(
                              children: [
                                Text("Out-Time : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10)),
                                Text(
                                  getTime(model.timeOut),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: colorPrimary),
                                ),
                              ],
                            )
                          : Container()
                    ],
                  )
                : Container(),
            SizedBox(
              height: 10,
            )
          ],
        ),

        children: <Widget>[
          Divider(
            thickness: 1.0,
            height: 1.0,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 25, bottom: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () async {
                                    await _makePhoneCall("7802933894");
                                  },
                                  child: Container(
                                      child: Column(
                                    children: [
                                      Text(
                                        "Call",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Image.asset(
                                        PHONE_CALL_IMAGE,
                                        width: 30,
                                        height: 30,
                                      ),
                                    ],
                                  )),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    //await _makePhoneCall(model.contactNo1);
                                    //await _makeSms(model.contactNo1);
                                    showCommonDialogWithTwoOptions(
                                        context,
                                        "Do you have Two Accounts of WhatsApp ?" +
                                            "\n" +
                                            "Select one From below Option !",
                                        positiveButtonTitle: "WhatsApp",
                                        onTapOfPositiveButton: () {
                                          Navigator.pop(context);
                                          onButtonTap(
                                              Share.whatsapp_personal, model);
                                        },
                                        negativeButtonTitle: "Business",
                                        onTapOfNegativeButton: () {
                                          Navigator.pop(context);

                                          _launchWhatsAppBuz("7802933894");
                                        });
                                  },
                                  child: Container(
                                    child: /*Image.asset(
                                                    WHATSAPP_IMAGE,
                                                    width: 30,
                                                    height: 30,
                                                  ),*/
                                        Column(
                                      children: [
                                        Text(
                                          "Share",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Image.asset(
                                          WHATSAPP_IMAGE,
                                          width: 30,
                                          height: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                model.latitudeIN != "" ||
                                        model.longitudeIN != ""
                                    ? GestureDetector(
                                        onTap: () async {
                                          if (model.latitudeIN != "" ||
                                              model.longitudeIN != "") {
                                            print("jdjfds45" +
                                                double.parse(model.latitudeIN)
                                                    .toString() +
                                                " Longitude : " +
                                                double.parse(model.longitudeIN)
                                                    .toString());
                                            MapsLauncher.launchCoordinates(
                                                double.parse(model.latitudeIN),
                                                double.parse(model.longitudeIN),
                                                'Location In');
                                          } else {
                                            showCommonDialogWithSingleOption(
                                                context,
                                                "Location In Not Valid !",
                                                positiveButtonTitle: "OK",
                                                onTapOfPositiveButton: () {
                                              Navigator.of(context).pop();
                                            });
                                          }
                                        },
                                        child: Container(
                                            child: Column(
                                          children: [
                                            Text(
                                              "In",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.deepOrange,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Image.asset(
                                              LOCATION_ICON,
                                              width: 30,
                                              height: 30,
                                            ),
                                          ],
                                        )),
                                      )
                                    : Container(),
                                SizedBox(
                                  width: 20,
                                ),
                                model.latitudeOUT != "" ||
                                        model.longitudeOUT != ""
                                    ? GestureDetector(
                                        onTap: () async {
                                          if (model.timeOut != "" &&
                                              model.timeOut != "00:00:00") {
                                            if (model.latitudeOUT != "" ||
                                                model.longitudeOUT != "") {
                                              MapsLauncher.launchCoordinates(
                                                  double.parse(
                                                      model.latitudeOUT),
                                                  double.parse(
                                                      model.longitudeOUT),
                                                  'Location Out');
                                            } else {
                                              showCommonDialogWithSingleOption(
                                                  context,
                                                  "Location Out Not Valid !",
                                                  positiveButtonTitle: "OK",
                                                  onTapOfPositiveButton: () {
                                                Navigator.of(context).pop();
                                              });
                                            }
                                          }
                                        },
                                        child: model.timeOut != "" &&
                                                model.timeOut != "00:00:00"
                                            ? Container(
                                                child: Column(
                                                children: [
                                                  Text(
                                                    "Out",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Colors.deepOrange,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Image.asset(
                                                    LOCATION_ICON,
                                                    width: 30,
                                                    height: 30,
                                                  ),
                                                ],
                                              ))
                                            : Container(),
                                      )
                                    : Container(),
                              ]),
                        ),
                        SizedBox(
                          height: sizeboxsize,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Contact No1.",
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Color(label_color),
                                      fontSize: _fontSize_Label,
                                      letterSpacing: .3)),
                              SizedBox(
                                width: 5,
                              ),
                              Text("7802933894" == "" ? "N/A" : "7802933894",
                                  style: TextStyle(
                                      color: Color(title_color),
                                      fontSize: _fontSize_Title,
                                      letterSpacing: .3))
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildTitleWithValueView(
                                "Visit Date",
                                model.visitDate.getFormattedDate(
                                        fromFormat: "yyyy-MM-ddTHH:mm:ss",
                                        toFormat: "dd-MM-yyyy") ??
                                    "-"),
                          ),
                          Expanded(
                            child: _buildTitleWithValueView(
                                "Visit Type", model.complaintStatus ?? "-"),
                          ),
                        ]),
                    SizedBox(
                      height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildTitleWithValueView(
                                "Next Visit Date",
                                model.nextVisitDate.getFormattedDate(
                                        fromFormat: "yyyy-MM-ddTHH:mm:ss",
                                        toFormat: "dd-MM-yyyy") ??
                                    "-"),
                          ),
                          Expanded(
                            child: _buildTitleWithValueView(
                              "CreatedBy : ",
                              model.createdBy,
                            ),
                          )
                        ]),
                  ],
                ),
              ),
            ),
          ),
          edt_Status.text == "completestatus" || edt_Status.text == "future"
              ? Container()
              : ButtonBar(
                  alignment: MainAxisAlignment.center,
                  buttonHeight: 52.0,
                  buttonMinWidth: 90.0,
                  children: <Widget>[
                      model.timeIn.toString() == ""
                          ? GestureDetector(
                              onTap: () {
                                navigateTo(context,
                                        HemaAttendVisitAddEditScreen.routeName,
                                        arguments:
                                            QuickAddUpdateComplaintScreenArguments(
                                                _qucikComplaintListResponse
                                                    .details[index],
                                                false,
                                                "PunchIn"))
                                    .then((value) {
                                  _complaintScreenBloc.add(
                                      QuickComplaintListRequestCallEvent(
                                          QuickComplaintListRequest(
                                              Status: edt_Status.text,
                                              CompanyId:
                                                  CompanyID.toString())));
                                });
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.login,
                                    color: Colors.black,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                  ),
                                  Text(
                                    'PunchIn',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      model.timeIn.toString() != ""
                          ? GestureDetector(
                              onTap: () {
                                navigateTo(context,
                                        HemaAttendVisitAddEditScreen.routeName,
                                        arguments:
                                            QuickAddUpdateComplaintScreenArguments(
                                                _qucikComplaintListResponse
                                                    .details[index],
                                                false,
                                                "PunchOut"))
                                    .then((value) {
                                  _complaintScreenBloc.add(
                                      QuickComplaintListRequestCallEvent(
                                          QuickComplaintListRequest(
                                              Status: edt_Status.text,
                                              CompanyId:
                                                  CompanyID.toString())));
                                });
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.logout,
                                    color: Colors.black,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                  ),
                                  Text(
                                    'PunchOut',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ]),
          edt_Status.text == "future"
              ? ButtonBar(
                  alignment: MainAxisAlignment.center,
                  buttonHeight: 52.0,
                  buttonMinWidth: 90.0,
                  children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          navigateTo(context,
                                  HemaAttendVisitAddEditScreen.routeName,
                                  arguments:
                                      QuickAddUpdateComplaintScreenArguments(
                                          _qucikComplaintListResponse
                                              .details[index],
                                          true,
                                          "PunchIn"))
                              .then((value) {
                            _complaintScreenBloc.add(
                                QuickComplaintListRequestCallEvent(
                                    QuickComplaintListRequest(
                                        Status: edt_Status.text,
                                        CompanyId: CompanyID.toString())));
                          });
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.login,
                              color: Colors.black,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            Text(
                              'PunchIn',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      )
                    ])
              : Container(),
        ],
      ),
    );
  }

  Widget CustomDropDown1(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 15),
      child: Column(
        children: [
          InkWell(
            onTap: () => showcustomdialogWithOnlyName(
                values: Custom_values1,
                context1: context,
                controller: controllerForLeft,
                lable: "Select $Category"),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text(title,
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
                Card(
                  elevation: 5,
                  color: colorLightGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: 60,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              controller: controllerForLeft,
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: hintTextvalue,
                                labelStyle: TextStyle(
                                  color: Color(0xFF000000),
                                ),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF000000),
                              ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                              ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: colorGrayDark,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  FetchFollowupPriorityDetails() {
    arr_ALL_Name_ID_For_Folowup_Priority.clear();
    for (var i = 0; i <= 4; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "active";
      } else if (i == 1) {
        all_name_id.Name = "todays";
      } else if (i == 2) {
        all_name_id.Name = "missed";
      } else if (i == 3) {
        all_name_id.Name = "future";
      } else if (i == 4) {
        all_name_id.Name = "completestatus";
      }
      arr_ALL_Name_ID_For_Folowup_Priority.add(all_name_id);
    }
  }

  void _onFollowerEmployeeListByStatusCallSuccess(
      FollowerEmployeeListResponse state) {
    arr_ALL_Name_ID_For_Folowup_EmplyeeList.clear();

    if (state.details != null) {
      for (var i = 0; i < state.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.details[i].employeeName;
        all_name_id.Name1 = state.details[i].userID;
        arr_ALL_Name_ID_For_Folowup_EmplyeeList.add(all_name_id);
      }
    }
  }

  void _onComplaintListCallSuccess(QuickComplaintListResponseState state) {
    if (state.response.details.length != 0) {
      //_FollowupListResponse = state.quickFollowupListResponse;

      for (int i = 0; i < state.response.details.length; i++) {
        /* QuickFollowupListResponseDetails quickFollowupListResponseDetails = QuickFollowupListResponseDetails();
            quickFollowupListResponseDetails.customerName*/

        _qucikComplaintListResponse = state.response;
      }

      if (_qucikComplaintListResponse != null) {
        isListExist = true;
        TotalCount = state.response.totalCount;
      } else {
        isListExist = false;
        TotalCount = 0;
      }
    } else {
      isListExist = false;
    }
  }

  getTime(String time) {
    TimeOfDay _startTime = TimeOfDay(
        hour: int.parse(time.split(":")[0]),
        minute: int.parse(time.split(":")[1]));

    String beforZeroHour = _startTime.hourOfPeriod <= 9
        ? "0" + _startTime.hourOfPeriod.toString()
        : _startTime.hourOfPeriod.toString();
    String beforZerominute = _startTime.minute <= 9
        ? "0" + _startTime.minute.toString()
        : _startTime.minute.toString();
    /*selectedTime.hourOfPeriod <= 9
        ? "0" + selectedTime.hourOfPeriod*/
    return "${beforZeroHour}:${beforZerominute} ${_startTime.period == DayPeriod.pm ? "PM" : "AM"}";
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  Future<void> onButtonTap(
      Share share, QucikComplaintListResponseDetails customerDetails) async {
    String msg =
        "_"; //"Thank you for contacting us! We will be in touch shortly";
    //"Customer Name : "+customerDetails.customerName.toString()+"\n"+"Address : "+customerDetails.address+"\n"+"Mobile No. : " + customerDetails.contactNo1.toString();
    String url = 'https://pub.dev/packages/flutter_share_me';

    String response;
    final FlutterShareMe flutterShareMe = FlutterShareMe();
    switch (share) {
      case Share.facebook:
        response = await flutterShareMe.shareToFacebook(url: url, msg: msg);
        break;
      case Share.twitter:
        response = await flutterShareMe.shareToTwitter(url: url, msg: msg);
        break;

      case Share.whatsapp_business:
        response = await flutterShareMe.shareToWhatsApp4Biz(msg: msg);
        break;
      case Share.share_system:
        response = await flutterShareMe.shareToSystem(msg: msg);
        break;
      case Share.whatsapp_personal:
        response = await flutterShareMe.shareWhatsAppPersonalMessage(
            message: msg, phoneNumber: '+91' + "7802933894");
        break;
      case Share.share_telegram:
        response = await flutterShareMe.shareToTelegram(msg: msg);
        break;
    }
    debugPrint(response);
  }

  void _launchWhatsAppBuz(String MobileNo) async {
    await launch("https://wa.me/${"+91" + MobileNo}?text=Hello");
  }

  Future<void> share(String contactNo1) async {
    String msg =
        "_"; //"Thank you for contacting us! We will be in touch shortly";

    /*await WhatsappShare.share(
        text: msg,
        //linkUrl: 'https://flutter.dev/',
        phone: "91" + contactNo1,
        package: Package.businessWhatsapp);*/
  }

  Widget _buildTitleWithValueView(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: _fontSize_Label,
                color: Color(0xFF504F4F),
                /*fontWeight: FontWeight.bold,*/
                fontStyle: FontStyle
                    .italic) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
            ),
        SizedBox(
          height: 3,
        ),
        Text(value,
            style: TextStyle(
                fontSize: _fontSize_Title,
                color:
                    colorPrimary) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
            )
      ],
    );
  }
}
