import 'package:dio/dio.dart';
import './init_dio.dart';
import './req_user.dart';
import './req_article.dart';
import './req_article_cate.dart';
import './req_search.dart';
import './req_eland.dart';
import './req_setting.dart';

class Request {
  Dio _dio;

  Request() {
    _dio = initDio();
  }

  ReqUser get user => ReqUser(_dio);

  ReqArticle get article => ReqArticle(_dio);

  ReqArticleCate get article_cate => ReqArticleCate(_dio);

  ReqSearch get search => ReqSearch(_dio);

  ReqEland get eland => ReqEland(_dio);

  ReqSetting get setting => ReqSetting(_dio);
  
}