import 'package:dio/dio.dart';
import 'package:gekattendance/services/navigation_service.dart';
import 'package:gekattendance/utils/common.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://192.168.1.149:8000/',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // 🛠️ Add Interceptor to Automatically Inject Token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await getAccessToken();
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ Response: ${response.statusCode} ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print('❌ Error: ${e.response?.statusCode} ${e.message}');
          if (e.response?.statusCode == 401) {
            NavigationService.navigatorKey.currentState!
                .popAndPushNamed("/auth/login");
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> get(String path) async {
    return await _dio.get(path);
  }

  Future<Response> post(String path, dynamic data, {options}) async {
    return await _dio.post(path, data: data, options: options);
  }

  Future<Response> patch(String path, dynamic data) async {
    return await _dio.patch(path, data: data);
  }

  Future<Response> delete(String path, dynamic data) async {
    return await _dio.delete(path, data: data);
  }
}
