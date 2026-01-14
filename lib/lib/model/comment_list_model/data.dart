import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class CommentModel extends Object {
  String? msg;
  int? code;
  List<CommentListDatum>? list;

  CommentModel(this.msg, this.code, this.list);
  factory CommentModel.fromJson(Map<String, dynamic> srcJson) =>
      _$CommentModelFromJson(srcJson);
  Map<String, dynamic> toJson() => _$CommentModelToJson(this);
}

@JsonSerializable()
class CommentListDatum extends Object {
  int? key;
  String? avatar;
  int? comment_id;
  String? user_name;
  String? comment_content;
  String? comment_time;
  int? like_num;
  bool? ilike;
  int? reply_num;
  int? user_id;

  CommentListDatum(
    this.key,
    this.avatar,
    this.comment_id,
    this.user_name,
    this.comment_content,
    this.comment_time,
    this.like_num,
    this.reply_num,
    this.user_id,
  );

  factory CommentListDatum.fromJson(Map<String, dynamic> srcJson) =>
      _$CommentListDatumFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CommentListDatumToJson(this);
}
