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
    // Built by hand: Uri.queryParameters encodes spaces as '+', which mail
    // clients show literally.
    final uri = Uri.parse(
      subject == null
          ? 'mailto:$address'
          : 'mailto:$address?subject=${Uri.encodeComponent(subject)}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
