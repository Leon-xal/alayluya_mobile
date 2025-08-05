import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class ArticleCateModel {
  int code;
  List<ArticleCateDatum> list;
  String msg;

  ArticleCateModel({
    this.code,
    this.list,
    this.msg,
  });

  //反序列化
  factory ArticleCateModel.fromJson(Map<String, dynamic> json) => _$ArticleCateModelFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ArticleCateModelToJson(this);
}

@JsonSerializable()
class ArticleCateDatum {
  int key;
  int cateid;
  String catename;
  List<ArticleCatePic> catepic;

  ArticleCateDatum({
    this.key,
    this.cateid,
    this.catename,
    this.catepic,
  });

  //反序列化
  factory ArticleCateDatum.fromJson(Map<String, dynamic> json) => _$ArticleCateDatumFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ArticleCateDatumToJson(this);
}

@JsonSerializable()
class ArticleCatePic {
  String pic;
  int type;
  String type_name;
  String type_val;
  ArticleCatePic({
    this.pic,
    this.type,
    this.type_name,
    this.type_val,
  });

  //反序列化
  factory ArticleCatePic.fromJson(Map<String, dynamic> json) =>
      _$ArticleCatePicFromJson(json);
  //序列化
  Map<String, dynamic> toJson() => _$ArticleCatePicToJson(this);
}