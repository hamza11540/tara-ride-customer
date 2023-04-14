import 'package:auto_size_text/auto_size_text.dart';
import 'package:driver_customer_app/app_colors.dart';
import 'package:driver_customer_app/src/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../controllers/ride_controller.dart';
import '../../helper/dimensions.dart';
import '../../helper/styles.dart';
import '../../models/address.dart';
import '../../models/ride.dart';
import '../../models/screen_argument.dart';

class RideAddressWidget extends StatefulWidget {
  final Ride ride;
  final bool showHeader;
  final bool showRating;

  RideAddressWidget(
      {Key? key,
      required this.ride,
      this.showHeader = true,
      this.showRating = true})
      : super(key: key);

  @override
  _RideAddressWidgetState createState() => _RideAddressWidgetState();
}

class _RideAddressWidgetState extends StateMVC<RideAddressWidget> {
  late RideController _con;
  bool loading = false;
  _RideAddressWidgetState() : super(RideController()) {
    _con = controller as RideController;
  }
  void openAddress(Address address) {
    MapsLauncher.launchCoordinates(address.latitude, address.longitude,
        address.name + ' - ' + (address.number ?? ''));
  }

  Widget generateDecoration(Widget conteudo) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.lightBlue3,
        borderRadius: BorderRadius.circular(20),
      ),
      child: conteudo,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      children: [
        if (widget.showHeader)
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              AppLocalizations.of(context)!.clickOnAdressOpenInMap,
              textAlign: TextAlign.center,
              style: khulaBold.copyWith(
                  fontSize: Dimensions.FONT_SIZE_LARGE,
                  color: Theme.of(context).primaryColor),
            ),
          ),
        InkWell(
          onTap: () {
            openAddress(widget.ride.boardingLocation!);
          },
          child: generateDecoration(
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: Dimensions.FONT_SIZE_DEFAULT + 1,
                vertical: Dimensions.FONT_SIZE_EXTRA_SMALL / 2,
              ),
              title: Text(
                '${AppLocalizations.of(context)!.boardingPlace}:',
                style: khulaBold.copyWith(
                    fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                    color: Theme.of(context).primaryColor),
              ),
              subtitle: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.FONT_SIZE_EXTRA_SMALL,
                ),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.55,
                ),
                child: AutoSizeText(
                  ((currentUser.value.id) ?? '') +
                      ' - ' +
                      (widget.ride.boardingLocation?.number ?? ''),
                  minFontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                  style: khulaRegular.copyWith(
                    fontSize: Dimensions.FONT_SIZE_LARGE,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              trailing: IconButton(
                  onPressed: loading
                      ? null
                      : () {
                          setState(() => loading = true);
                          _con
                              .doFavouriteLocation(
                                  widget.ride.driver!.user!.id,
                                  widget.ride.destinationLocation!.latitude,
                                  widget.ride.destinationLocation!.longitude,
                                  widget.ride.destinationLocation!
                                      .formattedAddress)
                              .then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Location Added to Favourite"),
                              backgroundColor: AppColors.mainBlue,
                            ));
                          });
                        },
                  icon: Icon(
                    Icons.favorite_border,
                    color: AppColors.mainBlue,
                  )),
            ),
          ),
        ),
        generateDecoration(
          ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: Dimensions.FONT_SIZE_EXTRA_SMALL,
              vertical: Dimensions.FONT_SIZE_EXTRA_SMALL / 2,
            ),
            title: Text(
              '${AppLocalizations.of(context)!.destination}:',
              style: khulaBold.copyWith(
                  fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                  color: Theme.of(context).primaryColor),
              maxLines: 2,
            ),
            subtitle: InkWell(
              onTap: () {
                openAddress(widget.ride.destinationLocation!);
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: Dimensions.PADDING_SIZE_SMALL,
                ),
                decoration: BoxDecoration(
                  color: AppColors.mainBlue,
                  border: Border.all(width: 1, color: AppColors.mainBlue),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Dimensions.FONT_SIZE_DEFAULT + 1,
                    vertical: Dimensions.FONT_SIZE_EXTRA_SMALL / 2,
                  ),
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.locationArrow,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                  iconColor: Theme.of(context).primaryColor,
                  minLeadingWidth: 0,
                  title: AutoSizeText(
                    '${widget.ride.destinationLocation!.formattedAddress + ' - ' + (widget.ride.destinationLocation!.number ?? '')}',
                    style: khulaRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_LARGE,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                      color: AppColors.white,
                    ),
                    maxLines: 2,
                  ),
                ),
              ),
            ),
            trailing: IconButton(
                onPressed: loading
                    ? null
                    : () {
                        setState(() => loading = true);
                        _con
                            .doFavouriteLocation(
                                widget.ride.driver!.user!.id,
                                widget.ride.destinationLocation!.latitude,
                                widget.ride.destinationLocation!.longitude,
                                widget
                                    .ride.destinationLocation!.formattedAddress)
                            .then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Location Added to Favourite"),
                            backgroundColor: AppColors.mainBlue,
                          ));
                        });
                      },
                icon: Icon(
                  Icons.favorite_border,
                  color: AppColors.mainBlue,
                )),
          ),
        ),

        // InkWell(
        //   onTap: () {
        //     Navigator.of(context).pushReplacementNamed('/walletScreen',
        //         arguments: ScreenArgument({'rides': widget.ride}));
        //   },
        //   child: Container(
        //       margin: EdgeInsets.all(10),
        //       height: 60,
        //       width: double.infinity,
        //       decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(20),
        //           color: AppColors.mainBlue),
        //       child: Center(
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               Icon(Icons.payments_outlined, color: Colors.white,),
        //               SizedBox(width: 10,),
        //               Text(
        //                 "Add Amount to Wallet",
        //                 style: TextStyle(
        //                   color: Colors.white,
        //                   fontWeight: FontWeight.bold,
        //                   fontSize: Dimensions.FONT_SIZE_DEFAULT,
        //                 ),
        //               ),
        //             ],
        //           ))),
        // ),

        if (widget.showRating)
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                '/ratingScreen',
                arguments: ScreenArgument({'ride': widget.ride}),
              );
            },
            child: Container(
                margin: EdgeInsets.all(10),
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.mainBlue),
                child: Center(
                    child: Text(
                  "Add Rating/Feedback",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                  ),
                ))),
          )
      ],
    );
  }
}
