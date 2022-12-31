import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soleoserp/blocs/other/firstscreen/first_screen_bloc.dart';
import 'package:soleoserp/models/api_requests/company_details/company_details_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_source_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/designation_list_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/dimen_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/authentication/first_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class SerialKeyScreen extends BaseStatefulWidget {
  static const routeName = '/SerialKeyScreen';

  _SerialKeyScreenState createState() => _SerialKeyScreenState();
}

class _SerialKeyScreenState extends BaseState<SerialKeyScreen>
    with BasicScreen, WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  FirstScreenBloc _firstScreenBloc;
  final double _minValue = 8.0;

/*  final TextEditingController edt_User_Name = TextEditingController();

   final TextEditingController edt_User_Password = TextEditingController();*/
  int count = 0;

  TextEditingController _userNameController = TextEditingController();

  TextEditingController _IPCotroller = TextEditingController();
  TextEditingController EmailTO = TextEditingController();

  //EmailTO

  TextEditingController _passwordController = TextEditingController();
  CompanyDetailsResponse _offlineLoggedInData;
  CustomerSourceResponse _offlineCustomerSourceData;
  DesignationApiResponse _offlineCustomerDesignationData;
  LoginUserDetialsResponse _offlineLoggedInDetailsData;
  String InvalidUserMessage = "";
  bool _isObscure = true;

  List<ALL_Name_ID> arr_ALL_Name_ID_For_ModeOfTransfer = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_SerialKeyDropDown = [];

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorWhite;
    getIPDropDown();
    getSerialKeyDropDown();
    _firstScreenBloc = FirstScreenBloc(baseBloc);

    /*  _firstScreenBloc
      ..add(CompanyDetailsCallEvent(
          CompanyDetailsApiRequest(serialKey: "ABCD-EFGH-IJKL-MNOW")));*/
  }

  ///listener to multiple states of bloc to handles api responses
  ///use only BlocListener if only need to listen to events
