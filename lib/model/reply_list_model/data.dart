import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';


@JsonSerializable()
class ReplyModel extends Object {

  String msg;

  int code;

  List<ReplyListDatum> list;

  ReplyModel(this.msg,this.code,this.list,);

  factory ReplyModel.fromJson(Map<String, dynamic> srcJson) => _$ReplyModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ReplyModelToJson(this);

}


@JsonSerializable()
class ReplyListDatum extends Object {
  int key;

  String user_name;

  String avatar;

  int reply_id;

  int comment_id;

  String reply_content;

  String reply_time;

  int user_id;

  ReplyListDatum(this.key,this.user_name,this.avatar,this.reply_id,this.comment_id,this.reply_content,this.reply_time,this.user_id,);

  factory ReplyListDatum.fromJson(Map<String, dynamic> srcJson) => _$ReplyListDatumFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ReplyListDatumToJson(this);

}


