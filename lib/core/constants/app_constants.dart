class AppConstants {
  AppConstants._();

  static const String env = String.fromEnvironment('ENV', defaultValue: 'dev');
  static const String scheme = env == 'prod' ? 'iron-split' : 'iron-split-dev';
  static const String baseUrl = env == 'prod'
      ? 'https://iron-split.web.app'
      : 'https://iron-split-dev.web.app';

  static const int maxUserNameLength = 10;
}
