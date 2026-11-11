abstract final class AppStrings {
  static const String appName = 'Flutter Birmingham';
  static const String shortName = 'Flutter Brum';
  static const String tagline =
      'The Flutter & Dart community for Birmingham and the West Midlands.';
  static const String description =
      'Flutter Birmingham is a free, independent meetup for anyone building '
      'with Flutter and Dart. We get together for talks, hands-on workshops '
      'and good conversation — whether you shipped your first app last week '
      'or have been building with Flutter since the beta.';

  static const List<String> hashtags = [
    '#FlutterBrum',
    '#FlutterDev',
    '#Dart',
    '#ItsAllWidgets',
    '#Birmingham',
  ];

  static const String meetupUrl = 'https://www.meetup.com/flutter-birmingham/';
  static const String linkedInUrl =
      'https://www.linkedin.com/company/146899611/';
  static const String youTubeUrl = 'https://www.youtube.com/@Flutterbrum';
  static const String blueskyUrl =
      'https://bsky.app/profile/flutterbirmingham.bsky.social';
  static const String gitHubUrl =
      'https://github.com/iclectic/flutter_birmingham_website';
  static const String contactEmail = 'flutterbrum@gmail.com';
  static const String conductEmail = contactEmail;
  static const String speakerFormUrl =
      'https://docs.google.com/forms/d/e/1FAIpQLSe4cQX-DFlKlkfnHEaUJeAQFeyw9eUJwqUfRZqhEmno9o-FKA/viewform';

  static const String independentNotice =
      'Flutter Birmingham is an independent community group. Flutter and the '
      'related logo are trademarks of Google LLC. We are not endorsed by or '
      'affiliated with Google LLC.';

  static String get copyright => '© ${DateTime.now().year} Flutter Birmingham';
}
