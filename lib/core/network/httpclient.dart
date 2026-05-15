import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ritika_portfolio/core/config/config.dart';

Future<bool> sendEmail({
  required String name,
  required String email,
  required String message,
}) async {
  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'service_id': Config.emailServiceId,
      'template_id': Config.emailTemplateId,
      'user_id': Config.emailUserId,
      'template_params': {
        'from_name': name,
        'from_email': email,
        'message': message,
      },
    }),
  );

  return response.statusCode == 200;
}
