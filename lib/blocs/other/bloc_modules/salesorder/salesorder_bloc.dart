import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soleoserp/blocs/base/base_bloc.dart';
import 'package:soleoserp/models/api_requests/SalesBill/sale_bill_email_content_request.dart';
import 'package:soleoserp/models/api_requests/SalesBill/sales_bill_inq_QT_SO_NO_list_Request.dart';
import 'package:soleoserp/models/api_requests/SalesOrder/bank_details_list_request.dart';
import 'package:soleoserp/models/api_requests/SalesOrder/multi_no_to_product_details_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_search_by_id_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_project_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_terms_condition_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder/sale_order_header_save_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder/sale_order_product_save_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder/sales_order_all_product_delete_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder/sales_order_generate_pdf_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder/salesorder_list_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder/search_salesorder_list_by_name_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder/search_salesorder_list_by_number_request.dart';
import 'package:soleoserp/models/api_responses/SaleBill/sale_bill_email_content_response.dart';
import 'package:soleoserp/models/api_responses/SaleBill/sales_bill_INQ_QT_SO_NO_list_response.dart';
import 'package:soleoserp/models/api_responses/SaleOrder/bank_details_list_response.dart';
import 'package:soleoserp/models/api_responses/SaleOrder/multi_no_to_product_details_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_details_api_response.dart';
import 'package:soleoserp/models/api_responses/quotation/quotation_project_list_response.dart';
import 'package:soleoserp/models/api_responses/quotation/quotation_terms_condition_response.dart';
import 'package:soleoserp/models/api_responses/saleOrder/salesOrder_Product_Save_response.dart';
import 'package:soleoserp/models/api_responses/saleOrder/sales_order_header_save_response.dart';
import 'package:soleoserp/models/api_responses/saleOrder/sales_order_pdf_generate_pdf_response.dart';
import 'package:soleoserp/models/api_responses/saleOrder/sales_order_product_delete_response.dart';
import 'package:soleoserp/models/api_responses/saleOrder/salesorder_list_response.dart';
import 'package:soleoserp/models/api_responses/saleOrder/search_salesorder_list_response.dart';
import 'package:soleoserp/models/pushnotification/fcm_notification_response.dart';
import 'package:soleoserp/repositories/repository.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
import 'package:soleoserp/utils/sales_order_payment_schedule.dart';

part 'salesorder_events.dart';
part 'salesorder_states.dart';

