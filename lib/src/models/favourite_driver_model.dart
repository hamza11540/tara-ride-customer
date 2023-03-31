class FavouriteDriverModel {
  List<Data>? data;

  FavouriteDriverModel({this.data});

  FavouriteDriverModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? emailVerifiedAt;
  String? password;
  int? wallet;
  String? apiToken;
  String? firebaseToken;
  String? rememberToken;
  String? createdAt;
  String? updatedAt;
  int? userId;
  int? active;
  String? slug;
  String? lastLocationAt;
  String? lat;
  String? lng;
  int? vehicleTypeId;
  String? brand;
  String? model;
  String? plate;
  String? vehicleDocument;
  String? driverLicenseUrl;
  String? statusObservation;
  String? status;
  String? deletedAt;
  int? uId;
  int? dId;
  int? addToFav;

  Data(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.emailVerifiedAt,
      this.password,
      this.wallet,
      this.apiToken,
      this.firebaseToken,
      this.rememberToken,
      this.createdAt,
      this.updatedAt,
      this.userId,
      this.active,
      this.slug,
      this.lastLocationAt,
      this.lat,
      this.lng,
      this.vehicleTypeId,
      this.brand,
      this.model,
      this.plate,
      this.vehicleDocument,
      this.driverLicenseUrl,
      this.statusObservation,
      this.status,
      this.deletedAt,
      this.uId,
      this.dId,
      this.addToFav});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    emailVerifiedAt = json['email_verified_at'];
    password = json['password'];
    wallet = json['wallet'];
    apiToken = json['api_token'];
    firebaseToken = json['firebase_token'];
    rememberToken = json['remember_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userId = json['user_id'];
    active = json['active'];
    slug = json['slug'];
    lastLocationAt = json['last_location_at'];
    lat = json['lat'];
    lng = json['lng'];
    vehicleTypeId = json['vehicle_type_id'];
    brand = json['brand'];
    model = json['model'];
    plate = json['plate'];
    vehicleDocument = json['vehicle_document'];
    driverLicenseUrl = json['driver_license_url'];
    statusObservation = json['status_observation'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    uId = json['u_id'];
    dId = json['d_id'];
    addToFav = json['add_to_fav'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['password'] = this.password;
    data['wallet'] = this.wallet;
    data['api_token'] = this.apiToken;
    data['firebase_token'] = this.firebaseToken;
    data['remember_token'] = this.rememberToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['user_id'] = this.userId;
    data['active'] = this.active;
    data['slug'] = this.slug;
    data['last_location_at'] = this.lastLocationAt;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['vehicle_type_id'] = this.vehicleTypeId;
    data['brand'] = this.brand;
    data['model'] = this.model;
    data['plate'] = this.plate;
    data['vehicle_document'] = this.vehicleDocument;
    data['driver_license_url'] = this.driverLicenseUrl;
    data['status_observation'] = this.statusObservation;
    data['status'] = this.status;
    data['deleted_at'] = this.deletedAt;
    data['u_id'] = this.uId;
    data['d_id'] = this.dId;
    data['add_to_fav'] = this.addToFav;
    return data;
  }
}
