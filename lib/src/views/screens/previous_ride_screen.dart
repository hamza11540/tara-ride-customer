import 'package:driver_customer_app/src/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../../app_colors.dart';
import '../../controllers/ride_controller.dart';
import '../widgets/menu.dart';

class PreviousRideScreen extends StatefulWidget {
  const PreviousRideScreen({Key? key}) : super(key: key);

  @override
  _PreviousRideScreenState createState() => _PreviousRideScreenState();
}

class _PreviousRideScreenState extends StateMVC<PreviousRideScreen> {
  late RideController _rideCon;
  _PreviousRideScreenState() : super(RideController()) {
    _rideCon = controller as RideController;
  }

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
    return Scaffold(
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
          : _rideCon.previousRideModel?.previousRide == null || _rideCon.previousRideModel!.previousRide!.isEmpty ?Center(child: Text("No previous ride found")) :ListView.builder(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16),
              shrinkWrap: true,
              itemCount: _rideCon.previousRideModel?.previousRide?.length,
              itemBuilder: (BuildContext context, int index) {
                final favLocaction =
                    _rideCon.previousRideModel?.previousRide![index];
                return Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Card(
                      color: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.mainBlue,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                        ),
                        title:
                            Text(favLocaction?.boardingLocation??"hello"),
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
