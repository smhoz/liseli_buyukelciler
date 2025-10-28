import '/pages/event/model/event_model.dart';
import '/service/badge_notification_service.dart';
import '/service/system_chat_service.dart';
import '/flutter_flow/flutter_flow_util.dart';

class EventAnnouncementService {
  final BadgeNotificationService _notificationService = BadgeNotificationService();
  final SystemChatService _chatService = SystemChatService();

  /// Sends event announcement to badge holders
  /// Returns a map with success/failed counts for both notification and message
  ///
  /// [onNotificationProgress] - Optional callback for notification progress (current, total)
  /// [onMessageProgress] - Optional callback for message progress (current, total)
  Future<Map<String, dynamic>> sendEventAnnouncement({
    required List<String> badgeIds,
    required EventModel event,
    Function(int current, int total)? onNotificationProgress,
    Function(int current, int total)? onMessageProgress,
  }) async {
    print('📢 Etkinlik duyurusu gönderiliyor...');
    print('📅 Etkinlik: ${event.title}');
    print('🏷️ Rozet sayısı: ${badgeIds.length}');

    // Prepare notification title and body
    final String notificationTitle = '📅 Yeni Etkinlik: ${event.title}';
    final String eventDateStr = event.event_date != null
        ? dateTimeFormat('d/M/y', event.event_date!.toDate())
        : 'Tarih belirtilmemiş';

    final String notificationBody =
        '${event.explanation.length > 100 ? event.explanation.substring(0, 100) + '...' : event.explanation}\n\n'
        '📍 ${event.address}\n'
        '📅 $eventDateStr';

    // Prepare chat message
    final String chatMessage = '📅 *${event.title}*\n\n'
        '${event.explanation}\n\n'
        '📍 Konum: ${event.address}\n'
        '📅 Tarih: $eventDateStr\n\n'
        'Detaylar için etkinlikler sayfasını ziyaret edin!';

    try {
      // Send notification
      print('🔔 Bildirim gönderiliyor...');
      final notificationResult = await _notificationService.sendNotificationToBadgeHolders(
        badgeIds: badgeIds.toSet(),
        title: notificationTitle,
        body: notificationBody,
        onProgress: onNotificationProgress,
      );

      print(
          '✅ Bildirim gönderildi: ${notificationResult['success']} başarılı, ${notificationResult['failed']} başarısız');

      // Send message with event ID
      print('💬 Mesaj gönderiliyor...');
      final messageResult = await _chatService.sendMessageToBadgeHolders(
        badgeIds: badgeIds,
        message: chatMessage,
        eventId: event.id, // ✅ Pass event ID for clickable messages
        onProgress: onMessageProgress,
      );

      print(
          '✅ Mesaj gönderildi: ${messageResult['success']} başarılı, ${messageResult['failed']} başarısız');

      return {
        'notification_success': notificationResult['success'] ?? 0,
        'notification_failed': notificationResult['failed'] ?? 0,
        'message_success': messageResult['success'] ?? 0,
        'message_failed': messageResult['failed'] ?? 0,
        'oldVersionUsers': messageResult['oldVersionUsers'] ?? [],
      };
    } catch (e) {
      print('❌ Etkinlik duyurusu gönderme hatası: $e');
      rethrow;
    }
  }
}
