abstract final class AppStrings {
  static const String appName = 'Flutter Birmingham';
  static const String shortName = 'Flutter Brum';
  static const String tagline =
      'A meetup for Flutter and Dart developers in Birmingham and the '
      'West Midlands.';
  static const String description =
      'Flutter Birmingham is a free meetup for anyone who builds with '
      'Flutter and Dart. We get together in Birmingham for talks, '
      'workshops and a good chat afterwards. Maybe you\'ve just '
      'written your first widget. Maybe you\'ve been shipping Flutter '
      'apps for years. Either way, you\'ll fit right in.';

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
  static const String xUrl = 'https://x.com/flutterbrum';
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
