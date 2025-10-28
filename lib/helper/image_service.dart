import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

class ImageService {
  final BuildContext context;

  ImageService(this.context);

  /// Resmi sıkıştır ve boyutlandır
  static Future<Uint8List> compressAndResizeImage(
    Uint8List imageBytes, {
    int maxWidth = 1200,
    int maxHeight = 1200,
    int quality = 85,
  }) async {
    // Resmi decode et
    final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image image = frameInfo.image;

    // Orijinal boyutları al
    final int originalWidth = image.width;
    final int originalHeight = image.height;

    // Yeni boyutları hesapla (aspect ratio'yu koru)
    late int newWidth;
    late int newHeight;

    if (originalWidth > originalHeight) {
      // Landscape
      if (originalWidth > maxWidth) {
        newWidth = maxWidth;
        newHeight = (originalHeight * maxWidth / originalWidth).round();
      } else {
        newWidth = originalWidth;
        newHeight = originalHeight;
      }
    } else {
      // Portrait
      if (originalHeight > maxHeight) {
        newHeight = maxHeight;
        newWidth = (originalWidth * maxHeight / originalHeight).round();
      } else {
        newWidth = originalWidth;
        newHeight = originalHeight;
      }
    }

    // Resmi yeniden boyutlandır
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, originalWidth.toDouble(), originalHeight.toDouble()),
      Rect.fromLTWH(0, 0, newWidth.toDouble(), newHeight.toDouble()),
      Paint(),
    );

    final ui.Picture picture = recorder.endRecording();
    final ui.Image resizedImage = await picture.toImage(newWidth, newHeight);
    
    // PNG formatında encode et (quality parametresi PNG için kullanılmaz)
    final ByteData? byteData = await resizedImage.toByteData(format: ui.ImageByteFormat.png);
    
    return byteData?.buffer.asUint8List() ?? imageBytes;
  }

  /// Pro Image Editor ile resim editlme
  Future<Uint8List?> editImage(Uint8List imageBytes) async {
    try {
      final result = await Navigator.push<Uint8List?>(
        context,
        MaterialPageRoute(
          builder: (context) => ProImageEditor.memory(
            imageBytes,
            callbacks: ProImageEditorCallbacks(
              onImageEditingComplete: (bytes) async => Navigator.pop(context, bytes),
              onCloseEditor: () => Navigator.pop(context),
            ),
            configs: ProImageEditorConfigs(
              designMode: ImageEditorDesignModeE.material,
              i18n: I18n(
                various: I18nVarious(
                  loadingDialogMsg: 'Lütfen bekleyin...',
                  closeEditorWarningTitle: 'Editörü Kapat?',
                  closeEditorWarningMessage: 'Değişikliklerin kaydedilmeyeceğinden emin misin?',
                  closeEditorWarningConfirmBtn: 'Evet',
                  closeEditorWarningCancelBtn: 'İptal',
                ),
                paintEditor: I18nPaintingEditor(
                  bottomNavigationBarText: 'Çizim',
                  freestyle: 'Serbest',
                  arrow: 'Ok',
                  line: 'Çizgi',
                  rectangle: 'Dikdörtgen',
                  circle: 'Daire',
                  dashLine: 'Kesik Çizgi',
                  lineWidth: 'Çizgi Kalınlığı',
                  toggleFill: 'Doldurmayı Aç/Kapat',
                  undo: 'Geri Al',
                  redo: 'İleri Al',
                  done: 'Tamamla',
                  back: 'Geri',
                  smallScreenMoreTooltip: 'Daha Fazla',
                ),
                textEditor: I18nTextEditor(
                  bottomNavigationBarText: 'Metin',
                  inputHintText: 'Metin girin',
                  done: 'Tamamla',
                  back: 'Geri',
                  textAlign: 'Hizala',
                  fontScale: 'Font Boyutu',
                ),
                cropRotateEditor: I18nCropRotateEditor(
                  bottomNavigationBarText: 'Kırp',
                  rotate: 'Döndür',
                  ratio: 'Oran',
                  back: 'Geri',
                  done: 'Tamamla',
                ),
                filterEditor: I18nFilterEditor(
                  bottomNavigationBarText: 'Filtre',
                  filters: I18nFilters(
                    none: 'Filtre Yok',
                    addictiveBlue: 'Mavi',
                    addictiveRed: 'Kırmızı',
                    aden: 'Aden',
                    amaro: 'Amaro',
                    ashby: 'Ashby',
                    brannan: 'Brannan',
                    brooklyn: 'Brooklyn',
                    charmes: 'Charmes',
                    clarendon: 'Clarendon',
                    crema: 'Crema',
                    dogpatch: 'Dogpatch',
                    earlybird: 'Earlybird',
                    f1977: 'F1977',
                    gingham: 'Gingham',
                    ginza: 'Ginza',
                    hefe: 'Hefe',
                    helena: 'Helena',
                    hudson: 'Hudson',
                    inkwell: 'Inkwell',
                    juno: 'Juno',
                    kelvin: 'Kelvin',
                    lark: 'Lark',
                    loFi: 'Lo-Fi',
                    ludwig: 'Ludwig',
                    maven: 'Maven',
                    mayfair: 'Mayfair',
                    moon: 'Moon',
                    nashville: 'Nashville',
                    perpetua: 'Perpetua',
                    reyes: 'Reyes',
                    rise: 'Rise',
                    sierra: 'Sierra',
                    skyline: 'Skyline',
                    slumber: 'Slumber',
                    stinson: 'Stinson',
                    sutro: 'Sutro',
                    toaster: 'Toaster',
                    valencia: 'Valencia',
                    vesper: 'Vesper',
                    walden: 'Walden',
                    willow: 'Willow',
                    xProII: 'X-Pro II',
                  ),
                  back: 'Geri',
                  done: 'Tamamla',
                ),
                blurEditor: I18nBlurEditor(
                  bottomNavigationBarText: 'Bulanıklaştır',
                  back: 'Geri',
                  done: 'Tamamla',
                ),
                emojiEditor: I18nEmojiEditor(
                  bottomNavigationBarText: 'Emoji',
                ),
                stickerEditor: I18nStickerEditor(
                  bottomNavigationBarText: 'Sticker',
                ),
                cancel: 'İptal',
                undo: 'Geri Al',
                redo: 'İleri Al',
                done: 'Tamamla',
                remove: 'Kaldır',
                doneLoadingMsg: 'Değişiklikler kaydediliyor...',
              ),
            ),
          ),
        ),
      );

      return result;
    } catch (e) {
      print('Image editing error: $e');
      return null;
    }
  }

  /// Profil fotoğrafı için optimize boyutlandırma
  static Future<Uint8List> optimizeProfileImage(Uint8List imageBytes) async {
    return await compressAndResizeImage(
      imageBytes,
      maxWidth: 400,
      maxHeight: 400,
      quality: 90,
    );
  }

  /// Post fotoğrafı için optimize boyutlandırma
  static Future<Uint8List> optimizePostImage(Uint8List imageBytes) async {
    return await compressAndResizeImage(
      imageBytes,
      maxWidth: 1080,
      maxHeight: 1080,
      quality: 85,
    );
  }

  /// Story fotoğrafı için optimize boyutlandırma (9:16 aspect ratio)
  static Future<Uint8List> optimizeStoryImage(Uint8List imageBytes) async {
    return await compressAndResizeImage(
      imageBytes,
      maxWidth: 600,
      maxHeight: 1067, // 600 * 16/9
      quality: 80,
    );
  }
}