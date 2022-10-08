import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soleoserp/blocs/base/base_bloc.dart';
import 'package:soleoserp/models/api_requests/Accurabath_complaint/accurabath_complaint_image_upload_request.dart';
import 'package:soleoserp/models/api_requests/Accurabath_complaint/accurabath_complaint_list_request.dart';
import 'package:soleoserp/models/api_requests/Accurabath_complaint/accurabath_complaint_no_to_delete_image_video_request.dart';
import 'package:soleoserp/models/api_requests/Accurabath_complaint/accurabath_complaint_save_request.dart';
import 'package:soleoserp/models/api_requests/Accurabath_complaint/accurabath_emp_follower_list_request.dart';
import 'package:soleoserp/models/api_requests/Accurabath_complaint/fetch_accurabath_complaint_image_list_request.dart';
import 'package:soleoserp/models/api_requests/complaint/complaint_delete_request.dart';
import 'package:soleoserp/models/api_requests/complaint/complaint_list_request.dart';
import 'package:soleoserp/models/api_requests/complaint/complaint_save_request.dart';
import 'package:soleoserp/models/api_requests/complaint/complaint_search_by_Id_request.dart';
import 'package:soleoserp/models/api_requests/complaint/complaint_search_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_label_value_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_source_list_request.dart';
import 'package:soleoserp/models/api_requests/other/city_list_request.dart';
import 'package:soleoserp/models/api_requests/other/country_list_request.dart';
import 'package:soleoserp/models/api_requests/state_list_request.dart';
import 'package:soleoserp/models/api_requests/transection_mode_list_request.dart';
import 'package:soleoserp/models/api_responses/Accurabath_complaint/accurabath_complaint_list_response.dart';
import 'package:soleoserp/models/api_responses/Accurabath_complaint/accurabath_complaint_no_to_delete_image_video_response.dart';
import 'package:soleoserp/models/api_responses/Accurabath_complaint/accurabath_complaint_save_response.dart';
import 'package:soleoserp/models/api_responses/Accurabath_complaint/accurabath_emp_list_response.dart';
import 'package:soleoserp/models/api_responses/Accurabath_complaint/accurabth_complaint_upload_image_response.dart';
import 'package:soleoserp/models/api_responses/Accurabath_complaint/complaint_image_list_response.dart';
import 'package:soleoserp/models/api_responses/city_api_response.dart';
import 'package:soleoserp/models/api_responses/complaint_delete_response.dart';
import 'package:soleoserp/models/api_responses/complaint_list_response.dart';
import 'package:soleoserp/models/api_responses/complaint_save_response.dart';
import 'package:soleoserp/models/api_responses/complaint_search_response.dart';
import 'package:soleoserp/models/api_responses/country_list_response.dart';
import 'package:soleoserp/models/api_responses/customer_label_value_response.dart';
import 'package:soleoserp/models/api_responses/customer_source_response.dart';
import 'package:soleoserp/models/api_responses/state_list_response.dart';
import 'package:soleoserp/repositories/repository.dart';

part 'complaint_event.dart';
part 'complaint_state.dart';

