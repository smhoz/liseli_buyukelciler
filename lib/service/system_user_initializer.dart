import 'package:cloud_firestore/cloud_firestore.dart';

class SystemUserInitializer {
  static const String SYSTEM_USER_ID = 'SYSTEM_USER';
  static const String SYSTEM_USER_EMAIL = 'buyukelcilerliseli@gmail.com';
  static const String SYSTEM_USER_NAME = 'Liseli Büyükelçiler';

  /// System user'ı oluştur (bir kerelik çalıştırılır)
  static Future<void> createSystemUser() async {
    try {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(SYSTEM_USER_ID);

      // Zaten var mı kontrol et
      final docSnapshot = await userDoc.get();
      if (docSnapshot.exists) {
        print('✅ System user zaten mevcut');
        return;
      }

      // System user oluştur
      await userDoc.set({
        'uid': SYSTEM_USER_ID,
        'display_name': SYSTEM_USER_NAME,
        'email': SYSTEM_USER_EMAIL,
        'photo_url':
            'https://firebasestorage.googleapis.com/v0/b/liseli-buyukelciler-db.appspot.com/o/app_icon.png?alt=media',
        'phone_number': '',
        'created_time': FieldValue.serverTimestamp(),
        'badges': [],
        'fcm_token': '',
        'is_system_user': true,
        'bio': 'Resmi sistem hesabı - Duyurular ve bildirimler için kullanılır',
      });

      print('✅ System user başarıyla oluşturuldu!');
      print('   ID: $SYSTEM_USER_ID');
      print('   Email: $SYSTEM_USER_EMAIL');
      print('   Name: $SYSTEM_USER_NAME');
    } catch (e) {
      print('❌ System user oluşturma hatası: $e');
    }
  }

  /// System user ID'sini döndür
  static String getSystemUserId() {
    return SYSTEM_USER_ID;
  }

  /// Bir user'ın system user olup olmadığını kontrol et
  static bool isSystemUser(String userId) {
    return userId == SYSTEM_USER_ID;
  }
}
