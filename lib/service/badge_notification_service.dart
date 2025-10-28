import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:sosyal_medya/service/notification_service.dart';
import 'package:sosyal_medya/service/fcm_topic_service.dart';

/// Service for sending bulk notifications to users based on badges
///
/// Uses FCM Topic Messaging for efficient bulk notifications:
/// - For large groups (>50 users): Uses topic-based messaging (single HTTP request)
/// - For small groups (<50 users): Uses token-based messaging (individual requests)
///
/// This hybrid approach optimizes for both speed and reliability.
class BadgeNotificationService {
  static final BadgeNotificationService _instance = BadgeNotificationService._internal();
  factory BadgeNotificationService() => _instance;
  BadgeNotificationService._internal();

  final NotificationService _notificationService = NotificationService();

  // Threshold for switching between token-based and topic-based messaging
  static const int TOPIC_THRESHOLD = 50;

  /// Send notification to all users who have specific badges
  ///
  /// [badgeIds] - List of badge IDs to filter users
  /// [title] - Notification title
  /// [body] - Notification body/message
  /// [additionalData] - Optional additional data to send with notification
  /// [minVersion] - Optional minimum app version filter (e.g., "1.0.0")
  /// [onProgress] - Optional callback for progress updates (current, total)
  ///
  /// Returns a map with success count and failed count
  ///
  /// Uses hybrid approach:
  /// - If badgeIds is empty (all users): Uses 'all_users' topic (FAST!)
  /// - Otherwise: Uses token-based messaging (for badge filtering)
  Future<Map<String, int>> sendNotificationToBadgeHolders({
    required Set<String> badgeIds,
    required String title,
    required String body,
    Map<String, dynamic>? additionalData,
    String? minVersion,
    Function(int current, int total)? onProgress,
  }) async {
    try {
      // Get access token for FCM
      final accessToken = await _notificationService.getAccessToken();

      // Case 1: Send to ALL users (use 'all_users' topic)
      if (badgeIds.isEmpty) {
        print('📊 Sending to ALL users via topic: ${FcmTopicService.TOPIC_ALL_USERS}');
        final success = await _sendToTopic(
          topic: FcmTopicService.TOPIC_ALL_USERS,
          title: title,
          body: body,
          badgeIds: badgeIds,
          additionalData: additionalData,
          accessToken: accessToken,
        );
        return success ? {'success': 1, 'failed': 0} : {'success': 0, 'failed': 1};
      }

      // Case 2: Badge filtering - use token-based messaging
      print('📊 Badge filtering selected, using token-based messaging');
      return await _sendToTokens(
        badgeIds: badgeIds,
        title: title,
        body: body,
        additionalData: additionalData,
        minVersion: minVersion,
        accessToken: accessToken,
        onProgress: onProgress,
      );
    } catch (e) {
      print('❌ Toplu bildirim gönderme hatası: $e');
      return {'success': 0, 'failed': 1};
    }
  }

