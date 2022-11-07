import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soleoserp/blocs/other/bloc_modules/quotation/quotation_bloc.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_other_charge_list_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/quotation/quotation_list_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/other_charge_table.dart';
import 'package:soleoserp/models/common/othercharges/other_charges.dart';
import 'package:soleoserp/models/common/qt_other_charge_temp.dart';
import 'package:soleoserp/models/common/quotationtable.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class QuotationOtherChargesScreenArguments {
  int StateCode;
  String HeaderDiscFromAddEditScreen;
  QuotationDetails editModel;
  AllOtherCharges allOtherCharges;

  QuotationOtherChargesScreenArguments(this.StateCode, this.editModel,
      this.HeaderDiscFromAddEditScreen, this.allOtherCharges);
/* String ChargName1;
  String ChargName2;
  String ChargName3;
  String ChargName4;
  String ChargName5;
  String ChargeID1;
  String ChargeID2;
  String ChargeID3;
  String ChargeID4;
  String ChargeID5;
   String ChargeTaxType1;
   String ChargeTaxType2;
   String ChargeTaxType3;
   String ChargeTaxType4;
   String ChargeTaxType5;
   String ChargeGstPer1;
   String ChargeGstPer2;
   String ChargeGstPer3;
   String ChargeGstPer4;
   String ChargeGstPer5;
    String ChargeBeforGST1;
    String ChargeBeforGST2;
    String ChargeBeforGST3;
    String ChargeBeforGST4;
    String ChargeBeforGST5;
  */
}

class QuotationOtherChargeScreen extends BaseStatefulWidget {
  static const routeName = '/QuotationOtherChargeScreen';
  final QuotationOtherChargesScreenArguments arguments;

  QuotationOtherChargeScreen(this.arguments);

  @override
  _QuotationOtherChargeScreenState createState() =>
      _QuotationOtherChargeScreenState();
}

