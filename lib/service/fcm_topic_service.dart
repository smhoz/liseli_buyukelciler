import 'package:firebase_messaging/firebase_messaging.dart';

/// Service for managing FCM topic subscriptions
///
/// Topics:
/// - 'all_users' - All registered users (used for broadcasting to everyone)
///
/// Note: Badge-specific notifications use token-based messaging, not topics
class FcmTopicService {
  static final FcmTopicService _instance = FcmTopicService._internal();
  factory FcmTopicService() => _instance;
  FcmTopicService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Topic names
  static const String TOPIC_ALL_USERS = 'all_users';

  /// Subscribe user to 'all_users' topic
  /// Call this when user logs in
  Future<void> subscribeUserToTopics(String userId) async {
    try {
      await _subscribeToTopic(TOPIC_ALL_USERS);
    } catch (e) {
      print('❌ Error subscribing to all_users topic: $e');
    }
  }

  /// Unsubscribe user from 'all_users' topic
  /// Call this when user logs out
  Future<void> unsubscribeUserFromAllTopics(String userId) async {
    try {
      await _unsubscribeFromTopic(TOPIC_ALL_USERS);
    } catch (e) {
      print('❌ Error unsubscribing from all_users topic: $e');
    }
  }

  /// Subscribe to a specific topic
  Future<void> _subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
    } catch (e) {
      print('❌ Error subscribing to topic $topic: $e');
      rethrow;
    }
  }

  /// Unsubscribe from a specific topic
  Future<void> _unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
    } catch (e) {
      print('❌ Error unsubscribing from topic $topic: $e');
      rethrow;
    }
  }
}
