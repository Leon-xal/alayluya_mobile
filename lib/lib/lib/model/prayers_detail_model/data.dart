import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class PrayersDetailModel {
  int? code;
  PrayersDetailData? data;
  String? msg;

  PrayersDetailModel({this.code, this.data, this.msg});

  //反序列化
  factory PrayersDetailModel.fromJson(Map<String, dynamic> json) =>
      _$PrayersDetailModelFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$PrayersDetailModelToJson(this);
}

@JsonSerializable()
class PrayersDetailData {
  int? id;
  String? author;
  String? avatar;
  String? time;
  String? content;
  String? cover;
  int? prayer;
  bool? iprayer;
  String? content_app_link;

  PrayersDetailData({
    this.id,
    this.author,
    this.avatar,
    this.time,
    this.content,
    this.cover,
    this.prayer,
    this.iprayer,
    this.content_app_link,
  });

  //反序列化
  factory PrayersDetailData.fromJson(Map<String, dynamic> json) {
    //    print('UserDataFromJson=====>${json}');
    return _$PrayersDetailDataFromJson(json);
  }

  //序列化
  Map<String, dynamic> toJson() {
    return _$PrayersDetailDataToJson(this);
  }
}
