part of 'salesorder_bloc.dart';

abstract class SalesOrderStates extends BaseStates {
  const SalesOrderStates();
}

///all states of AuthenticationStates
class SalesOrderInitialState extends SalesOrderStates {}

class SalesOrderListCallResponseState extends SalesOrderStates {
  final SalesOrderListResponse response;
  final int newPage;
  SalesOrderListCallResponseState(this.response, this.newPage);
}

class SearchSalesOrderListByNameCallResponseState extends SalesOrderStates {
  final SearchSalesOrderListResponse response;

  SearchSalesOrderListByNameCallResponseState(this.response);
}

class SearchSalesOrderListByNumberCallResponseState extends SalesOrderStates {
  final SalesOrderListResponse response;

  SearchSalesOrderListByNumberCallResponseState(this.response);
}

class SalesOrderPDFGenerateResponseState extends SalesOrderStates {
  final SalesOrderPDFGenerateResponse response;

  SalesOrderPDFGenerateResponseState(this.response);
}

class BankDetailsListResponseState extends SalesOrderStates {
  final BankDetailsListResponse response;

  BankDetailsListResponseState(this.response);
}

class QuotationProjectListResponseState extends SalesOrderStates {
  final QuotationProjectListResponse response;

  QuotationProjectListResponseState(this.response);
}

class QuotationTermsCondtionResponseState extends SalesOrderStates {
  final QuotationTermsCondtionResponse response;

  QuotationTermsCondtionResponseState(this.response);
}

class SearchCustomerListByNumberCallResponseState extends SalesOrderStates {
  final CustomerDetailsResponse response;

  SearchCustomerListByNumberCallResponseState(this.response);
}

class SalesBill_INQ_QT_SO_NO_ListResponseState extends SalesOrderStates {
  final SalesBill_INQ_QT_SO_NO_ListResponse response;
  SalesBill_INQ_QT_SO_NO_ListResponseState(this.response);
}

class MultiNoToProductDetailsResponseState extends SalesOrderStates {
  final MultiNoToProductDetailsResponse response;
  MultiNoToProductDetailsResponseState(this.response);
}

class SaleBillEmailContentResponseState extends SalesOrderStates {
  final SaleBillEmailContentResponse response;

  SaleBillEmailContentResponseState(this.response);
}

//MultiNoToProductDetailsResponse
class FCMNotificationResponseState extends SalesOrderStates {
  final FCMNotificationResponse response;

  FCMNotificationResponseState(this.response);
}

class PaymentScheduleResponseState extends SalesOrderStates {
  final String response;

  PaymentScheduleResponseState(this.response);
}

class PaymentScheduleListResponseState extends SalesOrderStates {
  final List<SoPaymentScheduleTable> response;

  PaymentScheduleListResponseState(this.response);
}

class PaymentScheduleDeleteResponseState extends SalesOrderStates {
  final String response;

  PaymentScheduleDeleteResponseState(this.response);
}

class PaymentScheduleEditResponseState extends SalesOrderStates {
  final String response;

  PaymentScheduleEditResponseState(this.response);
}

class PaymentScheduleDeleteAllResponseState extends SalesOrderStates {
  final String response;

  PaymentScheduleDeleteAllResponseState(this.response);
}