  /// Send notification to a topic
  Future<bool> _sendToTopic({
    required String topic,
    required String title,
    required String body,
    required Set<String> badgeIds,
    Map<String, dynamic>? additionalData,
    required String accessToken,
  }) async {
    try {
      final payload = {
        'message': {
          'topic': topic,
          'notification': {
            'title': title,
            'body': body,
          },
          'data': {
            'type': 'badge_notification',
            'badge_ids': badgeIds.join(','),
            ...?additionalData,
          },
          'android': {
            'priority': 'high',
            'notification': {
              'channel_id': 'badge_channel',
            }
          },
          'apns': {
            'headers': {
              'apns-priority': '10',
            },
            'payload': {
              'aps': {
                'sound': 'default',
                'badge': 1,
              }
            }
          }
        }
      };

      print('📤 Gönderilen FCM Topic Payload:');
      print(jsonEncode(payload));

      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/v1/projects/liseli-buyukelciler-db/messages:send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(payload),
      );

      print('📤 FCM Response Status: ${response.statusCode}');
      print('📤 FCM Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Topic bildirimi başarıyla gönderildi: $topic');
        return true;
      } else {
        print('❌ Topic bildirimi gönderilemedi: $topic - ${response.statusCode}');
        print('   Hata: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Topic bildirim gönderme hatası: $e');
      return false;
    }
  }

  /// Send notification to individual tokens (for multiple badge selection)
  /// Uses PARALLEL requests for maximum speed
  Future<Map<String, int>> _sendToTokens({
    required Set<String> badgeIds,
    required String title,
    required String body,
    Map<String, dynamic>? additionalData,
    String? minVersion,
    required String accessToken,
    Function(int current, int total)? onProgress,
  }) async {
    try {
      // Get all users
      final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();

      // Filter users based on badge selection and version
      final targetUsers = usersSnapshot.docs.where((userDoc) {
        final userData = userDoc.data();
        final userBadges = userData['badges'];

        // Handle both String and List<String> formats (backward compatibility)
        List<String> badgesList = [];
        if (userBadges is String && userBadges.isNotEmpty) {
          badgesList = [userBadges];
        } else if (userBadges is List) {
          badgesList = userBadges.cast<String>();
        }

        // Check if user has any of the selected badges (OR logic)
        final hasMatchingBadge = badgesList.any((badgeId) => badgeIds.contains(badgeId));
        if (!hasMatchingBadge) return false;

        // Filter by minimum version if specified
        if (minVersion != null && minVersion.isNotEmpty) {
          final userVersion = userData['app_version'] as String?;

          // Skip users without version or with lower version
          if (userVersion == null || !_isVersionGreaterOrEqual(userVersion, minVersion)) {
            return false;
          }
        }

        return true;
      }).toList();

      print('📊 Hedef kullanıcı sayısı: ${targetUsers.length}');

      // Create list of futures for parallel execution
      final List<Future<bool>> notificationFutures = [];

      for (final userDoc in targetUsers) {
        final userData = userDoc.data();
        final fcmToken = userData['fcm_token'] as String?;

        if (fcmToken == null || fcmToken.isEmpty) {
          print('⚠️  Kullanıcı ${userDoc.id} için FCM token yok');
          continue;
        }

        // Add each notification request to the futures list
        notificationFutures.add(
          _sendSingleNotification(
            fcmToken: fcmToken,
            title: title,
            body: body,
            badgeIds: badgeIds,
            additionalData: additionalData,
            accessToken: accessToken,
            userName: userData['display_name'] ?? 'Unknown',
          ),
        );
      }

      print('🚀 Paralel olarak ${notificationFutures.length} bildirim gönderiliyor...');
      final startTime = DateTime.now();
      final totalCount = notificationFutures.length;

      // Report initial progress (0/total) to show progress bar immediately
      if (onProgress != null) {
        onProgress(0, totalCount);
      }

      // Execute requests with progress tracking
      int completedCount = 0;
      final results = <bool>[];

      for (final future in notificationFutures) {
        final result = await future;
        results.add(result);
        completedCount++;

        // Report progress
        if (onProgress != null) {
          onProgress(completedCount, totalCount);
        }
      }

      final duration = DateTime.now().difference(startTime);

      // Count successes and failures
      final successCount = results.where((success) => success).length;
      final failedCount = results.where((success) => !success).length;

      print(
          '✅ BİLDİRİM TAMAMLANDI: $successCount başarılı, $failedCount başarısız (${duration.inSeconds} saniye)');

      return {
        'success': successCount,
        'failed': failedCount,
      };
    } catch (e) {
      print('❌ Token-based bildirim gönderme hatası: $e');
      return {'success': 0, 'failed': 0};
    }
  }

  /// Send a single notification to a token
  /// Returns true if successful, false otherwise
  Future<bool> _sendSingleNotification({
    required String fcmToken,
    required String title,
    required String body,
    required Set<String> badgeIds,
    Map<String, dynamic>? additionalData,
    required String accessToken,
    required String userName,
  }) async {
    try {
      final payload = {
        'message': {
          'token': fcmToken,
          'notification': {
            'title': title,
            'body': body,
          },
          'data': {
            'type': 'badge_notification',
            'badge_ids': badgeIds.join(','),
            ...?additionalData,
          },
          'android': {
            'priority': 'high',
            'notification': {
              'channel_id': 'badge_channel',
            }
          },
          'apns': {
            'headers': {
              'apns-priority': '10',
            },
            'payload': {
              'aps': {
                'sound': 'default',
                'badge': 1,
              }
            }
          }
        }
      };

      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/v1/projects/liseli-buyukelciler-db/messages:send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        // Don't log individual successes for bulk operations
        return true;
      } else {
        print('❌ Bildirim gönderilemedi: $userName - ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Bildirim gönderme hatası ($userName): $e');
      return false;
    }
  }

  /// Send notification to all users who have ANY badges
  /// Uses token-based messaging with PARALLEL requests
  Future<Map<String, int>> sendNotificationToAllBadgeHolders({
    required String title,
    required String body,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      // Get access token for FCM
      final accessToken = await _notificationService.getAccessToken();

      // Get all users who have badges
      final usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('is_badge', isEqualTo: true)
          .get();

      print('📊 Hedef kullanıcı sayısı (rozet sahipleri): ${usersSnapshot.docs.length}');

      // Create list of futures for parallel execution
      final List<Future<bool>> notificationFutures = [];

      for (final userDoc in usersSnapshot.docs) {
        final userData = userDoc.data();
        final fcmToken = userData['fcm_token'] as String?;

        if (fcmToken == null || fcmToken.isEmpty) {
          print('⚠️  Kullanıcı ${userDoc.id} için FCM token yok');
          continue;
        }

        // Add each notification request to the futures list
        notificationFutures.add(
          _sendSingleNotification(
            fcmToken: fcmToken,
            title: title,
            body: body,
            badgeIds: {}, // Empty set for "all badge holders"
            additionalData: additionalData,
            accessToken: accessToken,
            userName: userData['display_name'] ?? 'Unknown',
          ),
        );
      }

      print('🚀 Paralel olarak ${notificationFutures.length} bildirim gönderiliyor...');
      final startTime = DateTime.now();

      // Execute all requests in parallel
      final results = await Future.wait(notificationFutures);

      final duration = DateTime.now().difference(startTime);

      // Count successes and failures
      final successCount = results.where((success) => success).length;
      final failedCount = results.where((success) => !success).length;

      print(
          '✅ BİLDİRİM TAMAMLANDI: $successCount başarılı, $failedCount başarısız (${duration.inSeconds} saniye)');

      return {
        'success': successCount,
        'failed': failedCount,
      };
    } catch (e) {
      print('❌ Badge holders bildirim gönderme hatası: $e');
      return {'success': 0, 'failed': 0};
    }
  }

  /// Compare two version strings (e.g., "1.2.3" vs "1.0.0")
  /// Returns true if userVersion >= minVersion
  bool _isVersionGreaterOrEqual(String userVersion, String minVersion) {
    try {
      final userParts = userVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();
      final minParts = minVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();

      // Pad with zeros if needed
      while (userParts.length < 3) userParts.add(0);
      while (minParts.length < 3) minParts.add(0);

      // Compare major.minor.patch
      for (int i = 0; i < 3; i++) {
        if (userParts[i] > minParts[i]) return true;
        if (userParts[i] < minParts[i]) return false;
      }

      // Equal
      return true;
    } catch (e) {
      print('❌ Versiyon karşılaştırma hatası: $e');
      return false;
    }
  }
}
