import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class ElandPrayersListModel {
  int? code;
  List<ElandPrayersListDatum>? list;
  String? msg;

  ElandPrayersListModel({this.code, this.list, this.msg});

  //反序列化
  factory ElandPrayersListModel.fromJson(Map<String, dynamic> json) =>
      _$ElandPrayersListModelFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ElandPrayersListModelToJson(this);
}

@JsonSerializable()
class ElandPrayersListDatum {
  int? key;
  int? id;
  String? pic;
  String? title;
  String? desc;
  String? author;
  int? like;
  bool? ilike;
  int? prayer;
  bool? iprayer;
  List<ElandPrayersListTags>? tags;

  ElandPrayersListDatum({
    this.key,
    this.id,
    this.pic,
    this.title,
    this.desc,
    this.author,
    this.like,
    this.ilike,
    this.prayer,
    this.iprayer,
    this.tags,
  });

  //反序列化
  factory ElandPrayersListDatum.fromJson(Map<String, dynamic> json) =>
      _$ElandPrayersListDatumFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ElandPrayersListDatumToJson(this);
}

@JsonSerializable()
class ElandPrayersListTags {
  String? name;
  String? value;
  ElandPrayersListTags({this.name, this.value});

  //反序列化
  factory ElandPrayersListTags.fromJson(Map<String, dynamic> json) =>
      _$ElandPrayersListTagsFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ElandPrayersListTagsToJson(this);
}
