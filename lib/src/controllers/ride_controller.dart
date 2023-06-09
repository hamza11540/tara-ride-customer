import 'package:driver_customer_app/src/models/driver.dart';
import 'package:driver_customer_app/src/models/favoutite_location_model.dart';
import 'package:driver_customer_app/src/models/previous_ride_model.dart';
import 'package:driver_customer_app/src/models/rating_model.dart';
import 'package:driver_customer_app/src/models/vehicle_type.dart';

import '../models/favourite_driver_model.dart';
import '../models/nearby_driver.dart';
import '../models/ride_simulation.dart';
import '../models/status_enum.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../helper/custom_trace.dart';
import '../models/create_ride_address.dart';
import '../models/ride.dart';
import '../models/selected_payment_method.dart';
import '../services/ride_service.dart';

class RideController extends ControllerMVC {
  List<Driver> driversAround = [];
  List<NearbyDriver> driversNearBy = [];
  RideSimulation? simulation;
  bool simulating = false;
  bool submiting = false;
  bool loading = false;
  bool hasMoreRides = false;
  List<Ride> rides = [];
  Ride? ride;
  bool loadingPreference = false;
  Map<String, dynamic>? preferenceId;
  FavouriteDriverModel? favDriver;
  PreviousRideResponse? previousRideModel;
  FavouriteLocationModel? favLocation;
  RatingModel? ratingModel;

  Future<void> doGetDriversAround(double lat, double lng) async {
    await getDriversAround(lat, lng).then((List<Driver> _drivers) async {
      setState(() {
        driversAround = _drivers;
      });
    }).catchError((error) async {
      throw error;
    });
  }

  Future<void> doFindNearBy(
      CreateRideAddress location, VehicleType vehicleType) async {
    setState(() {
      driversNearBy = [];
      loading = true;
    });
    await findNearBy(location, vehicleType)
        .then((List<NearbyDriver> _drivers) async {
      setState(() {
        driversNearBy = _drivers;
        loading = false;
      });
    }).catchError((error) async {
      setState(() => loading = false);
      throw error;
    });
  }

  Future<void> doSimulate(CreateRideAddress pickup, CreateRideAddress ride,
      VehicleType vehicleType) async {
    setState(() => simulating = true);
    await simulate(pickup, ride, vehicleType)
        .then((RideSimulation _simulation) async {
      setState(() {
        simulation = _simulation;
        simulating = false;
      });
    }).catchError((error) async {
      setState(() => simulating = false);
      throw error;
    });
  }

  Future<String> doSubmit(
      CreateRideAddress pickup,
      CreateRideAddress ride,
      VehicleType vehicleType,
      SelectedPaymentMethod paymentMethod,
      String? observation) async {
    setState(() => submiting = true);
    String _rideId =
        await submit(pickup, ride, vehicleType, paymentMethod, observation)
            .catchError((error) async {
      setState(() => submiting = false);
      throw error;
    });
    setState(() {
      submiting = false;
    });
    return _rideId;
  }

  Future<List<Ride>> doGetRides(
      {int? pageSize, DateTime? dateTimeStart, DateTime? dateTimeEnd}) async {
    setState(() => loading = true);
    Map<String, dynamic> response = await getRides(
      pageSize: pageSize,
      currentItem: rides.length,
      dateTimeStart: dateTimeStart,
      dateTimeEnd: dateTimeEnd,
    ).catchError((error) {
      print(CustomTrace(StackTrace.current, message: error.toString()));
      throw error;
    }).whenComplete(() => setState(() => loading = false));
    List<Ride> _rides = response['rides'];
    setState(() {
      hasMoreRides = response['hasMoreRides'];
      if (pageSize == null) {
        rides = _rides;
      } else {
        rides.addAll(_rides);
      }
      loading = false;
    });
    return _rides;
  }

  Future<Ride> doGetRide(String rideId) async {
    setState(() {
      loading = true;
      ride = null;
    });
    Ride _ride = await getRide(rideId).catchError((error) {
      print(CustomTrace(StackTrace.current, message: error.toString()));
      throw error;
    }).whenComplete(() => setState(() => loading = false));
    setState(() {
      ride = _ride;
      loading = false;
    });
    return _ride;
  }

  Future<void> doCancelRide(Ride ride) async {
    setState(() {
      loading = true;
    });
    await cancelRide(ride).then((value) async {
      setState(() => loading = false);
    }).catchError((error) async {
      setState(() => loading = false);
      throw error;
    });
  }

  Future<void> doInitializePayment(Ride ride) async {
    setState(() {
      loadingPreference = true;
      preferenceId = null;
    });
    await initializePayment(ride)
        .then((Map<String, dynamic> _preferenceId) async {
      setState(() {
        loadingPreference = false;
        preferenceId = _preferenceId;
      });
    }).catchError((error) async {
      setState(() => loadingPreference = false);
      throw error;
    });
  }

