import 'package:url_launcher/url_launcher.dart';

class LaunchService {
  static Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> sendEmail(String email, {String? subject, String? body}) async {
    final params = StringBuffer('mailto:$email');
    final parts = <String>[];
    if (subject != null) parts.add('subject=${Uri.encodeComponent(subject)}');
    if (body != null) parts.add('body=${Uri.encodeComponent(body)}');
    if (parts.isNotEmpty) params.write('?${parts.join('&')}');
    await openUrl(params.toString());
  }

  static Future<void> callPhone(String phone) async {
    final clean = phone.replaceAll(' ', '').replaceAll('-', '');
    await openUrl('tel:$clean');
  }
}
