import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/dealer/dealer_bloc.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/dimen_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Dealer/sales_bill/add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/general_utils.dart';

class DSaleBillListScreen extends BaseStatefulWidget {
  static const routeName = '/DSaleBillListScreen';

  @override
  BaseState<DSaleBillListScreen> createState() => _DSaleBillListScreenState();
}

class _DSaleBillListScreenState extends BaseState<DSaleBillListScreen>
    with BasicScreen, WidgetsBindingObserver {
  DealerBloc _dealerBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _dealerBloc = DealerBloc(baseBloc);

    _dealerBloc.add(DeleteAllDealerSaleBillProduct());
    _dealerBloc.add(DeleteAllDealerSaleBillOtherCharge());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _dealerBloc,
      child: BlocConsumer<DealerBloc, DealerStates>(
        builder: (BuildContext context, DealerStates state) {
          if (state is DeleteAllDealerSaleBillProductState) {
            deleteAllPurchaseProductFromDBResponse(state);
          }
          if (state is DeleteAllDealerSaleBillOtherChargeState) {
            deleteAllSalesBillOtherChargesFromDBResponse(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is DeleteAllDealerSaleBillProductState ||
              currentState is DeleteAllDealerSaleBillOtherChargeState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, DealerStates state) {
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
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
          title: Text('SalesBill List'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff62bb47),
          ]),
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
                  onRefresh: () async {},
                  child: Container(
                    padding: EdgeInsets.only(
                      left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                      right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                      top: 25,
                    ),
                    child: Column(
                      children: [Text("Sales Bill List")],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Add your onPressed code here!
            navigateTo(context, DSaleBillAddEditScreen.routeName);
          },
          child: const Icon(Icons.add),
          backgroundColor: colorPrimary,
        ),
        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: "Admin"),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  void deleteAllPurchaseProductFromDBResponse(
      DeleteAllDealerSaleBillProductState state) {
    print("DeleteAllPurchaseProductDB" + state.response);
  }

  void deleteAllSalesBillOtherChargesFromDBResponse(
      DeleteAllDealerSaleBillOtherChargeState state) {
    print("DeleteAllPurchaseProductDB" + state.response);
  }
}
