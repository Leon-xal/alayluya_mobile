import '../utils/global.dart';
import 'package:dio/dio.dart';

/// Initializes a Dio instance with robust error handling and request interception.
Dio initDio() {
  final baseOptions = BaseOptions(
    baseUrl: G.prdapi, // Directly use G.prdapi
    connectTimeout: const Duration(milliseconds: 5000), // Add timeout settings
    receiveTimeout: const Duration(milliseconds: 3000), // Add timeout settings
  );

  final dio = Dio(baseOptions);

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) async {
            if (G.user.data!.token != null) {
              options.headers['Authorization'] =
                  'Bearer ${G.user.data!.token}'; //More secure way to add token
            }
            return handler.next(
              options,
            ); // Use handler.next for proper continuation
          },
      onResponse: (Response response, ResponseInterceptorHandler handler) async {
        if (response.statusCode == 200 &&
            response.data is Map &&
            response.data['code'] == 500) {
          await G.toast(response.data['msg'] ?? 'An error occurred');
          //Consider returning a custom response or throwing an error here for better error handling
          return handler.next(response);
        }
        return handler.next(response);
      },
      onError: (DioError e, ErrorInterceptorHandler handler) async {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          await G.toast('Request timed out');
        } else if (e.type == DioExceptionType.unknown) {
          await G.toast('Network error');
          G.getCurrentState().pushNamed('/not_network');
        } else if (e.response != null) {
          final errorMessage =
              e.response?.data?['msg'] ??
              'Server error: ${e.response?.statusCode}';
          await G.toast(errorMessage);
          print(
            'DioError Response: ${e.response}',
          ); //Log the error for debugging
        } else {
          print('DioError: $e'); //Log other errors for debugging
        }
        return handler.next(
          e,
        ); // Allow Dio to handle the error or throw a custom error
      },
    ),
  );

  return dio;
}
