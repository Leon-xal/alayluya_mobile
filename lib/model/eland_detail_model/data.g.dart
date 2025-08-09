// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ElandDetailModel _$ElandDetailModelFromJson(Map<String, dynamic> json) {
  return ElandDetailModel(
    code: json['code'] as int,
    data: json['data'] == null
        ? null
        : ElandDetailData.fromJson(json['data'] as Map<String, dynamic>),
    msg: json['msg'] as String,
  );
}

Map<String, dynamic> _$ElandDetailModelToJson(ElandDetailModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg,
    };

ElandDetailData _$ElandDetailDataFromJson(Map<String, dynamic> json) {
  return ElandDetailData(
    id: json['id'] as int,
    name: json['name'] as String,
    type: json['type'] as String,
    type_pic: json['type_pic'] as String,
    desc: json['desc'] as String,
    cover: json['cover'] as String,
    avatar: json['avatar'] as String,
    address: json['address'] as String,
    phone: json['phone'] as String,
    fax: json['fax'] as String,
    email: json['email'] as String,
    link1: json['link1'] as String,
    link2: json['link2'] as String,
    link3: json['link3'] as String,
    follow: json['follow'] as int,
    ifollow: json['ifollow'] as bool,
    album: (json['album'] as List?)
        ?.map<ElandDetailAlbum>(
          (e) => e == null
              ? ElandDetailAlbum()
              : ElandDetailAlbum.fromJson(e as Map<String, dynamic>),
        )
        .toList(),
    /*?.map((e) => e == null
            ? null
            : ElandDetailAlbum.fromJson(e as Map<String, dynamic>))
        ?.toList(),*/
    brochure: (json['brochure'] as List?)
        ?.map<ElandDetailBrochure>(
          (e) => ElandDetailBrochure.fromJson(e as Map<String, dynamic>),
        )
        .toList(),
    /*?.map((e) => e == null
            ? null
            : ElandDetailBrochure.fromJson(e as Map<String, dynamic>))
        ?.toList(),*/
    map: json['map'] == null
        ? null
        : ElandDetailMap.fromJson(json['map'] as Map<String, dynamic>),
    album_url: json['album_url'] as String,
    MobileAppViewUrl: json['MobileAppViewUrl'] as String,
  );
}

Map<String, dynamic> _$ElandDetailDataToJson(ElandDetailData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'type_pic': instance.type_pic,
      'desc': instance.desc,
      'cover': instance.cover,
      'avatar': instance.avatar,
      'address': instance.address,
      'phone': instance.phone,
      'fax': instance.fax,
      'email': instance.email,
      'link1': instance.link1,
      'link2': instance.link2,
      'link3': instance.link3,
      'follow': instance.follow,
      'ifollow': instance.ifollow,
      'album': instance.album,
      'brochure': instance.brochure,
      'map': instance.map,
      'album_url': instance.album_url,
      'MobileAppViewUrl': instance.MobileAppViewUrl,
    };

ElandDetailAlbum _$ElandDetailAlbumFromJson(Map<String, dynamic> json) {
  return ElandDetailAlbum(
    img: json['img'] as String,
    desc: json['desc'] as String,
  );
}

Map<String, dynamic> _$ElandDetailAlbumToJson(ElandDetailAlbum instance) =>
    <String, dynamic>{'img': instance.img, 'desc': instance.desc};

ElandDetailBrochure _$ElandDetailBrochureFromJson(Map<String, dynamic> json) {
  return ElandDetailBrochure(
    img: json['img'] as String,
    desc: json['desc'] as String,
    type: json['type'] as int,
    source: json['source'] as String,
  );
}

Map<String, dynamic> _$ElandDetailBrochureToJson(
  ElandDetailBrochure instance,
) => <String, dynamic>{
  'img': instance.img,
  'desc': instance.desc,
  'type': instance.type,
  'source': instance.source,
};

ElandDetailMap _$ElandDetailMapFromJson(Map<String, dynamic> json) {
  return ElandDetailMap(lat: json['lat'] as String, lng: json['lng'] as String);
}

Map<String, dynamic> _$ElandDetailMapToJson(ElandDetailMap instance) =>
    <String, dynamic>{'lat': instance.lat, 'lng': instance.lng};
