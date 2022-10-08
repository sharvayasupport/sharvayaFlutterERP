import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soleoserp/blocs/base/base_bloc.dart';
import 'package:soleoserp/models/api_requests/bank_voucher/bank_drop_down_request.dart';
import 'package:soleoserp/models/api_requests/customer/cust_id_inq_list_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_label_value_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_search_by_id_request.dart';
import 'package:soleoserp/models/api_requests/inquiry/inquiry_no_to_product_list_request.dart';
import 'package:soleoserp/models/api_requests/inquiry/inquiry_product_search_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_delete_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_header_save_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_kind_att_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_no_to_product_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_other_charge_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_pdf_generate_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_product_delete_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_project_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_terms_condition_request.dart';
import 'package:soleoserp/models/api_requests/search_quotation_list_by_name_request.dart';
import 'package:soleoserp/models/api_requests/search_quotation_list_by_number_request.dart';
import 'package:soleoserp/models/api_requests/specification_list_request.dart';
import 'package:soleoserp/models/api_responses/bank_drop_down_response.dart';
import 'package:soleoserp/models/api_responses/cust_id_to_inq_list_response.dart';
import 'package:soleoserp/models/api_responses/customer_details_api_response.dart';
import 'package:soleoserp/models/api_responses/customer_label_value_response.dart';
import 'package:soleoserp/models/api_responses/inq_no_to_product_list_response.dart';
import 'package:soleoserp/models/api_responses/inquiry_product_search_response.dart';
import 'package:soleoserp/models/api_responses/quotation_delete_response.dart';
import 'package:soleoserp/models/api_responses/quotation_header_save_response.dart';
import 'package:soleoserp/models/api_responses/quotation_kind_att_list_response.dart';
import 'package:soleoserp/models/api_responses/quotation_list_response.dart';
import 'package:soleoserp/models/api_responses/quotation_no_to_product_list_response.dart';
import 'package:soleoserp/models/api_responses/quotation_other_charges_list_response.dart';
import 'package:soleoserp/models/api_responses/quotation_pdf_generate_response.dart';
import 'package:soleoserp/models/api_responses/quotation_product_delete_response.dart';
import 'package:soleoserp/models/api_responses/quotation_product_save_response.dart';
import 'package:soleoserp/models/api_responses/quotation_project_list_response.dart';
import 'package:soleoserp/models/api_responses/quotation_terms_condition_response.dart';
import 'package:soleoserp/models/api_responses/search_quotation_list_response.dart';
import 'package:soleoserp/models/api_responses/specification_list_response.dart';
import 'package:soleoserp/models/common/other_charge_table.dart';
import 'package:soleoserp/models/common/quotationtable.dart';
import 'package:soleoserp/models/pushnotification/fcm_notification_response.dart';
import 'package:soleoserp/models/pushnotification/get_report_to_token_request.dart';
import 'package:soleoserp/models/pushnotification/get_report_to_token_response.dart';
import 'package:soleoserp/repositories/repository.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';

part 'quotation_events.dart';
part 'quotation_states.dart';

