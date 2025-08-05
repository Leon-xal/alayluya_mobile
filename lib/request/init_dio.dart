import '../utils/global.dart';
import 'package:dio/dio.dart';
import '../utils/global.dart';

/// 初始化dio
Dio initDio() {
  BaseOptions _baseOptions = BaseOptions(
    //    baseUrl: "http://192.168.31.249/api",
    //    baseUrl: "http://192.168.4.45/api",
    //    baseUrl: "http://192.168.10.101/api",
    //    baseUrl: "http://192.168.1.9/api",
    //    baseUrl: "http://awana.uat4.online/api",
    //     baseUrl: "http://testapi2.alayluya.com/api",
    baseUrl: "${G.prdapi}",
    //    baseUrl: "http://testapi2uat.alayluya.com/api",
  );

  Dio dio = Dio(_baseOptions);
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (RequestOptions options) async {
        //        if(G.user.data != null) {
        //          options.queryParameters['token'] = G.user.data.token;
        //        }

        return options;
        // 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
        // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
        //
        // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
        // 这样请求将被中止并触发异常，上层catchError会被调用。
      },
      onResponse: (Response response) async {
        //        print('resultcode=======>${response.statusCode}');
        //        print('result=======>${response}');
        //        print('result=======>${response.data['code']}');

        //        print('result111=======>${response.data['code']}');
        if (response.statusCode == 200) {
          // 在返回响应数据之前做一些预处理
          if (response.data['code'] == 500) {
            // print('result2=======>${response.data['msg']}');
            await G.toast(response.data['msg']);
            response.data = null;
          }
          return response;
        } else {
          throw Exception('Failed to Response');
        }
      },
      onError: (DioException e) async {
        // G.toast(e.message);
        // 当请求失败时做一些预处理
        // print('dio====>${e}');
        // print('dio1====>${e.response}');
        //        print('dio2====>${e.response.statusCode}');
        //        print('dio3====>${e.response.data}');
        //        print('dio4====>${e.response.data['msg']}');
        if (e.response == null && e.type == DioExceptionType.DEFAULT) {
          print('not_network111====>');
          // G.pushNamed("/not_network");
          G.getCurrentState().pushNamed("/not_network");
        } else {
          print('not_network222====>');
          if (G.isDev == true) {
            G.getCurrentState().pushNamed("/not_network");
          } else {
            return e; //continue
          }
        }
      },
    ),
  );

  return dio;
}