class _QuotationOtherChargeScreenState
    extends BaseState<QuotationOtherChargeScreen>
    with BasicScreen, WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  bool isForUpdate = false;
  QuotationBloc _inquiryBloc;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";
  FocusNode QuantityFocusNode;
  TextEditingController _headerDiscountController = TextEditingController();
  TextEditingController _basicAmountController = TextEditingController();
  TextEditingController _otherChargeWithTaxController = TextEditingController();
  TextEditingController _totalGstController = TextEditingController();
  TextEditingController _otherChargeExcludeTaxController =
      TextEditingController();
  TextEditingController _netAmountController = TextEditingController();
  TextEditingController _roundOFController = TextEditingController();

  TextEditingController _otherChargeNameController1 = TextEditingController();
  TextEditingController _otherChargeIDController1 = TextEditingController();
  TextEditingController _otherChargeTaxTypeController1 =
      TextEditingController();
  TextEditingController _otherChargeGSTPerController1 = TextEditingController();
  TextEditingController _otherChargeBeForeGSTController1 =
      TextEditingController();

  TextEditingController _otherChargeNameController2 = TextEditingController();
  TextEditingController _otherChargeIDController2 = TextEditingController();
  TextEditingController _otherChargeTaxTypeController2 =
      TextEditingController();
  TextEditingController _otherChargeGSTPerController2 = TextEditingController();
  TextEditingController _otherChargeBeForeGSTController2 =
      TextEditingController();

  TextEditingController _otherChargeNameController3 = TextEditingController();
  TextEditingController _otherChargeIDController3 = TextEditingController();
  TextEditingController _otherChargeTaxTypeController3 =
      TextEditingController();
  TextEditingController _otherChargeGSTPerController3 = TextEditingController();
  TextEditingController _otherChargeBeForeGSTController3 =
      TextEditingController();

  TextEditingController _otherChargeNameController4 = TextEditingController();
  TextEditingController _otherChargeIDController4 = TextEditingController();
  TextEditingController _otherChargeTaxTypeController4 =
      TextEditingController();
  TextEditingController _otherChargeGSTPerController4 = TextEditingController();
  TextEditingController _otherChargeBeForeGSTController4 =
      TextEditingController();

  TextEditingController _otherChargeNameController5 = TextEditingController();
  TextEditingController _otherChargeIDController5 = TextEditingController();
  TextEditingController _otherChargeTaxTypeController5 =
      TextEditingController();
  TextEditingController _otherChargeGSTPerController5 = TextEditingController();
  TextEditingController _otherChargeBeForeGSTController5 =
      TextEditingController();

  TextEditingController _otherAmount1 = TextEditingController();
  TextEditingController _otherAmount2 = TextEditingController();
  TextEditingController _otherAmount3 = TextEditingController();
  TextEditingController _otherAmount4 = TextEditingController();
  TextEditingController _otherAmount5 = TextEditingController();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_ProjectList1 = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_ProjectList2 = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_ProjectList3 = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_ProjectList4 = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_ProjectList5 = [];

  double CardViewHeight = 35;

  bool ISExpanded = false;
  List<QuotationTable> _inquiryProductList = [];
  List<QuotationTable> _TempinquiryProductList = [];

  List<QT_OtherChargeTable> _QT_OtherChargseList = [];

  QuotationDetails _editModel;
  AllOtherCharges _allOtherCharges;

  bool _isForUpdate;
  bool _isForUpdateOtherCharges;

  String _HeaderDiscFromAddEditScreen = "";

  double HeaderDisAmnt = 0.00;
  double Tot_BasicAmount = 0.00;
  double Tot_otherChargeWithTax = 0.00;
  double Tot_GSTAmt = 0.00;
  double Tot_otherChargeExcludeTax = 0.00;
  double Tot_NetAmt = 0.00;

  double Tot_BasicAmountFinal = 0.00;
  double Tot_otherChargeWithTaxFinal = 0.00;
  double Tot_GSTAmtFinal = 0.00;
  double Tot_otherChargeExcludeTaxFinal = 0.00;
  double Tot_NetAmtFinal = 0.00;

  double InclusiveBeforeGstAmnt1 = 0.00;
  double InclusiveBeforeGstAmnt_Minus1 = 0.00;
  double AfterInclusiveBeforeGstAmnt1 = 0.00;
  double AfterInclusiveBeforeGstAmnt_Minus1 = 0.00;

  double InclusiveBeforeGstAmnt2 = 0.00;
  double InclusiveBeforeGstAmnt_Minus2 = 0.00;
  double AfterInclusiveBeforeGstAmnt2 = 0.00;
  double AfterInclusiveBeforeGstAmnt_Minus2 = 0.00;

  double InclusiveBeforeGstAmnt3 = 0.00;
  double InclusiveBeforeGstAmnt_Minus3 = 0.00;
  double AfterInclusiveBeforeGstAmnt3 = 0.00;
  double AfterInclusiveBeforeGstAmnt_Minus3 = 0.00;

  double InclusiveBeforeGstAmnt4 = 0.00;
  double InclusiveBeforeGstAmnt_Minus4 = 0.00;
  double AfterInclusiveBeforeGstAmnt4 = 0.00;
  double AfterInclusiveBeforeGstAmnt_Minus4 = 0.00;

  double InclusiveBeforeGstAmnt5 = 0.00;
  double InclusiveBeforeGstAmnt_Minus5 = 0.00;
  double AfterInclusiveBeforeGstAmnt5 = 0.00;
  double AfterInclusiveBeforeGstAmnt_Minus5 = 0.00;

  double ExclusiveBeforeGStAmnt1 = 0.00;
  double ExclusiveBeforeGStAmnt_Minus1 = 0.00;
  double ExclusiveAfterGstAmnt1 = 0.00;

  double ExclusiveBeforeGStAmnt2 = 0.00;
  double ExclusiveBeforeGStAmnt_Minus2 = 0.00;
  double ExclusiveAfterGstAmnt2 = 0.00;

  double ExclusiveBeforeGStAmnt3 = 0.00;
  double ExclusiveBeforeGStAmnt_Minus3 = 0.00;
  double ExclusiveAfterGstAmnt3 = 0.00;

  double ExclusiveBeforeGStAmnt4 = 0.00;
  double ExclusiveBeforeGStAmnt_Minus4 = 0.00;
  double ExclusiveAfterGstAmnt4 = 0.00;

  double ExclusiveBeforeGStAmnt5 = 0.00;
  double ExclusiveBeforeGStAmnt_Minus5 = 0.00;
  double ExclusiveAfterGstAmnt5 = 0.00;

  @override
  void initState() {
    super.initState();

    screenStatusBarColor = colorWhite;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();

    LoginUserID = _offlineLoggedInData.details[0].userID;
    CompanyID = _offlineCompanyData.details[0].pkId;
    QuantityFocusNode = FocusNode();
    _inquiryBloc = QuotationBloc(baseBloc);
    //  _headerDiscountController.text = "0.00";

    _headerDiscountController.text =
        widget.arguments.HeaderDiscFromAddEditScreen == null
            ? ""
            : widget.arguments.HeaderDiscFromAddEditScreen;
    _inquiryBloc.add(QuotationOtherChargeCallEvent(
        _headerDiscountController.text,
        CompanyID.toString(),
        QuotationOtherChargesListRequest(pkID: "")));

    _basicAmountController.text = "0.00";
    _otherChargeWithTaxController.text = "0.00";
    _totalGstController.text = "0.00";
    _otherChargeExcludeTaxController.text = "0.00";
    _netAmountController.text = "0.00";
    _roundOFController.text = "0.00";

    _otherAmount1.text = "0.00";
    _otherAmount2.text = "0.00";
    _otherAmount3.text = "0.00";
    _otherAmount4.text = "0.00";
    _otherAmount5.text = "0.00";

    _otherChargeIDController1.text = "0";
    _otherChargeTaxTypeController1.text = "0.00";
    _otherChargeGSTPerController1.text = "0.00";
    _otherChargeBeForeGSTController1.text = "0.00";

    _otherChargeIDController2.text = "0";
    _otherChargeTaxTypeController2.text = "0.00";
    _otherChargeGSTPerController2.text = "0.00";
    _otherChargeBeForeGSTController2.text = "0.00";

    _otherChargeIDController3.text = "0";
    _otherChargeTaxTypeController3.text = "0.00";
    _otherChargeGSTPerController3.text = "0.00";
    _otherChargeBeForeGSTController3.text = "0.00";

    _otherChargeIDController4.text = "0";
    _otherChargeTaxTypeController4.text = "0.00";
    _otherChargeGSTPerController4.text = "0.00";
    _otherChargeBeForeGSTController4.text = "0.00";

    _otherChargeIDController5.text = "0";
    _otherChargeTaxTypeController5.text = "0.00";
    _otherChargeGSTPerController5.text = "0.00";
    _otherChargeBeForeGSTController5.text = "0.00";

    _isForUpdate = widget.arguments.editModel != null;

    _isForUpdateOtherCharges = widget.arguments.allOtherCharges != null;

    if (_isForUpdate) {
      _editModel = widget.arguments.editModel;

      _basicAmountController.text = _editModel.basicAmt.toStringAsFixed(2);

      /*_otherAmount1.text = _editModel.chargeAmt1.toStringAsFixed(2);
      _otherAmount2.text = _editModel.chargeAmt2.toStringAsFixed(2);
      _otherAmount3.text = _editModel.chargeAmt3.toStringAsFixed(2);
      _otherAmount4.text = _editModel.chargeAmt4.toStringAsFixed(2);
      _otherAmount5.text = _editModel.chargeAmt5.toStringAsFixed(2);

      _otherChargeIDController1.text = _editModel.chargeID1.toString();
      _otherChargeIDController2.text = _editModel.chargeID2.toString();
      _otherChargeIDController3.text = _editModel.chargeID3.toString();
      _otherChargeIDController4.text = _editModel.chargeID4.toString();
      _otherChargeIDController5.text = _editModel.chargeID5.toString();

      _otherChargeNameController1.text = _editModel.chargeName1.toString();
      _otherChargeNameController2.text = _editModel.chargeName2.toString();
      _otherChargeNameController3.text = _editModel.chargeName3.toString();
      _otherChargeNameController4.text = _editModel.chargeName4.toString();
      _otherChargeNameController5.text = _editModel.chargeName5.toString();*/

      getProductFromDB();
    } else {
      getProductFromDB();
    }

    if (_isForUpdateOtherCharges) {
      _allOtherCharges = widget.arguments.allOtherCharges;

      //   _otherChargeNameController1.text = _allOtherCharges.OtherChargName1.toString();

      print("sdlfjdj" + _allOtherCharges.OtherChargeAmount1.toString());

      _otherAmount1.text = _allOtherCharges.OtherChargeAmount1;
      _otherAmount2.text = _allOtherCharges.OtherChargeAmount2;
      _otherAmount3.text = _allOtherCharges.OtherChargeAmount3;
      _otherAmount4.text = _allOtherCharges.OtherChargeAmount4;
      _otherAmount5.text = _allOtherCharges.OtherChargeAmount5;

      _otherChargeIDController1.text =
          _allOtherCharges.OtherChargeID1.toString();
      _otherChargeIDController2.text =
          _allOtherCharges.OtherChargeID2.toString();
      _otherChargeIDController3.text =
          _allOtherCharges.OtherChargeID3.toString();
      _otherChargeIDController4.text =
          _allOtherCharges.OtherChargeID4.toString();
      _otherChargeIDController5.text =
          _allOtherCharges.OtherChargeID5.toString();

      _otherChargeNameController1.text =
          _allOtherCharges.OtherChargName1.toString();
      _otherChargeNameController2.text =
          _allOtherCharges.OtherChargName2.toString();
      _otherChargeNameController3.text =
          _allOtherCharges.OtherChargName3.toString();
      _otherChargeNameController4.text =
          _allOtherCharges.OtherChargName4.toString();
      _otherChargeNameController5.text =
          _allOtherCharges.OtherChargName5.toString();

      _otherChargeTaxTypeController1.text =
          _allOtherCharges.OtherChargeTaxType1;
      _otherChargeTaxTypeController2.text =
          _allOtherCharges.OtherChargeTaxType2;
      _otherChargeTaxTypeController3.text =
          _allOtherCharges.OtherChargeTaxType3;
      _otherChargeTaxTypeController4.text =
          _allOtherCharges.OtherChargeTaxType4;
      _otherChargeTaxTypeController5.text =
          _allOtherCharges.OtherChargeTaxType5;

      _otherChargeGSTPerController1.text = _allOtherCharges.OtherChargeGstPer1;
      _otherChargeGSTPerController2.text = _allOtherCharges.OtherChargeGstPer2;
      _otherChargeGSTPerController3.text = _allOtherCharges.OtherChargeGstPer3;
      _otherChargeGSTPerController4.text = _allOtherCharges.OtherChargeGstPer4;
      _otherChargeGSTPerController5.text = _allOtherCharges.OtherChargeGstPer5;

      _otherChargeBeForeGSTController1.text =
          _allOtherCharges.OtherChargeBeforGst1;
      _otherChargeBeForeGSTController2.text =
          _allOtherCharges.OtherChargeBeforGst2;
      _otherChargeBeForeGSTController3.text =
          _allOtherCharges.OtherChargeBeforGst3;
      _otherChargeBeForeGSTController4.text =
          _allOtherCharges.OtherChargeBeforGst4;
      _otherChargeBeForeGSTController5.text =
          _allOtherCharges.OtherChargeBeforGst5;

      // _OnTaptoSave();
    }
    // getProductFromDB();

    /* _headerDiscountController.addListener(TotalCalculation);
        _basicAmountController.addListener(TotalCalculation);
        _otherChargeWithTaxController.addListener(TotalCalculation);
        _totalGstController.addListener(TotalCalculation);
        _otherChargeExcludeTaxController.addListener(TotalCalculation);
        _netAmountController.addListener(TotalCalculation);

        _otherChargeIDController1.addListener(TotalCalculation);
        _otherChargeTaxTypeController1.addListener(TotalCalculation);
        _otherChargeGSTPerController1.addListener(TotalCalculation);
        _otherChargeBeForeGSTController1.addListener(TotalCalculation);
*/
    /*_otherChargeIDController2.addListener(TotalCalculation);
        _otherChargeTaxTypeController2.addListener(TotalCalculation);
        _otherChargeGSTPerController2.addListener(TotalCalculation);
        _otherChargeBeForeGSTController2.addListener(TotalCalculation);

        _otherChargeIDController3.addListener(TotalCalculation);
        _otherChargeTaxTypeController3.addListener(TotalCalculation);
        _otherChargeGSTPerController3.addListener(TotalCalculation);
        _otherChargeBeForeGSTController3.addListener(TotalCalculation);

        _otherChargeIDController4.addListener(TotalCalculation);
        _otherChargeTaxTypeController4.addListener(TotalCalculation);
        _otherChargeGSTPerController4.addListener(TotalCalculation);
        _otherChargeBeForeGSTController4.addListener(TotalCalculation);

        _otherChargeIDController5.addListener(TotalCalculation);
        _otherChargeTaxTypeController5.addListener(TotalCalculation);
        _otherChargeGSTPerController5.addListener(TotalCalculation);
        _otherChargeBeForeGSTController5.addListener(TotalCalculation);*/

    //_otherChargeIDController1.addListener(TotalCalculation);
    /* _otherAmount1.addListener(TotalCalculation);
    _otherAmount2.addListener(TotalCalculation2);
    _otherAmount3.addListener(TotalCalculation3);
    _otherAmount4.addListener(TotalCalculation4);
    _otherAmount5.addListener(TotalCalculation5);*/
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _inquiryBloc,
      child: BlocConsumer<QuotationBloc, QuotationStates>(
        builder: (BuildContext context, QuotationStates state) {
          if (state is QuotationOtherChargeListResponseState) {
            _onOtherChargeListResponse(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is QuotationOtherChargeListResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, QuotationStates state) {
          if (state is QT_OtherChargeDeleteResponseState) {
            _ondeleteAllQT_OtherTable(state);
          }
          if (state is QT_OtherChargeInsertResponseState) {
            _onInsertAllQT_OtherTable(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is QT_OtherChargeDeleteResponseState ||
              currentState is QT_OtherChargeInsertResponseState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    super.dispose();
    QuantityFocusNode.dispose();
    _headerDiscountController.dispose();
    _basicAmountController.dispose();
    _otherChargeWithTaxController.dispose();
    _totalGstController.dispose();
    _otherChargeExcludeTaxController.dispose();
    _netAmountController.dispose();

    _otherChargeIDController1.dispose();
    _otherChargeTaxTypeController1.dispose();
    _otherChargeGSTPerController1.dispose();
    _otherChargeBeForeGSTController1.dispose();

    _otherChargeIDController2.dispose();
    _otherChargeTaxTypeController2.dispose();
    _otherChargeGSTPerController2.dispose();
    _otherChargeBeForeGSTController2.dispose();

    _otherChargeIDController3.dispose();
    _otherChargeTaxTypeController3.dispose();
    _otherChargeGSTPerController3.dispose();
    _otherChargeBeForeGSTController3.dispose();

    _otherChargeIDController4.dispose();
    _otherChargeTaxTypeController4.dispose();
    _otherChargeGSTPerController4.dispose();
    _otherChargeBeForeGSTController4.dispose();

    _otherChargeIDController5.dispose();
    _otherChargeTaxTypeController5.dispose();
    _otherChargeGSTPerController5.dispose();
    _otherChargeBeForeGSTController5.dispose();
  }

  @override
  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Column(
        children: [
          getCommonAppBar(context, baseTheme, "Quotation Charges",
              showBack: true, showHome: false, onTapOfBack: () {
            // _inquiryBloc.add(QT_OtherChargeDeleteRequestEvent());

            UpdateAfterHeaderDiscountToDB();
            PushAllOtherChargesToDb();

            AllOtherCharges allOtherCharges = AllOtherCharges();

            print("CHRGEID" +
                _otherChargeIDController1.text +
                _otherAmount1.text);
            allOtherCharges.HeaderDiscount = _headerDiscountController.text;

            allOtherCharges.OtherChargName1 = _otherChargeNameController1.text;
            allOtherCharges.OtherChargeAmount1 = _otherAmount1.text;
            allOtherCharges.OtherChargeID1 = _otherChargeIDController1.text;
            allOtherCharges.OtherChargeTaxType1 =
                _otherChargeTaxTypeController1.text;
            allOtherCharges.OtherChargeGstPer1 =
                _otherChargeGSTPerController1.text;
            allOtherCharges.OtherChargeBeforGst1 =
                _otherChargeBeForeGSTController1.text;

            allOtherCharges.OtherChargName2 = _otherChargeNameController2.text;
            allOtherCharges.OtherChargeAmount2 = _otherAmount2.text;
            allOtherCharges.OtherChargeID2 = _otherChargeIDController2.text;
            allOtherCharges.OtherChargeTaxType2 =
                _otherChargeTaxTypeController2.text;
            allOtherCharges.OtherChargeGstPer2 =
                _otherChargeGSTPerController2.text;
            allOtherCharges.OtherChargeBeforGst2 =
                _otherChargeBeForeGSTController2.text;

            allOtherCharges.OtherChargName3 = _otherChargeNameController3.text;
            allOtherCharges.OtherChargeAmount3 = _otherAmount3.text;
            allOtherCharges.OtherChargeID3 = _otherChargeIDController3.text;
            allOtherCharges.OtherChargeTaxType3 =
                _otherChargeTaxTypeController3.text;
            allOtherCharges.OtherChargeGstPer3 =
                _otherChargeGSTPerController3.text;
            allOtherCharges.OtherChargeBeforGst3 =
                _otherChargeBeForeGSTController3.text;

            allOtherCharges.OtherChargName4 = _otherChargeNameController4.text;
            allOtherCharges.OtherChargeAmount4 = _otherAmount4.text;
            allOtherCharges.OtherChargeID4 = _otherChargeIDController4.text;
            allOtherCharges.OtherChargeTaxType4 =
                _otherChargeTaxTypeController4.text;
            allOtherCharges.OtherChargeGstPer4 =
                _otherChargeGSTPerController4.text;
            allOtherCharges.OtherChargeBeforGst4 =
                _otherChargeBeForeGSTController4.text;

            allOtherCharges.OtherChargName5 = _otherChargeNameController5.text;
            allOtherCharges.OtherChargeAmount5 = _otherAmount5.text;
            allOtherCharges.OtherChargeID5 = _otherChargeIDController5.text;
            allOtherCharges.OtherChargeTaxType5 =
                _otherChargeTaxTypeController5.text;
            allOtherCharges.OtherChargeGstPer5 =
                _otherChargeGSTPerController5.text;
            allOtherCharges.OtherChargeBeforGst5 =
                _otherChargeBeForeGSTController5.text;
            Navigator.of(context).pop(allOtherCharges);
            print("Tap To BackEvent");
          }),
          Expanded(
            child: SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  Row(
                    children: [
                      Expanded(flex: 1, child: DiscountAmount()),
                      Expanded(flex: 1, child: BasicAmount())
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(children: [
                    Expanded(flex: 1, child: OtherChargeWithTax()),
                    Expanded(flex: 1, child: TotalGST())
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(children: [
                    Expanded(flex: 1, child: OtherChargeExcludingTax()),
                    Expanded(flex: 1, child: RoundOff())
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  NetAmount(),
                  SizedBox(
                    height: 20,
                  ),
                  getCommonButton(baseTheme, () {
                    setState(() {
                      if (ISExpanded == true) {
                        ISExpanded = false;
                      } else {
                        ISExpanded = true;
                      }
                    });
                  },
                      ISExpanded == true
                          ? "Other Charges - "
                          : "Other Charges + ",
                      backGroundColor: Color(0xff4d62dc),
                      height: 40),

                  /* Container(
                    margin: EdgeInsets.all(10),
                      child: Text("~~~~~~Other Charges~~~~~~",style: TextStyle(color: colorPrimary),)),*/

                  ISExpanded == true
                      ? Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(children: [
                              Expanded(
                                  flex: 2,
                                  child: Text("  Charge Type",
                                      style: TextStyle(
                                          color: colorPrimary, fontSize: 15))),
                              Expanded(
                                  flex: 1,
                                  child: Text("  Amount",
                                      style: TextStyle(
                                          color: colorPrimary, fontSize: 15)))
                            ]),
                            Row(children: [
                              Expanded(
                                flex: 2,
                                child: OtherChargeDropDown1("Other Charge 1",
                                    enable1: false,
                                    title: "Other Charge 1",
                                    hintTextvalue: "Select Other Charge",
                                    icon: Icon(Icons.arrow_drop_down),
                                    controllerForLeft:
                                        _otherChargeNameController1,
                                    controllerpkID: _otherChargeIDController1,
                                    Custom_values1:
                                        arr_ALL_Name_ID_For_ProjectList1),
                              ),
                              Expanded(flex: 1, child: OtherAmount1())
                            ]),
                            Row(children: [
                              Expanded(
                                flex: 2,
                                child: OtherChargeDropDown2("Other Charge 1",
                                    enable1: false,
                                    title: "Other Charge 1",
                                    hintTextvalue: "Select Other Charge",
                                    icon: Icon(Icons.arrow_drop_down),
                                    controllerForLeft:
                                        _otherChargeNameController2,
                                    controllerpkID: _otherChargeIDController2,
                                    Custom_values1:
                                        arr_ALL_Name_ID_For_ProjectList2),
                              ),
                              Expanded(flex: 1, child: OtherAmount2())
                            ]),
                            Row(children: [
                              Expanded(
                                flex: 2,
                                child: OtherChargeDropDown3("Other Charge 1",
                                    enable1: false,
                                    title: "Other Charge 1",
                                    hintTextvalue: "Select Other Charge",
                                    icon: Icon(Icons.arrow_drop_down),
                                    controllerForLeft:
                                        _otherChargeNameController3,
                                    controllerpkID: _otherChargeIDController3,
                                    Custom_values1:
                                        arr_ALL_Name_ID_For_ProjectList3),
                              ),
                              Expanded(flex: 1, child: OtherAmount3())
                            ]),
                            Row(children: [
                              Expanded(
                                flex: 2,
                                child: OtherChargeDropDown4("Other Charge 1",
                                    enable1: false,
                                    title: "Other Charge 1",
                                    hintTextvalue: "Select Other Charge",
                                    icon: Icon(Icons.arrow_drop_down),
                                    controllerForLeft:
                                        _otherChargeNameController4,
                                    controllerpkID: _otherChargeIDController4,
                                    Custom_values1:
                                        arr_ALL_Name_ID_For_ProjectList4),
                              ),
                              Expanded(flex: 1, child: OtherAmount4())
                            ]),
                            Row(children: [
                              Expanded(
                                flex: 2,
                                child: OtherChargeDropDown5("Other Charge 1",
                                    enable1: false,
                                    title: "Other Charge 1",
                                    hintTextvalue: "Select Other Charge",
                                    icon: Icon(Icons.arrow_drop_down),
                                    controllerForLeft:
                                        _otherChargeNameController5,
                                    controllerpkID: _otherChargeIDController5,
                                    Custom_values1:
                                        arr_ALL_Name_ID_For_ProjectList5),
                              ),
                              Expanded(flex: 1, child: OtherAmount5())
                            ]),
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  getCommonButton(baseTheme, () {
                    //_onTapOfAdd();

                    _OnTaptoSave();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("OtherCharges Update SucessFully !"),
                    ));
                  }, "Submit")
                ]),
              ),
            )),
          ),
        ],
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    PushAllOtherChargesToDb();
    /* _inquiryBloc.add(QT_OtherChargeDeleteRequestEvent());

    */
    UpdateAfterHeaderDiscountToDB();
    AllOtherCharges allOtherCharges = AllOtherCharges();

    allOtherCharges.HeaderDiscount = _headerDiscountController.text;

    allOtherCharges.OtherChargName1 = _otherChargeNameController1.text;
    allOtherCharges.OtherChargeAmount1 = _otherAmount1.text;
    allOtherCharges.OtherChargeID1 = _otherChargeIDController1.text;
    allOtherCharges.OtherChargeTaxType1 = _otherChargeTaxTypeController1.text;
    allOtherCharges.OtherChargeGstPer1 = _otherChargeGSTPerController1.text;
    allOtherCharges.OtherChargeBeforGst1 =
        _otherChargeBeForeGSTController1.text;

    allOtherCharges.OtherChargName2 = _otherChargeNameController2.text;
    allOtherCharges.OtherChargeAmount2 = _otherAmount2.text;
    allOtherCharges.OtherChargeID2 = _otherChargeIDController2.text;
    allOtherCharges.OtherChargeTaxType2 = _otherChargeTaxTypeController2.text;
    allOtherCharges.OtherChargeGstPer2 = _otherChargeGSTPerController2.text;
    allOtherCharges.OtherChargeBeforGst2 =
        _otherChargeBeForeGSTController2.text;

    allOtherCharges.OtherChargName3 = _otherChargeNameController3.text;
    allOtherCharges.OtherChargeAmount3 = _otherAmount3.text;
    allOtherCharges.OtherChargeID3 = _otherChargeIDController3.text;
    allOtherCharges.OtherChargeTaxType3 = _otherChargeTaxTypeController3.text;
    allOtherCharges.OtherChargeGstPer3 = _otherChargeGSTPerController3.text;
    allOtherCharges.OtherChargeBeforGst3 =
        _otherChargeBeForeGSTController3.text;

    allOtherCharges.OtherChargName4 = _otherChargeNameController4.text;
    allOtherCharges.OtherChargeAmount4 = _otherAmount4.text;
    allOtherCharges.OtherChargeID4 = _otherChargeIDController4.text;
    allOtherCharges.OtherChargeTaxType4 = _otherChargeTaxTypeController4.text;
    allOtherCharges.OtherChargeGstPer4 = _otherChargeGSTPerController4.text;
    allOtherCharges.OtherChargeBeforGst4 =
        _otherChargeBeForeGSTController4.text;

    allOtherCharges.OtherChargName5 = _otherChargeNameController5.text;
    allOtherCharges.OtherChargeAmount5 = _otherAmount5.text;
    allOtherCharges.OtherChargeID5 = _otherChargeIDController5.text;
    allOtherCharges.OtherChargeTaxType5 = _otherChargeTaxTypeController5.text;
    allOtherCharges.OtherChargeGstPer5 = _otherChargeGSTPerController5.text;
    allOtherCharges.OtherChargeBeforGst5 =
        _otherChargeBeForeGSTController5.text;

    Navigator.of(context).pop(allOtherCharges);
    print("Tap To BackEvent");
  }

  Widget DiscountAmount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Discount Amount",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 3,
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            alignment: Alignment.center,
            child: TextFormField(
                validator: (value) {
                  if (value.toString().trim().isEmpty) {
                    return "Please enter this field";
                  }
                  return null;
                },
                focusNode: QuantityFocusNode,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: _headerDiscountController,
                onTap: () => {
                      _headerDiscountController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: _headerDiscountController.text.length,
                      )
                    },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 10),
                  hintText: "0.00",
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
        )
      ],
    );
  }

  Widget BasicAmount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Basic Amount",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 3,
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: TextFormField(
                // key: Key(totalCalculated()),

                validator: (value) {
                  if (value.toString().trim().isEmpty) {
                    return "Please enter this field";
                  }
                  return null;
                },
                enabled: false,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: _basicAmountController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 10),
                  hintText: "0.00",
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
        )
      ],
    );
  }

  Widget OtherChargeWithTax() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("OtherCharge(With Tax)",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 3,
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                      // key: Key(totalCalculated()),

                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Please enter this field";
                        }
                        return null;
                      },
                      enabled: false,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _otherChargeWithTaxController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
                        hintText: "0.00",
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
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget TotalGST() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Total GST",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 3,
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                      // key: Key(totalCalculated()),

                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Please enter this field";
                        }
                        return null;
                      },
                      enabled: false,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _totalGstController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
                        hintText: "0.00",
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
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget OtherChargeExcludingTax() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("OtherCharge(Exc.Tax)",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 3,
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                      // key: Key(totalCalculated()),

                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Please enter this field";
                        }
                        return null;
                      },
                      enabled: false,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _otherChargeExcludeTaxController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
                        hintText: "0.00",
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
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget NetAmount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Net Amount",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 3,
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                      // key: Key(totalCalculated()),

                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Please enter this field";
                        }
                        return null;
                      },
                      enabled: false,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _netAmountController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
                        hintText: "0.00",
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
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget RoundOff() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Round Off",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 3,
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                      // key: Key(totalCalculated()),

                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Please enter this field";
                        }
                        return null;
                      },
                      enabled: false,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _roundOFController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
                        hintText: "0.00",
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
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget OtherChargeDropDown1(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      TextEditingController controller1,
      TextEditingController controllerpkID,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      margin: EdgeInsets.only(top: 3, bottom: 10),
      child: Column(
        children: [
          InkWell(
            onTap: () => showcustomdialogWithOtherCharges(
                values: arr_ALL_Name_ID_For_ProjectList1,
                context1: context,
                controller: _otherChargeNameController1,
                controllerID: _otherChargeIDController1,
                controller1: _otherChargeGSTPerController1,
                controller2: _otherChargeTaxTypeController1,
                controller3: _otherChargeBeForeGSTController1,
                lable: "Select Other Charge"),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 5,
                  color: colorLightGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: CardViewHeight,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              controller: controllerForLeft,
                              enabled: false,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 10),
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

  Widget OtherChargeDropDown2(String Category,
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
            onTap: () => showcustomdialogWithOtherCharges(
                values: arr_ALL_Name_ID_For_ProjectList2,
                context1: context,
                controller: _otherChargeNameController2,
                controllerID: _otherChargeIDController2,
                controller1: _otherChargeGSTPerController2,
                controller2: _otherChargeTaxTypeController2,
                controller3: _otherChargeBeForeGSTController2,
                lable: "Select Other Charge"),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 5,
                  color: colorLightGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: CardViewHeight,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              controller: controllerForLeft,
                              enabled: false,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 10),
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

  Widget OtherChargeDropDown3(String Category,
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
            onTap: () => showcustomdialogWithOtherCharges(
                values: arr_ALL_Name_ID_For_ProjectList3,
                context1: context,
                controller: _otherChargeNameController3,
                controllerID: _otherChargeIDController3,
                controller1: _otherChargeGSTPerController3,
                controller2: _otherChargeTaxTypeController3,
                controller3: _otherChargeBeForeGSTController3,
                lable: "Select Other Charge"),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 5,
                  color: colorLightGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: CardViewHeight,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              controller: controllerForLeft,
                              enabled: false,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 10),
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

  Widget OtherChargeDropDown4(String Category,
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
            onTap: () => showcustomdialogWithOtherCharges(
                values: arr_ALL_Name_ID_For_ProjectList4,
                context1: context,
                controller: _otherChargeNameController4,
                controllerID: _otherChargeIDController4,
                controller1: _otherChargeGSTPerController4,
                controller2: _otherChargeTaxTypeController4,
                controller3: _otherChargeBeForeGSTController4,
                lable: "Select Other Charge"),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 5,
                  color: colorLightGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: CardViewHeight,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              controller: controllerForLeft,
                              enabled: false,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 10),
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

  Widget OtherChargeDropDown5(String Category,
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
            onTap: () => showcustomdialogWithOtherCharges(
                values: arr_ALL_Name_ID_For_ProjectList5,
                context1: context,
                controller: _otherChargeNameController5,
                controllerID: _otherChargeIDController5,
                controller1: _otherChargeGSTPerController5,
                controller2: _otherChargeTaxTypeController5,
                controller3: _otherChargeBeForeGSTController5,
                lable: "Select Other Charge"),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 5,
                  color: colorLightGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: CardViewHeight,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              controller: controllerForLeft,
                              enabled: false,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 10),
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

  void _onOtherChargeListResponse(QuotationOtherChargeListResponseState state) {
    if (state.quotationOtherChargesListResponse.details.length != 0) {
      arr_ALL_Name_ID_For_ProjectList1.clear();
      arr_ALL_Name_ID_For_ProjectList2.clear();
      arr_ALL_Name_ID_For_ProjectList3.clear();
      arr_ALL_Name_ID_For_ProjectList4.clear();
      arr_ALL_Name_ID_For_ProjectList5.clear();

      for (var i = 0;
          i < state.quotationOtherChargesListResponse.details.length;
          i++) {
        print("InquiryStatus : " +
            state.quotationOtherChargesListResponse.details[i].chargeName);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name =
            state.quotationOtherChargesListResponse.details[i].chargeName;
        all_name_id.pkID =
            state.quotationOtherChargesListResponse.details[i].pkId;
        all_name_id.Taxtype = state
            .quotationOtherChargesListResponse.details[i].taxType
            .toString();
        all_name_id.TaxRate = state
            .quotationOtherChargesListResponse.details[i].gSTPer
            .toString();
        all_name_id.isChecked =
            state.quotationOtherChargesListResponse.details[i].beforeGST;
        arr_ALL_Name_ID_For_ProjectList1.add(all_name_id);
        arr_ALL_Name_ID_For_ProjectList2.add(all_name_id);
        arr_ALL_Name_ID_For_ProjectList3.add(all_name_id);
        arr_ALL_Name_ID_For_ProjectList4.add(all_name_id);
        arr_ALL_Name_ID_For_ProjectList5.add(all_name_id);

        if (_otherChargeIDController1.text ==
            state.quotationOtherChargesListResponse.details[i].pkId
                .toString()) {
          _otherChargeIDController1.text = state
              .quotationOtherChargesListResponse.details[i].pkId
              .toString();

          _otherChargeNameController1.text =
              state.quotationOtherChargesListResponse.details[i].chargeName;

          _otherChargeTaxTypeController1.text = state
              .quotationOtherChargesListResponse.details[i].taxType
              .toString();
          _otherChargeGSTPerController1.text = state
              .quotationOtherChargesListResponse.details[i].gSTPer
              .toString();
          _otherChargeBeForeGSTController1.text = state
              .quotationOtherChargesListResponse.details[i].beforeGST
              .toString();
        }

        if (_otherChargeIDController2.text ==
            state.quotationOtherChargesListResponse.details[i].pkId
                .toString()) {
          _otherChargeIDController2.text = state
              .quotationOtherChargesListResponse.details[i].pkId
              .toString();

          _otherChargeNameController2.text =
              state.quotationOtherChargesListResponse.details[i].chargeName;

          _otherChargeTaxTypeController2.text = state
              .quotationOtherChargesListResponse.details[i].taxType
              .toString();
          _otherChargeGSTPerController2.text = state
              .quotationOtherChargesListResponse.details[i].gSTPer
              .toString();
          _otherChargeBeForeGSTController2.text = state
              .quotationOtherChargesListResponse.details[i].beforeGST
              .toString();
        } else if (_otherChargeIDController3.text ==
            state.quotationOtherChargesListResponse.details[i].pkId
                .toString()) {
          _otherChargeIDController3.text = state
              .quotationOtherChargesListResponse.details[i].pkId
              .toString();

          _otherChargeNameController3.text =
              state.quotationOtherChargesListResponse.details[i].chargeName;

          _otherChargeTaxTypeController3.text = state
              .quotationOtherChargesListResponse.details[i].taxType
              .toString();
          _otherChargeGSTPerController3.text = state
              .quotationOtherChargesListResponse.details[i].gSTPer
              .toString();
          _otherChargeBeForeGSTController3.text = state
              .quotationOtherChargesListResponse.details[i].beforeGST
              .toString();
        } else if (_otherChargeIDController4.text ==
            state.quotationOtherChargesListResponse.details[i].pkId
                .toString()) {
          _otherChargeIDController4.text = state
              .quotationOtherChargesListResponse.details[i].pkId
              .toString();

          _otherChargeNameController4.text =
              state.quotationOtherChargesListResponse.details[i].chargeName;

          _otherChargeTaxTypeController4.text = state
              .quotationOtherChargesListResponse.details[i].taxType
              .toString();
          _otherChargeGSTPerController4.text = state
              .quotationOtherChargesListResponse.details[i].gSTPer
              .toString();
          _otherChargeBeForeGSTController4.text = state
              .quotationOtherChargesListResponse.details[i].beforeGST
              .toString();
        } else if (_otherChargeIDController5.text ==
            state.quotationOtherChargesListResponse.details[i].pkId
                .toString()) {
          _otherChargeIDController5.text = state
              .quotationOtherChargesListResponse.details[i].pkId
              .toString();

          _otherChargeNameController5.text =
              state.quotationOtherChargesListResponse.details[i].chargeName;

          _otherChargeTaxTypeController5.text = state
              .quotationOtherChargesListResponse.details[i].taxType
              .toString();
          _otherChargeGSTPerController5.text = state
              .quotationOtherChargesListResponse.details[i].gSTPer
              .toString();
          _otherChargeBeForeGSTController5.text = state
              .quotationOtherChargesListResponse.details[i].beforeGST
              .toString();
        }
      }

      /*  if(arr_ALL_Name_ID_For_ProjectList1.length!=0)
        {
          for(int i=0;i<arr_ALL_Name_ID_For_ProjectList1.length;i++)
            {
              if(_otherChargeIDController1.text==arr_ALL_Name_ID_For_ProjectList1[i].pkID.toString())
              {
                _otherChargeIDController1.text        = arr_ALL_Name_ID_For_ProjectList1[i].pkID.toString();
                _otherChargeNameController1.text      = arr_ALL_Name_ID_For_ProjectList1[i].Name;
                _otherChargeTaxTypeController1.text   = arr_ALL_Name_ID_For_ProjectList1[i].Taxtype;
                _otherChargeGSTPerController1.text    = arr_ALL_Name_ID_For_ProjectList1[i].TaxRate;
                _otherChargeBeForeGSTController1.text = arr_ALL_Name_ID_For_ProjectList1[i].isChecked.toString();


              }

            }
        }
      else if(arr_ALL_Name_ID_For_ProjectList2.length!=0)
      {
        for(int i=0;i<arr_ALL_Name_ID_For_ProjectList2.length;i++)
        {
          if(_otherChargeIDController2.text==arr_ALL_Name_ID_For_ProjectList2[i].pkID.toString())
          {
            _otherChargeIDController2.text = arr_ALL_Name_ID_For_ProjectList2[i].pkID.toString();

            _otherChargeNameController2.text  = arr_ALL_Name_ID_For_ProjectList2[i].Name;

            _otherChargeTaxTypeController2.text = arr_ALL_Name_ID_For_ProjectList2[i].Taxtype;
            _otherChargeGSTPerController2.text =arr_ALL_Name_ID_For_ProjectList2[i].TaxRate;
            _otherChargeBeForeGSTController2.text = arr_ALL_Name_ID_For_ProjectList2[i].isChecked.toString();


          }

        }
      }
      else if(arr_ALL_Name_ID_For_ProjectList3.length!=0)
      {
        for(int i=0;i<arr_ALL_Name_ID_For_ProjectList3.length;i++)
        {

          print("gfry"+ _otherChargeIDController3.text  + "ArrayChrgeID : " + arr_ALL_Name_ID_For_ProjectList3[i].pkID.toString());
          if(_otherChargeIDController3.text==arr_ALL_Name_ID_For_ProjectList3[i].pkID.toString())
          {
            _otherChargeIDController3.text = arr_ALL_Name_ID_For_ProjectList3[i].pkID.toString();

            _otherChargeNameController3.text  = arr_ALL_Name_ID_For_ProjectList3[i].Name;


            _otherChargeTaxTypeController3.text = arr_ALL_Name_ID_For_ProjectList3[i].Taxtype;

            print("sdfjdfj"+ "ChargeTaxtype" +  _otherChargeTaxTypeController3.text);

            _otherChargeGSTPerController3.text =arr_ALL_Name_ID_For_ProjectList3[i].TaxRate;
            _otherChargeBeForeGSTController3.text = arr_ALL_Name_ID_For_ProjectList3[i].isChecked.toString();


          }

        }
      }
      else if(arr_ALL_Name_ID_For_ProjectList4.length!=0)
      {
        for(int i=0;i<arr_ALL_Name_ID_For_ProjectList4.length;i++)
        {
          if(_otherChargeIDController4.text==arr_ALL_Name_ID_For_ProjectList4[i].pkID.toString())
          {
            _otherChargeIDController4.text = arr_ALL_Name_ID_For_ProjectList4[i].pkID.toString();

            _otherChargeNameController4.text  = arr_ALL_Name_ID_For_ProjectList4[i].Name;

            _otherChargeTaxTypeController4.text = arr_ALL_Name_ID_For_ProjectList4[i].Taxtype;
            _otherChargeGSTPerController4.text =arr_ALL_Name_ID_For_ProjectList4[i].TaxRate;
            _otherChargeBeForeGSTController4.text = arr_ALL_Name_ID_For_ProjectList4[i].isChecked.toString();


          }

        }
      }
      else if(arr_ALL_Name_ID_For_ProjectList5.length!=0)
      {
        for(int i=0;i<arr_ALL_Name_ID_For_ProjectList5.length;i++)
        {
          if(_otherChargeIDController5.text==arr_ALL_Name_ID_For_ProjectList5[i].pkID.toString())
          {
            _otherChargeIDController5.text = arr_ALL_Name_ID_For_ProjectList5[i].pkID.toString();

            _otherChargeNameController5.text  = arr_ALL_Name_ID_For_ProjectList5[i].Name;

            _otherChargeTaxTypeController5.text = arr_ALL_Name_ID_For_ProjectList5[i].Taxtype;
            _otherChargeGSTPerController5.text =arr_ALL_Name_ID_For_ProjectList5[i].TaxRate;
            _otherChargeBeForeGSTController5.text = arr_ALL_Name_ID_For_ProjectList5[i].isChecked.toString();


          }

        }


      }

*/
    }
  }

  Widget OtherAmount1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            alignment: Alignment.center,
            child: Focus(
              child: TextFormField(
                  validator: (value) {
                    if (value.toString().trim().isEmpty) {
                      return "Please enter this field";
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: _otherAmount1,
                  onTap: () => {
                        _otherAmount1.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: _otherAmount1.text.length,
                        )
                      },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 10),
                    hintText: "0.00",
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
              /*onFocusChange: (hasFocus){
                  if(hasFocus)
                    {
                      TotalCalculation();
                    }
                },*/
            ),
            /*  onFocusChange: (hasFocus) {
                if(hasFocus) {
                  // do stuff



                }
              },
            ),*/
          ),
        )
      ],
    );
  }

  Widget OtherAmount2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            alignment: Alignment.center,
            child: Focus(
              child: TextFormField(
                  validator: (value) {
                    if (value.toString().trim().isEmpty) {
                      return "Please enter this field";
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: _otherAmount2,
                  onTap: () => {
                        _otherAmount2.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: _otherAmount2.text.length,
                        )
                      },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 10),
                    hintText: "0.00",
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
              /* onFocusChange: (hasFocus){
                if(hasFocus){
                  TotalCalculation2();
                }
              },*/
            ),
          ),
        )
      ],
    );
  }

  Widget OtherAmount3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            alignment: Alignment.center,
            child: Focus(
              child: TextFormField(
                  validator: (value) {
                    if (value.toString().trim().isEmpty) {
                      return "Please enter this field";
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: _otherAmount3,
                  onTap: () => {
                        _otherAmount3.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: _otherAmount3.text.length,
                        )
                      },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 10),
                    hintText: "0.00",
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
              /* onFocusChange: (hasFocus)
              {
                if(hasFocus)
                  {
                    TotalCalculation3();
                  }
              },*/
            ),
          ),
        )
      ],
    );
  }

  Widget OtherAmount4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            alignment: Alignment.center,
            child: Focus(
              child: TextFormField(
                  validator: (value) {
                    if (value.toString().trim().isEmpty) {
                      return "Please enter this field";
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: _otherAmount4,
                  onTap: () => {
                        _otherAmount4.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: _otherAmount4.text.length,
                        )
                      },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 10),
                    hintText: "0.00",
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
              onFocusChange: (hasFocus) {
                if (hasFocus) {
                  TotalCalculation4();
                }
              },
            ),
          ),
        )
      ],
    );
  }

  Widget OtherAmount5() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            alignment: Alignment.center,
            child: TextFormField(
                validator: (value) {
                  if (value.toString().trim().isEmpty) {
                    return "Please enter this field";
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: _otherAmount5,
                onTap: () => {
                      _otherAmount5.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: _otherAmount5.text.length,
                      )
                    },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 10),
                  hintText: "0.00",
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
        )
      ],
    );
  }

