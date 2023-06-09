import 'package:cached_network_image/cached_network_image.dart';
import 'package:driver_customer_app/src/controllers/ride_controller.dart';
import 'package:driver_customer_app/src/models/ride.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../../app_colors.dart';
import '../../helper/assets.dart';
import '../../repositories/user_repository.dart';
import '../widgets/textfield_decoration.dart';

class RatingScreen extends StatefulWidget {
  final Ride ride;
  const RatingScreen({
    Key? key,
    required this.ride,
  }) : super(key: key);

  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends StateMVC<RatingScreen> {
  TextEditingController feedBack = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double? ratings;
  bool loading = false;
  late RideController _con;
  _RatingScreenState() : super(RideController()) {
    _con = controller as RideController;
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: SingleChildScrollView(
              child: Column(

                children: [

                  SizedBox(height: 30,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Bill",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Text(
                            "\$ ${widget.ride.amount}",
                            style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.40,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Column(
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.mainBlue, width: 3)),
                            child: ClipOval(
                                child: widget.ride.driver?.user!.picture != null &&
                                    widget.ride.driver?.user!.picture!.id != ''
                                    ? CachedNetworkImage(
                                  progressIndicatorBuilder:
                                      (context, url, progress) => Center(
                                    child: CircularProgressIndicator(
                                      value: progress.progress,
                                    ),
                                  ),
                                  imageUrl:
                                  widget.ride.driver?.user?.picture!.url ?? "",
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                                    : Image.asset(Assets.placeholderUser,
                                    color: Theme.of(context).primaryColor,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.scaleDown)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.ride.driver?.user?.name ?? "",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.ride.driver?.user?.email ?? "",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 12),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: AppColors.mainBlue,
                            ),
                            onRatingUpdate: (rating) {
                              ratings = rating;
                              setState(() {});
                              print(rating);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Feedback is valuable for us.",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: feedBack,
                        maxLines: 5,
                        cursorColor: Colors.black,
                        style: const TextStyle(color: Colors.black, fontSize: 12),
                        decoration: customInputDecoration(
                            hintText: "Feedback",
                            hintTextStyle:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
                  InkWell(
                    onTap: loading
                        ? null
                        : () {
                      if (_formKey.currentState!.validate() &&
                          ratings != null) {
                        _formKey.currentState!.save();
                        setState(() => loading = true);
                        _con
                            .doRating(
                            widget.ride.driver!.user!.id,
                            widget.ride.id,
                            currentUser.value.id,
                            ratings.toString(),
                            feedBack.text)
                            .then((value) {
                          Navigator.pushNamedAndRemoveUntil(context, "/Home",
                                  (Route<dynamic> route) => false)
                              .then((value) => {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content:
                              Text("Rating added successfully"),
                              backgroundColor:
                              Theme.of(context).errorColor,
                            ))
                          })
                              .catchError((onError) {
                            setState(() => loading = false);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: Text("Sorry rating not added"),
                              backgroundColor: Theme.of(context).errorColor,
                            ));
                          });
                          setState(() => loading = false);
                          return;
                        });
                      }
                    },
                    child: loading
                        ? Center(
                      child: CircularProgressIndicator(
                          color: AppColors.mainBlue),
                    )
                        : Container(

                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.mainBlue),
                      child: Center(
                        child: Text(
                          "Done",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
