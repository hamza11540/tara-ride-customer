import 'package:driver_customer_app/app_colors.dart';
import 'package:driver_customer_app/src/controllers/ride_controller.dart';
import 'package:driver_customer_app/src/views/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:url_launcher/url_launcher.dart';

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
    Future.microtask(() {
      _rideCon.doGetFavouriteDriver();
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
        title: Text("Favourite Driver"),
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
              itemCount: _rideCon.favDriver?.data?.length,
              itemBuilder: (BuildContext context, int index) {
                final favDriver = _rideCon.favDriver?.data![index];
                return Container(
                  height: 190,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Card(
                      color: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Driver Name: ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      favDriver?.name ?? "",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Text(
                                  favDriver?.status?.toUpperCase() ?? "",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Driver's e-mail: ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  favDriver?.email ?? "",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Car Brand: ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  favDriver?.brand ?? "",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Car Number: ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  favDriver?.plate ?? "",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  favDriver?.phone ?? "+92000000000",
                                  style: TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                    onPressed: () async {
                                      String? telephoneNumber = "+9200000000";
                                      String telephoneUrl =
                                          "tel:$telephoneNumber";
                                      if (await canLaunch(telephoneUrl)) {
                                        await launch(telephoneUrl);
                                      } else {
                                        throw "Error occurred trying to call that number.";
                                      }
                                    },
                                    icon: Icon(
                                      Icons.call,
                                      color: AppColors.mainBlue,
                                    ))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
