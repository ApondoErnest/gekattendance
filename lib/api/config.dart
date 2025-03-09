final MEDIA_BASE_URL = String.fromEnvironment('API_BASE_URL',
    defaultValue: 'http://192.168.1.149:8000');

String apiUrl(String path) {
  String uri =
      "${const String.fromEnvironment('API_BASE_URL', defaultValue: 'http://192.168.1.149:8000')}$path";
  return uri;
}

String mediaUrl(String path) {
  return "$MEDIA_BASE_URL$path";
}
