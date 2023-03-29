import 'package:cached_network_image/cached_network_image.dart';
import 'package:driver_customer_app/src/controllers/ride_controller.dart';
import 'package:driver_customer_app/src/models/ride.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../app_colors.dart';
import '../../helper/assets.dart';
import '../widgets/textfield_decoration.dart';

class RatingScreen extends StatefulWidget {
  final Ride ride;
  const RatingScreen({
    Key? key,
    required this.ride,
  }) : super(key: key);

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double? ratings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        fit: StackFit.passthrough,
        children: [
          Positioned(
            top: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.32,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(80),
                      bottomRight: Radius.circular(80)),
                  color: AppColors.mainBlue),
            ),
          ),
          Positioned(
              top: 70,
              left: 19,
              right: 19,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "You Bill",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              )),
          Positioned(
              top: 120,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "\$ ${widget.ride.amount}",
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              )),
          Positioned(
              top: 190,
              left: 22,
              right: 22,
              child: Container(
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
                            child: widget.ride.driver?.user?.picture != null &&
                                    widget.ride.driver?.user?.picture!.id != ''
                                ? CachedNetworkImage(
                                    progressIndicatorBuilder:
                                        (context, url, progress) => Center(
                                      child: CircularProgressIndicator(
                                        value: progress.progress,
                                      ),
                                    ),
                                    imageUrl: widget
                                            .ride.driver?.user?.picture!.url ??
                                        "",
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
              )),
          Positioned(
            bottom: 120,
            left: 20,
            right: 20,
            child: Column(
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
          ),
          Positioned(
            bottom: 20,
            left: 50,
            right: 50,
            child: Container(
              margin: EdgeInsets.only(left: 30),
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
    );
  }
}
