import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:gekattendance/api/client.dart';
import 'package:gekattendance/api/urls.dart';
import 'package:gekattendance/models/institution.dart';
import 'package:gekattendance/utils/common.dart';

final api = ApiClient();
Future<List<Course>> getTeacherCourses() async {
  try {
    final response = await api.get(Urls.TEACHER_COURSES);

    if (response.statusCode == 200) {
      List<dynamic> data = response.data;
      return data.map((course) => Course.fromJson(course)).toList();
    } else {
      throw Exception(response.statusMessage);
    }
  } on DioException catch (e) {
    if (e.response != null && e.response!.statusCode == 400) {
      // Extract response body when status is 400
      return Future.error(e.response!.data);
    } else {
      // Handle other errors (network issues, timeouts, etc.)
      return Future.error(e.message ?? "An error occurred");
    }
  }
}

Future<Course> initiateAttendance(XFile video, String courseCode) async {
  try {
    // 1. Prepare the form data
    FormData formData = FormData.fromMap({
      'course_code': courseCode,
      'video': await MultipartFile.fromFile(video.path, filename: video.name),
    });

    // 2. Make the POST request with the form data
    final response = await api.post(
      Urls.TEACHER_SUBMIT_ATTENDANCE,
      formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data['message'];
    } else {
      throw response.data['message'] ??
          'Upload failed with status code ${response.statusCode}';
    }
  } on DioException catch (e) {
    if (e.response != null) {
      throw e.response!.data['message'] ??
          'Upload failed: ${e.response!.statusCode}';
    } else {
      throw 'Network error: ${e.message}';
    }
  } catch (e) {
    throw 'An unexpected error occurred: $e';
  }
}

Future<List<Course>> getCourseAttendance(String courseCode) async {
  try {
    //hell
    //hel
    final response = await api.get(
        "${Urls.TEACHER_COURSE_ATTENDANCE}?date=${getCurrentDate()}&course_code=$courseCode");
    if (response.statusCode == 200) {
      print('####### attendance ${response.data}');
      List<dynamic> data = response.data;
      return data.map((course) => Course.fromJson(course)).toList();
    } else {
      throw Exception(response.statusMessage);
    }
  } on DioException catch (e) {
    if (e.response != null && e.response!.statusCode == 400) {
      // Extract response body when status is 400
      return Future.error(e.response!.data);
    } else {
      // Handle other errors (network issues, timeouts, etc.)
      return Future.error(e.message ?? "An error occurred");
    }
  }
}
