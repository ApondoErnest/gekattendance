import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gekattendance/constants/common.dart';
import 'package:gekattendance/models/user.dart';
import 'package:gekattendance/providers/user_provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

Future<String> getAccessToken() async {
  const storage = FlutterSecureStorage();
  return await storage.read(key: CommonHash.ACCESS_TOKEN_KEY) ?? '';
}

User getUserFromToken(String jwtToken) {
  Map<String, dynamic> tokenData = JwtDecoder.decode(jwtToken);
  Map<String, dynamic> userData = tokenData["user_data"];
  User user = User(
      email: userData['email'],
      student: userData['student'],
      teacher: userData['teacher']);
  return user;
}

bool isStudent(User user) {
  return user.student != null && user.student!.isNotEmpty;
}

bool isTeacher(User user) {
  return user.teacher != null && user.teacher!.isNotEmpty;
}

bool isStudentRegistrationComplete(User user) {
  return user.student != null &&
      user.student!.containsKey('matricule') &&
      user.student!.containsKey('front_face') &&
      user.student!['front_face'] != null &&
      user.student!.containsKey('right_face') &&
      user.student!['right_face'] != null &&
      user.student!.containsKey('right_face') &&
      user.student!['right_face'] != null;
}

bool isStudentMatriculeComplete(User user) {
  return user.student != null &&
      user.student!.containsKey('matricule') &&
      (user.student!['matricule'] as String).isNotEmpty;
}

String determineStartRoute(User user, {String? role}) {
  if (role != null && role == 'teacher' && isTeacher(user)) {
    return '/teacher/dashboard';
  } else if (isStudent(user)) {
    if (isStudentRegistrationComplete(user)) {
      return '/student/dashboard';
    } else if (isStudentMatriculeComplete(user)) {
      return '/student/register/face';
    } else {
      return '/auth/register/matricule';
    }
  }
  return '/student/dashboard/incomplete';
}

Future<void> logout() async {
  const storage = FlutterSecureStorage();
  await storage.delete(key: CommonHash.ACCESS_TOKEN_KEY);
  await storage.delete(key: CommonHash.REFRESH_TOKEN_KEY);
}

User saveUserTokenAndUpdateUser(BuildContext context, Token token) {
  const storage = FlutterSecureStorage();
  storage.write(key: CommonHash.ACCESS_TOKEN_KEY, value: token.access);
  storage.write(key: CommonHash.REFRESH_TOKEN_KEY, value: token.refresh);
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final user = getUserFromToken(token.access);
  userProvider.setUser(user);
  return user;
}

Future<XFile?> urlToXFile(String fileUrl) async {
  try {
    Dio dio = Dio();

    // Get temporary directory
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/${fileUrl.split('/').last}';

    // Download file using Dio
    await dio.download(fileUrl, filePath);

    return XFile(filePath);
  } catch (e) {
    debugPrint('Error downloading file: $e');
    return null;
  }
}

String getCurrentDate() {
  // Get the current date
  DateTime now = DateTime.now();

  // Format the date to a string (e.g., "YYYY-MM-DD")
  String formattedDate =
      "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

  return formattedDate;
}
