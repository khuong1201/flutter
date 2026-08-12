import 'package:dio/dio.dart';

class ApiResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data != null && response.data is Map<String, dynamic>) {
      final mapData = response.data as Map<String, dynamic>;
      
      // If the response follows our standard {code, message, data} structure
      if (mapData.containsKey('code')) {
        final code = mapData['code'];
        
        if (code == 'SUCCESS') {
          // Unwrap the 'data' field so Repositories can use response.data directly
          if (mapData.containsKey('data')) {
            response.data = mapData['data'];
          } else {
            // Some successful APIs might not return data (e.g. POST /complete)
            response.data = null;
          }
          return handler.next(response);
        } else {
          // The API returned 200 OK but code is not SUCCESS. Treat as an error.
          final error = DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            error: mapData['message'],
          );
          return handler.reject(error);
        }
      }
    }
    
    // Pass through if it doesn't match the standard wrapper
    return handler.next(response);
  }
}