class ComplaintScreenBloc
    extends Bloc<ComplaintScreenEvents, ComplaintScreenStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  ComplaintScreenBloc(this.baseBloc) : super(ComplaintScreenInitialState());

  @override
  Stream<ComplaintScreenStates> mapEventToState(
      ComplaintScreenEvents event) async* {
    if (event is ComplaintListCallEvent) {
      yield* _mapComplaintListCallEventToState(event);
    }
    if (event is ComplaintSearchByNameCallEvent) {
      yield* _mapSearchByNameCallEventToState(event);
    }
    if (event is ComplaintSearchByIDCallEvent) {
      yield* _mapSearchByIDCallEventToState(event);
    }
    if (event is ComplaintDeleteCallEvent) {
      yield* _mapDeleteCallEventToState(event);
    }

    if (event is SearchFollowupCustomerListByNameCallEvent) {
      yield* _mapFollowupCustomerListByNameCallEventToState(event);
    }
    if (event is CustomerSourceCallEvent) {
      yield* _mapCustomerSourceCallEventToState(event);
    }
    if (event is ComplaintSaveCallEvent) {
      yield* _mapSaveCallEventToState(event);
    }

    if (event is AccuraBathComplaintListRequestEvent) {
      yield* _mapAccurabathComplaintListCallEventToState(event);
    }
    if (event is FetchAccuraBathComplaintImageListRequestEvent) {
      yield* _mapAccuraBathFetchComplaintImageListCallEventToState(event);
    }

    if (event is AccuraBathComplaintEmpFollowerListRequestEvent) {
      yield* _mapAccuraBathComplaintEmpFollowerListEventState(event);
    }

    if (event is AccuraBathComplaintSaveRequestEvent) {
      yield* _mapAccuraBathSaveCallEventToState(event);
    }

    if (event is AccuraBathComplaintNoToDeleteImageVideoRequestEvent) {
      yield* _MapAccuraBathComplaintNoToDeleteImageVideo(event);
    }

    if (event is AccuraBathComplaintUploadImageAPIRequestEvent) {
      yield* _mapAccuraBathComplaintUploadImageCallEventToState(event);
    }

    if (event is CountryCallEvent) {
      yield* _mapCountryListCallEventToState(event);
    }
    if (event is StateCallEvent) {
      yield* _mapStateListCallEventToState(event);
    }
    if (event is CityCallEvent) {
      yield* _mapCityListCallEventToState(event);
    }
  }

  Stream<ComplaintScreenStates> _mapComplaintListCallEventToState(
      ComplaintListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ComplaintListResponse response = await userRepository.getComplaintList(
          event.pageNo, event.complaintListRequest);
      yield ComplaintListResponseState(event.pageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates> _mapSearchByNameCallEventToState(
      ComplaintSearchByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ComplaintSearchResponse response = await userRepository
          .getComplaintSearchByName(event.complaintSearchRequest);
      yield ComplaintSearchByNameResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates> _mapSearchByIDCallEventToState(
      ComplaintSearchByIDCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ComplaintListResponse response = await userRepository
          .getComplaintSearchByID(event.pkID, event.complaintSearchByIDRequest);
      yield ComplaintSearchByIDResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates> _mapDeleteCallEventToState(
      ComplaintDeleteCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ComplaintDeleteResponse response =
          await userRepository.DeleteComplaintBypkID(
              event.pkID, event.complaintDeleteRequest);
      yield ComplaintDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates> _mapFollowupCustomerListByNameCallEventToState(
      SearchFollowupCustomerListByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CustomerLabelvalueRsponse response =
          await userRepository.getCustomerListSearchByName(event.request);
      yield FollowupCustomerListByNameCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates> _mapCustomerSourceCallEventToState(
      CustomerSourceCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      CustomerSourceResponse respo =
          await userRepository.customer_Source_List_call(event.request1);
      yield CustomerSourceCallEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates> _mapSaveCallEventToState(
      ComplaintSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ComplaintSaveResponse response = await userRepository.getComplaintSave(
          event.pkID, event.complaintSaveRequest);
      yield ComplaintSaveResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates> _mapAccurabathComplaintListCallEventToState(
      AccuraBathComplaintListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      AccuraBathComplaintListResponse response =
          await userRepository.getAccurabathComplaintList(
              event.pageNo, event.accuraBathComplaintListRequest);
      yield AccuraBathComplaintListResponseState(event.pageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates>
      _mapAccuraBathFetchComplaintImageListCallEventToState(
          FetchAccuraBathComplaintImageListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      FetchAccuraBathComplaintImageListResponse respo =
          await userRepository.AccuraBathComplaintImage_list_details(
              event.fetchAccuraBathComplaintImageListRequest);
      yield FetchAccuraBathComplaintImageListResponseState(
          respo, event.accuraBathComplaintListResponseDetails);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates>
      _mapAccuraBathComplaintEmpFollowerListEventState(
          AccuraBathComplaintEmpFollowerListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      AccuraBathComplaintEmpFollowerListResponse respo =
          await userRepository.getComplaintEmployeeFollowerAPI(
              event.complaintEmpFollowerListRequest);
      yield AccuraBathComplaintEmpFollowerListResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates> _mapAccuraBathSaveCallEventToState(
      AccuraBathComplaintSaveRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      AccuraBathComplaintSaveResponse response = await userRepository
          .getAccuraBathComplaintSave(event.pkID, event.complaintSaveRequest);
      yield AccuraBathComplaintSaveResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates> _MapAccuraBathComplaintNoToDeleteImageVideo(
      AccuraBathComplaintNoToDeleteImageVideoRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      AccuraBathComplaintNoToDeleteImageVideoResponse respo =
          await userRepository.getComplaintNoToDeleteImageVideoAPI(
              event.ComplaintNo, event.complaintNoToDeleteImageVideoRequest);
      yield AccuraBathComplaintNoToDeleteImageVideoResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates>
      _mapAccuraBathComplaintUploadImageCallEventToState(
          AccuraBathComplaintUploadImageAPIRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      AccuraBathComplaintImageUploadResponse response;
      for (int i = 0; i < event.expenseImageFile.length; i++) {
        if (event.expenseImageFile[i].path != "") {
          event.complaintUploadImageAPIRequest.DocName =
              event.expenseImageFile[i].path.split('/').last;
          event.complaintUploadImageAPIRequest.file = event.expenseImageFile[i];
          response = await userRepository.getAccuraBathComplaintuploadImage(
              event.expenseImageFile[i], event.complaintUploadImageAPIRequest);
        }
      }

      // print("RESPPDDDD" +  await userRepository.getuploadImage(event.expenseUploadImageAPIRequest).toString());
      yield AccuraBathComplaintUploadImageCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates> _mapCountryListCallEventToState(
      CountryCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CountryListResponse respo =
          await userRepository.country_list_call(event.countryListRequest);
      yield CountryListEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates> _mapStateListCallEventToState(
      StateCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      StateListResponse respo =
          await userRepository.state_list_call(event.stateListRequest);
      yield StateListEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ComplaintScreenStates> _mapCityListCallEventToState(
      CityCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      CityApiRespose respo =
          await userRepository.city_list_details(event.cityApiRequest);
      yield CityListEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
}
