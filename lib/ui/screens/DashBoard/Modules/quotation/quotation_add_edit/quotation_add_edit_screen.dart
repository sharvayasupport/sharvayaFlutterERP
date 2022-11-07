import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/other/bloc_modules/quotation/quotation_bloc.dart';
import 'package:soleoserp/models/api_requests/bank_voucher/bank_drop_down_request.dart';
import 'package:soleoserp/models/api_requests/customer/cust_id_inq_list_request.dart';
import 'package:soleoserp/models/api_requests/inquiry/inquiry_no_to_product_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_email_content_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_header_save_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_kind_att_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_no_to_product_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_other_charge_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_product_delete_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_project_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_terms_condition_request.dart';
import 'package:soleoserp/models/api_requests/quotation/save_email_content_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_label_value_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/quotation/quotation_list_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/globals.dart';
import 'package:soleoserp/models/common/other_charge_table.dart';
import 'package:soleoserp/models/common/othercharges/other_charges.dart';
import 'package:soleoserp/models/common/qt_other_charge_temp.dart';
import 'package:soleoserp/models/common/quotationtable.dart';
import 'package:soleoserp/models/pushnotification/get_report_to_token_request.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/quotation/quotation_add_edit/quotation_general_customer_search_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/quotation/quotation_add_edit/quotationdb/quotation_other_charges_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/quotation/quotation_add_edit/quotationdb/quotation_product_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/quotation/quotation_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/General_Constants.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class AddUpdateQuotationScreenArguments {
  QuotationDetails editModel;

  AddUpdateQuotationScreenArguments(this.editModel);
}

class QuotationAddEditScreen extends BaseStatefulWidget {
  static const routeName = '/QuotationAddEditScreen';
  final AddUpdateQuotationScreenArguments arguments;

  QuotationAddEditScreen(this.arguments);

  @override
  _QuotationAddEditScreenState createState() => _QuotationAddEditScreenState();
}

