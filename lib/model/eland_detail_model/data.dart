import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class ElandDetailModel {
  int? code;
  ElandDetailData? data;
  String? msg;

  ElandDetailModel({this.code, this.data, this.msg});

  //反序列化
  factory ElandDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ElandDetailModelFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ElandDetailModelToJson(this);
}

@JsonSerializable()
class ElandDetailData {
  int? id;
  String? name;
  String? type;
  String? type_pic;
  String? desc;
  String? cover;
  String? avatar;
  String? address;
  String? phone;
  String? fax;
  String? email;
  String? link1;
  String? link2;
  String? link3;
  int? follow;
  bool? ifollow;
  List<ElandDetailAlbum>? album;
  List<ElandDetailBrochure>? brochure;
  ElandDetailMap? map;
  String? album_url;
  String? MobileAppViewUrl;
  ElandDetailData({
    this.id,
    this.name,
    this.type,
    this.type_pic,
    this.desc,
    this.cover,
    this.avatar,
    this.address,
    this.phone,
    this.fax,
    this.email,
    this.link1,
    this.link2,
    this.link3,
    this.follow,
    this.ifollow,
    this.album,
    this.brochure,
    this.map,
    this.album_url,
    this.MobileAppViewUrl,
  });

  //反序列化
  factory ElandDetailData.fromJson(Map<String, dynamic> json) {
    //    print('UserDataFromJson=====>${json}');
    return _$ElandDetailDataFromJson(json);
  }

  //序列化
  Map<String, dynamic> toJson() {
    return _$ElandDetailDataToJson(this);
  }
}

@JsonSerializable()
class ElandDetailAlbum {
  String? img;
  String? desc;
  ElandDetailAlbum({this.img, this.desc});

  //反序列化
  factory ElandDetailAlbum.fromJson(Map<String, dynamic> json) =>
      _$ElandDetailAlbumFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ElandDetailAlbumToJson(this);
}

@JsonSerializable()
class ElandDetailBrochure {
  String? img;
  String? desc;
  int? type;
  String? source;
  ElandDetailBrochure({this.img, this.desc, this.type, this.source});

  //反序列化
  factory ElandDetailBrochure.fromJson(Map<String, dynamic> json) =>
      _$ElandDetailBrochureFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ElandDetailBrochureToJson(this);
}

@JsonSerializable()
class ElandDetailMap {
  String? lat;
  String? lng;
  ElandDetailMap({this.lat, this.lng});

  //反序列化
  factory ElandDetailMap.fromJson(Map<String, dynamic> json) {
    //    print('UserDataFromJson=====>${json}');
    return _$ElandDetailMapFromJson(json);
  }

  //序列化
  Map<String, dynamic> toJson() {
    return _$ElandDetailMapToJson(this);
  }
}