  Future<bool> doCheckPaymentStatus(Ride ride) async {
    StatusEnum? status = await checkPaymentStatus(ride).catchError((error) {
      print(CustomTrace(StackTrace.current, message: error.toString()));
      throw error;
    });
    if (status != null && status != ride.paymentStatus) {
      return true;
    }
    return false;
  }

  Future<bool> doUpdateDriverLocation(Ride _ride) async {
    LatLng loc = await updateDriverLocation(_ride).catchError((error) {
      print(CustomTrace(StackTrace.current, message: error.toString()));
      throw error;
    });
    if (ride?.driver != null) {
      if (ride!.driver!.lat != loc.latitude ||
          ride!.driver!.lng != loc.longitude) {
        setState(() {
          ride!.driver!.lat = loc.latitude;
          ride!.driver!.lng = loc.longitude;
        });
        return true;
      }
    }
    return false;
  }

  Future<StatusEnum?> doCheckRideStatus(Ride _ride) async {
    return checkRideStatus(_ride).then((status) {
      setState(() {
        ride?.rideStatus = status;
      });
      return status;
    }).catchError((error) {
      print(CustomTrace(StackTrace.current, message: error.toString()));
      throw error;
    });
  }

  Future<void> doRating(String userId, String rideId, String driverId,
      String ratings, String comment) async {
    // setState(() => simulating = true);
    await rating(userId, rideId, driverId, ratings, comment)
        .then((value) async {
      setState(() {
        // simulation = _simulation;
        //  simulating = false;
      });
    }).catchError((error) async {
      //  setState(() => simulating = false);
      throw error;
    });
  }

  Future<void> doFavouriteLocation(
      String userId, double latitude, double longitude, String address) async {
    // setState(() => simulating = true);
    await favouriteLocation(userId, latitude, longitude, address)
        .then((value) async {
      setState(() {
        // simulation = _simulation;
        //  simulating = false;
      });
    }).catchError((error) async {
      //  setState(() => simulating = false);
      throw error;
    });
  }

  Future<void> doFavouriteDriver(
      String userId, String driverId, String addToFav) async {
    setState(() {
      loading = true;
    });
    await favouriteDriver(userId, driverId, addToFav).then((value) async {
      setState(() => loading = false);
    }).catchError((error) async {
      setState(() => loading = false);
      throw error;
    });
  }

  Future<FavouriteLocationModel?> doGetFavouriteLocation() async {
    setState(() {
      loading = true;
    });
    favLocation = await getFavouriteLocation().catchError((error) {
      print(CustomTrace(StackTrace.current, message: error.toString()));
      throw 'Erro ao buscar pedido, tente novamente';
    }).whenComplete(() => setState(() => loading = false));

    return favLocation;
  }

  Future<RatingModel?> doGetRating() async {
    setState(() {
      loading = true;
    });
    ratingModel = await getRating().catchError((error) {
      print(CustomTrace(StackTrace.current, message: error.toString()));
      throw 'Erro ao buscar pedido, tente novamente';
    }).whenComplete(() => setState(() => loading = false));

    return ratingModel;
  }

  Future<FavouriteDriverModel?> doGetFavouriteDriver() async {
    setState(() {
      loading = true;
    });
    favDriver = await getFavouriteDriver().catchError((error) {
      print(CustomTrace(StackTrace.current, message: error.toString()));
      throw 'Erro ao buscar pedido, tente novamente';
    }).whenComplete(() => setState(() => loading = false));

    return favDriver;
  }

  Future<void> doWalletTransfer(
    String senderId,
    String recieverId,
    String amount,
  ) async {
    // setState(() => simulating = true);
    await walletTransfer(
      senderId,
      recieverId,
      amount,
    ).then((value) async {
      setState(() {
        // simulation = _simulation;
        //  simulating = false;
      });
    }).catchError((error) async {
      //  setState(() => simulating = false);
      throw error;
    });
  }

  Future<PreviousRideResponse?> doGetPreviousRide(String userId,) async {
    setState(() {
      loading = true;
    });
    previousRideModel = await getPreviousRide(userId).catchError((error) {
      print(CustomTrace(StackTrace.current, message: error.toString()));
      throw 'Error';
    }).whenComplete(() => setState(() => loading = false));

    return previousRideModel;
  }

  Future<PreviousRideResponse?> doGetAllRide(String userId,) async {
    setState(() {
      loading = true;
    });
    previousRideModel = await getAllRide(userId).catchError((error) {
      print(CustomTrace(StackTrace.current, message: error.toString()));
      throw 'Error';
    }).whenComplete(() => setState(() => loading = false));

    return previousRideModel;
  }
}