class _QuotationAddEditScreenState extends BaseState<QuotationAddEditScreen>
    with BasicScreen, WidgetsBindingObserver {
  QuotationBloc _inquiryBloc;
  int _pageNo = 0;
  bool expanded = true;
  double sizeboxsize = 12;
  int label_color = 0xFF504F4F; //0x66666666;
  int title_color = 0xFF000000;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";

  //CustomerSourceResponse _offlineCustomerSource;
  //InquiryStatusListResponse _offlineInquiryLeadStatusData;

  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final TextEditingController edt_InquiryDate = TextEditingController();
  final TextEditingController edt_ReverseInquiryDate = TextEditingController();
  final TextEditingController edt_CustomerName = TextEditingController();
  final TextEditingController edt_CustomerpkID = TextEditingController();
  final TextEditingController edt_Priority = TextEditingController();
  final TextEditingController edt_LeadStatus = TextEditingController();
  final TextEditingController edt_LeadStatusID = TextEditingController();
  final TextEditingController edt_LeadSource = TextEditingController();
  final TextEditingController edt_LeadSourceID = TextEditingController();
  final TextEditingController edt_Reference_Name = TextEditingController();
  final TextEditingController edt_Reference_No = TextEditingController();
  final TextEditingController edt_Description = TextEditingController();
  final TextEditingController edt_FollowupNotes = TextEditingController();

  final TextEditingController edt_NextFollowupDate = TextEditingController();
  final TextEditingController edt_StateCode = TextEditingController();

  final TextEditingController edt_ReverseNextFollowupDate =
      TextEditingController();
  final TextEditingController edt_PreferedTime = TextEditingController();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_Priority = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_LeadStatus = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_LeadSource = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_KindAttList = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_ProjectList = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_TermConditionList = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_InqNoList = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Email_Subject = [];

  final TextEditingController edt_KindAtt = TextEditingController();
  final TextEditingController edt_KindAttID = TextEditingController();
  final TextEditingController edt_ProjectName = TextEditingController();
  final TextEditingController edt_ProjectID = TextEditingController();
  final TextEditingController edt_TermConditionHeader = TextEditingController();
  final TextEditingController edt_TermConditionHeaderID =
      TextEditingController();

  final TextEditingController edt_TermConditionFooter = TextEditingController();
  final TextEditingController edt_InquiryNo = TextEditingController();
  final TextEditingController edt_InquiryNoID = TextEditingController();
  final TextEditingController edt_InquiryNoExist = TextEditingController();

  final TextEditingController edt_ChargeID1 = TextEditingController();
  final TextEditingController edt_ChargeName1 = TextEditingController();

  final TextEditingController edt_ChargeTaxType1 = TextEditingController();
  final TextEditingController edt_ChargeGstPer1 = TextEditingController();
  final TextEditingController edt_ChargeBeforGST1 = TextEditingController();

  final TextEditingController edt_ChargeID2 = TextEditingController();
  final TextEditingController edt_ChargeName2 = TextEditingController();

  final TextEditingController edt_ChargeTaxType2 = TextEditingController();
  final TextEditingController edt_ChargeGstPer2 = TextEditingController();
  final TextEditingController edt_ChargeBeforGST2 = TextEditingController();

  final TextEditingController edt_ChargeID3 = TextEditingController();
  final TextEditingController edt_ChargeName3 = TextEditingController();

  final TextEditingController edt_ChargeTaxType3 = TextEditingController();
  final TextEditingController edt_ChargeGstPer3 = TextEditingController();
  final TextEditingController edt_ChargeBeforGST3 = TextEditingController();

  final TextEditingController edt_ChargeID4 = TextEditingController();
  final TextEditingController edt_ChargeName4 = TextEditingController();

  final TextEditingController edt_ChargeTaxType4 = TextEditingController();
  final TextEditingController edt_ChargeGstPer4 = TextEditingController();
  final TextEditingController edt_ChargeBeforGST4 = TextEditingController();

  final TextEditingController edt_ChargeID5 = TextEditingController();
  final TextEditingController edt_ChargeName5 = TextEditingController();

  final TextEditingController edt_ChargeTaxType5 = TextEditingController();
  final TextEditingController edt_ChargeGstPer5 = TextEditingController();
  final TextEditingController edt_ChargeBeforGST5 = TextEditingController();
  final TextEditingController edt_HeaderDisc = TextEditingController();
  TextEditingController _controller_select_email_subject =
      TextEditingController();
  TextEditingController _controller_select_email_subject_ID =
      TextEditingController();
  TextEditingController _controller_Ref_Inquiry = TextEditingController();
  TextEditingController _contrller_other_Remarks = TextEditingController();
  TextEditingController _contrller_Email_Discription = TextEditingController();
  TextEditingController _contrller_Email_Add_Subject = TextEditingController();
  TextEditingController _contrller_Email_Add_Content = TextEditingController();

  QuotationDetails _editModel;
  bool _isForUpdate;
  String InquiryNo = "";
  int pkID = 0;
  List<QuotationTable> _inquiryProductList = [];
  FocusNode ReferenceFocusNode;

  // SearchInquiryListResponse _searchInquiryListResponse;
  // SearchInquiryCustomer _searchInquiryListResponse;
  SearchDetails _searchInquiryListResponse;

  List<ALL_Name_ID> arr_ALL_Name_ID_For_BankDropDownList = [];
  final TextEditingController edt_Portal_details = TextEditingController();
  final TextEditingController edt_Portal_details_ID = TextEditingController();
  String ReportToToken = "";

  String OtherChargName1 = "";
  String OtherChargeAmount1 = "0.00";
  String OtherChargeID1 = "0";
  String OtherChargeTaxType1 = "0.00";
  String OtherChargeGstPer1 = "0.00";
  String OtherChargeBeforGst1 = "0.00";

  String OtherChargName2 = "";
  String OtherChargeAmount2 = "0.00";
  String OtherChargeID2 = "0";
  String OtherChargeTaxType2 = "0.00";
  String OtherChargeGstPer2 = "0.00";
  String OtherChargeBeforGst2 = "0.00";

  String OtherChargName3 = "";
  String OtherChargeAmount3 = "0.00";
  String OtherChargeID3 = "0";
  String OtherChargeTaxType3 = "0.00";
  String OtherChargeGstPer3 = "0.00";
  String OtherChargeBeforGst3 = "0.00";

  String OtherChargName4 = "";
  String OtherChargeAmount4 = "0.00";
  String OtherChargeID4 = "0";
  String OtherChargeTaxType4 = "0.00";
  String OtherChargeGstPer4 = "0.00";
  String OtherChargeBeforGst4 = "0.00";

  String OtherChargName5 = "";
  String OtherChargeAmount5 = "0.00";
  String OtherChargeID5 = "0";
  String OtherChargeTaxType5 = "0.00";
  String OtherChargeGstPer5 = "0.00";
  String OtherChargeBeforGst5 = "0.00";

  double InclusiveBeforeGstAmnt1 = 0.00;
  double InclusiveBeforeGstAmnt_Minus1 = 0.00;
  double AfterInclusiveBeforeGstAmnt1 = 0.00;
  double AfterInclusiveBeforeGstAmnt_Minus1 = 0.00;

  double ExclusiveBeforeGStAmnt1 = 0.00;
  double ExclusiveBeforeGStAmnt_Minus1 = 0.00;
  double ExclusiveAfterGstAmnt1 = 0.00;

  double InclusiveBeforeGstAmnt2 = 0.00;
  double InclusiveBeforeGstAmnt_Minus2 = 0.00;
  double AfterInclusiveBeforeGstAmnt2 = 0.00;
  double AfterInclusiveBeforeGstAmnt_Minus2 = 0.00;

  double ExclusiveBeforeGStAmnt2 = 0.00;
  double ExclusiveBeforeGStAmnt_Minus2 = 0.00;
  double ExclusiveAfterGstAmnt2 = 0.00;

  double InclusiveBeforeGstAmnt3 = 0.00;
  double InclusiveBeforeGstAmnt_Minus3 = 0.00;
  double AfterInclusiveBeforeGstAmnt3 = 0.00;
  double AfterInclusiveBeforeGstAmnt_Minus3 = 0.00;

  double ExclusiveBeforeGStAmnt3 = 0.00;
  double ExclusiveBeforeGStAmnt_Minus3 = 0.00;
  double ExclusiveAfterGstAmnt3 = 0.00;

  double InclusiveBeforeGstAmnt4 = 0.00;
  double InclusiveBeforeGstAmnt_Minus4 = 0.00;
  double AfterInclusiveBeforeGstAmnt4 = 0.00;
  double AfterInclusiveBeforeGstAmnt_Minus4 = 0.00;

  double ExclusiveBeforeGStAmnt4 = 0.00;
  double ExclusiveBeforeGStAmnt_Minus4 = 0.00;
  double ExclusiveAfterGstAmnt4 = 0.00;

  double InclusiveBeforeGstAmnt5 = 0.00;
  double InclusiveBeforeGstAmnt_Minus5 = 0.00;
  double AfterInclusiveBeforeGstAmnt5 = 0.00;
  double AfterInclusiveBeforeGstAmnt_Minus5 = 0.00;

  double ExclusiveBeforeGStAmnt5 = 0.00;
  double ExclusiveBeforeGStAmnt_Minus5 = 0.00;
  double ExclusiveAfterGstAmnt5 = 0.00;

  double Tot_BasicAmount = 0.00;
  double Tot_otherChargeWithTax = 0.00;
  double Tot_GSTAmt = 0.00;
  double Tot_otherChargeExcludeTax = 0.00;
  double Tot_NetAmt = 0.00;

  String _basicAmountController =
      "0.00"; //_editModel.basicAmt.toStringAsFixed(2);
  String _otherChargeWithTaxController = "0.00";
  String _totalGstController = "0.00";
  String _otherChargeExcludeTaxController = "0.00";
  String netAmountController = "0.00";
  double HeaderDisAmnt = 0.00; //double.parse(edt_HeaderDisc.toString());

  bool IsWithoutTapOtherCharges = false;

  final TextEditingController editMode_netamount_controller =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorPrimary;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    // _offlineCustomerSource = SharedPrefHelper.instance.getCustomerSourceData();
    //  _offlineInquiryLeadStatusData = SharedPrefHelper.instance.getInquiryLeadStatus();
    // _onLeadSourceListTypeCallSuccess(_offlineCustomerSource);
    //_onLeadStatusListTypeCallSuccess(_offlineInquiryLeadStatusData);
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    _inquiryBloc = QuotationBloc(baseBloc);
    ReferenceFocusNode = FocusNode();
    edt_LeadSource.addListener(() {
      ReferenceFocusNode.requestFocus();
    });
    edt_HeaderDisc.text = "0.00";

    _inquiryBloc.add(GetReportToTokenRequestEvent(GetReportToTokenRequest(
        CompanyId: CompanyID.toString(),
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString())));

    _isForUpdate = widget.arguments != null;
    if (_isForUpdate) {
      _editModel = widget.arguments.editModel;
      fillData();
    } else {
      edt_InquiryDate.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();
      edt_ReverseInquiryDate.text = selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString();
      edt_StateCode.text = "";
      setState(() {
        edt_InquiryNo.text = "";
      });
    }

    edt_InquiryNo.addListener(() {
      if (edt_InquiryNo.text != "") {
        _inquiryBloc.add(InqNoToProductListCallEvent(
            InquiryNoToProductListRequest(
                InquiryNo: edt_InquiryNo.text,
                CompanyId: CompanyID.toString(),
                LoginUserID: LoginUserID)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _inquiryBloc,
      child: BlocConsumer<QuotationBloc, QuotationStates>(
        builder: (BuildContext context, QuotationStates state) {
          if (state is GetReportToTokenResponseState) {
            _onGetTokenfromReportopersonResult(state);
          }
          if (state is QuotationOtherCharge1ListResponseState) {
            _OnChargID1Response(state);
          }
          if (state is QuotationOtherCharge2ListResponseState) {
            _OnChargID2Response(state);
          }
          if (state is QuotationOtherCharge3ListResponseState) {
            _OnChargID3Response(state);
          }
          if (state is QuotationOtherCharge4ListResponseState) {
            _OnChargID4Response(state);
          }
          if (state is QuotationOtherCharge5ListResponseState) {
            _OnChargID5Response(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is GetReportToTokenResponseState ||
              currentState is QuotationOtherCharge1ListResponseState ||
              currentState is QuotationOtherCharge2ListResponseState ||
              currentState is QuotationOtherCharge3ListResponseState ||
              currentState is QuotationOtherCharge4ListResponseState ||
              currentState is QuotationOtherCharge5ListResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, QuotationStates state) {
          if (state is QuotationNoToProductListCallResponseState) {
            _OnQuotationNoToProductListResponse(state);
          }

          if (state is QuotationKindAttListResponseState) {
            _OnKindAttListResponseSucess(state);
          }

          if (state is QuotationProjectListResponseState) {
            _OnProjectListResponseSucess(state);
          }
          if (state is QuotationTermsCondtionResponseState) {
            _OnTermConditionListResponse(state);
          }
          if (state is CustIdToInqListResponseState) {
            _OnCustIdToInqNoListResponse(state);
          }
          if (state is InqNoToProductListResponseState) {
            _OnInqNotoProductListResponse(state);
          }
          if (state is QuotationHeaderSaveResponseState) {
            _OnQuotationHeaderSaveSucessResponse(state);
          }
          if (state is QuotationProductSaveResponseState) {
            _OnQuotationProductSaveSucessResponse(state);
          }
          if (state is QuotationProductDeleteResponseState) {
            _OnInquiryNoTodeleteAllProduct(state);
          }
          /* if(state is QuotationOtherChargeListResponseState)
          {
            _onOtherChargeListResponse(state);
          }*/

          if (state is QuotationBankDropDownResponseState) {
            _onBankVoucherSaveResponse(state);
          }

          if (state is FCMNotificationResponseState) {
            _onRecevedNotification(state);
          }

          if (state is QuotationEmailContentResponseState) {
            _OnEmailContentResponse(state);
          }
          if (state is SaveEmailContentResponseState) {
            _OnSaveEmailContentResponse(state);
          }

          if (state is QT_OtherChargeInsertResponseState) {
            _onInsertAllQT_OtherTable(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is QuotationNoToProductListCallResponseState ||
                  currentState is QuotationKindAttListResponseState ||
                  currentState is QuotationProjectListResponseState ||
                  currentState is QuotationTermsCondtionResponseState ||
                  currentState is CustIdToInqListResponseState ||
                  currentState is InqNoToProductListResponseState ||
                  currentState is QuotationHeaderSaveResponseState ||
                  currentState is QuotationProductSaveResponseState ||
                  currentState is QuotationBankDropDownResponseState ||
                  currentState is FCMNotificationResponseState ||
                  currentState is QuotationEmailContentResponseState ||
                  currentState is SaveEmailContentResponseState ||
                  currentState is QT_OtherChargeInsertResponseState
/*
              currentState is QuotationOtherChargeListResponseState
*/
              ) {
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
          title: Text('Quotation Details'),
          gradient:
              LinearGradient(colors: [Colors.blue, Colors.purple, Colors.red]),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.water_damage_sharp,
                  color: colorWhite,
                ),
                onPressed: () async {
                  //_onTapOfLogOut();
                  await _onTapOfDeleteALLProduct();
                  navigateTo(context, HomeScreen.routeName,
                      clearAllStack: true);
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.all(Constant.CONTAINERMARGIN),
              child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFollowupDate(),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        _buildSearchView(),
                        edt_InquiryNoExist.text == "true"
                            ? InqNoList("Inquiry No.",
                                enable1: false,
                                title: "Inquiry No.",
                                hintTextvalue: "Tap to Select Inquiry No.",
                                icon: Icon(Icons.arrow_drop_down),
                                controllerForLeft: edt_InquiryNo,
                                controllerpkID: edt_InquiryNoID,
                                Custom_values1: arr_ALL_Name_ID_For_InqNoList)
                            : Container(),
                        /* KindAttList("Kind Attn.",
                            enable1: false,
                            title: "Kind Attn.",
                            hintTextvalue: "Tap to Select Kind Attn.",
                            icon: Icon(Icons.arrow_drop_down),
                            controllerForLeft: edt_KindAtt,
                            controllerpkID: edt_KindAttID,
                            Custom_values1: arr_ALL_Name_ID_For_KindAttList),*/
                        ProjectList("Project",
                            enable1: false,
                            title: "Project",
                            hintTextvalue: "Tap to Select Project",
                            icon: Icon(Icons.arrow_drop_down),
                            controllerForLeft: edt_ProjectName,
                            controllerpkID: edt_ProjectID,
                            Custom_values1: arr_ALL_Name_ID_For_ProjectList),
                        BankDropDown("Bank Details *",
                            enable1: false,
                            title: "Bank Details *",
                            hintTextvalue: "Tap to Select Bank Portal",
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: colorPrimary,
                            ),
                            controllerForLeft: edt_Portal_details,
                            controllerpkID: edt_Portal_details_ID,
                            Custom_values1:
                                arr_ALL_Name_ID_For_BankDropDownList),
                        TermsConditionList("Select Term & Condition",
                            enable1: false,
                            title: "Select Term & Condition",
                            hintTextvalue: "Tap to Select Term & Condition",
                            icon: Icon(Icons.arrow_drop_down),
                            controllerForLeft: edt_TermConditionHeader,
                            controllerpkID: edt_TermConditionHeaderID,
                            Custom_values1:
                                arr_ALL_Name_ID_For_TermConditionList),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Text("Term & Condition",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: colorPrimary,
                                  fontWeight: FontWeight
                                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                              ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 7, right: 7, top: 10),
                          child: TextFormField(
                            controller: edt_TermConditionFooter,
                            minLines: 2,
                            maxLines: 15,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                hintText: 'Enter Notes',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                )),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        emailContent(),
                        AssumptionandOthers(),
                        Container(
                          margin: EdgeInsets.all(10),
                          alignment: Alignment.bottomCenter,
                          child: getCommonButton(baseTheme, () {
                            //  _onTapOfDeleteALLContact();
                            //  navigateTo(context, InquiryProductListScreen.routeName);
                            //UpdateAfterHeaderDiscount();
                            if (edt_CustomerName.text != "") {
                              //UpdateAfterHeaderDiscountToDB();

                              print("INWWWE" + InquiryNo.toString());
                              navigateTo(
                                  context, QuotationProductListScreen.routeName,
                                  arguments: AddQuotationProductListArgument(
                                      InquiryNo,
                                      edt_StateCode.text,
                                      edt_HeaderDisc.text));
                            } else {
                              showCommonDialogWithSingleOption(context,
                                  "Customer name is required To view Product !",
                                  positiveButtonTitle: "OK");
                            }
                          }, "Add Product + ",
                              width: 600,
                              backGroundColor: Color(0xff4d62dc),
                              radius: 25.0),
                        ),
                        Visibility(
                          visible: true,
                          child: Container(
                            margin: EdgeInsets.all(10),
                            alignment: Alignment.bottomCenter,
                            child: getCommonButton(baseTheme, () async {
                              IsWithoutTapOtherCharges = true;

                              //  _onTapOfDeleteALLContact();
                              //  navigateTo(context, InquiryProductListScreen.routeName);
                              await getInquiryProductDetails();
                              if (_inquiryProductList.length != 0) {
                                print("HeaderDiscll" +
                                    edt_HeaderDisc.text.toString());

                                AllOtherCharges allOtherCharges =
                                    AllOtherCharges();
                                allOtherCharges.HeaderDiscount =
                                    edt_HeaderDisc.text;
                                allOtherCharges.OtherChargName1 =
                                    OtherChargName1;
                                allOtherCharges.OtherChargeAmount1 =
                                    OtherChargeAmount1;
                                allOtherCharges.OtherChargeID1 = OtherChargeID1;
                                allOtherCharges.OtherChargeTaxType1 =
                                    OtherChargeTaxType1;
                                allOtherCharges.OtherChargeGstPer1 =
                                    OtherChargeGstPer1;
                                allOtherCharges.OtherChargeBeforGst1 =
                                    OtherChargeBeforGst1;

                                allOtherCharges.OtherChargName2 =
                                    OtherChargName2;
                                allOtherCharges.OtherChargeAmount2 =
                                    OtherChargeAmount2;
                                allOtherCharges.OtherChargeID2 = OtherChargeID2;
                                allOtherCharges.OtherChargeTaxType2 =
                                    OtherChargeTaxType2;
                                allOtherCharges.OtherChargeGstPer2 =
                                    OtherChargeGstPer2;
                                allOtherCharges.OtherChargeBeforGst2 =
                                    OtherChargeBeforGst2;

                                allOtherCharges.OtherChargName3 =
                                    OtherChargName3;
                                allOtherCharges.OtherChargeAmount3 =
                                    OtherChargeAmount3;
                                allOtherCharges.OtherChargeID3 = OtherChargeID3;
                                allOtherCharges.OtherChargeTaxType3 =
                                    OtherChargeTaxType3;
                                allOtherCharges.OtherChargeGstPer3 =
                                    OtherChargeGstPer3;
                                allOtherCharges.OtherChargeBeforGst3 =
                                    OtherChargeBeforGst3;

                                allOtherCharges.OtherChargName4 =
                                    OtherChargName4;
                                allOtherCharges.OtherChargeAmount4 =
                                    OtherChargeAmount4;
                                allOtherCharges.OtherChargeID4 = OtherChargeID4;
                                allOtherCharges.OtherChargeTaxType4 =
                                    OtherChargeTaxType4;
                                allOtherCharges.OtherChargeGstPer4 =
                                    OtherChargeGstPer4;
                                allOtherCharges.OtherChargeBeforGst4 =
                                    OtherChargeBeforGst4;

                                allOtherCharges.OtherChargName5 =
                                    OtherChargName5;
                                allOtherCharges.OtherChargeAmount5 =
                                    OtherChargeAmount5;
                                allOtherCharges.OtherChargeID5 = OtherChargeID5;
                                allOtherCharges.OtherChargeTaxType5 =
                                    OtherChargeTaxType5;
                                allOtherCharges.OtherChargeGstPer5 =
                                    OtherChargeGstPer5;
                                allOtherCharges.OtherChargeBeforGst5 =
                                    OtherChargeBeforGst5;

                                navigateTo(context,
                                        QuotationOtherChargeScreen.routeName,
                                        arguments:
                                            QuotationOtherChargesScreenArguments(
                                                int.parse(
                                                    edt_StateCode.text == null
                                                        ? 0
                                                        : edt_StateCode.text),
                                                _editModel,
                                                edt_HeaderDisc.text,
                                                allOtherCharges))
                                    .then((value) {
                                  AllOtherCharges allOtherCharges = value;
                                  if (allOtherCharges == null) {
                                    print(
                                        "HeaderDiscount From QTOtherCharges 0.00");
                                  } else {
                                    print(
                                        "HeaderDiscount From OtherChargeAmount " +
                                            allOtherCharges.OtherChargeAmount1 +
                                            " OtherChargeName1 : " +
                                            allOtherCharges.OtherChargName1);
                                    setState(() {
                                      edt_HeaderDisc.text =
                                          allOtherCharges.HeaderDiscount;
                                      OtherChargName1 =
                                          allOtherCharges.OtherChargName1;
                                      OtherChargeAmount1 =
                                          allOtherCharges.OtherChargeAmount1;
                                      OtherChargeID1 =
                                          allOtherCharges.OtherChargeID1;
                                      OtherChargeTaxType1 =
                                          allOtherCharges.OtherChargeTaxType1;
                                      OtherChargeGstPer1 =
                                          allOtherCharges.OtherChargeGstPer1;
                                      OtherChargeBeforGst1 =
                                          allOtherCharges.OtherChargeBeforGst1;

                                      OtherChargName2 =
                                          allOtherCharges.OtherChargName2;
                                      OtherChargeAmount2 =
                                          allOtherCharges.OtherChargeAmount2;
                                      OtherChargeID2 =
                                          allOtherCharges.OtherChargeID2;
                                      OtherChargeTaxType2 =
                                          allOtherCharges.OtherChargeTaxType2;
                                      OtherChargeGstPer2 =
                                          allOtherCharges.OtherChargeGstPer2;
                                      OtherChargeBeforGst2 =
                                          allOtherCharges.OtherChargeBeforGst2;

                                      OtherChargName3 =
                                          allOtherCharges.OtherChargName3;
                                      OtherChargeAmount3 =
                                          allOtherCharges.OtherChargeAmount3;
                                      OtherChargeID3 =
                                          allOtherCharges.OtherChargeID3;
                                      OtherChargeTaxType3 =
                                          allOtherCharges.OtherChargeTaxType3;
                                      OtherChargeGstPer3 =
                                          allOtherCharges.OtherChargeGstPer3;
                                      OtherChargeBeforGst3 =
                                          allOtherCharges.OtherChargeBeforGst3;

                                      OtherChargName4 =
                                          allOtherCharges.OtherChargName4;
                                      OtherChargeAmount4 =
                                          allOtherCharges.OtherChargeAmount4;
                                      OtherChargeID4 =
                                          allOtherCharges.OtherChargeID4;
                                      OtherChargeTaxType4 =
                                          allOtherCharges.OtherChargeTaxType4;
                                      OtherChargeGstPer4 =
                                          allOtherCharges.OtherChargeGstPer4;
                                      OtherChargeBeforGst4 =
                                          allOtherCharges.OtherChargeBeforGst4;

                                      OtherChargName5 =
                                          allOtherCharges.OtherChargName5;
                                      OtherChargeAmount5 =
                                          allOtherCharges.OtherChargeAmount5;
                                      OtherChargeID5 =
                                          allOtherCharges.OtherChargeID5;
                                      OtherChargeTaxType5 =
                                          allOtherCharges.OtherChargeTaxType5;
                                      OtherChargeGstPer5 =
                                          allOtherCharges.OtherChargeGstPer5;
                                      OtherChargeBeforGst5 =
                                          allOtherCharges.OtherChargeBeforGst5;
                                    });
                                  }
                                });
                              } else {
                                showCommonDialogWithSingleOption(context,
                                    "Atleast one product is required to view other charges !",
                                    positiveButtonTitle: "OK");
                              }
                            }, "Other Charges",
                                width: 600,
                                backGroundColor: Color(0xff4d62dc),
                                radius: 25.0),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          alignment: Alignment.bottomCenter,
                          child: getCommonButton(baseTheme, () {
                            //  _onTapOfDeleteALLContact();
                            //  navigateTo(context, InquiryProductListScreen.routeName);

                            _onTaptoSaveQuotationHeader(context);
                          }, "Save  ",
                              width: 600, backGroundColor: colorPrimary),
                        ),
                      ]))),
        ),
        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: "Admin"),
      ),
    );
  }

  emailContent() {
    return Container(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xff4d62dc), borderRadius: BorderRadius.circular(20)
              // boxShadow: [
              //   BoxShadow(
              //       color: Colors.grey, blurRadius: 3.0, offset: Offset(2, 2),
              //       spreadRadius: 1.0
              //   ),
              // ]
              ),
          child: Theme(
            data: ThemeData().copyWith(
              dividerColor: Colors.white70,
            ),
            child: ListTileTheme(
              dense: true,
              child: ExpansionTile(
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,

                // backgroundColor: Colors.grey[350],
                title: Text(
                  "Email Content",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),

                leading: Container(
                  child: ClipRRect(
                    child: Image.asset(
                      EMAIL,
                      width: 27,
                      color: Colors.white,
                    ),
                  ),
                ),

                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15))),
                    child: Column(
                      children: [
                        createTextLabel("Select Subject", 10.0, 0.0),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: EmailSubjectWithMultiID1("Email Subject",
                                  enable1: false,
                                  title: "Email Subject",
                                  hintTextvalue: "Tap to Select Subject",
                                  icon: Icon(Icons.arrow_drop_down),
                                  Custom_values1:
                                      arr_ALL_Name_ID_For_Email_Subject),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 42,
                                alignment: Alignment.topRight,
                                child: FloatingActionButton(
                                  onPressed: () async {
                                    // Add your onPressed code here!
                                    //await _onTapOfDeleteALLProduct();

                                    // navigateTo(context, QuotationAddEditScreen.routeName);
                                    showcustomdialogSendEmail(
                                        context1: context, Email: "sdfj");
                                  },
                                  child: const Icon(Icons.add),
                                  backgroundColor: Colors.pinkAccent,
                                ),
                              ),
                            )
                          ],
                        ),
                        /*CustomDropDown1("Email Subject",
                            enable1: false,
                            title: "Email Subject",
                            hintTextvalue: "Tap to Select Subject",
                            icon: Icon(Icons.arrow_drop_down),
                            controllerForLeft: _controller_select_email_subject,
                            Custom_values1: arr_ALL_Name_ID_For_Email_Subject),*/
                        SizedBox(
                          height: 10,
                        ),
                        createTextLabel("Subject", 10.0, 0.0),
                        createTextFormField(
                            _controller_select_email_subject, "Email Subject",
                            keyboardInput: TextInputType.text),
                        SizedBox(
                          height: 3,
                        ),
                        createTextLabel("Email Introduction", 10.0, 0.0),
                        createTextFormField(
                            _contrller_Email_Discription, "Email Introduction",
                            minLines: 2,
                            maxLines: 5,
                            height: 70,
                            bottom: 5,
                            top: 5,
                            keyboardInput: TextInputType.text),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ], // children:
              ),
            ),
          ),
          // height: 60,
        ),
      ),
    );
  }

  AssumptionandOthers() {
    return Container(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xff4d62dc), borderRadius: BorderRadius.circular(20)
              // boxShadow: [
              //   BoxShadow(
              //       color: Colors.grey, blurRadius: 3.0, offset: Offset(2, 2),
              //       spreadRadius: 1.0
              //   ),
              // ]
              ),
          child: Theme(
            data: ThemeData().copyWith(
              dividerColor: Colors.white70,
            ),
            child: ListTileTheme(
              dense: true,
              child: ExpansionTile(
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,

                // backgroundColor: Colors.grey[350],
                title: Text(
                  "Assumption & Others",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),

                leading: Container(
                  child: ClipRRect(
                    child: Image.asset(
                      EMAIL,
                      width: 27,
                      color: Colors.white,
                    ),
                  ),
                ),

                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15))),
                    child: Column(
                      children: [
                        createTextLabel("Ref. Inquiry", 10.0, 0.0),
                        createTextFormField(
                            _controller_Ref_Inquiry, "Enter Description",
                            minLines: 2,
                            maxLines: 5,
                            height: 70,
                            bottom: 5,
                            top: 5,
                            keyboardInput: TextInputType.text),
                        SizedBox(
                          height: 3,
                        ),
                        createTextLabel("Other Remarks", 10.0, 0.0),
                        createTextFormField(
                            _contrller_other_Remarks, "Enter Description",
                            minLines: 2,
                            maxLines: 5,
                            height: 70,
                            bottom: 5,
                            top: 5,
                            keyboardInput: TextInputType.text),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ], // children:
              ),
            ),
          ),
          // height: 60,
        ),
      ),
    );
  }

  Widget createTextLabel(String labelName, double leftPad, double rightPad) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.only(left: leftPad, right: rightPad),
        child: Row(
          children: [
            Text(labelName,
                style: TextStyle(
                    fontSize: 10,
                    color: colorBlack,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget EmailSubjectWithMultiID1(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              _inquiryBloc.add(QuotationEmailContentRequestEvent(
                  QuotationEmailContentRequest(
                      CompanyId: CompanyID.toString(),
                      LoginUserID: LoginUserID)));
            },
            /*=> */
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*SizedBox(
                  height: 5,
                ),*/
                Card(
                  elevation: 3,
                  color: colorLightGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              controller: _controller_select_email_subject,
                              enabled: false,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 7),
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

  Widget createTextFormField(
      TextEditingController _controller, String _hintText,
      {int minLines = 1,
      int maxLines = 1,
      double height = 40,
      double left = 5,
      double right = 5,
      double top = 8,
      double bottom = 10,
      TextInputType keyboardInput = TextInputType.number}) {
    return Card(
      color: colorLightGray,
      margin:
          EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        padding: EdgeInsets.all(5),
        height: height,
        decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
          minLines: minLines,
          maxLines: maxLines,
          style: TextStyle(fontSize: 13),
          controller: _controller,
          textInputAction: TextInputAction.next,
          keyboardType: keyboardInput,
          decoration: InputDecoration(
              hintText: _hintText,
              hintStyle: TextStyle(fontSize: 13, color: colorGrayDark),
              filled: true,
              fillColor: colorLightGray,
              contentPadding: EdgeInsets.symmetric(horizontal: 14),
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              )),
        ),
      ),
    );
  }

  Widget _buildFollowupDate() {
    return InkWell(
      onTap: () {
        _selectDate(context, edt_InquiryDate);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Quotation Date *",
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: 60,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      edt_InquiryDate.text == null || edt_InquiryDate.text == ""
                          ? "DD-MM-YYYY"
                          : edt_InquiryDate.text,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: edt_InquiryDate.text == null ||
                                  edt_InquiryDate.text == ""
                              ? colorGrayDark
                              : colorBlack),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    color: colorGrayDark,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController F_datecontroller) async {
    DateTime selectedDate = DateTime.now();

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        edt_InquiryDate.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        edt_ReverseInquiryDate.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });
  }

  Widget _buildSearchView() {
    return InkWell(
      onTap: () {
        _onTapOfSearchView();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Search Customer *",
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: 60,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: edt_CustomerName,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: "Search customer",
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
                    Icons.search,
                    color: colorGrayDark,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _onTapOfSearchView() async {
    if (_isForUpdate == false) {
      await _onTapOfDeleteALLProduct();

      navigateTo(context, SearchQuotationCustomerScreen.routeName)
          .then((value) {
        if (value != null) {
          _searchInquiryListResponse = value;
          edt_CustomerName.text = _searchInquiryListResponse.label;
          edt_CustomerpkID.text = _searchInquiryListResponse.value.toString();
          setState(() {
            edt_InquiryNoExist.text = "true";
          });
          _inquiryBloc.add(CustIdToInqListCallEvent(CustIdToInqListRequest(
              CustomerID: _searchInquiryListResponse.value.toString(),
              ModuleType: "Inquiry",
              CompanyID: CompanyID.toString())));

          if (_searchInquiryListResponse.stateCode != 0) {
            edt_StateCode.text =
                _searchInquiryListResponse.stateCode.toString();
          } else {
            showCommonDialogWithSingleOption(context,
                "Customer State is Required !\nUpdate State From Customer Module",
                positiveButtonTitle: "OK", onTapOfPositiveButton: () {
              edt_CustomerName.text = "";
              Navigator.pop(context);
            });
          }
          //  _CustomerBloc.add(CustomerListCallEvent(1,CustomerPaginationRequest(companyId: 8033,loginUserID: "admin",CustomerID: "",ListMode: "L")));
        }
      });
    }
  }

  Future<bool> _onBackPressed() async {
    await _onTapOfDeleteALLProduct();
    navigateTo(context, QuotationListScreen.routeName, clearAllStack: true);
  }

  void fillData() async {
    pkID = _editModel.pkID;
    edt_InquiryDate.text = _editModel.quotationDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    edt_ReverseInquiryDate.text = _editModel.quotationDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");
    edt_CustomerName.text = _editModel.customerName.toString();
    edt_CustomerpkID.text = _editModel.customerID.toString();
    /*  edt_Priority.text = _editModel.priority;
    edt_LeadStatus.text = _editModel.inquiryStatus.toString();
    edt_LeadStatusID.text = _editModel.inquiryStatusID.toString();
    edt_LeadSourceID.text = _editModel.inquirySource.toString();
    edt_LeadSource.text = _editModel.InquirySourceName.toString();
    edt_Reference_Name.text = _editModel.referenceName.toString();
    edt_Description.text = _editModel.meetingNotes.toString();*/
    edt_ProjectName.text = _editModel.projectName;
    _contrller_Email_Discription.text = _editModel.quotationHeader;
    edt_TermConditionFooter.text = _editModel.quotationFooter;
    _controller_select_email_subject.text = _editModel.quotationSubject;
    edt_ReverseNextFollowupDate.text = "";
    edt_PreferedTime.text = "";
    edt_FollowupNotes.text = "";
    InquiryNo = _editModel.quotationNo;
    edt_StateCode.text = _editModel.stateCode.toString();
    int StateCode = _editModel.stateCode;
    if (InquiryNo != '') {
      await _onTapOfDeleteALLProduct();
      _inquiryBloc.add(QuotationNoToProductListCallEvent(
          StateCode,
          QuotationNoToProductListRequest(
              QuotationNo: InquiryNo, CompanyId: CompanyID.toString())));
    }
    setState(() {
      edt_InquiryNo.text = "";
    });

    edt_HeaderDisc.text = _editModel.discountAmt.toStringAsFixed(2);
    edt_ChargeID1.text = _editModel.chargeID1.toString();
    edt_ChargeID2.text = _editModel.chargeID2.toString();
    edt_ChargeID3.text = _editModel.chargeID3.toString();
    edt_ChargeID4.text = _editModel.chargeID4.toString();
    edt_ChargeID5.text = _editModel.chargeID5.toString();

    if (edt_ChargeID1.text != "") {
      _inquiryBloc.add(QuotationOtherCharge1CallEvent(CompanyID.toString(),
          QuotationOtherChargesListRequest(pkID: edt_ChargeID1.text)));
    }
    if (edt_ChargeID2.text != "") {
      _inquiryBloc.add(QuotationOtherCharge2CallEvent(CompanyID.toString(),
          QuotationOtherChargesListRequest(pkID: edt_ChargeID2.text)));
    }
    if (edt_ChargeID3.text != "") {
      _inquiryBloc.add(QuotationOtherCharge3CallEvent(CompanyID.toString(),
          QuotationOtherChargesListRequest(pkID: edt_ChargeID3.text)));
    }
    if (edt_ChargeID4.text != "") {
      _inquiryBloc.add(QuotationOtherCharge4CallEvent(CompanyID.toString(),
          QuotationOtherChargesListRequest(pkID: edt_ChargeID4.text)));
    }
    if (edt_ChargeID5.text != "") {
      _inquiryBloc.add(QuotationOtherCharge5CallEvent(CompanyID.toString(),
          QuotationOtherChargesListRequest(pkID: edt_ChargeID5.text)));
    }

    OtherChargName1 = _editModel.chargeName1;
    OtherChargeAmount1 = _editModel.chargeAmt1.toStringAsFixed(2);
    OtherChargeID1 = _editModel.chargeID1.toString();

    OtherChargName2 = _editModel.chargeName2;
    ;
    OtherChargeAmount2 = _editModel.chargeAmt2.toStringAsFixed(2);
    OtherChargeID2 = _editModel.chargeID2.toString();
    //OtherChargeTaxType2;
    // OtherChargeGstPer2;
    // OtherChargeBeforGst2;

    OtherChargName3 = _editModel.chargeName3;
    OtherChargeAmount3 = _editModel.chargeAmt3.toStringAsFixed(2);
    OtherChargeID3 = _editModel.chargeID3.toString();
    // OtherChargeTaxType3;
    // OtherChargeGstPer3;
    // OtherChargeBeforGst3;

    OtherChargName4 = _editModel.chargeName4;
    OtherChargeAmount4 = _editModel.chargeAmt4.toStringAsFixed(2);
    OtherChargeID4 = _editModel.chargeID3.toString();
    // OtherChargeTaxType4;
    // OtherChargeGstPer4;
    // OtherChargeBeforGst4;

    OtherChargName5 = _editModel.chargeName5;
    OtherChargeAmount5 = _editModel.chargeAmt5.toStringAsFixed(2);
    OtherChargeID5 = _editModel.chargeID5.toString();

    edt_Portal_details.text = _editModel.bankName;
    edt_Portal_details_ID.text = _editModel.bankID.toString();

    _controller_Ref_Inquiry.text = _editModel.assumptionRemark;
    _contrller_other_Remarks.text = _editModel.additionalRemark;

    // OtherChargeTaxType5;
    // OtherChargeGstPer5;
    // OtherChargeBeforGst5;

    /* _inquiryBloc.add(QuotationOtherChargeCallEvent(CompanyID.toString(),
        QuotationOtherChargesListRequest(pkID: "")));*/
  }

  Future<void> getInquiryProductDetails() async {
    _inquiryProductList.clear();
    List<QuotationTable> temp =
        await OfflineDbHelper.getInstance().getQuotationProduct();
    _inquiryProductList.addAll(temp);
    setState(() {});
  }

  Future<void> _onTapOfDeleteALLProduct() async {
    await OfflineDbHelper.getInstance().deleteALLQuotationProduct();
    await OfflineDbHelper.getInstance().deleteALLOldQuotationProduct();
  }

  /* void updateRetrunInquiryNoToDB(String ReturnInquiryNo) {
    _inquiryProductList.forEach((element) {
      element.InquiryNo = ReturnInquiryNo;
      element.LoginUserID = LoginUserID;
      element.CompanyId = CompanyID.toString();
    });
  }*/

  _onTapOfAdd(
      String productName,
      String ProductID,
      String Quantity,
      String UnitPrice,
      double TotalAmount,
      String specification,
      String qtNo,
      String unit,
      double disc1,
      double discAmount1,
      double netRate1,
      double amount1,
      int taxtype1,
      double taxper1,
      double taxAmount1,
      double cgstPer,
      double sgstPer,
      double igstPer,
      double cgstAmount,
      double sgstAmount,
      double igstAmount,
      int stateCode,
      double HeaderDiscAmnr) async {
    int productID = int.parse(ProductID);
    double quantity = double.parse(Quantity);
    double unitPrice = double.parse(UnitPrice);
    double totalAmount = TotalAmount;
    double disc = disc1;
    double discAmount = discAmount1;
    double netRate = netRate1;
    double amount = amount1;
    double taxPer = taxper1;
    double taxAmount = taxAmount1;
    int taxtype = taxtype1;
    /*double Quantity,   double UnitRate,   double Disc,   double NetRate,   double Amount,   double TaxPer,   double TaxAmount,   double NetAmount,*/

    await OfflineDbHelper.getInstance().insertQuotationProduct(QuotationTable(
      qtNo,
      specification,
      productID,
      productName,
      unit,
      quantity,
      unitPrice,
      disc,
      discAmount,
      netRate,
      amount,
      taxPer,
      taxAmount,
      totalAmount,
      taxtype,
      cgstPer,
      sgstPer,
      igstPer,
      cgstAmount,
      sgstAmount,
      igstAmount,
      stateCode,
      0,
      LoginUserID,
      CompanyID.toString(),
      0,
      HeaderDiscAmnr,
    ));

    await OfflineDbHelper.getInstance()
        .insertOldQuotationProduct(QuotationTable(
      qtNo,
      specification,
      productID,
      productName,
      unit,
      quantity,
      unitPrice,
      disc,
      discAmount,
      netRate,
      amount,
      taxPer,
      taxAmount,
      totalAmount,
      taxtype,
      cgstPer,
      sgstPer,
      igstPer,
      cgstAmount,
      sgstAmount,
      igstAmount,
      stateCode,
      0,
      LoginUserID,
      CompanyID.toString(),
      0,
      HeaderDiscAmnr,
    ));
  }

  _OnInquiryNoTodeleteAllProduct(QuotationProductDeleteResponseState state) {
    print(
        "QuotationProductDeleteResponse " + state.response.details[0].column1);
  }

  Widget FollowupFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Followup Notes *",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 7, right: 7, top: 10),
          child: TextFormField(
            controller: edt_FollowupNotes,
            minLines: 2,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                hintText: 'Enter Notes',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                )),
          ),
        ),
        SizedBox(
          width: 20,
          height: 15,
        ),
        InkWell(
          onTap: () {
            _selectNextFollowupDate(context, edt_NextFollowupDate);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Text("Next FollowUp Date *",
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
                        child: Text(
                          edt_NextFollowupDate.text == null ||
                                  edt_NextFollowupDate.text == ""
                              ? "DD-MM-YYYY"
                              : edt_NextFollowupDate.text,
                          style: baseTheme.textTheme.headline3.copyWith(
                              color: edt_NextFollowupDate.text == null ||
                                      edt_NextFollowupDate.text == ""
                                  ? colorGrayDark
                                  : colorBlack),
                        ),
                      ),
                      Icon(
                        Icons.calendar_today_outlined,
                        color: colorGrayDark,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          width: 20,
          height: 15,
        ),
        InkWell(
          onTap: () {
            _selectTime(context, edt_PreferedTime);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Text("Preferred Time",
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
                        child: Text(
                          edt_PreferedTime.text == null ||
                                  edt_PreferedTime.text == ""
                              ? "HH:MM:SS"
                              : edt_PreferedTime.text,
                          style: baseTheme.textTheme.headline3.copyWith(
                              color: edt_PreferedTime.text == null ||
                                      edt_PreferedTime.text == ""
                                  ? colorGrayDark
                                  : colorBlack),
                        ),
                      ),
                      Icon(
                        Icons.watch_later_outlined,
                        color: colorGrayDark,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          width: 20,
          height: 15,
        ),
      ],
    );
  }

  Future<void> _selectNextFollowupDate(
      BuildContext context, TextEditingController F_datecontroller) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        edt_NextFollowupDate.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        edt_ReverseNextFollowupDate.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController F_datecontroller) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
        });

    if (picked_s != null && picked_s != selectedTime)
      setState(() {
        selectedTime = picked_s;

        String AM_PM =
            selectedTime.periodOffset.toString() == "12" ? "PM" : "AM";
        String beforZeroHour = selectedTime.hourOfPeriod <= 9
            ? "0" + selectedTime.hourOfPeriod.toString()
            : selectedTime.hourOfPeriod.toString();
        String beforZerominute = selectedTime.minute <= 9
            ? "0" + selectedTime.minute.toString()
            : selectedTime.minute.toString();

        edt_PreferedTime.text = beforZeroHour +
            ":" +
            beforZerominute +
            " " +
            AM_PM; //picked_s.periodOffset.toString();
      });
  }

  void _OnQuotationNoToProductListResponse(
      QuotationNoToProductListCallResponseState state) {
    for (var i = 0; i < state.response.details.length; i++) {
      /* String LoginUserID="abc";
    String CompanyId="0";
    String InquiryNo="0";*/
      String ProductName = state.response.details[i].productName;
      String ProductID = state.response.details[i].productID.toString();
      String Unit = state.response.details[i].unit.toString();
      String Quantity = state.response.details[i].quantity.toString();
      String UnitPrice = state.response.details[i].unitRate.toString();
      double disc = state.response.details[i].discountPercent;
      double discAmount = state.response.details[i].discountAmt;

      double netRate = state.response.details[i].netRate;
      double amount = state.response.details[i].amount;
      int taxtype = state.response.details[i].taxType;
      double taxper = state.response.details[i].taxRate;
      double taxAmount = state.response.details[i].taxAmount;
      double netAmount = state.response.details[i].netAmount;
      double CGSTPer = state.response.details[i].cGSTPer;
      double SGSTPer = state.response.details[i].sGSTPer;
      double IGSTPer = state.response.details[i].iGSTPer;
      double CGSTAmount = state.response.details[i].cGSTAmt;
      double SGSTAmount = state.response.details[i].sGSTAmt;
      double IGSTAmount = state.response.details[i].iGSTAmt;
      double HeaderDiscAmnr = state.response.details[i].headerDiscAmt;

      // double totamnt = double.parse(Quantity) * double.parse(UnitPrice);
      //String TotalAmount = totamnt.toString();
      String Specification =
          state.response.details[i].productSpecification.toString();
      String QTNo = state.response.details[i].quotationNo.toString();
      int StateCode = state.StateCode;

      edt_HeaderDisc.text =
          state.response.details[i].headerDiscountAmt.toStringAsFixed(2);

      _onTapOfAdd(
          ProductName,
          ProductID,
          Quantity,
          UnitPrice,
          netAmount,
          Specification,
          QTNo,
          Unit,
          disc,
          discAmount,
          netRate,
          amount,
          taxtype,
          taxper,
          taxAmount,
          CGSTPer,
          SGSTPer,
          IGSTPer,
          CGSTAmount,
          SGSTAmount,
          IGSTAmount,
          StateCode,
          HeaderDiscAmnr);
    }
  }

  Widget InqNoList(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      TextEditingController controller1,
      TextEditingController controllerpkID,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          InkWell(
            onTap: () => showcustomdialogWithID(
                values: arr_ALL_Name_ID_For_InqNoList,
                context1: context,
                controller: edt_InquiryNo,
                controllerID: edt_InquiryNoID,
                lable: "Select InquiryNo. "),
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

  Widget KindAttList(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      TextEditingController controller1,
      TextEditingController controllerpkID,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          InkWell(
            onTap:
                () => /*showcustomdialogWithID(
                values: Custom_values1,
                context1: context,
                controller: controllerForLeft,
                controllerID: controllerpkID,
                lable: "Select $Category")*/
                    {
              if (edt_CustomerpkID != "")
                {
                  _inquiryBloc.add(QuotationKindAttListCallEvent(
                      QuotationKindAttListApiRequest(
                          CompanyId: CompanyID.toString(),
                          CustomerID: edt_CustomerpkID.text)))
                }
            },
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

  Widget ProjectList(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      TextEditingController controller1,
      TextEditingController controllerpkID,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          InkWell(
            onTap:
                () => /*showcustomdialogWithID(
                values: Custom_values1,
                context1: context,
                controller: controllerForLeft,
                controllerID: controllerpkID,
                lable: "Select $Category")*/

                    _inquiryBloc.add(QuotationProjectListCallEvent(
                        QuotationProjectListRequest(
                            CompanyId: CompanyID.toString(),
                            LoginUserID: LoginUserID))),
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

  Widget TermsConditionList(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      TextEditingController controller1,
      TextEditingController controllerpkID,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          InkWell(
            onTap:
                () => /*showcustomdialogWithID(
                values: Custom_values1,
                context1: context,
                controller: controllerForLeft,
                controllerID: controllerpkID,
                lable: "Select $Category")*/

                    _inquiryBloc.add(QuotationTermsConditionCallEvent(
                        QuotationTermsConditionRequest(
                            CompanyId: CompanyID.toString(),
                            LoginUserID: LoginUserID))),
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

  void _OnKindAttListResponseSucess(QuotationKindAttListResponseState state) {
    if (state.response.details.length != 0) {
      arr_ALL_Name_ID_For_KindAttList.clear();
      for (var i = 0; i < state.response.details.length; i++) {
        print("InquiryStatus : " + state.response.details[i].contactPerson1);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].contactPerson1;
        all_name_id.pkID = state.response.details[i].customerID;
        arr_ALL_Name_ID_For_KindAttList.add(all_name_id);
      }
      showcustomdialogWithID(
          values: arr_ALL_Name_ID_For_KindAttList,
          context1: context,
          controller: edt_KindAtt,
          controllerID: edt_KindAttID,
          lable: "Select Kind Att.");
    }
  }

  void _OnProjectListResponseSucess(QuotationProjectListResponseState state) {
    if (state.response.details.length != 0) {
      arr_ALL_Name_ID_For_ProjectList.clear();
      for (var i = 0; i < state.response.details.length; i++) {
        print("InquiryStatus : " + state.response.details[i].projectName);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].projectName;
        all_name_id.pkID = state.response.details[i].pkID;
        arr_ALL_Name_ID_For_ProjectList.add(all_name_id);
      }
      showcustomdialogWithID(
          values: arr_ALL_Name_ID_For_ProjectList,
          context1: context,
          controller: edt_ProjectName,
          controllerID: edt_ProjectID,
          lable: "Select Project ");
    }
  }

  void _OnTermConditionListResponse(QuotationTermsCondtionResponseState state) {
    if (state.response.details.length != 0) {
      arr_ALL_Name_ID_For_TermConditionList.clear();
      for (var i = 0; i < state.response.details.length; i++) {
        print("InquiryStatus : " + state.response.details[i].tNCHeader);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].tNCHeader;
        all_name_id.pkID = state.response.details[i].pkID;
        all_name_id.Name1 = state.response.details[i].tNCContent;

        arr_ALL_Name_ID_For_TermConditionList.add(all_name_id);
      }
      showcustomdialogWithMultipleID(
          values: arr_ALL_Name_ID_For_TermConditionList,
          context1: context,
          controller: edt_TermConditionHeader,
          controllerID: edt_TermConditionHeaderID,
          controller2: edt_TermConditionFooter,
          lable: "Select Term & Condition ");
    }
  }

  void _OnCustIdToInqNoListResponse(CustIdToInqListResponseState state) {
    if (state.response.details.length != 0) {
      setState(() {
        edt_InquiryNoExist.text = "true";
      });

      arr_ALL_Name_ID_For_InqNoList.clear();
      for (var i = 0; i < state.response.details.length; i++) {
        print("InquiryStatus : " + state.response.details[i].inquiryNo);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].inquiryNo;
        all_name_id.pkID = state.response.details[i].customerID;

        arr_ALL_Name_ID_For_InqNoList.add(all_name_id);
      }
    } else {
      setState(() {
        edt_InquiryNoExist.text = "";
      });
      arr_ALL_Name_ID_For_InqNoList.clear();
    }
  }

  void _OnInqNotoProductListResponse(
      InqNoToProductListResponseState state) async {
    for (var i = 0; i < state.response.details.length; i++) {
      double Quantity = state.response.details[i].quantity;
      double UnitPrice = state.response.details[i].unitPrice;
      double DisPer = 0.00;
      double NetRate = 0.00;
      double Amount = 0.00;
      double TaxPer = state.response.details[i].taxRate;
      double TaxAmount = 0.00;
      int TaxType = state.response.details[i].taxType;
      double Amount1 = 0.00;
      double TaxAmount1 = 0.00;
      double TotalAmount = 0.00;
      double NetRate1 = 0.00; //(UnitPrice * DisPer) / 100;
      /* double CGSTPer1 =0.00;
      double SGSTPer1 =0.00;
      double IGSTPer1 =0.00;
      double CGSTAmount1 =0.00;
      double SGSTAmount1 =0.00;
      double IGSTAmount1 =0.00;*/
      double CGSTPer = 0.00;
      double SGSTPer = 0.00;
      double IGSTPer = 0.00;
      double CGSTAmount = 0.00;
      double SGSTAmount = 0.00;
      double IGSTAmount = 0.00;

      NetRate1 = UnitPrice;
      NetRate = NetRate1;
      if (TaxType == 1) {
        Amount1 = Quantity * NetRate1;
        Amount = Amount1;
        TaxAmount1 = (Amount1 * TaxPer) / 100;
        TaxAmount = TaxAmount1;
        TotalAmount = Amount1 + TaxAmount1;
      } else {
        Amount1 = 0.00;
        TaxAmount1 = 0.00;
        TotalAmount = 0.00;

        TaxAmount1 = ((Quantity * NetRate1) * TaxPer) / (100 + TaxPer);
        Amount1 = (Quantity * NetRate1) - TaxAmount1;
        TotalAmount = (Quantity * NetRate1);

        /*TaxAmount1 = ((Quantity * NetRate1) * TaxPer) / (100 + TaxPer);
        TaxAmount = getNumber(TaxAmount1, precision: 2);

        Amount1 = (Quantity * NetRate1) - getNumber(TaxAmount1, precision: 2);
        Amount = getNumber(Amount1, precision: 2);

        TotalAmount =
            (Quantity * NetRate1) + getNumber(TaxAmount1, precision: 2);*/
        // _totalAmountController.text = getNumber(TotalAmount,precision: 2).toString();
      }

      if (_offlineLoggedInData.details[0].stateCode ==
          int.parse(edt_StateCode.text)) {
        CGSTPer = TaxPer / 2;
        SGSTPer = TaxPer / 2;
        CGSTAmount = TaxAmount / 2;
        SGSTAmount = TaxAmount / 2;
        IGSTPer = 0.00;
        IGSTAmount = 0.00;
      } else {
        CGSTPer = 0.00;
        SGSTPer = 0.00;
        CGSTAmount = 0.00;
        SGSTAmount = 0.00;
        IGSTPer = TaxPer;
        IGSTAmount = TaxAmount;
      }

      await OfflineDbHelper.getInstance().insertQuotationProduct(QuotationTable(
          "",
          state.response.details[i].productSpecification,
          state.response.details[i].productID,
          state.response.details[i].productName,
          state.response.details[i].unit,
          Quantity,
          UnitPrice,
          0.00,
          0.00,
          NetRate,
          Amount,
          TaxPer,
          TaxAmount,
          TotalAmount,
          TaxType,
          CGSTPer,
          SGSTPer,
          IGSTPer,
          CGSTAmount,
          SGSTAmount,
          IGSTAmount,
          int.parse(edt_StateCode.text),
          0,
          LoginUserID,
          CompanyID.toString(),
          0,
          0.00));
    }
  }

  double getNumber(double input, {int precision = 2}) => double.parse(
      '$input'.substring(0, '$input'.indexOf('.') + precision + 1));

  void _onTaptoSaveQuotationHeader(BuildContext context) async {
    /* bool isExistNetAmnt = false;
    if (_isForUpdate == true) {
      if (IsWithoutTapOtherCharges == false) {
        await getInquiryProductDetails();

        _OnTaptoSave();
        print("netamountfj" + " NetAmnt : " + netAmountController.toString());
        PushAllOtherChargesToDb();
        print("netamountfj" + " NetAmnt1 : " + netAmountController.toString());
        isExistNetAmnt = true;
      } else {
        isExistNetAmnt = false;
      }
    } else {
      isExistNetAmnt = false;
    }*/
    print("netamountfj" + " NetAmnt2 : " + netAmountController.toString());

    print("NETAMNTRT" + " NETAMNT : " + editMode_netamount_controller.text);
    await getInquiryProductDetails();
    List<QT_OtherChargeTable> tempOtherCharges =
        await OfflineDbHelper.getInstance().getQuotationOtherCharge();

    if (edt_InquiryDate.text != "") {
      if (edt_CustomerName.text != "") {
        if (edt_Portal_details.text != "") {
          if (_inquiryProductList.length != 0) {
            showCommonDialogWithTwoOptions(
                context, "Are you sure you want to Save this Quotation ?",
                negativeButtonTitle: "No",
                positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
              _OnTaptoSave();
              print("netamountfj" +
                  " NetAmnt : " +
                  netAmountController.toString());
              PushAllOtherChargesToDb();
              print("netamountfj" +
                  " NetAmnt1 : " +
                  netAmountController.toString());

              Navigator.of(context).pop();

              if (InquiryNo != '') {
                _inquiryBloc.add(QuotationDeleteProductCallEvent(
                    InquiryNo,
                    QuotationProductDeleteRequest(
                        CompanyId: CompanyID.toString())));
              } else {}

              double tot_basicAmount = 0.00;
              double tot_CGSTAmount = 0.00;
              double tot_SGSTAmount = 0.00;
              double tot_IGSTAmount = 0.00;
              double tot_DiscountAmount = 0.00;
              double tot_NetAmount = 0.00;

              for (int i = 0; i < _inquiryProductList.length; i++) {
                tot_basicAmount =
                    tot_basicAmount + _inquiryProductList[i].Amount;
                tot_DiscountAmount =
                    tot_DiscountAmount + _inquiryProductList[i].DiscountAmt;
                tot_NetAmount =
                    tot_NetAmount + _inquiryProductList[i].NetAmount;

                if (_offlineLoggedInData.details[0].stateCode ==
                    int.parse(edt_StateCode.text)) {
                  tot_CGSTAmount =
                      tot_CGSTAmount + _inquiryProductList[i].CGSTAmt;
                  tot_SGSTAmount =
                      tot_SGSTAmount + _inquiryProductList[i].SGSTAmt;
                  tot_IGSTAmount = 0.00;
                } else {
                  tot_IGSTAmount =
                      tot_IGSTAmount + _inquiryProductList[i].IGSTAmt;
                  tot_CGSTAmount = 0.00;
                  tot_SGSTAmount = 0.00;
                }
              }

              String ChargeID1 = "";
              String ChargeAmt1 = "";
              String ChargeBasicAmt1 = "";
              String ChargeGSTAmt1 = "";
              String ChargeID2 = "";
              String ChargeAmt2 = "";
              String ChargeBasicAmt2 = "";
              String ChargeGSTAmt2 = "";
              String ChargeID3 = "";
              String ChargeAmt3 = "";
              String ChargeBasicAmt3 = "";
              String ChargeGSTAmt3 = "";
              String ChargeID4 = "";
              String ChargeAmt4 = "";
              String ChargeBasicAmt4 = "";
              String ChargeGSTAmt4 = "";
              String ChargeID5 = "";
              String ChargeAmt5 = "";
              String ChargeBasicAmt5 = "";
              String ChargeGSTAmt5 = "";

              if (tempOtherCharges.length != 0) {
                for (int i = 0; i < tempOtherCharges.length; i++) {
                  print("Cjkdfj" +
                      " ChargeId : " +
                      tempOtherCharges[i].ChargeID1.toString());
                  ChargeID1 = tempOtherCharges[i].ChargeID1.toString();
                  ChargeAmt1 =
                      tempOtherCharges[i].ChargeAmt1.toStringAsFixed(2);
                  ChargeBasicAmt1 =
                      tempOtherCharges[i].ChargeBasicAmt1.toStringAsFixed(2);
                  ChargeGSTAmt1 =
                      tempOtherCharges[i].ChargeGSTAmt1.toStringAsFixed(2);
                  ChargeID2 = tempOtherCharges[i].ChargeID2.toString();
                  ChargeAmt2 =
                      tempOtherCharges[i].ChargeAmt2.toStringAsFixed(2);
                  ChargeBasicAmt2 =
                      tempOtherCharges[i].ChargeBasicAmt2.toStringAsFixed(2);
                  ChargeGSTAmt2 =
                      tempOtherCharges[i].ChargeGSTAmt2.toStringAsFixed(2);
                  ChargeID3 = tempOtherCharges[i].ChargeID3.toString();
                  ChargeAmt3 =
                      tempOtherCharges[i].ChargeAmt3.toStringAsFixed(2);
                  ChargeBasicAmt3 =
                      tempOtherCharges[i].ChargeBasicAmt3.toStringAsFixed(2);
                  ChargeGSTAmt3 =
                      tempOtherCharges[i].ChargeGSTAmt3.toStringAsFixed(2);
                  ChargeID4 = tempOtherCharges[i].ChargeID4.toString();
                  ChargeAmt4 =
                      tempOtherCharges[i].ChargeAmt4.toStringAsFixed(2);
                  ChargeBasicAmt4 =
                      tempOtherCharges[i].ChargeBasicAmt4.toStringAsFixed(2);
                  ChargeGSTAmt4 =
                      tempOtherCharges[i].ChargeGSTAmt4.toStringAsFixed(2);
                  ChargeID5 = tempOtherCharges[i].ChargeID5.toString();
                  ChargeAmt5 =
                      tempOtherCharges[i].ChargeAmt5.toStringAsFixed(2);
                  ChargeBasicAmt5 =
                      tempOtherCharges[i].ChargeBasicAmt5.toStringAsFixed(2);
                  ChargeGSTAmt5 =
                      tempOtherCharges[i].ChargeGSTAmt5.toStringAsFixed(2);
                }
              } else {
                ChargeID1 = "";
                ChargeAmt1 = "";
                ChargeBasicAmt1 = "";
                ChargeGSTAmt1 = "";
                ChargeID2 = "";
                ChargeAmt2 = "";
                ChargeBasicAmt2 = "";
                ChargeGSTAmt2 = "";
                ChargeID3 = "";
                ChargeAmt3 = "";
                ChargeBasicAmt3 = "";
                ChargeGSTAmt3 = "";
                ChargeID4 = "";
                ChargeAmt4 = "";
                ChargeBasicAmt4 = "";
                ChargeGSTAmt4 = "";
                ChargeID5 = "";
                ChargeAmt5 = "";
                ChargeBasicAmt5 = "";
                ChargeGSTAmt5 = "";
              }

              print("Assumptionn" +
                  _contrller_other_Remarks.text +
                  " Assumption : " +
                  _controller_Ref_Inquiry.text);

              _inquiryBloc.add(QuotationHeaderSaveCallEvent(
                  context,
                  pkID,
                  QuotationHeaderSaveRequest(
                      pkID: pkID.toString(),
                      InquiryNo:
                          edt_InquiryNo.text == null ? "" : edt_InquiryNo.text,
                      QuotationNo: InquiryNo,
                      QuotationDate: edt_ReverseInquiryDate.text,
                      CustomerID: edt_CustomerpkID.text,
                      ProjectName: edt_ProjectName.text,
                      QuotationSubject: _controller_select_email_subject.text,
                      QuotationHeader: _contrller_Email_Discription.text,
                      QuotationFooter: edt_TermConditionFooter.text,
                      LoginUserID: LoginUserID,
                      Latitude: SharedPrefHelper.instance.getLatitude(),
                      Longitude: SharedPrefHelper.instance.getLongitude(),
                      DiscountAmt: edt_HeaderDisc.text.toString(),
                      SGSTAmt: tot_SGSTAmount.toString(),
                      CGSTAmt: tot_CGSTAmount.toString(),
                      IGSTAmt: tot_IGSTAmount.toString(),
                      ChargeID1: ChargeID1,
                      ChargeAmt1: ChargeAmt1,
                      ChargeBasicAmt1: ChargeBasicAmt1,
                      ChargeGSTAmt1: ChargeGSTAmt1,
                      ChargeID2: ChargeID2,
                      ChargeAmt2: ChargeAmt2,
                      ChargeBasicAmt2: ChargeBasicAmt2,
                      ChargeGSTAmt2: ChargeGSTAmt2,
                      ChargeID3: ChargeID3,
                      ChargeAmt3: ChargeAmt3,
                      ChargeBasicAmt3: ChargeBasicAmt3,
                      ChargeGSTAmt3: ChargeGSTAmt3,
                      ChargeID4: ChargeID4,
                      ChargeAmt4: ChargeAmt4,
                      ChargeBasicAmt4: ChargeBasicAmt4,
                      ChargeGSTAmt4: ChargeGSTAmt4,
                      ChargeID5: ChargeID5,
                      ChargeAmt5: ChargeAmt5,
                      ChargeBasicAmt5: ChargeBasicAmt5,
                      ChargeGSTAmt5: ChargeGSTAmt5,
                      NetAmt:
                          netAmountController /*isExistNetAmnt == true
                          ? netAmountController
                          : tot_NetAmount.toString()*/
                      ,
                      BasicAmt: tot_basicAmount.toString(),
                      ROffAmt: "0.00",
                      ChargePer1: "0.00",
                      ChargePer2: "0.00",
                      ChargePer3: "0.00",
                      ChargePer4: "0.00",
                      ChargePer5: "0.00",
                      CompanyId: CompanyID.toString(),
                      BankID: edt_Portal_details_ID.text,
                      AdditionalRemarks: _contrller_other_Remarks.text,
                      AssumptionRemarks: _controller_Ref_Inquiry.text)));
            });
          } else {
            showCommonDialogWithSingleOption(
                context, "Quotation Product is required !",
                positiveButtonTitle: "OK");
          }
        } else {
          showCommonDialogWithSingleOption(
              context, "Bank Details is required !",
              positiveButtonTitle: "OK");
        }
      } else {
        showCommonDialogWithSingleOption(context, "Customer name is required !",
            positiveButtonTitle: "OK");
      }
    } else {
      showCommonDialogWithSingleOption(context, "Quotation date is required !",
          positiveButtonTitle: "OK");
    }
  }

  void _OnQuotationHeaderSaveSucessResponse(
      QuotationHeaderSaveResponseState state) {
    int returnPKID = 0;
    String retrunQT_No = "";
    for (int i = 0; i < state.response.details.length; i++) {
      returnPKID = state.response.details[i].column3;
      retrunQT_No = state.response.details[i].column4;
    }
    updateRetrunInquiryNoToDB(state.context, returnPKID, retrunQT_No);
    String notiTitle = "Quotation";
    String updatemsg = _isForUpdate == true ? " Updated " : " Created ";

    ///state.inquiryHeaderSaveResponse.details[0].column3;
    String notibody = "Quotation " +
        retrunQT_No +
        updatemsg +
        " For " +
        edt_CustomerName.text +
        " By " +
        _offlineLoggedInData.details[0].employeeName;

    var request123 = {
      "to": ReportToToken,
      "notification": {"body": notibody, "title": notiTitle},
      "data": {
        "body": notibody,
        "title": notiTitle,
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
      }
    };

    print("Notificationdf" + request123.toString());
    _inquiryBloc.add(FCMNotificationRequestEvent(request123));
  }

  void _OnQuotationProductSaveSucessResponse(
      QuotationProductSaveResponseState state) async {
    String Msg = _isForUpdate == true
        ? "Quotation Updated Successfully"
        : "Quotation Added Successfully";

    /* showCommonDialogWithSingleOption(context, Msg,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          navigateTo(context, InquiryListScreen.routeName, clearAllStack: true);
        });*/
    await showCommonDialogWithSingleOption(Globals.context, Msg,
        positiveButtonTitle: "OK");
    Navigator.of(context).pop();
  }

  void updateRetrunInquiryNoToDB(
      BuildContext context1, int pkID, String ReturnQT_No) async {
    await getInquiryProductDetails();

    _inquiryProductList.forEach((element) {
      element.pkID = pkID;
      element.LoginUserID = LoginUserID;
      element.CompanyId = CompanyID.toString();
    });
    _inquiryBloc.add(QuotationProductSaveCallEvent(
        context1, ReturnQT_No, _inquiryProductList));
  }

  void _onOtherChargeListResponse(QuotationOtherChargeListResponseState state) {
    int chrID1 = 0;
    int chrID2 = 0;
    int chrID3 = 0;
    int chrID4 = 0;
    int chrID5 = 0;

    for (int i = 0;
        i < state.quotationOtherChargesListResponse.details.length;
        i++) {
      if (edt_ChargeID1.text ==
          state.quotationOtherChargesListResponse.details[i].pkId.toString()) {
        chrID1 = state.quotationOtherChargesListResponse.details[i].pkId;
        edt_ChargeID1.text = chrID1.toString();

        edt_ChargeName1.text =
            state.quotationOtherChargesListResponse.details[i].chargeName;

        edt_ChargeTaxType1.text = state
            .quotationOtherChargesListResponse.details[i].taxType
            .toString();
        edt_ChargeGstPer1.text = state
            .quotationOtherChargesListResponse.details[i].gSTPer
            .toString();
        edt_ChargeBeforGST1.text = state
            .quotationOtherChargesListResponse.details[i].beforeGST
            .toString();
      } else if (edt_ChargeID2.text ==
          state.quotationOtherChargesListResponse.details[i].pkId.toString()) {
        chrID2 = state.quotationOtherChargesListResponse.details[i].pkId;
        edt_ChargeID2.text = chrID2.toString();
        edt_ChargeName2.text =
            state.quotationOtherChargesListResponse.details[i].chargeName;

        edt_ChargeTaxType2.text = state
            .quotationOtherChargesListResponse.details[i].taxType
            .toString();
        edt_ChargeGstPer2.text = state
            .quotationOtherChargesListResponse.details[i].gSTPer
            .toString();
        edt_ChargeBeforGST2.text = state
            .quotationOtherChargesListResponse.details[i].beforeGST
            .toString();
      } else if (edt_ChargeID3.text ==
          state.quotationOtherChargesListResponse.details[i].pkId.toString()) {
        chrID3 = state.quotationOtherChargesListResponse.details[i].pkId;
        edt_ChargeID3.text = chrID3.toString();
        edt_ChargeName3.text =
            state.quotationOtherChargesListResponse.details[i].chargeName;

        edt_ChargeTaxType3.text = state
            .quotationOtherChargesListResponse.details[i].taxType
            .toString();
        edt_ChargeGstPer3.text = state
            .quotationOtherChargesListResponse.details[i].gSTPer
            .toString();
        edt_ChargeBeforGST3.text = state
            .quotationOtherChargesListResponse.details[i].beforeGST
            .toString();
      } else if (edt_ChargeID4.text ==
          state.quotationOtherChargesListResponse.details[i].pkId.toString()) {
        chrID4 = state.quotationOtherChargesListResponse.details[i].pkId;
        edt_ChargeID4.text = chrID4.toString();
        edt_ChargeName4.text =
            state.quotationOtherChargesListResponse.details[i].chargeName;

        edt_ChargeTaxType4.text = state
            .quotationOtherChargesListResponse.details[i].taxType
            .toString();
        edt_ChargeGstPer4.text = state
            .quotationOtherChargesListResponse.details[i].gSTPer
            .toString();
        edt_ChargeBeforGST4.text = state
            .quotationOtherChargesListResponse.details[i].beforeGST
            .toString();
      } else if (edt_ChargeID5.text ==
          state.quotationOtherChargesListResponse.details[i].pkId.toString()) {
        chrID5 = state.quotationOtherChargesListResponse.details[i].pkId;
        edt_ChargeID5.text = chrID5.toString();
        edt_ChargeName5.text =
            state.quotationOtherChargesListResponse.details[i].chargeName;

        edt_ChargeTaxType5.text = state
            .quotationOtherChargesListResponse.details[i].taxType
            .toString();
        edt_ChargeGstPer5.text = state
            .quotationOtherChargesListResponse.details[i].gSTPer
            .toString();
        edt_ChargeBeforGST5.text = state
            .quotationOtherChargesListResponse.details[i].beforeGST
            .toString();
      }
    }
  }

  Widget BankDropDown(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      TextEditingController controller1,
      TextEditingController controllerpkID,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () => _inquiryBloc
              ..add(QuotationBankDropDownCallEvent(BankDropDownRequest(
                  CompanyID: CompanyID.toString(),
                  LoginUserID: LoginUserID,
                  pkID: ""))),
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

  void _onBankVoucherSaveResponse(QuotationBankDropDownResponseState state) {
    arr_ALL_Name_ID_For_BankDropDownList.clear();
    for (var i = 0; i < state.response.details.length; i++) {
      ALL_Name_ID all_name_id = new ALL_Name_ID();
      all_name_id.pkID = state.response.details[i].pkID;
      all_name_id.Name = state.response.details[i].bankName;
      arr_ALL_Name_ID_For_BankDropDownList.add(all_name_id);
    }
    showcustomdialogWithID(
        values: arr_ALL_Name_ID_For_BankDropDownList,
        context1: context,
        controller: edt_Portal_details,
        controllerID: edt_Portal_details_ID,
        lable: "Select Bank Portal");
  }

  void _onGetTokenfromReportopersonResult(GetReportToTokenResponseState state) {
    ReportToToken = state.response.details[0].reportPersonTokenNo;
  }

  void _onRecevedNotification(FCMNotificationResponseState state) {
    print("fcm_notification" +
        state.response.canonicalIds.toString() +
        state.response.failure.toString() +
        state.response.multicastId.toString() +
        state.response.success.toString() +
        state.response.results[0].messageId);
  }

  void _OnEmailContentResponse(QuotationEmailContentResponseState state) {
    if (state.response.details.length != 0) {
      arr_ALL_Name_ID_For_Email_Subject.clear();
      for (var i = 0; i < state.response.details.length; i++) {
        print("InquiryStatus : " + state.response.details[i].contentData);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].subject;
        all_name_id.pkID = state.response.details[i].pkID;
        all_name_id.Name1 = state.response.details[i].contentData;

        arr_ALL_Name_ID_For_Email_Subject.add(all_name_id);
      }

      showcustomdialogWithMultipleID(
          values: arr_ALL_Name_ID_For_Email_Subject,
          context1: context,
          controller: _controller_select_email_subject,
          controllerID: _controller_select_email_subject_ID,
          controller2: _contrller_Email_Discription,
          lable: "Select Email Content ");
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
                    "Add Email Subject",
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
                            child: Text("Subject *",
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
                            margin: EdgeInsets.only(left: 10, right: 10),
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
                                          controller:
                                              _contrller_Email_Add_Subject,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            hintText: "Tap to enter Subject",
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
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Text("Email Content *",
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
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Card(
                              elevation: 5,
                              color: colorLightGray,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                width: double.maxFinite,
                                height: 100,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: TextField(
                                          controller:
                                              _contrller_Email_Add_Content,
                                          decoration: InputDecoration(
                                            hintText: "Tap to enter content",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: getCommonButton(baseTheme, () async {
                            if (_contrller_Email_Add_Subject.text != "") {
                              if (_contrller_Email_Add_Content.text != "") {
                                Navigator.pop(context123);

                                _inquiryBloc.add(SaveEmailContentRequestEvent(
                                    SaveEmailContentRequest(
                                        pkID: "0",
                                        Subject:
                                            _contrller_Email_Add_Subject.text,
                                        ContentData:
                                            _contrller_Email_Add_Content.text,
                                        LoginUserID: LoginUserID,
                                        CompanyId: CompanyID.toString())));
                              } else {
                                showCommonDialogWithSingleOption(
                                    context, "Email content is required !",
                                    positiveButtonTitle: "OK");
                              }
                            } else {
                              showCommonDialogWithSingleOption(
                                  context, "Subject is required !",
                                  positiveButtonTitle: "OK");
                            }
                          }, "Add",
                              backGroundColor: colorPrimary,
                              textColor: colorWhite,
                              radius: 36),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 100,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: getCommonButton(baseTheme, () {
                            Navigator.pop(context);
                          }, "Close",
                              backGroundColor: colorPrimary,
                              textColor: colorWhite,
                              radius: 36),
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

  void _OnSaveEmailContentResponse(SaveEmailContentResponseState state) {
    showCommonDialogWithSingleOption(context, state.response.details[0].column2,
        positiveButtonTitle: "OK");
  }

  void _OnChargID1Response(QuotationOtherCharge1ListResponseState state) {
    OtherChargeTaxType1 =
        state.quotationOtherChargesListResponse.details[0].taxType.toString();
    OtherChargeGstPer1 = state
        .quotationOtherChargesListResponse.details[0].gSTPer
        .toStringAsFixed(2);
    OtherChargeBeforGst1 =
        state.quotationOtherChargesListResponse.details[0].beforeGST.toString();
  }

  void _OnChargID2Response(QuotationOtherCharge2ListResponseState state) {
    OtherChargeTaxType2 =
        state.quotationOtherChargesListResponse.details[0].taxType.toString();
    OtherChargeGstPer2 = state
        .quotationOtherChargesListResponse.details[0].gSTPer
        .toStringAsFixed(2);
    OtherChargeBeforGst2 =
        state.quotationOtherChargesListResponse.details[0].beforeGST.toString();
  }

  void _OnChargID3Response(QuotationOtherCharge3ListResponseState state) {
    OtherChargeTaxType3 =
        state.quotationOtherChargesListResponse.details[0].taxType.toString();
    OtherChargeGstPer3 = state
        .quotationOtherChargesListResponse.details[0].gSTPer
        .toStringAsFixed(2);
    OtherChargeBeforGst3 =
        state.quotationOtherChargesListResponse.details[0].beforeGST.toString();
  }

  void _OnChargID4Response(QuotationOtherCharge4ListResponseState state) {
    OtherChargeTaxType4 =
        state.quotationOtherChargesListResponse.details[0].taxType.toString();
    OtherChargeGstPer4 = state
        .quotationOtherChargesListResponse.details[0].gSTPer
        .toStringAsFixed(2);
    OtherChargeBeforGst4 =
        state.quotationOtherChargesListResponse.details[0].beforeGST.toString();
  }

  void _OnChargID5Response(QuotationOtherCharge5ListResponseState state) {
    OtherChargeTaxType5 =
        state.quotationOtherChargesListResponse.details[0].taxType.toString();
    OtherChargeGstPer5 = state
        .quotationOtherChargesListResponse.details[0].gSTPer
        .toStringAsFixed(2);
    OtherChargeBeforGst5 =
        state.quotationOtherChargesListResponse.details[0].beforeGST.toString();
  }

  void _OnTaptoSave() async {
    HeaderDisAmnt = double.parse(edt_HeaderDisc.text.toString());

    TotalCalculation();
    TotalCalculation2();
    TotalCalculation3();
    TotalCalculation4();
    TotalCalculation5();

    double ChargeAmt1 = double.parse(OtherChargeAmount1);
    double ChargeAmt2 = double.parse(OtherChargeAmount2);
    double ChargeAmt3 = double.parse(OtherChargeAmount3);
    double ChargeAmt4 = double.parse(OtherChargeAmount4);
    double ChargeAmt5 = double.parse(OtherChargeAmount5);

    double TotalOtherAmnt =
        ChargeAmt1 + ChargeAmt2 + ChargeAmt3 + ChargeAmt4 + ChargeAmt5;

    Tot_BasicAmount = 0.00;
    Tot_otherChargeWithTax = 0.00;
    Tot_GSTAmt = 0.00;
    Tot_otherChargeExcludeTax = 0.00;
    Tot_NetAmt = 0.00;

    for (int i = 0; i < _inquiryProductList.length; i++) {
      Tot_BasicAmount = Tot_BasicAmount + _inquiryProductList[i].Amount;

      print(" GetBasicAmount " +
          " BasicTotal : " +
          _inquiryProductList[i].Amount.toStringAsFixed(2));
      Tot_otherChargeWithTax = 0.00;
      Tot_GSTAmt = Tot_GSTAmt + _inquiryProductList[i].TaxAmount;
      Tot_otherChargeExcludeTax = 0.00;
      Tot_NetAmt = Tot_NetAmt + _inquiryProductList[i].NetAmount;
    }

    UpdateAfterHeaderDiscount();
    Tot_otherChargeWithTax = (InclusiveBeforeGstAmnt1) +
        (ExclusiveBeforeGStAmnt1) +
        (InclusiveBeforeGstAmnt2) +
        (ExclusiveBeforeGStAmnt2) +
        (InclusiveBeforeGstAmnt3) +
        (ExclusiveBeforeGStAmnt3) +
        (InclusiveBeforeGstAmnt4) +
        (ExclusiveBeforeGStAmnt4) +
        (InclusiveBeforeGstAmnt5) +
        (ExclusiveBeforeGStAmnt5); //+ (ChargeAmt3 - devide3) + (ChargeAmt4 - devide4) + (ChargeAmt5 - devide5);
    Tot_GSTAmt = Tot_GSTAmt +
        InclusiveBeforeGstAmnt_Minus1 +
        ExclusiveBeforeGStAmnt_Minus1 +
        InclusiveBeforeGstAmnt_Minus2 +
        ExclusiveBeforeGStAmnt_Minus2 +
        InclusiveBeforeGstAmnt_Minus3 +
        ExclusiveBeforeGStAmnt_Minus3 +
        InclusiveBeforeGstAmnt_Minus4 +
        ExclusiveBeforeGStAmnt_Minus4 +
        InclusiveBeforeGstAmnt_Minus5 +
        ExclusiveBeforeGStAmnt_Minus5;
    Tot_otherChargeExcludeTax = AfterInclusiveBeforeGstAmnt1 +
        ExclusiveAfterGstAmnt1 +
        AfterInclusiveBeforeGstAmnt2 +
        ExclusiveAfterGstAmnt2 +
        AfterInclusiveBeforeGstAmnt3 +
        ExclusiveAfterGstAmnt3 +
        AfterInclusiveBeforeGstAmnt4 +
        ExclusiveAfterGstAmnt4 +
        AfterInclusiveBeforeGstAmnt5 +
        ExclusiveAfterGstAmnt5;

    _basicAmountController = Tot_BasicAmount.toStringAsFixed(2);
    _otherChargeWithTaxController = Tot_otherChargeWithTax.toStringAsFixed(2);

    ///Final Setup Befor GST
    _totalGstController = Tot_GSTAmt.toStringAsFixed(2);
    _otherChargeExcludeTaxController =
        Tot_otherChargeExcludeTax.toStringAsFixed(2);

    ///Final Setup After GST
    //double Tot_NetAmnt = Tot_NetAmt + Tot_otherChargeWithTax + Tot_otherChargeExcludeTax;

    double Tot_NetAmnt = Tot_NetAmt +
        TotalOtherAmnt +
        ExclusiveBeforeGStAmnt_Minus1 +
        ExclusiveBeforeGStAmnt_Minus2 +
        ExclusiveBeforeGStAmnt_Minus3 +
        ExclusiveBeforeGStAmnt_Minus4 +
        ExclusiveBeforeGStAmnt_Minus5;

    double MinusHeaderDiscamnt = Tot_NetAmnt - HeaderDisAmnt;

    netAmountController = /*nt.toStringAsFixed(
        2);*/
        MinusHeaderDiscamnt.toStringAsFixed(
            2); //Tot_BasicAmount.toStringAsFixed(2) + Tot_otherChargeWithTax.toStringAsFixed(2) + Tot_GSTAmt.toStringAsFixed(2) + Tot_otherChargeExcludeTax.toStringAsFixed(2);

    print("sNERg" + " NETAMNT : " + netAmountController);

    editMode_netamount_controller.text = MinusHeaderDiscamnt.toStringAsFixed(2);
  }

  void TotalCalculation() async {
    double ChargeAmt1 = double.parse(OtherChargeAmount1);

    double taxRate1 = double.parse(OtherChargeGstPer1);

    ///_otherChargeTaxTypeController1.text = 1 (Exclusive) -- _otherChargeTaxTypeController1.text = 0 (Inclusive)

    /// _otherChargeBeForeGSTController1.text=="true" (Before GST) _otherChargeBeForeGSTController1.text=="false" (After GST)
    ///
    double Taxtype = 0.00;
    int ISTaxType = 0;

    if (OtherChargeTaxType1 != null) {
      Taxtype = double.parse(OtherChargeTaxType1);
      ISTaxType = Taxtype.toInt();
    }

    print("sdfjdlf" + ISTaxType.toString());
    if (ISTaxType == 1) {
      InclusiveBeforeGstAmnt1 = 0.00;
      InclusiveBeforeGstAmnt_Minus1 = 0.00;
      AfterInclusiveBeforeGstAmnt1 = 0.00;
      if (OtherChargeBeforGst1 == "true") {
        double multi1 = 0.00;
        double addtaxt1 = 0.00;
        double devide1 = 0.00;
        multi1 = ChargeAmt1 * taxRate1;
        addtaxt1 = 100;
        devide1 = multi1 / addtaxt1;

        ExclusiveBeforeGStAmnt1 = ChargeAmt1;
        ExclusiveBeforeGStAmnt_Minus1 = devide1;
        ExclusiveAfterGstAmnt1 = 0.00;

        print("jfjfj44" + devide1.toString());
        //Tot_otherChargeWithTax = ChargeAmt1+ChargeAmt2 +ChargeAmt3+ChargeAmt4+ChargeAmt5;
      } else {
        // Tot_otherChargeExcludeTax =   ChargeAmt1+  ChargeAmt2 +ChargeAmt3+ChargeAmt4+ChargeAmt5;
        ExclusiveAfterGstAmnt1 = ChargeAmt1;
        ExclusiveBeforeGStAmnt1 = 0.00;
        ExclusiveBeforeGStAmnt_Minus1 = 0.00;
      }

      // Tot_GSTAmt =  ((ChargeAmt1 * taxRate1)/100) + ((ChargeAmt2 * taxRate2)/100) + ((ChargeAmt3 * taxRate3)/100) + ((ChargeAmt4 * taxRate4)/100) + ((ChargeAmt5 * taxRate5)/100);
    } else {
      ExclusiveBeforeGStAmnt1 = 0.00;
      ExclusiveBeforeGStAmnt_Minus1 = 0.00;
      ExclusiveAfterGstAmnt1 = 0.00;

      if (OtherChargeBeforGst1 == "true") {
        double multi1 = 0.00;
        double addtaxt1 = 0.00;
        double devide1 = 0.00;
        double to_InclusiveBeforeGstAmnt1 = 0.00;

        multi1 = ChargeAmt1 * taxRate1;
        addtaxt1 = 100 + taxRate1;
        devide1 = multi1 / addtaxt1;

        InclusiveBeforeGstAmnt1 = ChargeAmt1 - devide1;
        InclusiveBeforeGstAmnt_Minus1 = devide1;
        AfterInclusiveBeforeGstAmnt1 = 0.00;
      } else {
        // Tot_otherChargeExcludeTax = ChargeAmt1+  ChargeAmt2 +ChargeAmt3+ChargeAmt4+ChargeAmt5;
        InclusiveBeforeGstAmnt1 = 0.00;
        InclusiveBeforeGstAmnt_Minus1 = 0.00;
        AfterInclusiveBeforeGstAmnt1 = ChargeAmt1;
      }
    }

    print("DFDFDFDF232" +
        " TotalBasicAmt : " +
        Tot_BasicAmount.toStringAsFixed(2) +
        " Tot_otherChargeWithTax : " +
        Tot_otherChargeWithTax.toStringAsFixed(2) +
        " Tot_GSTAmt : " +
        Tot_GSTAmt.toStringAsFixed(2) +
        " Tot_otherChargeExcludeTax : " +
        Tot_otherChargeExcludeTax.toStringAsFixed(2) +
        " Tot_NetAmt : " +
        Tot_NetAmt.toStringAsFixed(2));
  }

  void TotalCalculation2() async {
    double ChargeAmt2 = double.parse(OtherChargeAmount2);

    double taxRate2 = double.parse(OtherChargeGstPer2);

    double Taxtype = 0.00;
    int ISTaxType = 0;

    if (OtherChargeTaxType2 != null) {
      Taxtype = double.parse(OtherChargeTaxType2);
      ISTaxType = Taxtype.toInt();
    }

    if (ISTaxType == 1) {
      InclusiveBeforeGstAmnt2 = 0.00;
      InclusiveBeforeGstAmnt_Minus2 = 0.00;
      AfterInclusiveBeforeGstAmnt2 = 0.00;
      if (OtherChargeBeforGst2 == "true") {
        double multi2 = 0.00;
        double addtaxt2 = 0.00;
        double devide2 = 0.00;

        multi2 = ChargeAmt2 * taxRate2;
        addtaxt2 = 100;
        devide2 = multi2 / addtaxt2;

        ExclusiveBeforeGStAmnt2 = ChargeAmt2;
        ExclusiveBeforeGStAmnt_Minus2 = devide2;
        ExclusiveAfterGstAmnt2 = 0.00;
      } else {
        //Tot_otherChargeExcludeTax =  ChargeAmt1+ChargeAmt2 +ChargeAmt3+ChargeAmt4+ChargeAmt5;
        ExclusiveAfterGstAmnt2 = ChargeAmt2;
        ExclusiveBeforeGStAmnt2 = 0.00;
        ExclusiveBeforeGStAmnt_Minus2 = 0.00;
      }

      //Tot_GSTAmt =  ((ChargeAmt1 * taxRate1)/100) + ((ChargeAmt2 * taxRate2)/100) + ((ChargeAmt3 * taxRate3)/100) + ((ChargeAmt4 * taxRate4)/100) + ((ChargeAmt5 * taxRate5)/100);
    } else {
      ExclusiveBeforeGStAmnt2 = 0.00;
      ExclusiveBeforeGStAmnt_Minus2 = 0.00;
      ExclusiveAfterGstAmnt2 = 0.00;

      if (OtherChargeBeforGst2 == "true") {
        double multi2 = 0.00;
        double addtaxt2 = 0.00;
        double devide2 = 0.00;
        double to_InclusiveBeforeGstAmnt2 = 0.00;

        multi2 = ChargeAmt2 * taxRate2;
        addtaxt2 = 100 + taxRate2;
        devide2 = multi2 / addtaxt2;

        InclusiveBeforeGstAmnt2 = ChargeAmt2 - devide2;
        InclusiveBeforeGstAmnt_Minus2 = devide2;
        AfterInclusiveBeforeGstAmnt2 = 0.00;
      } else {
        InclusiveBeforeGstAmnt2 = 0.00;
        InclusiveBeforeGstAmnt_Minus2 = 0.00;
        AfterInclusiveBeforeGstAmnt2 = ChargeAmt2;
      }
    }
  }

  void TotalCalculation3() async {
    double ChargeAmt3 = double.parse(OtherChargeAmount3);
    double taxRate3 = double.parse(OtherChargeGstPer3);
    double Taxtype = 0.00;
    int ISTaxType = 0;

    print("testOtherg" + OtherChargeTaxType3);

    if (OtherChargeTaxType3 != null) {
      Taxtype = double.parse(OtherChargeTaxType3);
      ISTaxType = Taxtype.toInt();
    }
    if (ISTaxType == 1) {
      InclusiveBeforeGstAmnt3 = 0.00;
      InclusiveBeforeGstAmnt_Minus3 = 0.00;
      AfterInclusiveBeforeGstAmnt3 = 0.00;
      if (OtherChargeBeforGst3 == "true") {
        double multi3 = 0.00;
        double addtaxt3 = 0.00;
        double devide3 = 0.00;

        multi3 = ChargeAmt3 * taxRate3;
        addtaxt3 = 100;
        devide3 = multi3 / addtaxt3;

        ExclusiveBeforeGStAmnt3 = ChargeAmt3;
        ExclusiveBeforeGStAmnt_Minus3 = devide3;
        ExclusiveAfterGstAmnt3 = 0.00;
      } else {
        ExclusiveAfterGstAmnt3 = ChargeAmt3;
        ExclusiveBeforeGStAmnt3 = 0.00;
        ExclusiveBeforeGStAmnt_Minus3 = 0.00;
      }
    } else {
      ExclusiveBeforeGStAmnt3 = 0.00;
      ExclusiveBeforeGStAmnt_Minus3 = 0.00;
      ExclusiveAfterGstAmnt3 = 0.00;

      if (OtherChargeBeforGst3 == "true") {
        double multi3 = 0.00;
        double addtaxt3 = 0.00;
        double devide3 = 0.00;
        double to_InclusiveBeforeGstAmnt2 = 0.00;

        multi3 = ChargeAmt3 * taxRate3;
        addtaxt3 = 100 + taxRate3;
        devide3 = multi3 / addtaxt3;

        InclusiveBeforeGstAmnt3 = ChargeAmt3 - devide3;
        InclusiveBeforeGstAmnt_Minus3 = devide3;
        AfterInclusiveBeforeGstAmnt3 = 0.00;
      } else {
        InclusiveBeforeGstAmnt3 = 0.00;
        InclusiveBeforeGstAmnt_Minus3 = 0.00;
        AfterInclusiveBeforeGstAmnt3 = ChargeAmt3;
      }
    }
  }

  void TotalCalculation4() async {
    double ChargeAmt4 = double.parse(OtherChargeAmount4);
    double taxRate4 = double.parse(OtherChargeGstPer4);

    double Taxtype = 0.00;
    int ISTaxType = 0;

    if (OtherChargeTaxType4 != null) {
      Taxtype = double.parse(OtherChargeTaxType4);
      ISTaxType = Taxtype.toInt();
    }

    if (ISTaxType == 1) {
      InclusiveBeforeGstAmnt4 = 0.00;
      InclusiveBeforeGstAmnt_Minus4 = 0.00;
      AfterInclusiveBeforeGstAmnt4 = 0.00;
      if (OtherChargeBeforGst4 == "true") {
        double multi4 = 0.00;
        double addtaxt4 = 0.00;
        double devide4 = 0.00;

        multi4 = ChargeAmt4 * taxRate4;
        addtaxt4 = 100;
        devide4 = multi4 / addtaxt4;

        ExclusiveBeforeGStAmnt4 = ChargeAmt4;
        ExclusiveBeforeGStAmnt_Minus4 = devide4;
        ExclusiveAfterGstAmnt4 = 0.00;
      } else {
        ExclusiveAfterGstAmnt4 = ChargeAmt4;
        ExclusiveBeforeGStAmnt4 = 0.00;
        ExclusiveBeforeGStAmnt_Minus4 = 0.00;
      }
    } else {
      ExclusiveBeforeGStAmnt4 = 0.00;
      ExclusiveBeforeGStAmnt_Minus4 = 0.00;
      ExclusiveAfterGstAmnt4 = 0.00;

      if (OtherChargeBeforGst4 == "true") {
        double multi4 = 0.00;
        double addtaxt4 = 0.00;
        double devide4 = 0.00;
        double to_InclusiveBeforeGstAmnt4 = 0.00;

        multi4 = ChargeAmt4 * taxRate4;
        addtaxt4 = 100 + taxRate4;
        devide4 = multi4 / addtaxt4;

        InclusiveBeforeGstAmnt4 = ChargeAmt4 - devide4;
        InclusiveBeforeGstAmnt_Minus4 = devide4;
        AfterInclusiveBeforeGstAmnt4 = 0.00;
      } else {
        InclusiveBeforeGstAmnt4 = 0.00;
        InclusiveBeforeGstAmnt_Minus4 = 0.00;
        AfterInclusiveBeforeGstAmnt4 = ChargeAmt4;
      }
    }
  }

  void TotalCalculation5() async {
    double ChargeAmt5 = double.parse(OtherChargeAmount5);
    double taxRate5 = double.parse(OtherChargeGstPer5);

    double Taxtype = 0.00;
    int ISTaxType = 0;

    if (OtherChargeTaxType5 != null) {
      Taxtype = double.parse(OtherChargeTaxType5);
      ISTaxType = Taxtype.toInt();
    }

    if (ISTaxType == 1) {
      InclusiveBeforeGstAmnt5 = 0.00;
      InclusiveBeforeGstAmnt_Minus5 = 0.00;
      AfterInclusiveBeforeGstAmnt5 = 0.00;
      if (OtherChargeBeforGst5 == "true") {
        double multi5 = 0.00;
        double addtaxt5 = 0.00;
        double devide5 = 0.00;

        multi5 = ChargeAmt5 * taxRate5;
        addtaxt5 = 100;
        devide5 = multi5 / addtaxt5;

        ExclusiveBeforeGStAmnt5 = ChargeAmt5;
        ExclusiveBeforeGStAmnt_Minus5 = devide5;
        ExclusiveAfterGstAmnt5 = 0.00;
      } else {
        ExclusiveAfterGstAmnt5 = ChargeAmt5;
        ExclusiveBeforeGStAmnt5 = 0.00;
        ExclusiveBeforeGStAmnt_Minus5 = 0.00;
      }
    } else {
      ExclusiveBeforeGStAmnt5 = 0.00;
      ExclusiveBeforeGStAmnt_Minus5 = 0.00;
      ExclusiveAfterGstAmnt5 = 0.00;

      if (OtherChargeBeforGst5 == "true") {
        double multi5 = 0.00;
        double addtaxt5 = 0.00;
        double devide5 = 0.00;
        double to_InclusiveBeforeGstAmnt5 = 0.00;

        multi5 = ChargeAmt5 * taxRate5;
        addtaxt5 = 100 + taxRate5;
        devide5 = multi5 / addtaxt5;

        InclusiveBeforeGstAmnt5 = ChargeAmt5 - devide5;
        InclusiveBeforeGstAmnt_Minus5 = devide5;
        AfterInclusiveBeforeGstAmnt5 = 0.00;
      } else {
        InclusiveBeforeGstAmnt5 = 0.00;
        InclusiveBeforeGstAmnt_Minus5 = 0.00;
        AfterInclusiveBeforeGstAmnt5 = ChargeAmt5;
      }
    }
  }

  void UpdateAfterHeaderDiscount() async {
    double tot_amnt_net = 0.00;

    Tot_NetAmt = 0.00;

    for (int i = 0; i < _inquiryProductList.length; i++) {
      print("_inquiryProductList[i].NetAmount234" +
          " Tot_NetAmt : " +
          _inquiryProductList[i].NetAmount.toString());

      tot_amnt_net = tot_amnt_net + _inquiryProductList[i].NetAmount;
    }
    print("Tot_NetAmtTot_NetAmt" + " Tot_NetAmt : " + tot_amnt_net.toString());

    HeaderDisAmnt = double.parse(edt_HeaderDisc.text.toString());

    double ExclusiveItemWiseHeaderDisAmnt = 0.00;
    double ExclusiveItemWiseAmount = 0.00;
    double ExclusiveNetAmntAfterHeaderDisAmnt = 0.00;
    double ExclusiveItemWiseTaxAmnt = 0.00;
    double ExclusiveTaxPluse100 = 0.00;
    double ExclusiveFinalNetAmntAfterHeaderDisAmnt = 0.00;

    double ExclusiveTotalNetAmntAfterHeaderDisAmnt = 0.00;

    double InclusiveItemWiseHeaderDisAmnt = 0.00;
    double InclusiveItemWiseAmount = 0.00;
    double InclusiveNetAmntAfterHeaderDisAmnt = 0.00;
    double InclusiveItemWiseTaxAmnt = 0.00;
    double InclusiveTaxPluse100 = 0.00;
    double InclusiveFinalNetAmntAfterHeaderDisAmnt = 0.00;

    double InclusiveTotalNetAmntAfterHeaderDisAmnt = 0.00;
    double ExTotalBasic = 0.00;
    double ExTotalGSTamt = 0.00;
    double ExTotalNetAmnt = 0.00;
    double InTotalBasic = 0.00;
    double InTotalGSTamt = 0.00;
    double InTotalNetAmnt = 0.00;

    for (int i = 0; i < _inquiryProductList.length; i++) {
      if (_inquiryProductList[i].TaxType == 1) {
        ExclusiveItemWiseHeaderDisAmnt =
            (_inquiryProductList[i].NetAmount * HeaderDisAmnt) / tot_amnt_net;
        print("sdf434" +
            ExclusiveItemWiseHeaderDisAmnt.toString() +
            "  Net amnt : " +
            _inquiryProductList[i].NetAmount.toString() +
            " Hder : " +
            HeaderDisAmnt.toString());
        ExclusiveItemWiseAmount =
            _inquiryProductList[i].Quantity * _inquiryProductList[i].NetRate;
        ExclusiveNetAmntAfterHeaderDisAmnt =
            ExclusiveItemWiseAmount - ExclusiveItemWiseHeaderDisAmnt;
        ExclusiveItemWiseTaxAmnt = (ExclusiveNetAmntAfterHeaderDisAmnt *
                _inquiryProductList[i].TaxRate) /
            100;

        print("dfjfj221223" + ExclusiveNetAmntAfterHeaderDisAmnt.toString());

        ExclusiveFinalNetAmntAfterHeaderDisAmnt =
            ExclusiveNetAmntAfterHeaderDisAmnt;
        ExclusiveTotalNetAmntAfterHeaderDisAmnt =
            ExclusiveItemWiseAmount + ExclusiveItemWiseTaxAmnt;

        ExTotalBasic += ExclusiveFinalNetAmntAfterHeaderDisAmnt;
        ExTotalGSTamt += ExclusiveItemWiseTaxAmnt;
        ExTotalNetAmnt += ExclusiveTotalNetAmntAfterHeaderDisAmnt;
      } else {
        InclusiveItemWiseHeaderDisAmnt =
            (_inquiryProductList[i].NetAmount * HeaderDisAmnt) / tot_amnt_net;
        InclusiveItemWiseAmount =
            _inquiryProductList[i].Quantity * _inquiryProductList[i].NetRate;
        InclusiveNetAmntAfterHeaderDisAmnt =
            InclusiveItemWiseAmount - InclusiveItemWiseHeaderDisAmnt;
        InclusiveTaxPluse100 = 100 + _inquiryProductList[i].TaxRate;
        InclusiveItemWiseTaxAmnt = (InclusiveNetAmntAfterHeaderDisAmnt *
                _inquiryProductList[i].TaxRate) /
            InclusiveTaxPluse100;
        InclusiveFinalNetAmntAfterHeaderDisAmnt =
            InclusiveNetAmntAfterHeaderDisAmnt - InclusiveItemWiseTaxAmnt;
        InclusiveTotalNetAmntAfterHeaderDisAmnt =
            InclusiveNetAmntAfterHeaderDisAmnt; //+ InclusiveItemWiseTaxAmnt;

        InTotalBasic += InclusiveFinalNetAmntAfterHeaderDisAmnt;
        InTotalGSTamt += InclusiveItemWiseTaxAmnt;
        InTotalNetAmnt += InclusiveTotalNetAmntAfterHeaderDisAmnt;
      }

      /* double TotNet =0.00; // ExclusiveTotalNetAmntAfterHeaderDisAmnt+InclusiveTotalNetAmntAfterHeaderDisAmnt;
      print("TotNet3455gg"+" Total : "+TotNet.toStringAsFixed(2) + " TotExclNetAmnt : " + ExclusiveTotalNetAmntAfterHeaderDisAmnt.toStringAsFixed(2) +
          " TotIncNetAmnt : " + InclusiveTotalNetAmntAfterHeaderDisAmnt.toStringAsFixed(2)
      );*/
    }
    print("testExclusive" +
        " Total ExcBasic : " +
        ExTotalBasic.toStringAsFixed(2) +
        "Total ExGSTAmnt : " +
        ExTotalGSTamt.toStringAsFixed(2) +
        "Total ExNetAmnt " +
        ExTotalNetAmnt.toStringAsFixed(2));
    print("testExclusive" +
        " Total ExcBasic : " +
        InTotalBasic.toStringAsFixed(2) +
        "Total ExGSTAmnt : " +
        InTotalGSTamt.toStringAsFixed(2) +
        "Total ExNetAmnt " +
        InTotalNetAmnt.toStringAsFixed(2));

    Tot_BasicAmount = ExTotalBasic + InTotalBasic;
    Tot_GSTAmt = ExTotalGSTamt + InTotalGSTamt;
    Tot_NetAmt = 0.00;
    double TotNet = ExTotalNetAmnt + InTotalNetAmnt;

    Tot_NetAmt = TotNet;

/*
     Tot_BasicAmount +=  ExclusiveFinalNetAmntAfterHeaderDisAmnt+InclusiveFinalNetAmntAfterHeaderDisAmnt;
     Tot_GSTAmt += ExclusiveItemWiseTaxAmnt+InclusiveItemWiseTaxAmnt;
     Tot_NetAmt =0.00;
     double TotNet = ExclusiveTotalNetAmntAfterHeaderDisAmnt+InclusiveTotalNetAmntAfterHeaderDisAmnt;
     print("TotNet3455gg"+" Total : "+TotNet.toStringAsFixed(2) + " TotExclNetAmnt : " + ExclusiveTotalNetAmntAfterHeaderDisAmnt.toStringAsFixed(2) +
         " TotIncNetAmnt : " + InclusiveTotalNetAmntAfterHeaderDisAmnt.toStringAsFixed(2)
     );
     Tot_NetAmt +=  TotNet - HeaderDisAmnt;*/

    //print("TotNATe"+ " NetAmnt : " + Tot_NetAmt.toStringAsFixed(2));

    _basicAmountController = Tot_BasicAmount.toStringAsFixed(2);
    _otherChargeWithTaxController = Tot_otherChargeWithTax.toStringAsFixed(2);

    ///Final Setup Befor GST
    _totalGstController = Tot_GSTAmt.toStringAsFixed(2);
    _otherChargeExcludeTaxController =
        Tot_otherChargeExcludeTax.toStringAsFixed(2);

    ///Final Setup After GST
    // double Tot_NetAmnt = Tot_NetAmt + Tot_otherChargeWithTax +   Tot_otherChargeExcludeTax;
    netAmountController = Tot_NetAmt.toStringAsFixed(2);
    print("netamountfj" + " NetAmount4 : " + netAmountController);
    //Tot_BasicAmount.toStringAsFixed(2) + Tot_otherChargeWithTax.toStringAsFixed(2) + Tot_GSTAmt.toStringAsFixed(2) + Tot_otherChargeExcludeTax.toStringAsFixed(2);
  }

  void PushAllOtherChargesToDb() {
    /* List<QT_OtherChargeTable> arrTemp = await OfflineDbHelper.getInstance().getQuotationOtherCharge();

   if(arrTemp.isNotEmpty)
     {
         await OfflineDbHelper.getInstance().deleteALLQuotationOtherCharge();
     }*/

    print("BeforGSTAmnt" +
        "ChargeAmnt1 : " +
        OtherChargeAmount1.toString() +
        "ChargeAmnt2 : " +
        OtherChargeAmount2.toString() +
        " ChargeBasicAmnt1 : " +
        InclusiveBeforeGstAmnt1.toStringAsFixed(2) +
        " ChargeBasicAmnt2 : " +
        InclusiveBeforeGstAmnt2.toStringAsFixed(2) +
        " ChargeGstAmnt1 : " +
        InclusiveBeforeGstAmnt_Minus1.toStringAsFixed(2) +
        " ChargeGstAmnt2 : " +
        InclusiveBeforeGstAmnt_Minus2.toStringAsFixed(2));
    //  print("AfterGSTAmnt" + " AfterGSTAmnt1 : " + AfterInclusiveBeforeGstAmnt1.toStringAsFixed(2) + " AfterGSTAmnt2 : " + AfterInclusiveBeforeGstAmnt2.toStringAsFixed(2)  );
    print("AfterGSTAmnt" +
        "ChargeAmnt1 : " +
        OtherChargeAmount1.toString() +
        "ChargeAmnt2 : " +
        OtherChargeAmount2.toString() +
        " ChargeBasicAmnt1 : " +
        AfterInclusiveBeforeGstAmnt1.toStringAsFixed(2) +
        " ChargeBasicAmnt2 : " +
        AfterInclusiveBeforeGstAmnt2.toStringAsFixed(2) +
        " ChargeGstAmnt1 : " +
        "0.00" +
        " ChargeGstAmnt2 : " +
        "0.00");
    print("ExclusiveBeforeGst" +
        " BeforeGST_AMNT1 : " +
        ExclusiveBeforeGStAmnt1.toStringAsFixed(2) +
        " GSTMinus1 : " +
        ExclusiveBeforeGStAmnt_Minus1.toStringAsFixed(2) +
        " BeforeGST_AMNT2 : " +
        ExclusiveBeforeGStAmnt2.toStringAsFixed(2) +
        " GSTMinus2 : " +
        ExclusiveBeforeGStAmnt_Minus2.toStringAsFixed(2));

    print("ExclusiveAfterGst" +
        " AfterGST_AMNT1 : " +
        ExclusiveAfterGstAmnt1.toStringAsFixed(2) +
        " AfterGST_AMNT2 : " +
        ExclusiveAfterGstAmnt2.toStringAsFixed(2));

    QT_OtherChargeTemp qt_otherChargeTable = QT_OtherChargeTemp();
    print("ChargeID" + OtherChargeID2.toString());
    qt_otherChargeTable.ChargeID1 = int.parse(
        OtherChargeID1); //==null?0:_otherChargeIDController1.text.toString());
    qt_otherChargeTable.ChargeID2 = int.parse(
        OtherChargeID2); //==null?0:_otherChargeIDController2.text.toString());
    qt_otherChargeTable.ChargeID3 = int.parse(
        OtherChargeID3); //==null?0:_otherChargeIDController3.text.toString());
    qt_otherChargeTable.ChargeID4 = int.parse(
        OtherChargeID4); //==null?0:_otherChargeIDController4.text.toString());
    qt_otherChargeTable.ChargeID5 = int.parse(
        OtherChargeID5); //==null?0:_otherChargeIDController5.text.toString());
    qt_otherChargeTable.Headerdiscount = 0.00;
    qt_otherChargeTable.Tot_BasicAmt = double.parse(
        _basicAmountController == null ? 0.00 : _basicAmountController);
    qt_otherChargeTable.OtherChargeWithTaxamt = double.parse(
        _otherChargeWithTaxController == null
            ? 0.00
            : _otherChargeWithTaxController);
    qt_otherChargeTable.Tot_GstAmt =
        double.parse(_totalGstController == null ? 0.00 : _totalGstController);
    qt_otherChargeTable.OtherChargeExcludeTaxamt = double.parse(
        _otherChargeExcludeTaxController == null
            ? 0.00
            : _otherChargeExcludeTaxController);
    qt_otherChargeTable.Tot_NetAmount =
        double.parse(netAmountController == null ? 0.00 : netAmountController);
    qt_otherChargeTable.ChargeAmt1 = double.parse(OtherChargeAmount1);
    qt_otherChargeTable.ChargeAmt2 = double.parse(OtherChargeAmount2);
    qt_otherChargeTable.ChargeAmt3 = double.parse(OtherChargeAmount3);
    qt_otherChargeTable.ChargeAmt4 = double.parse(OtherChargeAmount4);
    qt_otherChargeTable.ChargeAmt5 = double.parse(OtherChargeAmount5);

    if (OtherChargeTaxType1 == "1") {
      if (OtherChargeBeforGst1 == "true") {
        qt_otherChargeTable.ChargeBasicAmt1 = ExclusiveBeforeGStAmnt1;
        qt_otherChargeTable.ChargeGSTAmt1 = ExclusiveBeforeGStAmnt_Minus1;
      } else {
        qt_otherChargeTable.ChargeBasicAmt1 = ExclusiveAfterGstAmnt1;
        qt_otherChargeTable.ChargeGSTAmt1 = 0.00;
      }
    } else {
      if (OtherChargeBeforGst1 == "true") {
        qt_otherChargeTable.ChargeBasicAmt1 = InclusiveBeforeGstAmnt1;
        qt_otherChargeTable.ChargeGSTAmt1 = InclusiveBeforeGstAmnt_Minus1;
      } else {
        qt_otherChargeTable.ChargeBasicAmt1 = AfterInclusiveBeforeGstAmnt1;
        qt_otherChargeTable.ChargeGSTAmt1 = 0.00;
      }
    }

    if (OtherChargeTaxType2 == "1") {
      if (OtherChargeBeforGst2 == "true") {
        qt_otherChargeTable.ChargeBasicAmt2 = ExclusiveBeforeGStAmnt2;
        qt_otherChargeTable.ChargeGSTAmt2 = ExclusiveBeforeGStAmnt_Minus2;
      } else {
        qt_otherChargeTable.ChargeBasicAmt2 = ExclusiveAfterGstAmnt2;
        qt_otherChargeTable.ChargeGSTAmt2 = 0.00;
      }
    } else {
      if (OtherChargeBeforGst2 == "true") {
        qt_otherChargeTable.ChargeBasicAmt2 = InclusiveBeforeGstAmnt2;
        qt_otherChargeTable.ChargeGSTAmt2 = InclusiveBeforeGstAmnt_Minus2;
      } else {
        qt_otherChargeTable.ChargeBasicAmt2 = AfterInclusiveBeforeGstAmnt2;
        qt_otherChargeTable.ChargeGSTAmt2 = 0.00;
      }
    }

    if (OtherChargeTaxType3 == "1") {
      if (OtherChargeBeforGst3 == "true") {
        qt_otherChargeTable.ChargeBasicAmt3 = ExclusiveBeforeGStAmnt3;
        qt_otherChargeTable.ChargeGSTAmt3 = ExclusiveBeforeGStAmnt_Minus3;
      } else {
        qt_otherChargeTable.ChargeBasicAmt3 = ExclusiveAfterGstAmnt3;
        qt_otherChargeTable.ChargeGSTAmt3 = 0.00;
      }
    } else {
      if (OtherChargeBeforGst3 == "true") {
        qt_otherChargeTable.ChargeBasicAmt3 = InclusiveBeforeGstAmnt3;
        qt_otherChargeTable.ChargeGSTAmt3 = InclusiveBeforeGstAmnt_Minus3;
      } else {
        qt_otherChargeTable.ChargeBasicAmt3 = AfterInclusiveBeforeGstAmnt3;
        qt_otherChargeTable.ChargeGSTAmt3 = 0.00;
      }
    }

    if (OtherChargeTaxType4 == "1") {
      if (OtherChargeBeforGst4 == "true") {
        qt_otherChargeTable.ChargeBasicAmt4 = ExclusiveBeforeGStAmnt4;
        qt_otherChargeTable.ChargeGSTAmt4 = ExclusiveBeforeGStAmnt_Minus4;
      } else {
        qt_otherChargeTable.ChargeBasicAmt4 = ExclusiveAfterGstAmnt4;
        qt_otherChargeTable.ChargeGSTAmt4 = 0.00;
      }
    } else {
      if (OtherChargeBeforGst4 == "true") {
        qt_otherChargeTable.ChargeBasicAmt4 = InclusiveBeforeGstAmnt4;
        qt_otherChargeTable.ChargeGSTAmt4 = InclusiveBeforeGstAmnt_Minus4;
      } else {
        qt_otherChargeTable.ChargeBasicAmt4 = AfterInclusiveBeforeGstAmnt4;
        qt_otherChargeTable.ChargeGSTAmt4 = 0.00;
      }
    }

    if (OtherChargeTaxType5 == "1") {
      if (OtherChargeBeforGst5 == "true") {
        qt_otherChargeTable.ChargeBasicAmt5 = ExclusiveBeforeGStAmnt5;
        qt_otherChargeTable.ChargeGSTAmt5 = ExclusiveBeforeGStAmnt_Minus5;
      } else {
        qt_otherChargeTable.ChargeBasicAmt5 = ExclusiveAfterGstAmnt5;
        qt_otherChargeTable.ChargeGSTAmt5 = 0.00;
      }
    } else {
      if (OtherChargeBeforGst5 == "true") {
        qt_otherChargeTable.ChargeBasicAmt5 = InclusiveBeforeGstAmnt5;
        qt_otherChargeTable.ChargeGSTAmt5 = InclusiveBeforeGstAmnt_Minus5;
      } else {
        qt_otherChargeTable.ChargeBasicAmt5 = AfterInclusiveBeforeGstAmnt5;
        qt_otherChargeTable.ChargeGSTAmt5 = 0.00;
      }
    }

    print("hhfdh" +
        " ChargeID1 : " +
        qt_otherChargeTable.ChargeID1.toString() +
        " ChargeID2 : " +
        qt_otherChargeTable.ChargeID2.toString() +
        " ChargeID3 : " +
        qt_otherChargeTable.ChargeID3.toString() +
        " ChargeID4 : " +
        qt_otherChargeTable.ChargeID4.toString() +
        " ChargeID5 : " +
        qt_otherChargeTable.ChargeID5.toString());

    _inquiryBloc.add(QT_OtherChargeInsertRequestEvent(QT_OtherChargeTable(
      qt_otherChargeTable.Headerdiscount,
      qt_otherChargeTable.Tot_BasicAmt,
      qt_otherChargeTable.OtherChargeWithTaxamt,
      qt_otherChargeTable.Tot_GstAmt,
      qt_otherChargeTable.OtherChargeExcludeTaxamt,
      qt_otherChargeTable.Tot_NetAmount,
      qt_otherChargeTable.ChargeID1,
      qt_otherChargeTable.ChargeAmt1,
      qt_otherChargeTable.ChargeBasicAmt1,
      qt_otherChargeTable.ChargeGSTAmt1,
      qt_otherChargeTable.ChargeID2,
      qt_otherChargeTable.ChargeAmt2,
      qt_otherChargeTable.ChargeBasicAmt2,
      qt_otherChargeTable.ChargeGSTAmt2,
      qt_otherChargeTable.ChargeID3,
      qt_otherChargeTable.ChargeAmt3,
      qt_otherChargeTable.ChargeBasicAmt3,
      qt_otherChargeTable.ChargeGSTAmt3,
      qt_otherChargeTable.ChargeID4,
      qt_otherChargeTable.ChargeAmt4,
      qt_otherChargeTable.ChargeBasicAmt4,
      qt_otherChargeTable.ChargeGSTAmt4,
      qt_otherChargeTable.ChargeID5,
      qt_otherChargeTable.ChargeAmt5,
      qt_otherChargeTable.ChargeBasicAmt5,
      qt_otherChargeTable.ChargeGSTAmt5,
    )));
  }

  void _onInsertAllQT_OtherTable(QT_OtherChargeInsertResponseState state) {
    print("sucess123" + state.response.toString());
  }

  UpdateAfterHeaderDiscountToDB() {
    double tot_amnt_net = 0.00;

    double Tot_NetAmt = 0.00;

    List<QuotationTable> _TempinquiryProductList = [];

    _TempinquiryProductList.clear();
    _TempinquiryProductList.addAll(_inquiryProductList);

    _inquiryProductList.clear();

    QuotationTable tempQuotationTable;

    //await OfflineDbHelper.getInstance().deleteALLQuotationProduct();

    for (int i = 0; i < _TempinquiryProductList.length; i++) {
      print("_inquiryProductList[i].NetAmount234" +
          " Tot_NetAmt : " +
          _TempinquiryProductList[i].NetAmount.toString());

      tot_amnt_net = tot_amnt_net + _TempinquiryProductList[i].NetAmount;
    }
    print("Tot_NetAmtTot_NetAmt" + " Tot_NetAmt : " + tot_amnt_net.toString());

    double HeaderDisAmnt =
        double.parse(edt_HeaderDisc.text == null ? 0.00 : edt_HeaderDisc.text);
    double ExclusiveItemWiseHeaderDisAmnt = 0.00;
    double ExclusiveItemWiseAmount = 0.00;
    double ExclusiveNetAmntAfterHeaderDisAmnt = 0.00;
    double ExclusiveItemWiseTaxAmnt = 0.00;
    double ExclusiveTaxPluse100 = 0.00;
    double ExclusiveFinalNetAmntAfterHeaderDisAmnt = 0.00;

    double ExclusiveTotalNetAmntAfterHeaderDisAmnt = 0.00;

    double InclusiveItemWiseHeaderDisAmnt = 0.00;
    double InclusiveItemWiseAmount = 0.00;
    double InclusiveNetAmntAfterHeaderDisAmnt = 0.00;
    double InclusiveItemWiseTaxAmnt = 0.00;
    double InclusiveTaxPluse100 = 0.00;
    double InclusiveFinalNetAmntAfterHeaderDisAmnt = 0.00;

    double InclusiveTotalNetAmntAfterHeaderDisAmnt = 0.00;
    double ExTotalBasic = 0.00;
    double ExTotalGSTamt = 0.00;
    double ExTotalNetAmnt = 0.00;
    double InTotalBasic = 0.00;
    double InTotalGSTamt = 0.00;
    double InTotalNetAmnt = 0.00;

    for (int i = 0; i < _TempinquiryProductList.length; i++) {
      if (_TempinquiryProductList[i].TaxType == 1) {
        ExclusiveItemWiseHeaderDisAmnt =
            (_TempinquiryProductList[i].NetAmount * HeaderDisAmnt) /
                tot_amnt_net;
        ExclusiveItemWiseAmount = _TempinquiryProductList[i].Quantity *
            _TempinquiryProductList[i].NetRate;
        ExclusiveNetAmntAfterHeaderDisAmnt =
            ExclusiveItemWiseAmount - ExclusiveItemWiseHeaderDisAmnt;
        ExclusiveItemWiseTaxAmnt = (ExclusiveNetAmntAfterHeaderDisAmnt *
                _TempinquiryProductList[i].TaxRate) /
            100;
        ExclusiveFinalNetAmntAfterHeaderDisAmnt =
            ExclusiveNetAmntAfterHeaderDisAmnt;
        ExclusiveTotalNetAmntAfterHeaderDisAmnt =
            ExclusiveItemWiseAmount + ExclusiveItemWiseTaxAmnt;

        var CGSTPer = 0.00;
        var CGSTAmount = 0.00;
        var SGSTPer = 0.00;
        var SGSTAmount = 0.00;
        var IGSTPer = 0.00;
        var IGSTAmount = 0.00;
        if (_offlineLoggedInData.details[0].stateCode ==
            int.parse(_TempinquiryProductList[i].StateCode.toString())) {
          CGSTPer = _TempinquiryProductList[i].TaxRate / 2;
          SGSTPer = _TempinquiryProductList[i].TaxRate / 2;
          CGSTAmount = ExclusiveItemWiseTaxAmnt / 2;
          SGSTAmount = ExclusiveItemWiseTaxAmnt / 2;
          IGSTPer = 0.00;
          IGSTAmount = 0.00;
        } else {
          IGSTPer = _TempinquiryProductList[i].TaxRate;
          IGSTAmount = ExclusiveItemWiseTaxAmnt;
          CGSTPer = 0.00;
          SGSTPer = 0.00;
          CGSTAmount = 0.00;
          SGSTAmount = 0.00;
        }

        tempQuotationTable = QuotationTable(
            _TempinquiryProductList[i].QuotationNo,
            _TempinquiryProductList[i].ProductSpecification,
            _TempinquiryProductList[i].ProductID,
            _TempinquiryProductList[i].ProductName,
            _TempinquiryProductList[i].Unit,
            _TempinquiryProductList[i].Quantity,
            _TempinquiryProductList[i].UnitRate,
            _TempinquiryProductList[i].DiscountPercent,
            _TempinquiryProductList[i].DiscountAmt,
            _TempinquiryProductList[i].NetRate,
            ExclusiveFinalNetAmntAfterHeaderDisAmnt,
            _TempinquiryProductList[i].TaxRate,
            ExclusiveItemWiseTaxAmnt,
            ExclusiveTotalNetAmntAfterHeaderDisAmnt,
            _TempinquiryProductList[i].TaxType,
            CGSTPer,
            SGSTPer,
            IGSTPer,
            CGSTAmount,
            SGSTAmount,
            IGSTAmount,
            _TempinquiryProductList[i].StateCode,
            _TempinquiryProductList[i].pkID,
            LoginUserID,
            CompanyID.toString(),
            0,
            ExclusiveItemWiseHeaderDisAmnt);
        _inquiryProductList.add(tempQuotationTable);
        /* await OfflineDbHelper.getInstance().insertQuotationProduct(
            QuotationTable(
                _TempinquiryProductList[i].QuotationNo,
                _TempinquiryProductList[i].ProductSpecification,
                _TempinquiryProductList[i].ProductID,
                _TempinquiryProductList[i].ProductName,
                _TempinquiryProductList[i].Unit,
                _TempinquiryProductList[i].Quantity,
                _TempinquiryProductList[i].UnitRate,
                _TempinquiryProductList[i].DiscountPercent,
                _TempinquiryProductList[i].DiscountAmt,
                _TempinquiryProductList[i].NetRate,
                ExclusiveFinalNetAmntAfterHeaderDisAmnt,
                _TempinquiryProductList[i].TaxRate,
                ExclusiveItemWiseTaxAmnt,
                ExclusiveTotalNetAmntAfterHeaderDisAmnt,
                _TempinquiryProductList[i].TaxType,
                CGSTPer,
                SGSTPer,
                IGSTPer,
                CGSTAmount,
                SGSTAmount,
                IGSTAmount,
                _TempinquiryProductList[i].StateCode,
                _TempinquiryProductList[i].pkID,
                LoginUserID,
                CompanyID.toString(),
                0,
                ExclusiveItemWiseHeaderDisAmnt));*/
      } else {
        InclusiveItemWiseHeaderDisAmnt =
            (_TempinquiryProductList[i].NetAmount * HeaderDisAmnt) /
                tot_amnt_net;
        InclusiveItemWiseAmount = _TempinquiryProductList[i].Quantity *
            _TempinquiryProductList[i].NetRate;
        InclusiveNetAmntAfterHeaderDisAmnt =
            InclusiveItemWiseAmount - InclusiveItemWiseHeaderDisAmnt;
        InclusiveTaxPluse100 = 100 + _TempinquiryProductList[i].TaxRate;
        InclusiveItemWiseTaxAmnt = (InclusiveNetAmntAfterHeaderDisAmnt *
                _TempinquiryProductList[i].TaxRate) /
            InclusiveTaxPluse100;
        InclusiveFinalNetAmntAfterHeaderDisAmnt =
            InclusiveNetAmntAfterHeaderDisAmnt - InclusiveItemWiseTaxAmnt;
        InclusiveTotalNetAmntAfterHeaderDisAmnt =
            InclusiveNetAmntAfterHeaderDisAmnt; //+ InclusiveItemWiseTaxAmnt;

        var CGSTPer = 0.00;
        var CGSTAmount = 0.00;
        var SGSTPer = 0.00;
        var SGSTAmount = 0.00;
        var IGSTPer = 0.00;
        var IGSTAmount = 0.00;
        if (_offlineLoggedInData.details[0].stateCode ==
            int.parse(_TempinquiryProductList[i].StateCode.toString())) {
          CGSTPer = _TempinquiryProductList[i].TaxRate / 2;
          SGSTPer = _TempinquiryProductList[i].TaxRate / 2;
          CGSTAmount = InclusiveItemWiseTaxAmnt / 2;
          SGSTAmount = InclusiveItemWiseTaxAmnt / 2;
          IGSTPer = 0.00;
          IGSTAmount = 0.00;
        } else {
          IGSTPer = _TempinquiryProductList[i].TaxRate;
          IGSTAmount = InclusiveItemWiseTaxAmnt;
          CGSTPer = 0.00;
          SGSTPer = 0.00;
          CGSTAmount = 0.00;
          SGSTAmount = 0.00;
        }
        tempQuotationTable = QuotationTable(
            _TempinquiryProductList[i].QuotationNo,
            _TempinquiryProductList[i].ProductSpecification,
            _TempinquiryProductList[i].ProductID,
            _TempinquiryProductList[i].ProductName,
            _TempinquiryProductList[i].Unit,
            _TempinquiryProductList[i].Quantity,
            _TempinquiryProductList[i].UnitRate,
            _TempinquiryProductList[i].DiscountPercent,
            _TempinquiryProductList[i].DiscountAmt,
            _TempinquiryProductList[i].NetRate,
            InclusiveFinalNetAmntAfterHeaderDisAmnt,
            _TempinquiryProductList[i].TaxRate,
            InclusiveItemWiseTaxAmnt,
            InclusiveTotalNetAmntAfterHeaderDisAmnt,
            _TempinquiryProductList[i].TaxType,
            CGSTPer,
            SGSTPer,
            IGSTPer,
            CGSTAmount,
            SGSTAmount,
            IGSTAmount,
            _TempinquiryProductList[i].StateCode,
            _TempinquiryProductList[i].pkID,
            LoginUserID,
            CompanyID.toString(),
            0,
            InclusiveItemWiseHeaderDisAmnt);
        _inquiryProductList.add(tempQuotationTable);
        /*await OfflineDbHelper.getInstance().insertQuotationProduct(
            QuotationTable(
                _TempinquiryProductList[i].QuotationNo,
                _TempinquiryProductList[i].ProductSpecification,
                _TempinquiryProductList[i].ProductID,
                _TempinquiryProductList[i].ProductName,
                _TempinquiryProductList[i].Unit,
                _TempinquiryProductList[i].Quantity,
                _TempinquiryProductList[i].UnitRate,
                _TempinquiryProductList[i].DiscountPercent,
                _TempinquiryProductList[i].DiscountAmt,
                _TempinquiryProductList[i].NetRate,
                InclusiveFinalNetAmntAfterHeaderDisAmnt,
                _TempinquiryProductList[i].TaxRate,
                InclusiveItemWiseTaxAmnt,
                InclusiveTotalNetAmntAfterHeaderDisAmnt,
                _TempinquiryProductList[i].TaxType,
                CGSTPer,
                SGSTPer,
                IGSTPer,
                CGSTAmount,
                SGSTAmount,
                IGSTAmount,
                _TempinquiryProductList[i].StateCode,
                _TempinquiryProductList[i].pkID,
                LoginUserID,
                CompanyID.toString(),
                0,
                InclusiveItemWiseHeaderDisAmnt));*/
      }
    }
  }
}
