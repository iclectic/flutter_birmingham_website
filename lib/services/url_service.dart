import 'package:url_launcher/url_launcher.dart';

class UrlService {
  static Future<void> open(String url, {bool newTab = true}) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final mode = newTab ? LaunchMode.externalApplication : LaunchMode.platformDefault;
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

  static Future<void> addToGoogleCalendar({
    required String title,
    required DateTime start,
    required DateTime end,
    String? location,
    String? description,
  }) async {
    String fmt(DateTime dt) {
      final s = dt.toUtc().toIso8601String();
      return '${s.replaceAll('-', '').replaceAll(':', '').split('.').first}Z';
    }

    final params = <String, String?>{
      'action': 'TEMPLATE',
      'text': title,
      'dates': '${fmt(start)}/${fmt(end)}',
      'location': location,
      'details': description,
    }.entries
        .where((e) => e.value != null)
        .fold<Map<String, String>>({}, (m, e) => m..[e.key] = e.value!);

    final uri = Uri.https('calendar.google.com', '/calendar/render', params);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
