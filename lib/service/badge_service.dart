import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sosyal_medya/auth/firebase_auth/auth_util.dart';
import 'package:sosyal_medya/backend/schema/badge_model/badge_model.dart';
import 'package:sosyal_medya/service/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BadgeService {
  static final BadgeService _instance = BadgeService._internal();
  factory BadgeService() => _instance;
  BadgeService._internal();

  final NotificationService _notificationService = NotificationService();

  /// İlk aktivite paylaşımı için rozet kontrol et ve ver
  Future<void> checkAndAwardFirstActivityBadge() async {
    try {
      if (currentUserReference == null) return;

      // Kullanıcının daha önce aktivite paylaşıp paylaşmadığını kontrol et
      final userActivitiesQuery = await FirebaseFirestore.instance
          .collection('user_posts')
          .where('post_user', isEqualTo: currentUserReference)
          .where('post_is_activity', isEqualTo: true)
          .get();

      // İlk aktivite ise rozet ver
      if (userActivitiesQuery.docs.length == 1) {
        await _awardFirstActivityBadge();
      }
    } catch (e) {
      print('İlk aktivite rozet kontrol hatası: $e');
    }
  }

  /// İlk paylaşım için rozet kontrol et ve ver
  Future<void> checkAndAwardFirstPostBadge() async {
    try {
      if (currentUserReference == null) return;

      // Kullanıcının daha önce post paylaşıp paylaşmadığını kontrol et
      final userPostsQuery = await FirebaseFirestore.instance
          .collection('user_posts')
          .where('post_user', isEqualTo: currentUserReference)
          .where('post_is_activity', isEqualTo: false)
          .get();

      // İlk paylaşım ise rozet ver
      if (userPostsQuery.docs.length == 1) {
        await _awardFirstPostBadge();
      }
    } catch (e) {
      print('İlk paylaşım rozet kontrol hatası: $e');
    }
  }

  /// İlk hikaye için rozet kontrol et ve ver
  Future<void> checkAndAwardFirstStoryBadge() async {
    try {
      if (currentUserReference == null) return;

      // Kullanıcının daha önce hikaye paylaşıp paylaşmadığını kontrol et
      final userStoriesQuery = await FirebaseFirestore.instance
          .collection('user_stories')
          .where('user', isEqualTo: currentUserReference)
          .get();

      // İlk hikaye ise rozet ver
      if (userStoriesQuery.docs.length == 1) {
        await _awardFirstStoryBadge();
      }
    } catch (e) {
      print('İlk hikaye rozet kontrol hatası: $e');
    }
  }

  /// İlk aktivite rozeti ver
  Future<void> _awardFirstActivityBadge() async {
    try {
      // "İlk Aktivite" rozetini bul
      final badgeQuery = await FirebaseFirestore.instance
          .collection('badge')
          .where('name', isEqualTo: 'İlk Aktivite')
          .where('is_deleted', isEqualTo: false)
          .limit(1)
          .get();

      if (badgeQuery.docs.isEmpty) {
        print('İlk Aktivite rozeti bulunamadı');
        return;
      }

      final badgeDoc = badgeQuery.docs.first;
      final badgeId = badgeDoc.id;

      // Kullanıcının bu rozeti zaten sahip olup olmadığını kontrol et
      final currentUser =
          await FirebaseFirestore.instance.collection('users').doc(currentUserUid).get();

      if (currentUser.exists) {
        final userData = currentUser.data() as Map<String, dynamic>;
        final currentBadges = userData['badges'];

        // Badges'i list olarak al (backward compatibility)
        List<String> badgesList = [];
        if (currentBadges is String && currentBadges.isNotEmpty) {
          badgesList = [currentBadges];
        } else if (currentBadges is List) {
          badgesList = currentBadges.cast<String>();
        }

        // Eğer kullanıcının bu rozeti yoksa ver
        if (!badgesList.contains(badgeId)) {
          await FirebaseFirestore.instance.collection('users').doc(currentUserUid).update({
            'badges': FieldValue.arrayUnion([badgeId]),
            'is_badge': true,
          });

          // Rozet verildiğinde bildirim gönder
          await _sendBadgeNotification(badgeDoc.data());
        }
      }
    } catch (e) {
      print('İlk aktivite rozet verme hatası: $e');
    }
  }

  /// İlk paylaşım rozeti ver
  Future<void> _awardFirstPostBadge() async {
    try {
      // "İlk Paylaşım" rozetini bul
      final badgeQuery = await FirebaseFirestore.instance
          .collection('badge')
          .where('name', isEqualTo: 'İlk Paylaşım')
          .where('is_deleted', isEqualTo: false)
          .limit(1)
          .get();

      if (badgeQuery.docs.isEmpty) {
        print('İlk Paylaşım rozeti bulunamadı');
        return;
      }

      final badgeDoc = badgeQuery.docs.first;
      final badgeId = badgeDoc.id;

      // Kullanıcının bu rozeti zaten sahip olup olmadığını kontrol et
      final currentUser =
          await FirebaseFirestore.instance.collection('users').doc(currentUserUid).get();

      if (currentUser.exists) {
        final userData = currentUser.data() as Map<String, dynamic>;
        final currentBadges = userData['badges'];

        // Badges'i list olarak al (backward compatibility)
        List<String> badgesList = [];
        if (currentBadges is String && currentBadges.isNotEmpty) {
          badgesList = [currentBadges];
        } else if (currentBadges is List) {
          badgesList = currentBadges.cast<String>();
        }

        // Eğer kullanıcının bu rozeti yoksa ver
        if (!badgesList.contains(badgeId)) {
          await FirebaseFirestore.instance.collection('users').doc(currentUserUid).update({
            'badges': FieldValue.arrayUnion([badgeId]),
            'is_badge': true,
          });

          // Rozet verildiğinde bildirim gönder
          await _sendBadgeNotification(badgeDoc.data());
        }
      }
    } catch (e) {
      print('İlk paylaşım rozet verme hatası: $e');
    }
  }

  /// İlk hikaye rozeti ver
  Future<void> _awardFirstStoryBadge() async {
    try {
      // "Sosyal Kelebek" rozetini bul (hikaye için)
      final badgeQuery = await FirebaseFirestore.instance
          .collection('badge')
          .where('name', isEqualTo: 'Sosyal Kelebek')
          .where('is_deleted', isEqualTo: false)
          .limit(1)
          .get();

      if (badgeQuery.docs.isEmpty) {
        print('Sosyal Kelebek rozeti bulunamadı');
        return;
      }

      final badgeDoc = badgeQuery.docs.first;
      final badgeId = badgeDoc.id;

      // Kullanıcının bu rozeti zaten sahip olup olmadığını kontrol et
      final currentUser =
          await FirebaseFirestore.instance.collection('users').doc(currentUserUid).get();

      if (currentUser.exists) {
        final userData = currentUser.data() as Map<String, dynamic>;
        final currentBadges = userData['badges'];

        // Badges'i list olarak al (backward compatibility)
        List<String> badgesList = [];
        if (currentBadges is String && currentBadges.isNotEmpty) {
          badgesList = [currentBadges];
        } else if (currentBadges is List) {
          badgesList = currentBadges.cast<String>();
        }

        // Eğer kullanıcının bu rozeti yoksa ver
        if (!badgesList.contains(badgeId)) {
          await FirebaseFirestore.instance.collection('users').doc(currentUserUid).update({
            'badges': FieldValue.arrayUnion([badgeId]),
            'is_badge': true,
          });

          // Rozet verildiğinde bildirim gönder
          await _sendBadgeNotification(badgeDoc.data());
        }
      }
    } catch (e) {
      print('İlk hikaye rozet verme hatası: $e');
    }
  }

  /// Rozet kazanıldığında bildirim gönder
  Future<void> _sendBadgeNotification(Map<String, dynamic> badgeData) async {
    try {
      final badge = BadgeModel.fromJson(badgeData);

      // Lokal bildirim gönder
      await _sendLocalNotification(badge);

      // FCM bildirimi gönder (eğer token varsa)
      await _sendFCMNotification(badge);
    } catch (e) {
      print('Rozet bildirim gönderme hatası: $e');
    }
  }

  /// Lokal bildirim gönder
  Future<void> _sendLocalNotification(BadgeModel badge) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'badge_channel',
        'Rozet Bildirimleri',
        channelDescription: 'Yeni rozet kazanım bildirimleri',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        '🏆 Yeni Rozet Kazandın!',
        '${badge.name} rozetini kazandın! Tebrikler! 🎉',
        platformChannelSpecifics,
      );
    } catch (e) {
      print('Lokal bildirim gönderme hatası: $e');
    }
  }

  /// FCM bildirimi gönder
  Future<void> _sendFCMNotification(BadgeModel badge) async {
    try {
      // FCM token al
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null) return;

      // Access token al
      final accessToken = await _notificationService.getAccessToken();

      // FCM API'ye bildirim gönder
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/v1/projects/liseli-buyukelciler-db/messages:send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'message': {
            'token': fcmToken,
            'notification': {
              'title': '🏆 Yeni Rozet Kazandın!',
              'body': '${badge.name} rozetini kazandın! Tebrikler! 🎉',
            },
            'data': {
              'badge_id': badge.id,
              'badge_name': badge.name,
              'type': 'badge_earned',
            },
            'android': {
              'notification': {
                'channel_id': 'badge_channel',
                'priority': 'high',
                'notification_priority': 'PRIORITY_MAX',
              }
            }
          }
        }),
      );

      if (response.statusCode == 200) {
        print('FCM bildirimi başarıyla gönderildi');
      } else {
        print('FCM bildirim hatası: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('FCM bildirim gönderme hatası: $e');
    }
  }

  /// Genel rozet verme fonksiyonu
  Future<void> awardBadge(String badgeName) async {
    try {
      if (currentUserReference == null) return;

      // Rozeti bul
      final badgeQuery = await FirebaseFirestore.instance
          .collection('badge')
          .where('name', isEqualTo: badgeName)
          .where('is_deleted', isEqualTo: false)
          .limit(1)
          .get();

      if (badgeQuery.docs.isEmpty) {
        print('$badgeName rozeti bulunamadı');
        return;
      }

      final badgeDoc = badgeQuery.docs.first;
      final badgeId = badgeDoc.id;

      // Kullanıcının bu rozeti zaten sahip olup olmadığını kontrol et
      final currentUser =
          await FirebaseFirestore.instance.collection('users').doc(currentUserUid).get();

      if (currentUser.exists) {
        final userData = currentUser.data() as Map<String, dynamic>;
        final currentBadges = userData['badges'];

        // Badges'i list olarak al (backward compatibility)
        List<String> badgesList = [];
        if (currentBadges is String && currentBadges.isNotEmpty) {
          badgesList = [currentBadges];
        } else if (currentBadges is List) {
          badgesList = currentBadges.cast<String>();
        }

        // Eğer kullanıcının bu rozeti yoksa ver
        if (!badgesList.contains(badgeId)) {
          await FirebaseFirestore.instance.collection('users').doc(currentUserUid).update({
            'badges': FieldValue.arrayUnion([badgeId]),
            'is_badge': true,
          });

          // Rozet verildiğinde bildirim gönder
          await _sendBadgeNotification(badgeDoc.data());
        }
      }
    } catch (e) {
      print('Rozet verme hatası: $e');
    }
  }
}