//Other Charge (With Tax)

  void TotalCalculation() async {
    double ChargeAmt1 =
        double.parse(_otherAmount1.text == null ? 0.00 : _otherAmount1.text);

    double taxRate1 = double.parse(_otherChargeGSTPerController1.text == null
        ? 0.00
        : _otherChargeGSTPerController1.text);

    ///_otherChargeTaxTypeController1.text = 1 (Exclusive) -- _otherChargeTaxTypeController1.text = 0 (Inclusive)

    /// _otherChargeBeForeGSTController1.text=="true" (Before GST) _otherChargeBeForeGSTController1.text=="false" (After GST)
    ///
    double Taxtype = 0.00;
    int ISTaxType = 0;

    if (_otherChargeTaxTypeController1.text != null) {
      Taxtype = double.parse(_otherChargeTaxTypeController1.text);
      ISTaxType = Taxtype.toInt();
    }

    print("sdfjdlf" + ISTaxType.toString());
    if (ISTaxType == 1) {
      InclusiveBeforeGstAmnt1 = 0.00;
      InclusiveBeforeGstAmnt_Minus1 = 0.00;
      AfterInclusiveBeforeGstAmnt1 = 0.00;
      if (_otherChargeBeForeGSTController1.text == "true") {
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

      if (_otherChargeBeForeGSTController1.text == "true") {
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
    double ChargeAmt2 =
        double.parse(_otherAmount2.text == null ? 0.00 : _otherAmount2.text);

    double taxRate2 = double.parse(_otherChargeGSTPerController2.text == null
        ? 0.00
        : _otherChargeGSTPerController2.text);

    double Taxtype = 0.00;
    int ISTaxType = 0;

    if (_otherChargeTaxTypeController2.text != null) {
      Taxtype = double.parse(_otherChargeTaxTypeController2.text);
      ISTaxType = Taxtype.toInt();
    }

    if (ISTaxType == 1) {
      InclusiveBeforeGstAmnt2 = 0.00;
      InclusiveBeforeGstAmnt_Minus2 = 0.00;
      AfterInclusiveBeforeGstAmnt2 = 0.00;
      if (_otherChargeBeForeGSTController2.text == "true") {
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

      if (_otherChargeBeForeGSTController2.text == "true") {
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
    double ChargeAmt3 =
        double.parse(_otherAmount3.text == null ? 0.00 : _otherAmount3.text);
    double taxRate3 = double.parse(_otherChargeGSTPerController3.text == null
        ? 0.00
        : _otherChargeGSTPerController3.text);
    double Taxtype = 0.00;
    int ISTaxType = 0;

    print("testOtherg" + _otherChargeTaxTypeController3.text);

    if (_otherChargeTaxTypeController3.text != null) {
      Taxtype = double.parse(_otherChargeTaxTypeController3.text);
      ISTaxType = Taxtype.toInt();
    }
    if (ISTaxType == 1) {
      InclusiveBeforeGstAmnt3 = 0.00;
      InclusiveBeforeGstAmnt_Minus3 = 0.00;
      AfterInclusiveBeforeGstAmnt3 = 0.00;
      if (_otherChargeBeForeGSTController3.text == "true") {
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

      if (_otherChargeBeForeGSTController3.text == "true") {
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
    double ChargeAmt4 =
        double.parse(_otherAmount4.text == null ? 0.00 : _otherAmount4.text);
    double taxRate4 = double.parse(_otherChargeGSTPerController4.text == null
        ? 0.00
        : _otherChargeGSTPerController4.text);

    double Taxtype = 0.00;
    int ISTaxType = 0;

    if (_otherChargeTaxTypeController4.text != null) {
      Taxtype = double.parse(_otherChargeTaxTypeController4.text);
      ISTaxType = Taxtype.toInt();
    }

    if (ISTaxType == 1) {
      InclusiveBeforeGstAmnt4 = 0.00;
      InclusiveBeforeGstAmnt_Minus4 = 0.00;
      AfterInclusiveBeforeGstAmnt4 = 0.00;
      if (_otherChargeBeForeGSTController4.text == "true") {
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

      if (_otherChargeBeForeGSTController4.text == "true") {
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
    double ChargeAmt5 =
        double.parse(_otherAmount5.text == null ? 0.00 : _otherAmount5.text);
    double taxRate5 = double.parse(_otherChargeGSTPerController5.text == null
        ? 0.00
        : _otherChargeGSTPerController5.text);

    double Taxtype = 0.00;
    int ISTaxType = 0;

    if (_otherChargeTaxTypeController5.text != null) {
      Taxtype = double.parse(_otherChargeTaxTypeController5.text);
      ISTaxType = Taxtype.toInt();
    }

    if (ISTaxType == 1) {
      InclusiveBeforeGstAmnt5 = 0.00;
      InclusiveBeforeGstAmnt_Minus5 = 0.00;
      AfterInclusiveBeforeGstAmnt5 = 0.00;
      if (_otherChargeBeForeGSTController5.text == "true") {
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

      if (_otherChargeBeForeGSTController5.text == "true") {
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

  Future<void> getInquiryProductDetails() async {
    _inquiryProductList.clear();
    List<QuotationTable> temp =
        await OfflineDbHelper.getInstance().getQuotationProduct();
    _inquiryProductList.addAll(temp);

    setState(() {});
  }

  //

  void getProductFromDB() async {
    await getInquiryProductDetails();

    /* double Tot_BasicAmount = 0.00;
    double Tot_otherChargeWithTax = 0.00;
    double Tot_GSTAmt = 0.00;
    double Tot_otherChargeExcludeTax = 0.00;
    double Tot_NetAmt = 0.00;*/

    _basicAmountController.text = "0.00";
    _otherChargeWithTaxController.text = "0.00";
    _totalGstController.text = "0.00";
    _otherChargeExcludeTaxController.text = "0.00";
    _netAmountController.text = "0.00";

    /*  int Taxtype1 = int.parse(_otherChargeTaxTypeController1.text==null?0:_otherChargeTaxTypeController1.text);
    int Taxtype2 = int.parse(_otherChargeTaxTypeController1.text==null?0:_otherChargeTaxTypeController1.text);
    int Taxtype3 = int.parse(_otherChargeTaxTypeController1.text==null?0:_otherChargeTaxTypeController1.text);
    int Taxtype4 = int.parse(_otherChargeTaxTypeController1.text==null?0:_otherChargeTaxTypeController1.text);
    int Taxtype5 = int.parse(_otherChargeTaxTypeController1.text==null?0:_otherChargeTaxTypeController1.text);

    String beforeGSt1 = _otherChargeBeForeGSTController1.text==null?"":_otherChargeBeForeGSTController1.text;
    String beforeGSt2 = _otherChargeBeForeGSTController1.text==null?"":_otherChargeBeForeGSTController1.text;
    String beforeGSt3 = _otherChargeBeForeGSTController1.text==null?"":_otherChargeBeForeGSTController1.text;
    String beforeGSt4 = _otherChargeBeForeGSTController1.text==null?"":_otherChargeBeForeGSTController1.text;
    String beforeGSt5 = _otherChargeBeForeGSTController1.text==null?"":_otherChargeBeForeGSTController1.text;

    double ChargeAmt1 = double.parse(_otherAmount1.text==null?0.00:_otherAmount1.text);
    double ChargeAmt2 = double.parse(_otherAmount2.text==null?0.00:_otherAmount1.text);
    double ChargeAmt3 = double.parse(_otherAmount3.text==null?0.00:_otherAmount1.text);
    double ChargeAmt4 = double.parse(_otherAmount4.text==null?0.00:_otherAmount1.text);
    double ChargeAmt5 = double.parse(_otherAmount5.text==null?0.00:_otherAmount1.text);

    double taxRate1 = double.parse(_otherChargeGSTPerController1.text==null?0.00:_otherChargeGSTPerController1.text);
    double taxRate2 = double.parse(_otherChargeGSTPerController2.text==null?0.00:_otherChargeGSTPerController2.text);
    double taxRate3 = double.parse(_otherChargeGSTPerController3.text==null?0.00:_otherChargeGSTPerController3.text);
    double taxRate4 = double.parse(_otherChargeGSTPerController4.text==null?0.00:_otherChargeGSTPerController4.text);
    double taxRate5 = double.parse(_otherChargeGSTPerController5.text==null?0.00:_otherChargeGSTPerController5.text);*/

    if (_inquiryProductList.length != 0) {
      for (int i = 0; i < _inquiryProductList.length; i++) {
        Tot_BasicAmount = Tot_BasicAmount + _inquiryProductList[i].Amount;
        Tot_otherChargeWithTax = 0.00;

        ///Before Gst
        Tot_GSTAmt = Tot_GSTAmt + _inquiryProductList[i].TaxAmount;
        Tot_otherChargeExcludeTax = 0.00;

        ///AFTER gst
        Tot_NetAmt = Tot_NetAmt + _inquiryProductList[i].NetAmount;
      }

      print("ldsjf323" + Tot_NetAmt.toStringAsFixed(2));

      /* if(Taxtype1==1)
          {
            if(beforeGSt1=="true")
              {
                Tot_otherChargeWithTax = Tot_otherChargeWithTax +  ChargeAmt1;
              }
            else{
                 Tot_otherChargeExcludeTax =  Tot_otherChargeExcludeTax +ChargeAmt1;
            }

            Tot_GSTAmt =  Tot_GSTAmt + ((ChargeAmt1 * taxRate1)/100);

          }
        else{
          if(beforeGSt1=="true")
          {
            Tot_otherChargeWithTax = Tot_otherChargeWithTax + (ChargeAmt1 - ((ChargeAmt1 * taxRate1) / 100+taxRate1)) ;
          }
          else{
            Tot_otherChargeExcludeTax =  Tot_otherChargeExcludeTax +ChargeAmt1;
          }

          Tot_GSTAmt =  Tot_GSTAmt + ((ChargeAmt1 * taxRate1)/100+taxRate1);

        }*/

      setState(() {
        _basicAmountController.text = Tot_BasicAmount.toStringAsFixed(2);
        _otherChargeWithTaxController.text =
            Tot_otherChargeWithTax.toStringAsFixed(2);
        _totalGstController.text = Tot_GSTAmt.toStringAsFixed(2);
        _otherChargeExcludeTaxController.text =
            Tot_otherChargeExcludeTax.toStringAsFixed(2);
        _netAmountController.text = Tot_NetAmt.toStringAsFixed(2);
      });
    }

    _OnTaptoSave();
  }

  void PushAllOtherChargesToDb() {
    /* List<QT_OtherChargeTable> arrTemp = await OfflineDbHelper.getInstance().getQuotationOtherCharge();

   if(arrTemp.isNotEmpty)
     {
         await OfflineDbHelper.getInstance().deleteALLQuotationOtherCharge();
     }*/

    print("BeforGSTAmnt" +
        "ChargeAmnt1 : " +
        _otherAmount1.text.toString() +
        "ChargeAmnt2 : " +
        _otherAmount2.text.toString() +
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
        _otherAmount1.text.toString() +
        "ChargeAmnt2 : " +
        _otherAmount2.text.toString() +
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
    print("ChargeID" + _otherChargeIDController2.text.toString());
    qt_otherChargeTable.ChargeID1 =
        _otherChargeIDController1.text.toString() != "" ||
                _otherChargeIDController1.text.toString() != null
            ? int.parse(_otherChargeIDController1.text.toString())
            : 0; //==null?0:_otherChargeIDController1.text.toString());
    qt_otherChargeTable.ChargeID2 = _otherChargeIDController2.text != "" ||
            _otherChargeIDController2.text != null
        ? int.parse(_otherChargeIDController2.text.toString())
        : 0; //==null?0:_otherChargeIDController2.text.toString());
    qt_otherChargeTable.ChargeID3 =
        _otherChargeIDController3.text.toString() != "" ||
                _otherChargeIDController3.text.toString() != null
            ? int.parse(_otherChargeIDController3.text.toString())
            : 0; //==null?0:_otherChargeIDController3.text.toString());
    qt_otherChargeTable.ChargeID4 =
        _otherChargeIDController4.text.toString() != "" ||
                _otherChargeIDController4.text.toString() != null
            ? int.parse(_otherChargeIDController4.text.toString())
            : 0; //==null?0:_otherChargeIDController4.text.toString());
    qt_otherChargeTable.ChargeID5 =
        _otherChargeIDController5.text.toString() != "" ||
                _otherChargeIDController5.text.toString() != null
            ? int.parse(_otherChargeIDController5.text.toString())
            : 0; //==null?0:_otherChargeIDController5.text.toString());
    qt_otherChargeTable.Headerdiscount = 0.00;
    qt_otherChargeTable.Tot_BasicAmt = double.parse(
        _basicAmountController.text == null
            ? 0.00
            : _basicAmountController.text);
    qt_otherChargeTable.OtherChargeWithTaxamt = double.parse(
        _otherChargeWithTaxController.text == null
            ? 0.00
            : _otherChargeWithTaxController.text);
    qt_otherChargeTable.Tot_GstAmt = double.parse(
        _totalGstController.text == null ? 0.00 : _totalGstController.text);
    qt_otherChargeTable.OtherChargeExcludeTaxamt = double.parse(
        _otherChargeExcludeTaxController.text == null
            ? 0.00
            : _otherChargeExcludeTaxController.text);
    qt_otherChargeTable.Tot_NetAmount = double.parse(
        _netAmountController.text == null ? 0.00 : _netAmountController.text);
    qt_otherChargeTable.ChargeAmt1 =
        double.parse(_otherAmount1.text == null ? 0.00 : _otherAmount1.text);
    qt_otherChargeTable.ChargeAmt2 =
        double.parse(_otherAmount2.text == null ? 0.00 : _otherAmount2.text);
    qt_otherChargeTable.ChargeAmt3 =
        double.parse(_otherAmount3.text == null ? 0.00 : _otherAmount3.text);
    qt_otherChargeTable.ChargeAmt4 =
        double.parse(_otherAmount4.text == null ? 0.00 : _otherAmount4.text);
    qt_otherChargeTable.ChargeAmt5 =
        double.parse(_otherAmount5.text == null ? 0.00 : _otherAmount5.text);

    if (_otherChargeTaxTypeController1.text == "1") {
      if (_otherChargeBeForeGSTController1.text == "true") {
        qt_otherChargeTable.ChargeBasicAmt1 = ExclusiveBeforeGStAmnt1;
        qt_otherChargeTable.ChargeGSTAmt1 = ExclusiveBeforeGStAmnt_Minus1;
      } else {
        qt_otherChargeTable.ChargeBasicAmt1 = ExclusiveAfterGstAmnt1;
        qt_otherChargeTable.ChargeGSTAmt1 = 0.00;
      }
    } else {
      if (_otherChargeBeForeGSTController1.text == "true") {
        qt_otherChargeTable.ChargeBasicAmt1 = InclusiveBeforeGstAmnt1;
        qt_otherChargeTable.ChargeGSTAmt1 = InclusiveBeforeGstAmnt_Minus1;
      } else {
        qt_otherChargeTable.ChargeBasicAmt1 = AfterInclusiveBeforeGstAmnt1;
        qt_otherChargeTable.ChargeGSTAmt1 = 0.00;
      }
    }

    if (_otherChargeTaxTypeController2.text == "1") {
      if (_otherChargeBeForeGSTController2.text == "true") {
        qt_otherChargeTable.ChargeBasicAmt2 = ExclusiveBeforeGStAmnt2;
        qt_otherChargeTable.ChargeGSTAmt2 = ExclusiveBeforeGStAmnt_Minus2;
      } else {
        qt_otherChargeTable.ChargeBasicAmt2 = ExclusiveAfterGstAmnt2;
        qt_otherChargeTable.ChargeGSTAmt2 = 0.00;
      }
    } else {
      if (_otherChargeBeForeGSTController2.text == "true") {
        qt_otherChargeTable.ChargeBasicAmt2 = InclusiveBeforeGstAmnt2;
        qt_otherChargeTable.ChargeGSTAmt2 = InclusiveBeforeGstAmnt_Minus2;
      } else {
        qt_otherChargeTable.ChargeBasicAmt2 = AfterInclusiveBeforeGstAmnt2;
        qt_otherChargeTable.ChargeGSTAmt2 = 0.00;
      }
    }

    if (_otherChargeTaxTypeController3.text == "1") {
      if (_otherChargeBeForeGSTController3.text == "true") {
        qt_otherChargeTable.ChargeBasicAmt3 = ExclusiveBeforeGStAmnt3;
        qt_otherChargeTable.ChargeGSTAmt3 = ExclusiveBeforeGStAmnt_Minus3;
      } else {
        qt_otherChargeTable.ChargeBasicAmt3 = ExclusiveAfterGstAmnt3;
        qt_otherChargeTable.ChargeGSTAmt3 = 0.00;
      }
    } else {
      if (_otherChargeBeForeGSTController3.text == "true") {
        qt_otherChargeTable.ChargeBasicAmt3 = InclusiveBeforeGstAmnt3;
        qt_otherChargeTable.ChargeGSTAmt3 = InclusiveBeforeGstAmnt_Minus3;
      } else {
        qt_otherChargeTable.ChargeBasicAmt3 = AfterInclusiveBeforeGstAmnt3;
        qt_otherChargeTable.ChargeGSTAmt3 = 0.00;
      }
    }

    if (_otherChargeTaxTypeController4.text == "1") {
      if (_otherChargeBeForeGSTController4.text == "true") {
        qt_otherChargeTable.ChargeBasicAmt4 = ExclusiveBeforeGStAmnt4;
        qt_otherChargeTable.ChargeGSTAmt4 = ExclusiveBeforeGStAmnt_Minus4;
      } else {
        qt_otherChargeTable.ChargeBasicAmt4 = ExclusiveAfterGstAmnt4;
        qt_otherChargeTable.ChargeGSTAmt4 = 0.00;
      }
    } else {
      if (_otherChargeBeForeGSTController4.text == "true") {
        qt_otherChargeTable.ChargeBasicAmt4 = InclusiveBeforeGstAmnt4;
        qt_otherChargeTable.ChargeGSTAmt4 = InclusiveBeforeGstAmnt_Minus4;
      } else {
        qt_otherChargeTable.ChargeBasicAmt4 = AfterInclusiveBeforeGstAmnt4;
        qt_otherChargeTable.ChargeGSTAmt4 = 0.00;
      }
    }

    if (_otherChargeTaxTypeController5.text == "1") {
      if (_otherChargeBeForeGSTController5.text == "true") {
        qt_otherChargeTable.ChargeBasicAmt5 = ExclusiveBeforeGStAmnt5;
        qt_otherChargeTable.ChargeGSTAmt5 = ExclusiveBeforeGStAmnt_Minus5;
      } else {
        qt_otherChargeTable.ChargeBasicAmt5 = ExclusiveAfterGstAmnt5;
        qt_otherChargeTable.ChargeGSTAmt5 = 0.00;
      }
    } else {
      if (_otherChargeBeForeGSTController5.text == "true") {
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

    //await OfflineDbHelper.getInstance().insertQuotationOtherCharge(qt_otherChargeTable);

    /*await OfflineDbHelper.getInstance()
        .insertQuotationOtherCharge(QT_OtherChargeTable(
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
    ));*/
  }

  void FetchDetailsOfOtherCharges() async {
    List<QT_OtherChargeTable> temp =
        await OfflineDbHelper.getInstance().getQuotationOtherCharge();
    for (int i = 0; i < temp.length; i++) {
      print("OtherChargeQT : " + temp[i].ChargeGSTAmt1.toString());
    }
  }

  Future<void> _onTapOfDeleteALLQuotationCharges() async {
    await OfflineDbHelper.getInstance().deleteALLQuotationOtherCharge();
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

    HeaderDisAmnt = double.parse(_headerDiscountController.text == null
        ? 0.00
        : _headerDiscountController.text);
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

    _basicAmountController.text = Tot_BasicAmount.toStringAsFixed(2);
    _otherChargeWithTaxController.text =
        Tot_otherChargeWithTax.toStringAsFixed(2);

    ///Final Setup Befor GST
    _totalGstController.text = Tot_GSTAmt.toStringAsFixed(2);
    _otherChargeExcludeTaxController.text =
        Tot_otherChargeExcludeTax.toStringAsFixed(2);

    ///Final Setup After GST
    // double Tot_NetAmnt = Tot_NetAmt + Tot_otherChargeWithTax +   Tot_otherChargeExcludeTax;
    _netAmountController.text = Tot_NetAmt.toStringAsFixed(2);
    //Tot_BasicAmount.toStringAsFixed(2) + Tot_otherChargeWithTax.toStringAsFixed(2) + Tot_GSTAmt.toStringAsFixed(2) + Tot_otherChargeExcludeTax.toStringAsFixed(2);
  }

  void UpdateAfterHeaderDiscountToDB() async {
    double tot_amnt_net = 0.00;

    Tot_NetAmt = 0.00;

    _TempinquiryProductList.clear();
    _TempinquiryProductList.addAll(_inquiryProductList);

    _onTapOfDeleteALLProduct();

    for (int i = 0; i < _TempinquiryProductList.length; i++) {
      print("_inquiryProductList[i].NetAmount234" +
          " Tot_NetAmt : " +
          _TempinquiryProductList[i].NetAmount.toString());

      tot_amnt_net = tot_amnt_net + _TempinquiryProductList[i].NetAmount;
    }
    print("Tot_NetAmtTot_NetAmt" + " Tot_NetAmt : " + tot_amnt_net.toString());

    HeaderDisAmnt = double.parse(_headerDiscountController.text == null
        ? 0.00
        : _headerDiscountController.text);
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

        print("1eeee " +
            ExclusiveItemWiseHeaderDisAmnt.toStringAsFixed(2) +
            " totnet " +
            tot_amnt_net.toStringAsFixed(2));
        ExclusiveItemWiseAmount = _TempinquiryProductList[i].Quantity *
            _TempinquiryProductList[i].NetRate;

        print("2eeee " + ExclusiveItemWiseAmount.toStringAsFixed(2));
        ExclusiveNetAmntAfterHeaderDisAmnt =
            ExclusiveItemWiseAmount - ExclusiveItemWiseHeaderDisAmnt;
        print("3eeee " + ExclusiveNetAmntAfterHeaderDisAmnt.toStringAsFixed(2));

        ExclusiveItemWiseTaxAmnt = (ExclusiveNetAmntAfterHeaderDisAmnt *
                _TempinquiryProductList[i].TaxRate) /
            100;

        print("4eeeee " +
            ExclusiveNetAmntAfterHeaderDisAmnt.toStringAsFixed(2) +
            "  " +
            ExclusiveItemWiseTaxAmnt.toStringAsFixed(2));

        ExclusiveFinalNetAmntAfterHeaderDisAmnt =
            ExclusiveNetAmntAfterHeaderDisAmnt;
        ExclusiveTotalNetAmntAfterHeaderDisAmnt =
            ExclusiveItemWiseAmount + ExclusiveItemWiseTaxAmnt;
        print("5eeeee " +
            ExclusiveTotalNetAmntAfterHeaderDisAmnt.toStringAsFixed(2) +
            "  " +
            ExclusiveItemWiseAmount.toStringAsFixed(2));

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

        await OfflineDbHelper.getInstance().insertQuotationProduct(
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
                ExclusiveItemWiseHeaderDisAmnt));
      } else {
        InclusiveItemWiseHeaderDisAmnt =
            (_TempinquiryProductList[i].NetAmount * HeaderDisAmnt) /
                tot_amnt_net;

        print("1eeee " +
            InclusiveItemWiseHeaderDisAmnt.toStringAsFixed(2) +
            " totnet " +
            tot_amnt_net.toStringAsFixed(2));
        InclusiveItemWiseAmount = _TempinquiryProductList[i].Quantity *
            _TempinquiryProductList[i].NetRate;

        print("2eeee " + InclusiveItemWiseAmount.toStringAsFixed(2));
        InclusiveNetAmntAfterHeaderDisAmnt =
            InclusiveItemWiseAmount - InclusiveItemWiseHeaderDisAmnt;

        print("3eeee " + InclusiveNetAmntAfterHeaderDisAmnt.toStringAsFixed(2));

        InclusiveTaxPluse100 = 100 + _TempinquiryProductList[i].TaxRate;
        InclusiveItemWiseTaxAmnt = (InclusiveNetAmntAfterHeaderDisAmnt *
                _TempinquiryProductList[i].TaxRate) /
            InclusiveTaxPluse100;

        print("4eeeee " +
            ExclusiveNetAmntAfterHeaderDisAmnt.toStringAsFixed(2) +
            "  " +
            ExclusiveItemWiseTaxAmnt.toStringAsFixed(2));

        InclusiveFinalNetAmntAfterHeaderDisAmnt =
            InclusiveNetAmntAfterHeaderDisAmnt - InclusiveItemWiseTaxAmnt;

        InclusiveTotalNetAmntAfterHeaderDisAmnt =
            InclusiveNetAmntAfterHeaderDisAmnt; // + InclusiveItemWiseTaxAmnt;

        print("4eeeee " +
            InclusiveTotalNetAmntAfterHeaderDisAmnt.toStringAsFixed(2) +
            "  " +
            InclusiveNetAmntAfterHeaderDisAmnt.toStringAsFixed(2));

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

        await OfflineDbHelper.getInstance().insertQuotationProduct(
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
                InclusiveItemWiseHeaderDisAmnt));
      }
    }
  }

  Future<void> _onTapOfDeleteALLProduct() async {
    await OfflineDbHelper.getInstance().deleteALLQuotationProduct();
  }

  void _OnTaptoSave() async {
    if (_headerDiscountController.text == "") {
      _headerDiscountController.text = "0.00";
    }

    TotalCalculation();
    TotalCalculation2();
    TotalCalculation3();
    TotalCalculation4();
    TotalCalculation5();

    double ChargeAmt1 =
        double.parse(_otherAmount1.text == null ? 0.00 : _otherAmount1.text);
    double ChargeAmt2 =
        double.parse(_otherAmount2.text == null ? 0.00 : _otherAmount2.text);
    double ChargeAmt3 =
        double.parse(_otherAmount3.text == null ? 0.00 : _otherAmount3.text);
    double ChargeAmt4 =
        double.parse(_otherAmount4.text == null ? 0.00 : _otherAmount4.text);
    double ChargeAmt5 =
        double.parse(_otherAmount5.text == null ? 0.00 : _otherAmount5.text);

    double TotalOtherAmnt =
        ChargeAmt1 + ChargeAmt2 + ChargeAmt3 + ChargeAmt4 + ChargeAmt5;

    Tot_BasicAmount = 0.00;
    Tot_otherChargeWithTax = 0.00;
    Tot_GSTAmt = 0.00;
    Tot_otherChargeExcludeTax = 0.00;
    Tot_NetAmt = 0.00;

    await getInquiryProductDetails();

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

    _basicAmountController.text = Tot_BasicAmount.toStringAsFixed(2);
    _otherChargeWithTaxController.text =
        Tot_otherChargeWithTax.toStringAsFixed(2);

    ///Final Setup Befor GST
    _totalGstController.text = Tot_GSTAmt.toStringAsFixed(2);
    _otherChargeExcludeTaxController.text =
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

    _netAmountController.text = MinusHeaderDiscamnt.roundToDouble()
        .toStringAsFixed(2); //MinusHeaderDiscamnt.toStringAsFixed(2);

    double value = MinusHeaderDiscamnt;
    double decimalValue = value - value.toInt();

    _roundOFController.text = decimalValue.toStringAsFixed(2);
  }

  void _ondeleteAllQT_OtherTable(QT_OtherChargeDeleteResponseState state) {
    print("sucess" + state.response.toString());
  }

  void _onInsertAllQT_OtherTable(QT_OtherChargeInsertResponseState state) {
    print("sucess123" + state.response.toString());
  }
}
