import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/other/bloc_modules/installation/installation_bloc.dart';
import 'package:soleoserp/models/api_requests/installation_request/installation_country_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/installation_response/installation_country_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class InstallationSearchCountryScreen extends BaseStatefulWidget {
  static const routeName = '/InstallationSearchCountryScreen';

  @override
  _InstallationSearchCountryScreenState createState() =>
      _InstallationSearchCountryScreenState();
}

class _InstallationSearchCountryScreenState
    extends BaseState<InstallationSearchCountryScreen>
    with BasicScreen, WidgetsBindingObserver {
  InstallationBloc installationBloc;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";
  InstallationCountryResponse Response1;

  @override
  void initState() {
    super.initState();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    screenStatusBarColor = colorPrimary;
    installationBloc = InstallationBloc(baseBloc);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => installationBloc,
      child: BlocConsumer<InstallationBloc, InstallationListState>(
        builder: (BuildContext context, InstallationListState state) {
          if (state is InstallationCountryCallResponseState) {
            _onSearchInquiryListCallSuccess(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is InstallationCountryCallResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, InstallationListState state) {},
        listenWhen: (oldState, currentState) {
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        NewGradientAppBar(
          title: Text('Search Country'),
          gradient:
              LinearGradient(colors: [Colors.blue, Colors.purple, Colors.red]),
        ),
        Expanded(
          child: Column(
            children: [
              _buildSearchView(),
              Expanded(child: _buildInquiryList())
            ],
          ),
        ),
      ],
    );
  }

  ///builds header and title view
  Widget _buildSearchView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Text("Min. 3 chars to Search Country ",
              style: TextStyle(
                  fontFamily: "QuickSand",
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Card(
            elevation: 5,
            color: colorLightGray,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      autofocus: true,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      onChanged: (value) {
                        _onSearchChanged(value);
                      },
                      decoration: InputDecoration(
                        hintText: "Tap to enter Country",
                        border: InputBorder.none,
                      ),
                      style: baseTheme.textTheme.subtitle2
                          .copyWith(color: colorBlack),
                    ),
                  ),
                  Icon(
                    Icons.search,
                    color: colorGrayDark,
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  ///builds inquiry list
  Widget _buildInquiryList() {
    if (Response1 == null) {
      return Container();
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        return _buildSearchInquiryListItem(index);
      },
      shrinkWrap: true,
      itemCount: Response1.details.length,
    );
  }

  ///builds row item view of inquiry list
  Widget _buildSearchInquiryListItem(int index) {
    InstallationCountryDetails cs = Response1.details[index];

    return Container(
      margin: EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop(cs);
        },
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Card(
            elevation: 4,
            child: Container(
              padding:
                  EdgeInsets.only(left: 20, right: 10, top: 20, bottom: 20),
              child: Text(
                cs.countryName,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///calls search list api
  void _onSearchChanged(String value) {
    if (value.trim().length > 2) {
      installationBloc.add(InstallationCountryCallEvent(
          InstallationCountryRequest(
              CompanyId: this.CompanyID, CountryCode: value)));
    }
  }

  void _onSearchInquiryListCallSuccess(
      InstallationCountryCallResponseState state) {
    Response1 = state.response;
  }

  Widget CountryList() {
    return ListView.builder(
      itemBuilder: (BuildContext abc, int index) {
        return country(index);
      },
      shrinkWrap: true,
      itemCount: 10,
    );
  }

  Widget country(int index) {
    InstallationCountryDetails CD = Response1.details[index];
    return Container(
      child: Card(
        elevation: 4,
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 25, bottom: 25),
          child: Text(
            CD.countryName,
          ),
        ),
        margin: EdgeInsets.only(top: 10),
      ),
    );
  }
}
