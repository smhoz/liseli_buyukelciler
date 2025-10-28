import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Access token alma fonksiyonu
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

Future<void> saveTokenToSharedPrefs(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('access_token', token);
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized(); // <-- eklenecek
  await Firebase.initializeApp();
  Timer(Duration(seconds: 1), () async {
    try {
      String? accessToken = await FirebaseMessaging.instance.getToken();
      if (accessToken != null) {
        print('İlk Firebase Token: $accessToken');
        await saveTokenToSharedPrefs(accessToken);
      } else {
        print('Token alınamadı, accessToken null');
      }
    } catch (e) {
      print('Token alınırken hata oluştu: $e');
    }

    Timer.periodic(Duration(hours: 1), (timer) async {
      try {
        String? accessToken = await FirebaseMessaging.instance.getToken();
        if (accessToken != null) {
          print('Yeni Firebase Token: $accessToken');
          await saveTokenToSharedPrefs(accessToken);
        } else {
          print('Yeni token alınamadı, accessToken null');
        }
      } catch (e) {
        print('Yeni token alınırken hata oluştu: $e');
      }
    });
  });
}

// iOS arka plan işlemleri
Future<bool> onBackground(ServiceInstance service) async {
  print("Background service running on iOS");
  return true;
}

// Servisi başlatma fonksiyonu
void startBackgroundService() {
  final service = FlutterBackgroundService();

  service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart, // Android için background işlemleri
      isForegroundMode: true, // Servis foregroundda çalışacak
      autoStart: true,
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart, // iOS foreground işlemleri
      onBackground: onBackground, // iOS background işlemleri
      autoStart: true,
    ),
  );

  service.startService(); // Servisi başlatma
}

void main() {
  startBackgroundService(); // Arka plan servisini başlat
}
