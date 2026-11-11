import 'package:url_launcher/url_launcher.dart';

class UrlService {
  static Future<void> open(String url, {bool newTab = true}) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final mode = newTab
        ? LaunchMode.externalApplication
        : LaunchMode.platformDefault;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: mode);
    }
  }

  static Future<void> openEmail(String address, {String? subject}) async {
    final uri = Uri(
      scheme: 'mailto',
      path: address,
      queryParameters: subject != null ? {'subject': subject} : null,
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
