import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class ElandCateModel {
  int code;
  List<ElandCateDatum> list;
  String msg;

  ElandCateModel({
    this.code,
    this.list,
    this.msg,
  });

  //反序列化
  factory ElandCateModel.fromJson(Map<String, dynamic> json) => _$ElandCateModelFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ElandCateModelToJson(this);
}

@JsonSerializable()
class ElandCateDatum {
  int key;
  int cateid;
  String catename;

  ElandCateDatum({
    this.key,
    this.cateid,
    this.catename,
  });

  //反序列化
  factory ElandCateDatum.fromJson(Map<String, dynamic> json) => _$ElandCateDatumFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ElandCateDatumToJson(this);
}
