class RatingModel {
  List<Data>? data;

  RatingModel({this.data});

  RatingModel.fromJson(Map<String, dynamic> json) {
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
  int? uId;
  int? dId;
  int? rating;
  int? rId;
  String? comment;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.uId,
        this.dId,
        this.rating,
        this.rId,
        this.comment,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uId = json['u_id'];
    dId = json['d_id'];
    rating = json['rating'];
    rId = json['r_id'];
    comment = json['comment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['u_id'] = this.uId;
    data['d_id'] = this.dId;
    data['rating'] = this.rating;
    data['r_id'] = this.rId;
    data['comment'] = this.comment;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
