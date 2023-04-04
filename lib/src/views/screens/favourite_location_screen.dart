import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../../app_colors.dart';
import '../../controllers/ride_controller.dart';
import '../widgets/menu.dart';

class FavouriteLocationScreen extends StatefulWidget {
  const FavouriteLocationScreen({Key? key}) : super(key: key);

  @override
  _FavouriteLocationScreenState createState() =>
      _FavouriteLocationScreenState();
}

class _FavouriteLocationScreenState extends StateMVC<FavouriteLocationScreen> {
  late RideController _rideCon;
  _FavouriteLocationScreenState() : super(RideController()) {
    _rideCon = controller as RideController;
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _rideCon.doGetFavouriteLocation();
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
        title: Text("Favourite Location"),
        centerTitle: true,
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
          : ListView.builder(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16),

              shrinkWrap: true,
              itemCount: _rideCon.favLocation?.data?.length,
              itemBuilder: (BuildContext context, int index) {
                final favLocaction = _rideCon.favLocation?.data![index];
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
                        title: Text(favLocaction?.address ?? "Lahore, Pakistan"),
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
