import 'package:cloud_firestore/cloud_firestore.dart';

class BadgeInitializer {
  static Future<void> initializeDefaultBadges() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // İlk Aktivite rozetinin mevcut olup olmadığını kontrol et
      final firstActivityQuery =
          await firestore.collection('badge').where('name', isEqualTo: 'İlk Aktivite').where('is_deleted', isEqualTo: false).get();

      if (firstActivityQuery.docs.isEmpty) {
        // İlk Aktivite rozetini oluştur
        await firestore.collection('badge').add({
          'name': 'İlk Aktivite',
          'file_url': 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png', // Varsayılan ikon
          'created_at': FieldValue.serverTimestamp(),
          'is_deleted': false,
        });
        print('İlk Aktivite rozeti oluşturuldu');
      }

      // Diğer varsayılan rozetleri de ekleyebiliriz
      final badges = [
        {
          'name': 'İlk Paylaşım',
          'file_url': 'https://cdn-icons-png.flaticon.com/512/3239/3239952.png',
        },
        {
          'name': 'Aktif Kullanıcı',
          'file_url': 'https://cdn-icons-png.flaticon.com/512/2950/2950270.png',
        },
        {
          'name': 'Sosyal Kelebek',
          'file_url': 'https://cdn-icons-png.flaticon.com/512/3476/3476364.png',
        }
      ];

      for (var badge in badges) {
        final query = await firestore.collection('badge').where('name', isEqualTo: badge['name']).where('is_deleted', isEqualTo: false).get();

        if (query.docs.isEmpty) {
          await firestore.collection('badge').add({
            'name': badge['name'],
            'file_url': badge['file_url'],
            'created_at': FieldValue.serverTimestamp(),
            'is_deleted': false,
          });
          print('${badge['name']} rozeti oluşturuldu');
        }
      }
    } catch (e) {
      print('Rozet başlatma hatası: $e');
    }
  }
}
