import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../utils/global.dart';

/// 用户管理相关
class ReqArticle {
  final Dio _dio;

  ReqArticle(this._dio);

  /// 獲取列表
  Future<Response> list({
    int cateid = 0,
    int pageid = 1,
    int limit = 20,
    String search_by_title = '',
    int eland_id = 0,
    int userid = 0,
    bool ishot = false,
  }) {
    print('cateid======>${cateid}');
    print('pageid======>${pageid}');
    print('limit======>${limit}');
    print('search_by_title======>${search_by_title}');
    print('eland_id======>${eland_id}');
    print('userid======>${userid}');
    print('ishot======>${ishot}');
    return _dio.post(
      G.prdapi + '/article-list',
      //        '/article-list',
      queryParameters: {
        'cateid': cateid,
        'page': pageid,
        'limit': limit,
        'search_by_title': search_by_title,
        'eland_id': eland_id,
        'user_id': userid,
        'ishot': ishot,
      },
    );
  }

  /// 獲取喜歡的列表
  Future<Response> like_list({
    int cateid = 0,
    int pageid = 1,
    int limit = 20,
    String search_by_title = '',
    int eland_id = 0,
    int userid = 0,
  }) {
    //    print('cateid======>${cateid}');
    //    print('page======>${pageid}');
    //    print('limit======>${limit}');
    //    print('search_by_title======>${search_by_title}');
    //    print('eland_id======>${eland_id}');
    //    print('user_id======>${userid}');

    return _dio.post(
      G.prdapi + '/article-like-list',
      //        '/article-like-list',
      queryParameters: {
        'cateid': cateid,
        'page': pageid,
        'limit': limit,
        'search_by_title': search_by_title,
        'eland_id': eland_id,
        'user_id': userid,
      },
    );
  }

  /// 點擊喜歡
  Future<Response> dolike({required int articleid, required int userid}) {
    print('dolike-articleid====>${articleid}');
    print('dolike-user_id====>${userid}');
    return _dio.post(
      G.prdapi + '/do-like',
      //        '/do-like',
      queryParameters: {'articleid': articleid, 'user_id': userid},
    );
  }

  /// 获取详情
  Future<Response> detail({required int id, int userid = 0}) {
    print('article-detail====>${id}');
    print('article-user_id====>${userid}');
    return _dio.post(
      G.prdapi + '/article-detail',
      //        '/article-detail',
      queryParameters: {"id": id, 'user_id': userid},
    );
  }

  /// 點擊报告
  Future<Response> report({required int articleid, required int userid}) {
    return _dio.post(
      G.prdapi + '/do-report',
      //        '/do-like',
      queryParameters: {'articleid': articleid, 'user_id': userid},
    );
  }

  /// 點擊报告
  Future<Response> reportArticle({
    required int articleid,
    required int userid,
    required String content,
    required String name,
    required String phone,
    required String email,
    required String shop,
  }) {
    return _dio.post(
      G.prdapi + '/report-article',
      //        '/do-like',
      queryParameters: {
        'articleid': articleid,
        'user_id': userid,
        'content': content,
        'name': name,
        'phone': phone,
        'email': email,
        'shop': shop,
      },
    );
  }

  /// 獲取評論
  Future<Response> comment({
    @required int articleid,
    @required int userid,
    int pageid = 1,
    int limit = 20,
  }) {
    return _dio.post(
      G.prdapi + '/comment-list',
      queryParameters: {
        'articleid': articleid,
        'user_id': userid,
        'page': pageid,
        'limit': limit,
      },
    );
  }

  /// 提交評論
  Future<Response> add_comment({
    @required int articleid,
    @required int userid,
    @required String textStr,
  }) {
    return _dio.post(
      G.prdapi + '/add-comment',
      queryParameters: {
        'articleid': articleid,
        'user_id': userid,
        'text': textStr,
      },
    );
  }

  /// 點贊評論
  Future<Response> do_like_comment({
    @required int articleid,
    @required int userid,
    @required int comment_id,
    @required int to_userid,
  }) {
    return _dio.post(
      G.prdapi + '/do-like-comment',
      queryParameters: {
        'articleid': articleid,
        'user_id': userid,
        'comment_id': comment_id,
        'to_userid': to_userid,
      },
    );
  }

  /// 回復評論
  Future<Response> reply_comment({
    @required int articleid,
    @required int userid,
    @required int comment_id,
    @required int to_userid,
    @required String textStr,
  }) {
    return _dio.post(
      G.prdapi + '/reply-comment',
      queryParameters: {
        'articleid': articleid,
        'user_id': userid,
        'comment_id': comment_id,
        'to_userid': to_userid,
        'text': textStr,
      },
    );
  }

  /// 獲取回復評論列表
  Future<Response> reply_comment_list({
    @required int articleid,
    @required int userid,
    @required int comment_id,
    int pageid = 1,
    int limit = 20,
  }) {
    return _dio.post(
      G.prdapi + '/reply-comment-list',
      queryParameters: {
        'articleid': articleid,
        'user_id': userid,
        'comment_id': comment_id,
      },
    );
  }
}
