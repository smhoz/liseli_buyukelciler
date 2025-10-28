import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sosyal_medya/auth/firebase_auth/auth_util.dart';
import 'package:sosyal_medya/backend/schema/badge_model/badge_model.dart';
import 'package:sosyal_medya/helper/show_dialogs.dart';

import '/backend/schema/users_record_extensions.dart';

class FileDownloadService {
  final BuildContext context;
  FileDownloadService(this.context);

  // Yönetici rozeti kontrolü
  Future<bool> _isUserAdmin() async {
    if (currentUserDocument == null || currentUserDocument!.badges.isEmpty) {
      return false;
    }

    try {
      // User'ın badge'ini al
      DocumentSnapshot badgeSnapshot = await FirebaseFirestore.instance
          .collection('badge')
          .doc(currentUserDocument!.firstBadgeId)
          .get();

      if (badgeSnapshot.exists) {
        BadgeModel badge = BadgeModel.fromJson(badgeSnapshot.data() as Map<String, dynamic>);
        // Badge adının "Yönetici" veya "Admin" olup olmadığını kontrol et
        return badge.name.toLowerCase().contains('yönetici') ||
            badge.name.toLowerCase().contains('admin');
      }
    } catch (e) {
      print('Badge kontrol hatası: $e');
    }

    return false;
  }

  saveNetworkImage(String img) async {
    // Yönetici rozeti kontrolü
    bool isAdmin = await _isUserAdmin();
    if (!isAdmin) {
      Navigator.pop(context);
      CodeNoahDialogs(context).showFlush(
        type: SnackType.warning,
        message: 'Sadece yönetici rozetine sahip kullanıcılar fotoğraf indirebilir.',
      );
      return;
    }

    try {
      var response = await Dio().get(img, options: Options(responseType: ResponseType.bytes));
      final result = await ImageGallerySaverPlus.saveImage(Uint8List.fromList(response.data),
          quality: 60, name: "hello");
      print(result);

      Navigator.pop(context);
      CodeNoahDialogs(context).showFlush(
        type: SnackType.success,
        message: 'Resim İndirime İşlemi Başarılı',
      );
    } catch (e) {
      Navigator.pop(context);
      CodeNoahDialogs(context).showFlush(
        type: SnackType.error,
        message: 'Hata oluştu, lütfen daha sonra tekrar deneyiniz.',
      );
    }
  }

  saveNetworkVideoFile(String video) async {
    // Yönetici rozeti kontrolü
    bool isAdmin = await _isUserAdmin();
    if (!isAdmin) {
      Navigator.pop(context);
      CodeNoahDialogs(context).showFlush(
        type: SnackType.warning,
        message: 'Sadece yönetici rozetine sahip kullanıcılar video indirebilir.',
      );
      return;
    }

    try {
      var appDocDir = await getTemporaryDirectory();
      String savePath = appDocDir.path + "/temp.mp4";
      String fileUrl = video;
      await Dio().download(fileUrl, savePath, onReceiveProgress: (count, total) {
        print((count / total * 100).toStringAsFixed(0) + "%");
      });
      final result = await ImageGallerySaverPlus.saveFile(savePath);
      print(result);

      Navigator.pop(context);
      CodeNoahDialogs(context).showFlush(
        type: SnackType.success,
        message: 'Video İndirime İşlemi Başarılı',
      );
    } catch (e) {
      Navigator.pop(context);
      CodeNoahDialogs(context).showFlush(
        type: SnackType.error,
        message: 'Hata oluştu, lütfen daha sonra tekrar deneyiniz.',
      );
    }
  }
}
