import 'package:driver_customer_app/src/controllers/ride_controller.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
class FavouriteDriverScreen extends StatefulWidget {
  const FavouriteDriverScreen({Key? key}) : super(key: key);

  @override
  _FavouriteDriverScreenState createState() => _FavouriteDriverScreenState();
}

class _FavouriteDriverScreenState extends StateMVC<FavouriteDriverScreen> {
  late RideController _rideCon;
  _FavouriteDriverScreenState() : super(RideController()) {
    _rideCon = controller as RideController;
  }

  @override
  void initState() {
    super.initState();
    Future.microtask((){
      _rideCon.doGetFavouriteLocation();
      print("hello");

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _rideCon.loading?CircularProgressIndicator() :ListView.builder(
          itemCount: _rideCon.favLocation?.data?.length,
          itemBuilder: (BuildContext context, int index){
            final favLocaction = _rideCon.favLocation?.data![index];
        return Container(
          child: Text(favLocaction?.address??""),

        );
      }),
    );
  }
}