/*
  @override
  Widget build(BuildContext context) {
    return BlocListener<FirstScreenBloc, FirstScreenStates>(
      bloc: _authenticationBloc,
      listener: (BuildContext context, FirstScreenStates state) {
        if (state is FirstScreenResponseState) {
          _onFirstScreenCallSuccess(state.response);
        }
      },
      child: super.build(context),
    );
  }
*/

  ///listener and builder to multiple states of bloc to handles api responses
  ///use BlocProvider if need to listen and build
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _firstScreenBloc,
      child: BlocConsumer<FirstScreenBloc, FirstScreenStates>(
        builder: (BuildContext context, FirstScreenStates state) {
          //handle states

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          //return true for state for which builder method should be called

          return false;
        },
        listener: (BuildContext context, FirstScreenStates state) {
          //handle states
          if (state is ComapnyDetailsEventResponseState) {
            _onCompanyDetailsCallSucess(state.companyDetailsResponse);
          }

          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          //return true for state for which listener method should be called
          if (currentState is ComapnyDetailsEventResponseState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    /*edt_User_Name.text = "admin";
    edt_User_Password.text = "admin!@#";*/

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
            left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN,
            right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN,
            top: 50,
            bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildTopView(), SizedBox(height: 50), _buildLoginForm()],
        ),
      ),
    );
  }

  _onCompanyDetailsCallSucess(CompanyDetailsResponse response) {
    // SharedPrefHelper.instance.putBool(SharedPrefHelper.IS_LOGGED_IN_USER_DATA, true);

    if (response.details.length != 0) {
      SharedPrefHelper.instance.setCompanyData(response);
      _offlineLoggedInData = SharedPrefHelper.instance.getCompanyData();
      SharedPrefHelper.instance.putBool(SharedPrefHelper.IS_REGISTERED, true);

      navigateTo(context, FirstScreen.routeName, clearAllStack: true);

      print("Company Details : " +
          response.details[0].companyName.toString() +
          "");
    } else {
      showCommonDialogWithSingleOption(context, "Invalid SerialKey",
          positiveButtonTitle: "OK");
    }
  }

  Widget _buildTopView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onDoubleTap: () {
            showcustomdialogSendEmail(context1: context, Email: "Test");
          },
          child: Image.asset(
            IMG_HEADER_LOGO,
            width: MediaQuery.of(context).size.width / 1.8,
            fit: BoxFit.fitWidth,
          ),
        ),
        /* Container(
          alignment: Alignment.topLeft,
         // width: MediaQuery.of(context).size.width / 1.5,
          child: Icon(Icons.vpn_key_outlined,
            color: colorPrimary,
            size: 78,

          ),
        ),*/
        SizedBox(
          height: 40,
        ),
        /* Text(
          "Login",
          style: baseTheme.textTheme.headline1,
        ),*/
        Text(
          "Registration",
          style: TextStyle(
            color: colorPrimary,
            fontSize: 48,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Register your account",
          style: TextStyle(
            color: Color(0xff019ee9),
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          /*  getCommonTextFormField(context, baseTheme,
              title: "Serial Key",
              hint: "enter Serial Key",
              keyboardType: TextInputType.emailAddress,
              suffixIcon: ImageIcon(
                Image.asset(
                  IC_USERNAME,
                  color: colorPrimary,
                  width: 10,
                  height: 10,
                ).image,
              ),
              controller: _userNameController, validator: (value) {
                if (value.toString().trim().isEmpty) {
                  return "Please enter this field";
                }
                return null;
              }),*/
          SerialKeyTextField(),
          SizedBox(
            height: 25,
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: getCommonButton(baseTheme, () {
              _onTapOfLogin();
            }, "Register"),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  void _onTapOfForgetPassword() {
    //TODO
  }

  void _onTapOfLogin() {
    if (_userNameController.text != "") {
      /* _firstScreenBloc.add(LoginUserDetailsCallEvent(LoginUserDetialsAPIRequest(
          userID: _userNameController.text.toString(),
          password: _passwordController.text.toString(),
          companyId: _offlineLoggedInData.details[0].pkId)));*/

      _firstScreenBloc
        ..add(CompanyDetailsCallEvent(CompanyDetailsApiRequest(
            serialKey: _userNameController.text.toString())));
    } else {
      showCommonDialogWithSingleOption(context, "Serial Key field is blank !",
          positiveButtonTitle: "OK");
    }
    //TODO
  }

  void _onTapOfSignInWithGoogle() {
    //TODO
  }

  void _onTapOfRegister() {
    // navigateTo(context, RegisterScreen.routeName, clearAllStack: true);
  }

  Widget SerialKeyTextField() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 20),
            child: Text("Serial Key",
                style: TextStyle(
                    fontSize: 15,
                    color:
                        colorPrimary) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                ),
          ),
          SizedBox(
            height: 5,
          ),
          Card(
            elevation: 5,
            color: Color(0xffE0E0E0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: 60,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                          maxLength: 19,
                          controller: _userNameController,
                          cursorColor: Color(0xFFF1E6FF),
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.vpn_key,
                            ),
                            hintText: "xxxx-xxxx-xxxx-xxxx",
                            border: InputBorder.none,
                            counterStyle: TextStyle(height: double.minPositive),
                            counterText: "",
                          ),
                          onChanged: (String value) async {
                            setState(() {
                              if (count <= _userNameController.text.length &&
                                  (_userNameController.text.length == 4 ||
                                      _userNameController.text.length == 9 ||
                                      _userNameController.text.length == 14)) {
                                _userNameController.text =
                                    _userNameController.text + "-";
                                int pos = _userNameController.text.length;
                                _userNameController.selection =
                                    TextSelection.fromPosition(
                                        TextPosition(offset: pos));
                              } else if (count >=
                                      _userNameController.text.length &&
                                  (_userNameController.text.length == 4 ||
                                      _userNameController.text.length == 9 ||
                                      _userNameController.text.length == 14)) {
                                _userNameController.text =
                                    _userNameController.text.substring(
                                        0, _userNameController.text.length - 1);
                                int pos = _userNameController.text.length;
                                _userNameController.selection =
                                    TextSelection.fromPosition(
                                        TextPosition(offset: pos));
                              }
                              count = _userNameController.text.length;
                            });
                          })),
                ],
              ),
            ),
          ),
          Visibility(
            visible: false,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10, right: 20),
                  child: Text("IP",
                      style: TextStyle(
                          fontSize: 15,
                          color:
                              colorPrimary) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
                Card(
                  elevation: 5,
                  color: Color(0xffE0E0E0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    height: 60,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                          maxLength: 19,
                          controller: _IPCotroller,
                          cursorColor: Color(0xFFF1E6FF),
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.vpn_key,
                            ),
                            hintText: "xxxx-xxxx-xxxx-xxxx",
                            border: InputBorder.none,
                            counterStyle: TextStyle(height: double.minPositive),
                            counterText: "",
                          ),
                        )),
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

