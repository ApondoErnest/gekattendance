import 'package:dio/dio.dart';
import 'package:gekattendance/api/client.dart';
import 'package:gekattendance/api/config.dart';
import 'package:gekattendance/api/urls.dart';
import 'package:gekattendance/models/user.dart';
import 'package:image_picker/image_picker.dart';

final api = ApiClient();
Future<String> loginGenerateOtp(String email) async {
  Map<String, dynamic> requestData = {"email": email};

  try {
    final response = await api.post(Urls.LOGIN_GENERATE_OTP, requestData);

    if (response.statusCode == 201) {
      return response.data['message']; // Assuming response.data is a Map
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

Future<Token?> loginConfirmOtp(String email, String otp) async {
  Map<String, dynamic> requestData = <String, dynamic>{
    "email": email,
    "otp": otp
  };
  final response = await api.post(apiUrl(Urls.LOGIN_CONFIRM_OTP), requestData);
  if (response.statusCode == 200) {
    return Token(
        refresh: response.data['refresh'], access: response.data['access']);
  } else {
    throw Exception(response.data.message);
  }
}

Future<Token?> updateStudentMatricule(String matricule) async {
  Map<String, dynamic> requestData = <String, dynamic>{"matricule": matricule};
  try {
    final response =
        await api.post(apiUrl(Urls.STUDENT_UPDATE_MATRICULE), requestData);
    if (response.statusCode == 200) {
      return Token(
          refresh: response.data['refresh'], access: response.data['access']);
    } else {
      throw Exception(response.data.message);
    }
  } on DioException catch (e) {
    throw e.response!.data['message'] ?? 'Unknown Error Occurred';
  }
}

Future<Token?> uploadStudentFace(XFile faceImage, String direction) async {
  try {
    // 1. Prepare the form data
    FormData formData = FormData.fromMap({
      'direction': direction,
      'face_image': await MultipartFile.fromFile(faceImage.path,
          filename: faceImage.name),
    });

    // 2. Make the POST request with the form data
    final response = await api.post(
      Urls.STUDENT_UPLOAD_FACE,
      formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Token(
          refresh: response.data['refresh'], access: response.data['access']);
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
