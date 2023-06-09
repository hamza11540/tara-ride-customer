import 'package:auto_size_text/auto_size_text.dart';
import 'package:driver_customer_app/src/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:intl/intl.dart' show DateFormat, NumberFormat;
import '../../../app_colors.dart';
import '../../controllers/ride_controller.dart';
import '../../helper/dimensions.dart';
import '../../helper/styles.dart';
import '../../models/measure_unit_enum.dart';
import '../../models/payment_gateway_enum.dart';
import '../../models/status_enum.dart';
import '../../repositories/setting_repository.dart';
import '../widgets/menu.dart';
import 'package:intl/intl.dart' as intl;

class PreviousRideScreen extends StatefulWidget {
  const PreviousRideScreen({Key? key}) : super(key: key);

  @override
  _PreviousRideScreenState createState() => _PreviousRideScreenState();
}

class _PreviousRideScreenState extends StateMVC<PreviousRideScreen> {
  String dateTimeConverstion(String? createdAt) {
    if (createdAt == null) {
      return "-";
    }
    return intl.DateFormat("dd-MMM  hh:mm a")
        .format(DateTime.parse(createdAt).toLocal());
  }

  late RideController _rideCon;
  _PreviousRideScreenState() : super(RideController()) {
    _rideCon = controller as RideController;
  }
  late bool expanded;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _rideCon.doGetPreviousRide(currentUser.value.id);
      print("hello");

      //print(_rideCon.favLocation?.data?.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.mainBlue,
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          elevation: 1,
          shadowColor: Theme.of(context).primaryColor,
          title: Text("Recurring Rides"),
        ),
        drawer: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          child: Drawer(
            child: MenuWidget(),
          ),
        ),
        body: _rideCon.loading
            ? Center(
                child: CircularProgressIndicator(
                color: AppColors.mainBlue,
              ))
            : _rideCon.previousRideModel?.previousRide == null ||
                    _rideCon.previousRideModel!.previousRide!.isEmpty
                ? Center(child: Text("No previous ride found"))
                : ListView.builder(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                    shrinkWrap: true,
                    itemCount: _rideCon.previousRideModel?.previousRide?.length,
                    itemBuilder: (BuildContext context, int index) {
                      final recurringRide =
                          _rideCon.previousRideModel?.previousRide![index];
                      return Stack(
                        children: <Widget>[
                          Opacity(
                            opacity: 0.6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Card(
                                    color: AppColors.lightBlue3,
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 20, right: 45, left: 16),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    dateTimeConverstion(
                                                        recurringRide?.createdAt),
                                                    style: khulaBold.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_DEFAULT,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                  Transform.translate(
                                                    offset: const Offset(25, 0.0),
                                                    child: AutoSizeText(
                                                      '${recurringRide?.distance}${MeasureUnitEnumHelper.abbreviation(setting.value.measureUnit, context)} - ${NumberFormat.simpleCurrency(name: setting.value.currency).currencySymbol} ${recurringRide?.totalValue}',
                                                      textAlign: TextAlign.right,
                                                      style: khulaBold.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_DEFAULT,
                                                          color: Theme.of(context)
                                                              .primaryColor),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 12,),
                                              Row(
                                                children: [
                                                  Text(
                                                    'PickUp Address: ',
                                                    style: khulaBold.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_DEFAULT,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                  Expanded(
                                                    child: Transform.translate(
                                                      offset: const Offset(25, 0.0),
                                                      child: AutoSizeText(
                                                     recurringRide?.boardingLocation??"",
                                                        textAlign: TextAlign.right,
                                                        maxLines: 1,
                                                        minFontSize: Dimensions
                                                            .FONT_SIZE_DEFAULT,
                                                        maxFontSize: Dimensions
                                                            .FONT_SIZE_DEFAULT,
                                                        style: khulaBold.copyWith(
                                                            color: Theme.of(context)
                                                                .primaryColor),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 12,),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Destination Address: ',
                                                    style: khulaBold.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_DEFAULT,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                  Expanded(
                                                    child: Transform.translate(
                                                      offset: const Offset(25, 0.0),
                                                      child: AutoSizeText(
                                                        recurringRide?.destinationLocationData?.formattedAddress??"",
                                                        textAlign: TextAlign.right,
                                                        maxLines: 1,
                                                        minFontSize: Dimensions
                                                            .FONT_SIZE_DEFAULT,
                                                        maxFontSize: Dimensions
                                                            .FONT_SIZE_DEFAULT,
                                                        style: khulaBold.copyWith(
                                                            color: Theme.of(context)
                                                                .primaryColor),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 12,),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Rating: ',
                                                    style: khulaBold.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_DEFAULT,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                  Expanded(
                                                    child: Transform.translate(
                                                      offset: const Offset(25, 0.0),
                                                      child: AutoSizeText(
                                                        "${recurringRide?.rating.toString()}.0",
                                                        textAlign: TextAlign.right,
                                                        maxLines: 1,
                                                        minFontSize: Dimensions
                                                            .FONT_SIZE_DEFAULT,
                                                        maxFontSize: Dimensions
                                                            .FONT_SIZE_DEFAULT,
                                                        style: khulaBold.copyWith(
                                                            color: Theme.of(context)
                                                                .primaryColor),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 12,),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Feedback: ',
                                                    style: khulaBold.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_DEFAULT,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                  Expanded(
                                                    child: Transform.translate(
                                                      offset: const Offset(25, 0.0),
                                                      child: AutoSizeText(
                                                        recurringRide?.comment??"",
                                                        textAlign: TextAlign.right,
                                                        maxLines: 1,
                                                        minFontSize: Dimensions
                                                            .FONT_SIZE_DEFAULT,
                                                        maxFontSize: Dimensions
                                                            .FONT_SIZE_DEFAULT,
                                                        style: khulaBold.copyWith(
                                                            color: Theme.of(context)
                                                                .primaryColor),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),


                                            ],
                                          ),
                                        ),
                                        ButtonBar(
                                          buttonPadding: EdgeInsets.zero,
                                          alignment: MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () async {
                                                // await Navigator.pushNamed(
                                                //   context,
                                                //   '/Ride',
                                                //   arguments: ScreenArgument({
                                                //     'rideId': widget.ride.id,
                                                //     'showRating': false,
                                                //   }),
                                                // ).then((value) {
                                                //   if (widget.loadPedidos != null) {
                                                //     widget.loadPedidos!();
                                                //   }
                                                // });
                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Book Again",
                                                    style: khulaSemiBold.merge(
                                                      TextStyle(
                                                        color: Theme.of(context).primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                  Icon(Icons.chevron_right,
                                                      size: 25,
                                                      color: Theme.of(context).primaryColor),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsetsDirectional.only(start: 20),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: 28,
                            width: 140,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: AppColors.mainBlue),
                            alignment: AlignmentDirectional.center,
                            child: Text(
                              recurringRide?.rideStatus == "completed" ? "Completed":"",
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: Theme.of(context).textTheme.caption!.merge(
                                    TextStyle(
                                      height: 1,
                                      color: Theme.of(context).highlightColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            ),
                          ),
                        ],
                      );
                    }),
      ),
    );
  }
}