/*
    return TextFormField(
        maxLength: 19,
        controller: _userNameController,
        cursorColor: Color(0xFFF1E6FF),
        decoration: InputDecoration(
          icon: Icon(
            Icons.vpn_key,


          ),
          hintText: "xxxx-xxxx-xxxx-xxxx",
          border: InputBorder.none,
          counterStyle: TextStyle(
              height: double.minPositive),
          counterText: "",
        ),
        onChanged: (String value) async {
          setState(() {
            if (count <=
                _userNameController
                    .text.length &&
                (_userNameController.text.length ==
                    4 ||
                    _userNameController
                        .text.length ==
                        9 ||
                    _userNameController
                        .text.length ==
                        14)) {
              _userNameController.text =
                  _userNameController.text + "-";
              int pos = _userNameController
                  .text.length;
              _userNameController.selection =
                  TextSelection.fromPosition(
                      TextPosition(
                          offset: pos));
            } else if (count >=
                _userNameController
                    .text.length &&
                (_userNameController
                    .text.length ==
                    4 ||
                    _userNameController
                        .text.length ==
                        9 ||
                    _userNameController
                        .text.length ==
                        14)) {
              _userNameController.text =
                  _userNameController.text
                      .substring(
                      0,
                      _userNameController
                          .text.length -
                          1);
              int pos = _userNameController
                  .text.length;
              _userNameController.selection =
                  TextSelection.fromPosition(
                      TextPosition(
                          offset: pos));
            }
            count =
                _userNameController.text.length;
          });
        });
*/
  }

  void getIPDropDown() {
    arr_ALL_Name_ID_For_ModeOfTransfer.clear();
    for (var i = 0; i < 2; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "http://122.169.111.101:108/";
      } else if (i == 1) {
        all_name_id.Name = "http://208.109.14.134:83/";
      }
      arr_ALL_Name_ID_For_ModeOfTransfer.add(all_name_id);
    }
  }

  void getSerialKeyDropDown() {
    arr_ALL_Name_ID_For_SerialKeyDropDown.clear();
    for (var i = 0; i < 14; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Dolphin";
      } else if (i == 1) {
        all_name_id.Name = "DOL2-6UH7-PH03-IN5H";
      } else if (i == 2) {
        all_name_id.Name = "SharvayaTest";
      } else if (i == 3) {
        all_name_id.Name = "TEST-0000-SI0F-0208";
      } else if (i == 4) {
        all_name_id.Name = "E_OfficeDesk";
      } else if (i == 5) {
        all_name_id.Name = "SI08-SB94-MY45-RY15";
      } else if (i == 6) {
        all_name_id.Name = "AIM";
      } else if (i == 7) {
        all_name_id.Name = "A9GM-IP9S-FQT5-3N7D";
      } else if (i == 8) {
        all_name_id.Name = "MyGec";
      } else if (i == 9) {
        all_name_id.Name = "MYA6-G9EC-VS3P-H4PL";
      } else if (i == 10) {
        all_name_id.Name = "Swastik";
      } else if (i == 11) {
        all_name_id.Name = "SW0T-GLA5-IND7-AS71";
      } else if (i == 12) {
        all_name_id.Name = "Electro Smart";
      } else if (i == 13) {
        all_name_id.Name = "ELDF-CTGH-45SD-SM23";
      }

      //ARA6-ELA9-SFA7-NC0S
      arr_ALL_Name_ID_For_SerialKeyDropDown.add(all_name_id);
    }
  }

  showcustomdialogSendEmail({
    BuildContext context1,
    String Email,
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
                    "For Developer",
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
                            child: Text("Key",
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
                                            hintText: "Tap to enter Key",
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
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: getCommonButton(
                            baseTheme,
                            () {
                              if (EmailTO.text == "jugad") {
                                EmailTO.text = "";
                                Navigator.pop(context123);
                                getIPDropDown();

                                showcustomdialogWithOnlyName(
                                    values: arr_ALL_Name_ID_For_ModeOfTransfer,
                                    context1: context,
                                    controller: _IPCotroller,
                                    lable: "AppIP:");
                              } else {
                                showCommonDialogWithSingleOption(context,
                                    "This Field is For Only Developer !",
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
                              if (EmailTO.text == "jugad") {
                                EmailTO.text = "";
                                Navigator.pop(context123);
                                getSerialKeyDropDown();

                                showcustomdialogWithOnlyName(
                                    values:
                                        arr_ALL_Name_ID_For_SerialKeyDropDown,
                                    context1: context,
                                    controller: _userNameController,
                                    lable: "SerialKey:");
                              } else {
                                showCommonDialogWithSingleOption(context,
                                    "This Field is For Only Developer !",
                                    positiveButtonTitle: "OK");
                              }
                            },
                            "YES_S",
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
                              Navigator.pop(context123);
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
}