class SalesOrderBloc extends Bloc<SalesOrderEvents, SalesOrderStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  SalesOrderBloc(this.baseBloc) : super(SalesOrderInitialState());

  @override
  Stream<SalesOrderStates> mapEventToState(SalesOrderEvents event) async* {
    /// sets state based on events
    if (event is SalesOrderListCallEvent) {
      yield* _mapSalesOrderListCallEventToState(event);
    }
    if (event is SearchSalesOrderListByNameCallEvent) {
      yield* _mapSearchSalesOrderListByNameCallEventToState(event);
    }
    if (event is SearchSalesOrderListByNumberCallEvent) {
      yield* _mapSearchSalesOrderListByNumberCallEventToState(event);
    }

    if (event is SalesOrderPDFGenerateCallEvent) {
      yield* _mapSalesOrderPDFGenerateCallEventToState(event);
    }

    if (event is SaleOrderBankDetailsListRequestEvent) {
      yield* _map_bankDetailsEvent_state(event);
    }

    if (event is QuotationProjectListCallEvent) {
      yield* _mapQuotationProjectListCallEventToState(event);
    }

    if (event is QuotationTermsConditionCallEvent) {
      yield* _mapQuotationTermsConditionEventToState(event);
    }
    if (event is SearchCustomerListByNumberCallEvent) {
      yield* _mapSearchCustomerListByNumberCallEventToState(event);
    }
    if (event is SaleBill_INQ_QT_SO_NO_ListRequestEvent) {
      yield* _mapSaleBill_INQ_QT_SO_NO_ListEventState(event);
    }

    if (event is MultiNoToProductDetailsRequestEvent) {
      yield* _mapMultiNoToProductDetailsRequestEventState(event);
    }
    if (event is SalesBillEmailContentRequestEvent) {
      yield* _mapSalesBillEmailContentEventState(event);
    }

    if (event is FCMNotificationRequestEvent) {
      yield* _map_fcm_notificationEvent_state(event);
    }
    if (event is PaymentScheduleEvent) {
      yield* _mapPaymentScheduleEventState(event);
    }
    if (event is PaymentScheduleListEvent) {
      yield* _mapPaymentScheduleListEventState(event);
    }
    if (event is PaymentScheduleDeleteEvent) {
      yield* _mapPaymentScheduleDeleteEventState(event);
    }
    if (event is PaymentScheduleEditEvent) {
      yield* _mapPaymentScheduleEditEventState(event);
    }
    if (event is PaymentScheduleDeleteAllItemEvent) {
      yield* _mapPaymentScheduleDeleteAllEventState(event);
    }

    if (event is SaleOrderHeaderSaveRequestEvent) {
      yield* _mapSaleOrderHeaderSaveRequestEventState(event);
    }
    if (event is SaleOrderProductSaveCallEvent) {
      yield* _mapSaleOrderProductSaveCallEventState(event);
    }

    if (event is SalesOrderProductDeleteRequestEvent) {
      yield* _mapSalesOrderProductDeleteRequestEventState(event);
    }
  }

  ///event functions to states implementation
  Stream<SalesOrderStates> _mapSalesOrderListCallEventToState(
      SalesOrderListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SalesOrderListResponse response = await userRepository.getSalesOrderList(
          event.pageNo, event.salesOrderListApiRequest);
      yield SalesOrderListCallResponseState(response, event.pageNo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapSearchSalesOrderListByNumberCallEventToState(
      SearchSalesOrderListByNumberCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SalesOrderListResponse response = await userRepository
          .getSalesOrderListSearchByNumber(event.pkID, event.request);
      yield SearchSalesOrderListByNumberCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapSearchSalesOrderListByNameCallEventToState(
      SearchSalesOrderListByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SearchSalesOrderListResponse response =
          await userRepository.getSalesOrderListSearchByName(event.request);
      yield SearchSalesOrderListByNameCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapSalesOrderPDFGenerateCallEventToState(
      SalesOrderPDFGenerateCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SalesOrderPDFGenerateResponse response =
          await userRepository.getSalesOrderPDFGenerate(event.request);
      yield SalesOrderPDFGenerateResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _map_bankDetailsEvent_state(
      SaleOrderBankDetailsListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      BankDetailsListResponse response =
          await userRepository.getBankDetailsAPI(event.request);
      yield BankDetailsListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapQuotationProjectListCallEventToState(
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

  Stream<SalesOrderStates> _mapQuotationTermsConditionEventToState(
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

  Stream<SalesOrderStates> _mapSearchCustomerListByNumberCallEventToState(
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

  Stream<SalesOrderStates> _mapSaleBill_INQ_QT_SO_NO_ListEventState(
      SaleBill_INQ_QT_SO_NO_ListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SalesBill_INQ_QT_SO_NO_ListResponse response =
          await userRepository.getINQ_QT_SO_NO_API(event.request);
      yield SalesBill_INQ_QT_SO_NO_ListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapMultiNoToProductDetailsRequestEventState(
      MultiNoToProductDetailsRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      MultiNoToProductDetailsResponse response =
          await userRepository.getProductDetailsFrom_No(event.request);
      yield MultiNoToProductDetailsResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapSalesBillEmailContentEventState(
      SalesBillEmailContentRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SaleBillEmailContentResponse response =
          await userRepository.getEmailContentAPI(event.request);
      yield SaleBillEmailContentResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _map_fcm_notificationEvent_state(
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

  Stream<SalesOrderStates> _mapPaymentScheduleEventState(
      PaymentScheduleEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().insertPaymentScheduleItems(
          SoPaymentScheduleTable(
              event.soPaymentScheduleTable.amount,
              event.soPaymentScheduleTable.dueDate,
              event.soPaymentScheduleTable.revdueDate));
      // await userRepository.getQuotationTermConditionList(event.all_name_id.Name,event.all_name_id.PresentDate);
      yield PaymentScheduleResponseState("Added Successfully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapPaymentScheduleListEventState(
      PaymentScheduleListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      List<SoPaymentScheduleTable> response =
          await OfflineDbHelper.getInstance().getPaymentScheduleItems();
      // await userRepository.getQuotationTermConditionList(event.all_name_id.Name,event.all_name_id.PresentDate);
      yield PaymentScheduleListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapPaymentScheduleDeleteEventState(
      PaymentScheduleDeleteEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().deletePaymentScheduleItem(event.id);

      // await userRepository.getQuotationTermConditionList(event.all_name_id.Name,event.all_name_id.PresentDate);
      yield PaymentScheduleDeleteResponseState("Deleted Successfully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapPaymentScheduleEditEventState(
      PaymentScheduleEditEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance()
          .updatePaymentScheduleItems(event.soPaymentScheduleTable);

      // await userRepository.getQuotationTermConditionList(event.all_name_id.Name,event.all_name_id.PresentDate);
      yield PaymentScheduleEditResponseState("Updated Successfully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapPaymentScheduleDeleteAllEventState(
      PaymentScheduleDeleteAllItemEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().deleteAllPaymentScheduleItems();

      // await userRepository.getQuotationTermConditionList(event.all_name_id.Name,event.all_name_id.PresentDate);
      yield PaymentScheduleDeleteAllResponseState(
          "Deleted All Item in Table Successfully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapSaleOrderHeaderSaveRequestEventState(
      SaleOrderHeaderSaveRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SaleOrderHeaderSaveResponse response =
          await userRepository.getSalesOrderHeaderSaveAPI(
              event.pkID, event.saleOrderHeaderSaveRequest);
      yield SaleOrderHeaderSaveResponseState(
          event.context, event.pkID, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapSaleOrderProductSaveCallEventState(
      SaleOrderProductSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      print("dlddd" + event.arrSalesOrderProductList.length.toString());
      SaleOrderProductSaveResponse response = await userRepository
          .salesOrderProductSaveDetails(event.arrSalesOrderProductList);
      yield SaleOrderProductSaveResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapSalesOrderProductDeleteRequestEventState(
      SalesOrderProductDeleteRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SaleOrderProductDeleteResponse response =
          await userRepository.saleorder_productDelete(
              event.pkID, event.SalesOrderProductDeleteRequest);
      yield SaleOrderProductDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  //SalesOrderProductDeleteRequestEvent
}
