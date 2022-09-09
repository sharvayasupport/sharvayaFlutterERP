part of 'salesorder_bloc.dart';

@immutable
abstract class SalesOrderEvents {}

///all events of AuthenticationEvents
class SalesOrderListCallEvent extends SalesOrderEvents {
  final int pageNo;
  final SalesOrderListApiRequest salesOrderListApiRequest;
  SalesOrderListCallEvent(this.pageNo, this.salesOrderListApiRequest);
}

class SearchSalesOrderListByNameCallEvent extends SalesOrderEvents {
  final SearchSalesOrderListByNameRequest request;

  SearchSalesOrderListByNameCallEvent(this.request);
}

class SearchSalesOrderListByNumberCallEvent extends SalesOrderEvents {
  final int pkID;
  final SearchSalesOrderListByNumberRequest request;

  SearchSalesOrderListByNumberCallEvent(this.pkID, this.request);
}

class SalesOrderPDFGenerateCallEvent extends SalesOrderEvents {
  final SalesOrderPDFGenerateRequest request;

  SalesOrderPDFGenerateCallEvent(this.request);
}

class SaleOrderBankDetailsListRequestEvent extends SalesOrderEvents {
  final SaleOrderBankDetailsListRequest request;

  SaleOrderBankDetailsListRequestEvent(this.request);
}

class QuotationProjectListCallEvent extends SalesOrderEvents {
  final QuotationProjectListRequest request;

  QuotationProjectListCallEvent(this.request);
}

class QuotationTermsConditionCallEvent extends SalesOrderEvents {
  final QuotationTermsConditionRequest request;

  QuotationTermsConditionCallEvent(this.request);
}

class SearchCustomerListByNumberCallEvent extends SalesOrderEvents {
  final CustomerSearchByIdRequest request;

  SearchCustomerListByNumberCallEvent(this.request);
}

class SaleBill_INQ_QT_SO_NO_ListRequestEvent extends SalesOrderEvents {
  final SaleBill_INQ_QT_SO_NO_ListRequest request;
  SaleBill_INQ_QT_SO_NO_ListRequestEvent(this.request);
}

class MultiNoToProductDetailsRequestEvent extends SalesOrderEvents {
  final MultiNoToProductDetailsRequest request;
  MultiNoToProductDetailsRequestEvent(this.request);
}

class SalesBillEmailContentRequestEvent extends SalesOrderEvents {
  final SalesBillEmailContentRequest request;
  SalesBillEmailContentRequestEvent(this.request);
}

//MultiNoToProductDetailsRequest
class FCMNotificationRequestEvent extends SalesOrderEvents {
  //final FCMNotificationRequest request;
  var request123;
  FCMNotificationRequestEvent(this.request123);
}

class PaymentScheduleEvent extends SalesOrderEvents {
  //final FCMNotificationRequest request;
  SoPaymentScheduleTable soPaymentScheduleTable;
  PaymentScheduleEvent(this.soPaymentScheduleTable);
}

class PaymentScheduleListEvent extends SalesOrderEvents {
  //final FCMNotificationRequest request;
  PaymentScheduleListEvent();
}

class PaymentScheduleDeleteEvent extends SalesOrderEvents {
  //final FCMNotificationRequest request;

  int id;
  PaymentScheduleDeleteEvent(this.id);
}
class PaymentScheduleEditEvent extends SalesOrderEvents {
  //final FCMNotificationRequest request;
  SoPaymentScheduleTable soPaymentScheduleTable;
  PaymentScheduleEditEvent(this.soPaymentScheduleTable);
}

class PaymentScheduleDeleteAllItemEvent extends SalesOrderEvents {
  //final FCMNotificationRequest request;
  PaymentScheduleDeleteAllItemEvent();
}