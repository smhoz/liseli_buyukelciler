import '/backend/backend.dart';
import '/service/system_user_initializer.dart';

class SystemChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Send a system message to users with specific badges
  /// Uses PARALLEL requests for maximum speed
  ///
  /// [badgeIds] - List of badge IDs to filter users
  /// [message] - Message text to send
  /// [eventId] - Optional event ID for event announcement messages
  /// [minVersion] - Optional minimum app version filter (e.g., "1.0.0")
  /// [onProgress] - Optional callback for progress updates (current, total)
  ///
  /// Returns a map with success count, failed count, and list of users with old versions
  Future<Map<String, dynamic>> sendMessageToBadgeHolders({
    required List<String> badgeIds,
    required String message,
    String? eventId,
    String? minVersion,
    Function(int current, int total)? onProgress,
  }) async {
    try {
      // Get system user reference
      final systemUserRef =
          _firestore.collection('users').doc(SystemUserInitializer.SYSTEM_USER_ID);

      // Get all users
      final usersSnapshot = await _firestore.collection('users').get();

      print('📊 Toplam kullanıcı sayısı: ${usersSnapshot.docs.length}');

      // Filter users based on badge selection
      final List<Future<bool>> messageFutures = [];
      final List<Map<String, String>> oldVersionUsers = []; // Users with old app version

      for (var userDoc in usersSnapshot.docs) {
        final userData = userDoc.data();
        final userId = userDoc.id;

        // Skip system user
        if (userId == SystemUserInitializer.SYSTEM_USER_ID) {
          continue;
        }

        // If badgeIds is not empty, filter by badges
        if (badgeIds.isNotEmpty) {
          // Get user badges
          List<String> userBadges = [];
          if (userData['badges'] != null) {
            if (userData['badges'] is List) {
              userBadges = List<String>.from(userData['badges']);
            }
          }

          // Check if user has any of the selected badges (OR logic)
          final hasMatchingBadge = userBadges.any((badgeId) => badgeIds.contains(badgeId));

          if (!hasMatchingBadge) {
            continue;
          }
        }
        // If badgeIds is empty, include all users (no filtering)

        // Filter by minimum version (always use 1.0.0)
        final userVersion = userData['app_version'] as String?;
        if (userVersion == null || !_isVersionGreaterOrEqual(userVersion, '1.0.0')) {
          // Track users with old version
          oldVersionUsers.add({
            'name': userData['display_name'] ?? 'Unknown',
            'email': userData['email'] ?? '',
            'version': userVersion ?? 'Bilinmiyor',
          });
          continue;
        }

        // Add message sending to futures list
        messageFutures.add(
          _sendMessageToUser(
            systemUserRef: systemUserRef,
            userId: userId,
            userName: userData['display_name'] ?? 'Unknown',
            message: message,
            badgeIds: badgeIds,
            eventId: eventId,
          ),
        );
      }

      print('🚀 Paralel olarak ${messageFutures.length} mesaj gönderiliyor...');
      final startTime = DateTime.now();
      final totalCount = messageFutures.length;

      // Report initial progress (0/total) to show progress bar immediately
      if (onProgress != null) {
        onProgress(0, totalCount);
      }

      // Execute requests with progress tracking
      int completedCount = 0;
      final results = <bool>[];

      for (final future in messageFutures) {
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
          '✅ MESAJ TAMAMLANDI: $successCount başarılı, $failedCount başarısız (${duration.inSeconds} saniye)');

      if (oldVersionUsers.isNotEmpty) {
        print('⚠️ Eski versiyon kullanan ${oldVersionUsers.length} kullanıcı mesaj alamadı');
      }

      return {
        'success': successCount,
        'failed': failedCount,
        'oldVersionUsers': oldVersionUsers,
      };
    } catch (e) {
      print('❌ Genel hata: $e');
      return {'success': 0, 'failed': 0, 'oldVersionUsers': []};
    }
  }

  /// Send a message to a single user
  /// Returns true if successful, false otherwise
  Future<bool> _sendMessageToUser({
    required DocumentReference systemUserRef,
    required String userId,
    required String userName,
    required String message,
    required List<String> badgeIds,
    String? eventId,
  }) async {
    try {
      // Get or create system chat for this user
      final userRef = _firestore.collection('users').doc(userId);
      final chatRef = await _getOrCreateSystemChat(systemUserRef, userRef);

      if (chatRef == null) {
        print('❌ Chat oluşturulamadı: $userName');
        return false;
      }

      // Send message
      await _sendSystemMessage(
        chatRef: chatRef,
        systemUserRef: systemUserRef,
        message: message,
        badgeIds: badgeIds,
        eventId: eventId,
      );

      // Don't log individual successes for bulk operations
      return true;
    } catch (e) {
      print('❌ Mesaj gönderme hatası ($userName): $e');
      return false;
    }
  }

  /// Get existing system chat or create a new one
  Future<DocumentReference?> _getOrCreateSystemChat(
    DocumentReference systemUserRef,
    DocumentReference userRef,
  ) async {
    try {
      // Check if system chat already exists
      final existingChats =
          await _firestore.collection('chats').where('users', arrayContains: systemUserRef).get();

      // Find chat with this specific user
      for (var chatDoc in existingChats.docs) {
        final chatData = chatDoc.data();
        final users = List<DocumentReference>.from(chatData['users'] ?? []);

        if (users.contains(userRef)) {
          // Don't log for bulk operations
          return chatDoc.reference;
        }
      }

      // Create new system chat
      final chatRef = _firestore.collection('chats').doc();

      await chatRef.set({
        'users': [systemUserRef, userRef],
        'user_a': systemUserRef,
        'user_b': userRef,
        'last_message': '',
        'last_message_time': FieldValue.serverTimestamp(),
        'last_message_sent_by': systemUserRef,
        'last_message_seen_by': [systemUserRef],
        'group_chat_id': DateTime.now().millisecondsSinceEpoch % 9999999,
        'is_system_chat': true, // ✅ Mark as system chat for read-only
      });

      // Don't log for bulk operations
      return chatRef;
    } catch (e) {
      print('❌ Chat oluşturma hatası: $e');
      return null;
    }
  }

  /// Send a system message to a chat
  Future<void> _sendSystemMessage({
    required DocumentReference chatRef,
    required DocumentReference systemUserRef,
    required String message,
    required List<String> badgeIds,
    String? eventId,
  }) async {
    try {
      final batch = _firestore.batch();

      // Create message
      final messageRef = _firestore.collection('chat_messages').doc();

      // Prepare message data
      final messageData = {
        'user': systemUserRef,
        'chat': chatRef,
        'text': message,
        'timestamp': FieldValue.serverTimestamp(),
        'image': '',
        'video': '',
        'is_system_message': true, // ✅ Mark as system message
        'badge_ids': badgeIds.join(','), // Store related badge IDs
      };

      // Only add event_id if it's not null or empty
      if (eventId != null && eventId.isNotEmpty) {
        messageData['event_id'] = eventId;
      }

      batch.set(messageRef, messageData);

      // Update chat's last message
      batch.update(chatRef, {
        'last_message': message,
        'last_message_time': FieldValue.serverTimestamp(),
        'last_message_sent_by': systemUserRef,
        'last_message_seen_by': [systemUserRef], // Only system user has seen it
      });

      await batch.commit();
    } catch (e) {
      print('❌ Mesaj gönderme hatası: $e');
      rethrow;
    }
  }

  /// Check if a chat is a system chat
  static bool isSystemChat(ChatsRecord chat) {
    // Check if one of the users is the system user
    return chat.users.any((userRef) => userRef.id == SystemUserInitializer.SYSTEM_USER_ID);
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

  /// Check if current user can send messages in this chat
  static bool canSendMessage(ChatsRecord chat, String currentUserId) {
    // If it's a system chat and current user is not the system user, they can't send messages
    if (isSystemChat(chat) && currentUserId != SystemUserInitializer.SYSTEM_USER_ID) {
      return false;
    }
    return true;
  }
}
