class Urls {
  static String GET_SUPPORTED_COUNTRIES =
      "/api/v1/internationalization/supported-countries/";
  static String GET_CITIES = '/api/v1/internationalization/cities/';
  static String LOGIN_GENERATE_OTP = "/api/v1/user/otp/generate/";
  static String LOGIN_CONFIRM_OTP = "/api/v1/user/otp/confirm/";
  static String UPDATE_USER_PROFILE = "/api/v1/user/profile/update/";
  static String GET_MARKETS = "/api/v1/core/markets/";
  static String GET_USER_DELIVERY_ADDRESSES =
      "/api/v1/delivery/delivery-addresses/";
  static String ADD_USER_DELIVERY_ADDRESS =
      "/api/v1/delivery/delivery-addresses/";
  static String Function(int) UPDATE_DELIVERY_ADDRESS =
      (int id) => "/api/v1/delivery/delivery-address/$id/update/";
  static String Function(int) SET_DEFAULT_DELIVERY_ADDRESS =
      (int id) => "/api/v1/delivery/delivery-address/$id/set-default/";
}
