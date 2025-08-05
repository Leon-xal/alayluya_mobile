import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../utils/global.dart';

class ReqEland {
  final Dio _dio;

  ReqEland(this._dio);

  /// 獲取分類
  Future<Response> cate(){
    return _dio.post(
        G.prdapi+'/eland-cate'
    );
  }

  /// 獲取列表
  Future<Response> list({
    int userid = 0,
    String search_by_name = '',
    int pageid = 1,
    int limit = 10,
    int cateid = 0,
  }) {
   print('elandlist-userid===>${userid}');
   print('elandlist-pageid===>${pageid}');
   print('elandlist-limit===>${limit}');
   print('elandlist-cateid===>${cateid}');

   return _dio.post(
        G.prdapi+'/eland-list',
        queryParameters: {
          'user_id': userid,
          'search_by_name': search_by_name,
          'page': pageid,
          'limit': limit,
          'cate_id': cateid,
        }
    );
  }

  /// 獲取列表
  Future<Response> my_follow_list({
    int userid = 0,
    String search_by_name = '',
    int pageid = 1,
    int limit = 10,
    int cateid = 0,
  }) {
    print('elandlist-userid===>${userid}');
    print('elandlist-pageid===>${pageid}');
    print('elandlist-limit===>${limit}');
    print('elandlist-cateid===>${cateid}');

    return _dio.post(
        G.prdapi+'/my-eland-list',
        queryParameters: {
          'user_id': userid,
          'search_by_name': search_by_name,
          'page': pageid,
          'limit': limit,
          'cate_id': cateid,
        }
    );
  }

  /// 獲取動態列表
  Future<Response> dynamic({
    int userid = 0,
    String search_by_content = '',
    int pageid = 1,
    int limit = 20,
  }) {
//    print('dynamic-uid=====>${userid}');
//    print('dynamic-article=====>${userid}');
    return _dio.post(
        G.prdapi+'/eland-dynamic',
//        '/eland-dynamic',
        queryParameters: {
          'user_id': userid,
          'search_by_content': search_by_content,
          'page': pageid,
          'limit': limit,
        }
    );
  }


  /// 獲取的列表
  Future<Response> prayers_list({
    int cateid = 0,
    int pageid = 1,
    int limit = 20,
    String search_by_title = '',
    int eland_id = 0,
    int userid = 0,
  }) {
   // print('userid======>${userid}');
   // print('eland_id======>${eland_id}');
    return _dio.post(
        G.prdapi+'/eland-prayers-list',
//        '/article-like-list',
        queryParameters: {
          'cateid': cateid,
          'page': pageid,
          'limit': limit,
          'search_by_title': search_by_title,
          'eland_id': eland_id,
          'user_id': userid
        }
    );
  }

  /// 获取祈祷详情
  Future<Response> prayers_detail({
    @required int id,
    int userid = 0,
  }) {
    print('prayers_detail====>${id}');
    print('user_id====>${userid}');
    return _dio.post(
        G.prdapi+'/prayer-detail',
//        '/prayer-detail',
        queryParameters: {
          "id": id,
          'user_id': userid,
        }
    );
  }

  /// 获取文章的用户列表
  Future<Response> prayer_by_user({
    @required int id,
    int userid = 0,
  }) {
    print('prayer_by_user====>${id}');
    print('user_id====>${userid}');
    return _dio.post(
        G.prdapi+'/prayer-by-user',
        queryParameters: {
          "id": id,
          "user_id": userid,
//          "limit":50
        }
    );
  }

  /// 獲取eland詳情
  Future<Response> detail({
    @required int eland_id,
    int userid = 0,
  }) {
    print('userid======>${userid}');
    print('elandid======>${eland_id}');
    return _dio.post(
        G.prdapi+'/eland-detail',
//        '/eland-detail',
        queryParameters: {
          'eland_id': eland_id,
          'user_id': userid,
        }
    );
  }

  /// 關注eland
  Future<Response> dofollow({
    @required int eland_id,
    @required int userid,
  }) {
//    print('elanddofollow-elandid======>${eland_id}');
//    print('elanddofollow-userid======>${userid}');
    return _dio.post(
        G.prdapi+'/do-follow-eland',
        queryParameters: {
          'eland_id': eland_id,
          'user_id': userid,
        }
    );
  }

  /// 收藏eland動態內容
  Future<Response> docollect({
    @required int id,
    @required int userid,
    @required int type,
  }) {
//    print('docollect-type=====>${type}');
    print('docollect-id====>${id}');
    print('docollect-user_id====>${userid}');
    print('docollect-type====>${type}');
    return _dio.post(
        G.prdapi+'/do-collect',
//        '/do-collect',
        queryParameters: {
          'id': id,
          'user_id': userid,
          'type': type,
        }
    );
  }

  /// 點擊祈祷
  Future<Response> doprayer({
    @required int id,
    @required int userid,
  }) {
//    print('userid11======>${userid}');
//    print('articleid11======>${articleid}');
    return _dio.post(
//        G.prdapi+'/do-prayer',
        G.prdapi+'/do-prayer',
        queryParameters: {
          'id': id,
          'user_id': userid,
        }
    );
  }

}