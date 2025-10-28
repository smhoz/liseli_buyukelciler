import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';

class NotificationService {
  Future<String> getAccessToken() async {
    final jsonString = await rootBundle.loadString(
        'assets/jsons/liseli-buyukelciler-db-firebase-adminsdk-fbsvc-d071931178.json');
    final jsonMap = json.decode(jsonString);
    final accountCredentials = ServiceAccountCredentials.fromJson(jsonMap);
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    final client = await clientViaServiceAccount(accountCredentials, scopes);
    final accessToken = client.credentials.accessToken.data;
    client.close();

    return accessToken;
  }
}