class QuotationBloc extends Bloc<QuotationEvents, QuotationStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  QuotationBloc(this.baseBloc) : super(QuotationInitialState());

  @override
  Stream<QuotationStates> mapEventToState(QuotationEvents event) async* {
    /// sets state based on events
    if (event is QuotationListCallEvent) {
      yield* _mapQuotationListCallEventToState(event);
    }
    if (event is SearchQuotationListByNameCallEvent) {
      yield* _mapSearchQuotationListByNameCallEventToState(event);
    }
    if (event is SearchQuotationListByNumberCallEvent) {
      yield* _mapSearchQuotationListByNumberCallEventToState(event);
    }

    if (event is QuotationPDFGenerateCallEvent) {
      yield* _mapQuotationPDFGenerateCallEventToState(event);
    }

    if (event is SearchQuotationCustomerListByNameCallEvent) {
      yield* _mapCustomerListByNameCallEventToState(event);
    }
    if (event is QuotationNoToProductListCallEvent) {
      yield* _mapQuotationNoToProductListCallEventToState(event);
    }

    if (event is QuotationSpecificationCallEvent) {
      yield* _mapSpecificationListCallEventToState(event);
    }

    if (event is QuotationKindAttListCallEvent) {
      yield* _mapQuotationKindAttListCallEventToState(event);
    }
    if (event is QuotationProjectListCallEvent) {
      yield* _mapQuotationProjectListCallEventToState(event);
    }

    if (event is QuotationTermsConditionCallEvent) {
      yield* _mapQuotationTermsConditionEventToState(event);
    }

    if (event is CustIdToInqListCallEvent) {
      yield* _mapCustIdToInqListEventToState(event);
    }

    if (event is InqNoToProductListCallEvent) {
      yield* _mapInqNoToProductListEventToState(event);
    }

    if (event is InquiryProductSearchNameWithStateCodeCallEvent) {
      yield* _mapInquiryProductSearchCallEventToState(event);
    }

    if (event is QuotationHeaderSaveCallEvent) {
      yield* _mapQuotationHeaderSaveEventToState(event);
    }

    if (event is QuotationProductSaveCallEvent) {
      yield* _mapQuotationProductSaveEventToState(event);
    }

    if (event is QuotationDeleteProductCallEvent) {
      yield* _mapqtNoToDeleteProductEventToState(event);
    }

    if (event is QuotationDeleteRequestCallEvent) {
      yield* _mapDeleteQuotationCallEventToState(event);
    }

    if (event is QuotationOtherChargeCallEvent) {
      yield* _mapQuotationOtherChargeListEventToState(event);
    }
    if (event is QuotationBankDropDownCallEvent) {
      yield* _mapBankDropDownEventToState(event);
    }

    if (event is SearchCustomerListByNumberCallEvent) {
      yield* _mapSearchCustomerListByNumberCallEventToState(event);
    }

    if (event is FCMNotificationRequestEvent) {
      yield* _map_fcm_notificationEvent_state(event);
    }

    if (event is GetReportToTokenRequestEvent) {
      yield* _map_GetReportToTokenRequestEventState(event);
    }

    if (event is QT_OtherChargeDeleteRequestEvent) {
      yield* _map_QTOtherChargeDeleteEventState(event);
    }
    if (event is QT_OtherChargeInsertRequestEvent) {
      yield* _map_QTOtherChargeInsertEventState(event);
    }
  }

  ///event functions to states implementation
  Stream<QuotationStates> _mapQuotationListCallEventToState(
      QuotationListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationListResponse response = await userRepository.getQuotationList(
          event.pageNo, event.quotationListApiRequest);
      yield QuotationListCallResponseState(response, event.pageNo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapSearchQuotationListByNumberCallEventToState(
      SearchQuotationListByNumberCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationListResponse response = await userRepository
          .getQuotationListSearchByNumber(event.pkID, event.request);
      yield SearchQuotationListByNumberCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapSearchQuotationListByNameCallEventToState(
      SearchQuotationListByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SearchQuotationListResponse response =
          await userRepository.getQuotationListSearchByName(event.request);
      yield SearchQuotationListByNameCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapQuotationPDFGenerateCallEventToState(
      QuotationPDFGenerateCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationPDFGenerateResponse response =
          await userRepository.getQuotationPDFGenerate(event.request);
      yield QuotationPDFGenerateResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapCustomerListByNameCallEventToState(
      SearchQuotationCustomerListByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CustomerLabelvalueRsponse response =
          await userRepository.getCustomerListSearchByName(event.request);
      yield QuotationCustomerListByNameCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapQuotationNoToProductListCallEventToState(
      QuotationNoToProductListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationNoToProductResponse response =
          await userRepository.getQTNotoProductList(event.request);
      yield QuotationNoToProductListCallResponseState(
          event.StateCode, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapSpecificationListCallEventToState(
      QuotationSpecificationCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SpecificationListResponse response =
          await userRepository.getProductSpecificationList(event.request);
      yield SpecificationListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapQuotationKindAttListCallEventToState(
      QuotationKindAttListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationKindAttListResponse response =
          await userRepository.getQuotationKindAttList(event.request);
      yield QuotationKindAttListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapQuotationProjectListCallEventToState(
      QuotationProjectListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationProjectListResponse response =
          await userRepository.getQuotationProjectList(event.request);
      yield QuotationProjectListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapQuotationTermsConditionEventToState(
      QuotationTermsConditionCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationTermsCondtionResponse response =
          await userRepository.getQuotationTermConditionList(event.request);
      yield QuotationTermsCondtionResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapCustIdToInqListEventToState(
      CustIdToInqListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CustIdToInqListResponse response =
          await userRepository.getCustIdToInqList(event.request);
      yield CustIdToInqListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapInqNoToProductListEventToState(
      InqNoToProductListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      InqNoToProductListResponse response =
          await userRepository.getInqNoProductList(event.request);
      yield InqNoToProductListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapInquiryProductSearchCallEventToState(
      InquiryProductSearchNameWithStateCodeCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      InquiryProductSearchResponse response = await userRepository
          .getInquiryProductSearchList(event.inquiryProductSearchRequest);
      yield InquiryProductSearchByStateCodeResponseState(event.ProductID,
          event.ProductName, event.Quantity, event.UnitRate, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapQuotationHeaderSaveEventToState(
      QuotationHeaderSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationSaveHeaderResponse response = await userRepository
          .getQuotationHeaderSaveResponse(event.pkID, event.request);
      yield QuotationHeaderSaveResponseState(
          event.context, event.pkID, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapQuotationProductSaveEventToState(
      QuotationProductSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      QuotationProductSaveResponse respo =
          await userRepository.quotationProductSaveDetails(
              event.QT_No, event.quotationProductModel);
      yield QuotationProductSaveResponseState(event.context, respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapqtNoToDeleteProductEventToState(
      QuotationDeleteProductCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationProductDeleteResponse response = await userRepository
          .getQtNoToDeleteProductList(event.qt_No, event.request);
      yield QuotationProductDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapDeleteQuotationCallEventToState(
      QuotationDeleteRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationDeleteResponse inquiryDeleteResponse = await userRepository
          .deleteQuotation(event.pkID, event.quotationDeleteRequest);
      yield QuotationDeleteCallResponseState(
          event.context, inquiryDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapQuotationOtherChargeListEventToState(
      QuotationOtherChargeCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationOtherChargesListResponse quotationOtherChargesListResponse =
          await userRepository.getQuotationOtherChargeList(
              event.CompanyID, event.request);
      yield QuotationOtherChargeListResponseState(
          quotationOtherChargesListResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapBankDropDownEventToState(
      QuotationBankDropDownCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      BankDorpDownResponse response =
          await userRepository.getBankDropDown(event.request);
      yield QuotationBankDropDownResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapSearchCustomerListByNumberCallEventToState(
      SearchCustomerListByNumberCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CustomerDetailsResponse response =
          await userRepository.getCustomerListSearchByNumber(event.request);
      yield SearchCustomerListByNumberCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _map_fcm_notificationEvent_state(
      FCMNotificationRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      FCMNotificationResponse response =
          await userRepository.fcm_get_api(event.request123);
      yield FCMNotificationResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _map_GetReportToTokenRequestEventState(
      GetReportToTokenRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      GetReportToTokenResponse response =
          await userRepository.getreporttoTokenAPI(event.request);
      yield GetReportToTokenResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _map_QTOtherChargeDeleteEventState(
      QT_OtherChargeDeleteRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().deleteALLQuotationOtherCharge();

      yield QT_OtherChargeDeleteResponseState("deleted SucessFully");
      //yield QT_OtherChargeDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _map_QTOtherChargeInsertEventState(
      QT_OtherChargeInsertRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance()
          .insertQuotationOtherCharge(QT_OtherChargeTable(
        event.qt_otherChargeTable.Headerdiscount,
        event.qt_otherChargeTable.Tot_BasicAmt,
        event.qt_otherChargeTable.OtherChargeWithTaxamt,
        event.qt_otherChargeTable.Tot_GstAmt,
        event.qt_otherChargeTable.OtherChargeExcludeTaxamt,
        event.qt_otherChargeTable.Tot_NetAmount,
        event.qt_otherChargeTable.ChargeID1,
        event.qt_otherChargeTable.ChargeAmt1,
        event.qt_otherChargeTable.ChargeBasicAmt1,
        event.qt_otherChargeTable.ChargeGSTAmt1,
        event.qt_otherChargeTable.ChargeID2,
        event.qt_otherChargeTable.ChargeAmt2,
        event.qt_otherChargeTable.ChargeBasicAmt2,
        event.qt_otherChargeTable.ChargeGSTAmt2,
        event.qt_otherChargeTable.ChargeID3,
        event.qt_otherChargeTable.ChargeAmt3,
        event.qt_otherChargeTable.ChargeBasicAmt3,
        event.qt_otherChargeTable.ChargeGSTAmt3,
        event.qt_otherChargeTable.ChargeID4,
        event.qt_otherChargeTable.ChargeAmt4,
        event.qt_otherChargeTable.ChargeBasicAmt4,
        event.qt_otherChargeTable.ChargeGSTAmt4,
        event.qt_otherChargeTable.ChargeID5,
        event.qt_otherChargeTable.ChargeAmt5,
        event.qt_otherChargeTable.ChargeBasicAmt5,
        event.qt_otherChargeTable.ChargeGSTAmt5,
      ));

      yield QT_OtherChargeInsertResponseState("Inserted Successfully");
      //yield QT_OtherChargeDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
}
