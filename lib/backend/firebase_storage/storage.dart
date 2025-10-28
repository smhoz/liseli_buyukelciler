import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime_type/mime_type.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<String?> uploadData(String path, Uint8List data) async {
  try {
    // Image'i compress et
    Uint8List compressedData = data;

    if (path.toLowerCase().endsWith('.jpg') ||
        path.toLowerCase().endsWith('.jpeg') ||
        path.toLowerCase().endsWith('.png')) {
      final compressed = await FlutterImageCompress.compressWithList(
        data,
        quality: 95,
        format: CompressFormat.jpeg,
      );

      if (compressed.isNotEmpty) {
        compressedData = compressed;
        print('Image compressed: ${data.length} -> ${compressedData.length} bytes');
      }
    }

    final storage =
        FirebaseStorage.instanceFor(bucket: 'gs://liseli-buyukelciler-db.firebasestorage.app');
    final storageRef = storage.ref().child(path);

    final metadata = SettableMetadata(
        contentType: mime(path) ?? 'image/jpeg',
        customMetadata: {'uploadedAt': DateTime.now().toIso8601String()});

    final result = await storageRef.putData(compressedData, metadata);
    return result.state == TaskState.success ? await result.ref.getDownloadURL() : null;
  } catch (e) {
    print('Upload hatası: $e');
    return null;
  }
}
