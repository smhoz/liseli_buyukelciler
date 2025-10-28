import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MailSenderService {
  final BuildContext context;

  MailSenderService(this.context);

  Future<void> sendTemplateEmail(String email) async {
    final url = Uri.parse('https://api.mailersend.com/v1/email');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization':
              'Bearer mlsn.d153cdd6163507a2611cdb5857c3b95135dff2ce3192d47632a0d3741827c3db',
          'Content-Type': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
          'Access-Control-Allow-Origin': '*',
        },
        body: jsonEncode({
          "from": {
            "email": "MS_AK6xqd@test-51ndgwvzk3qlzqx8.mlsender.net",
            "name": "Liseli Büyükelçiler Mezun Derneği",
          },
          "to": [
            {"email": "buyukelcilerliseli@gmail.com"},
          ],
          "subject": "Liseli Büyükelçiler Mezun Derneği",
          "personalization": [
            {
              "email": 'buyukelcilerliseli@gmail.com',
              "data": {
                "user_email": email,
                "date":
                    "${DateTime.now().day.toString().padLeft(2, '0')}.${DateTime.now().month.toString().padLeft(2, '0')}.${DateTime.now().year.toString().padLeft(2, '0')}",
                "status": "Beklemede",
                "send_date":
                    "${DateTime.now().day.toString().padLeft(2, '0')}.${DateTime.now().month.toString().padLeft(2, '0')}.${DateTime.now().year.toString().padLeft(2, '0')}",
                "support_email": "idare@liselibuyukelciler.com",
              },
            },
          ],
          "template_id": "0r83ql3m7v0gzw1j",
        }),
      );

      if (response.statusCode == 202) {
        print('Mail şablon üzerinden gönderildi.');
        // CodeNoahDialogs(context).showFlush(
        //   type: SnackType.success,
        //   message: 'Mail şablon üzerinden gönderildi',
        // );
      } else {
        print('Hata: ${response.statusCode}');
        print('Cevap: ${response.body}');
        // CodeNoahDialogs(
        //   context,
        // ).showFlush(type: SnackType.error, message: 'Cevap: ${response.body}');
      }
    } catch (e) {
      // CodeNoahDialogs(
      //   context,
      // ).showFlush(type: SnackType.error, message: 'Cevap: ${e}');
      print('Hata: $e');
    }
  }
}
