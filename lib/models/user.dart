class Token {
  final String refresh;
  final String access;

  const Token({required this.refresh, required this.access});

  factory Token.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'access': String access,
        'refresh': String refresh,
      } =>
        Token(refresh: refresh, access: access),
      _ => throw const FormatException('Failed to load token data')
    };
  }
}

class User {
  final String email;
  final Map<String, dynamic>? student;
  final Map<String, dynamic>? teacher;
  const User(
      {required this.email, required this.student, required this.teacher});

  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'email': String email,
        'student': Map<String, dynamic> student,
        'teacher': Map<String, dynamic> teacher
      } =>
        User(email: email, student: student, teacher: teacher),
      _ => throw const FormatException('Failed to load user data')
    };
  }
}
