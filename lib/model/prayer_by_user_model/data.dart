import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class PrayerByUserModel {
  int? code;
  List<PrayerByUserDatum>? list;
  String? msg;

  PrayerByUserModel({this.code, this.list, this.msg});

  //反序列化
  factory PrayerByUserModel.fromJson(Map<String, dynamic> json) =>
      _$PrayerByUserModelFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$PrayerByUserModelToJson(this);
}

@JsonSerializable()
class PrayerByUserDatum {
  int? key;
  int? f_uid;
  String? f_avatar;
  String? f_uname;
  bool? my_is_follow;

  PrayerByUserDatum({
    this.key,
    this.f_uid,
    this.f_avatar,
    this.f_uname,
    this.my_is_follow,
  });

  //反序列化
  factory PrayerByUserDatum.fromJson(Map<String, dynamic> json) =>
      _$PrayerByUserDatumFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$PrayerByUserDatumToJson(this);
}
