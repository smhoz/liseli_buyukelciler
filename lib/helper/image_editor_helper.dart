import 'package:flutter/material.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:universal_io/io.dart';
import 'package:image/image.dart' as img;
import '/flutter_flow/flutter_flow_util.dart';

class ImageEditorHelper {
  /// Pro Image Editor ile resim editleme - basit versiyon
  static Future<FFUploadedFile?> editImage({
    required BuildContext context,
    required FFUploadedFile selectedFile,
    bool isCircle = false,
  }) async {
    try {
      // Resim bytes'ını al
      final imageBytes = selectedFile.bytes;
      if (imageBytes == null) {
        return null;
      }
      Uint8List? squareImageBytes;
      // Resmi kare hale getir
      if (isCircle) {
        squareImageBytes = await _makeImageSquare(imageBytes);
      }

      // Pro Image Editor'ı aç
      final result = await Navigator.push<Uint8List?>(
        context,
        MaterialPageRoute(
          builder: (context) => ProImageEditor.memory(
            (isCircle && squareImageBytes != null) ? squareImageBytes : imageBytes,
            configs: ProImageEditorConfigs(
              designMode: Platform.isAndroid
                  ? ImageEditorDesignModeE.material
                  : ImageEditorDesignModeE.cupertino,
              cropRotateEditorConfigs: isCircle
                  ? CropRotateEditorConfigs(
                      roundCropper: true,
                      initAspectRatio: 1.0,
                      canChangeAspectRatio: false,
                    )
                  : CropRotateEditorConfigs(),
            ),
            callbacks: ProImageEditorCallbacks(
              onImageEditingComplete: (bytes) async {
                Navigator.pop(context, bytes);
              },
            ),
          ),
        ),
      );

      if (result != null) {
        // Editlenmiş resmi FFUploadedFile'a çevir
        final editedFile = FFUploadedFile(
          name: 'edited_${DateTime.now().millisecondsSinceEpoch}_${selectedFile.name}',
          bytes: result,
        );

        return editedFile;
      }

      return selectedFile; // Değişiklik yoksa orijinali döndür
    } catch (e) {
      print('Pro Image Editor hatası: $e');
      return selectedFile; // Hata durumunda orijinal dosyayı döndür
    }
  }

  /// Sadece var olan bir FFUploadedFile'ı editlememizi sağlar
  static Future<void> showEditDialog({
    required BuildContext context,
    required FFUploadedFile selectedFile,
    required Function(FFUploadedFile?) onEditComplete,
    bool isCircle = false,
  }) async {
    try {
      // Pro Image Editor ile editlemek için sor
      final shouldEdit = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Resmi Düzenle'),
          content: const Text('Seçtiğiniz resmi düzenlemek istiyor musunuz?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Hayır'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Evet, Düzenle'),
            ),
          ],
        ),
      );

      if (shouldEdit == true) {
        // Resmi editle
        final editedFile = await editImage(
          context: context,
          selectedFile: selectedFile,
          isCircle: isCircle,
        );
        if (editedFile != null) onEditComplete(editedFile);
      } else {
        onEditComplete(selectedFile); // Editlenmeyecekse orijinali döndür
      }
    } catch (e) {
      print('Resim editleme hatası: $e');
      onEditComplete(selectedFile); // Hata durumunda orijinali döndür
    }
  }

  /// Story için hızlı editleme
  static Future<FFUploadedFile?> editForStory({
    required BuildContext context,
    required FFUploadedFile selectedFile,
  }) async {
    return await editImage(
      context: context,
      selectedFile: selectedFile,
    );
  }

  /// Post için tam editleme
  static Future<FFUploadedFile?> editForPost({
    required BuildContext context,
    required FFUploadedFile selectedFile,
  }) async {
    return await editImage(
      context: context,
      selectedFile: selectedFile,
    );
  }

  /// Activity için editleme
  static Future<FFUploadedFile?> editForActivity({
    required BuildContext context,
    required FFUploadedFile selectedFile,
  }) async {
    return await editImage(
      context: context,
      selectedFile: selectedFile,
    );
  }

  /// Resmi kare hale getiren yardımcı metod - yüksek kalite
  static Future<Uint8List> _makeImageSquare(Uint8List imageBytes) async {
    try {
      // Image paketini kullanarak resmi decode et
      final image = img.decodeImage(imageBytes);
      if (image == null) return imageBytes;

      // Eğer resim zaten kare ise, orijinali döndür
      if (image.width == image.height) {
        return imageBytes;
      }

      // En küçük boyutu al (kare için)
      final size = image.width < image.height ? image.width : image.height;

      // Resmin merkezinden kare bir alan kes
      final x = (image.width - size) ~/ 2;
      final y = (image.height - size) ~/ 2;

      final croppedImage = img.copyCrop(image, x: x, y: y, width: size, height: size);

      // Orijinal format kontrol et ve ona göre encode et
      final originalFormat = _getImageFormat(imageBytes);

      if (originalFormat == 'jpeg') {
        // JPEG olarak yüksek kalitede encode et
        final jpegBytes = img.encodeJpg(croppedImage, quality: 95);
        return Uint8List.fromList(jpegBytes);
      } else {
        // PNG olarak encode et (kayıpsız)
        final pngBytes = img.encodePng(croppedImage, level: 1); // En az sıkıştırma
        return Uint8List.fromList(pngBytes);
      }
    } catch (e) {
      print('Resmi kare yapma hatası: $e');
      return imageBytes; // Hata durumunda orijinali döndür
    }
  }

  /// Resim formatını tespit eden yardımcı metod
  static String _getImageFormat(Uint8List imageBytes) {
    if (imageBytes.length >= 2) {
      // JPEG magic bytes: FF D8
      if (imageBytes[0] == 0xFF && imageBytes[1] == 0xD8) {
        return 'jpeg';
      }
      // PNG magic bytes: 89 50 4E 47
      if (imageBytes.length >= 4 &&
          imageBytes[0] == 0x89 &&
          imageBytes[1] == 0x50 &&
          imageBytes[2] == 0x4E &&
          imageBytes[3] == 0x47) {
        return 'png';
      }
    }
    return 'png'; // Varsayılan olarak PNG
  }
}
