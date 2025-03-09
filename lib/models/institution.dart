class Course {
  final String title;
  final String code;
  const Course({required this.title, required this.code});

  factory Course.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'title': String title, 'code': String code} =>
        Course(title: title, code: code),
      _ => throw const FormatException('Failed to load user data')
    };
  }
}
