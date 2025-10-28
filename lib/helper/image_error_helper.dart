import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class ImageErrorHelper {
  /// Profile resmi için error widget
  static Widget profileImageErrorWidget(BuildContext context, String displayName,
      {double size = 44.0}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primary,
        borderRadius: BorderRadius.circular(size / 5.5),
      ),
      child: Center(
        child: Text(
          displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
          style: FlutterFlowTheme.of(context).titleMedium.override(
                fontFamily: 'Figtree',
                color: Colors.white,
                fontSize: size * 0.4,
                letterSpacing: 0.0,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  /// Normal resim için error widget
  static Widget normalImageErrorWidget(BuildContext context, {double size = 44.0}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).alternate,
        borderRadius: BorderRadius.circular(size / 5.5),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image_outlined,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: size * 0.4,
            ),
            if (size > 60)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'Resim Yüklenemedi',
                  style: FlutterFlowTheme.of(context).labelSmall.override(
                        fontFamily: 'Figtree',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: size * 0.12,
                        letterSpacing: 0.0,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Loading placeholder widget - optimize edilmiş
  static Widget loadingPlaceholder(BuildContext context, {double size = 44.0}) {
    return Container(
      width: size,
      height: size,
      color: FlutterFlowTheme.of(context).primaryBackground,
      child: Center(
        child: size > 60
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              )
            : Icon(
                Icons.person,
                size: size * 0.6,
                color: FlutterFlowTheme.of(context).secondaryText.withOpacity(0.3),
              ),
      ),
    );
  }

  /// CachedNetworkImage için profile resmi - OPTIMIZE EDİLMİŞ
  static Widget cachedProfileImage({
    required BuildContext context,
    required String imageUrl,
    required String displayName,
    double width = 44.0,
    double height = 44.0,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    Duration fadeInDuration = const Duration(milliseconds: 100), // Hızlandırıldı
    Duration fadeOutDuration = const Duration(milliseconds: 100),
  }) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(width / 5.5),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        fadeInDuration: fadeInDuration,
        fadeOutDuration: fadeOutDuration,

        // PERFORMANS OPTİMİZASYONLARI
        memCacheWidth: (width * MediaQuery.of(context).devicePixelRatio).round(),
        memCacheHeight: (height * MediaQuery.of(context).devicePixelRatio).round(),
        maxWidthDiskCache: (width * 2).round(),
        maxHeightDiskCache: (height * 2).round(),

        // HTTP OPTİMİZASYONLARI - Cache bypass kaldırıldı
        httpHeaders: const {
          'Cache-Control': 'max-age=86400', // 24 saat cache
          'Connection': 'keep-alive',
        },

        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: FlutterFlowTheme.of(context).primaryBackground,
          child: Icon(
            Icons.person,
            size: width * 0.6,
            color: FlutterFlowTheme.of(context).secondaryText.withOpacity(0.5),
          ),
        ),

        errorWidget: (context, url, error) {
          print('Profile image loading error: $error');
          return profileImageErrorWidget(context, displayName, size: width);
        },
      ),
    );
  }

  /// CachedNetworkImage için normal resim - OPTIMIZE EDİLMİŞ
  static Widget cachedNormalImage({
    required BuildContext context,
    required String imageUrl,
    double width = 44.0,
    double height = 44.0,
    BoxFit fit = BoxFit.contain,
    BorderRadius? borderRadius,
    Duration fadeInDuration = const Duration(milliseconds: 100), // Hızlandırıldı
    Duration fadeOutDuration = const Duration(milliseconds: 100),
  }) {
    // URL normalizasyonu - cache sorunlarını önlemek için
    String normalizedUrl = imageUrl;

    // Firebase Storage URL'leri için özel işlem
    if (normalizedUrl.contains('firebasestorage.googleapis.com')) {
      // Firebase Storage URL'leri zaten cache'lenebilir olmalı
      // Token sabit kaldığı için normalizasyon yapmıyoruz
      // normalizedUrl = imageUrl; // Değişiklik yok
    } else {
      // Diğer URL'ler için normal normalizasyon
      if (normalizedUrl.contains('?')) {
        final uri = Uri.parse(normalizedUrl);
        final cleanParams = Map<String, String>.from(uri.queryParameters);

        // Cache killer parametrelerini kaldır
        cleanParams.removeWhere((key, value) =>
            key.toLowerCase().contains('timestamp') ||
            key.toLowerCase().contains('cache') ||
            key == 't' ||
            key == '_' ||
            key == 'v');

        normalizedUrl =
            uri.replace(queryParameters: cleanParams.isEmpty ? null : cleanParams).toString();
      }
    }
    // Post resimleri için ekran boyutuna göre maksimum boyut
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final isPostImage = width > 200 || height > 200;
    final maxWidth = isPostImage && screenWidth > 600 ? 600 : screenWidth;

    // Cache working perfectly! Debug logs removed for performance

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(width / 5.5),
      child: CachedNetworkImage(
        imageUrl: normalizedUrl, // Normalized URL kullan
        width: width,
        height: height,
        fit: fit,
        fadeInDuration: fadeInDuration,
        fadeOutDuration: fadeOutDuration,

        // CUSTOM CACHE MANAGER - daha iyi performans için
        cacheManager: customCacheManager,

        // PLACEHOLDER/PROGRESS - büyük resimler için progress, küçükler için placeholder
        placeholder: !isPostImage
            ? (context, url) => Container(
                  width: width,
                  height: height,
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  child: Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: width * 0.4,
                      color: FlutterFlowTheme.of(context).secondaryText.withOpacity(0.5),
                    ),
                  ),
                )
            : null,

        // PROGRESSIVE LOADING - sadece büyük resimler için
        progressIndicatorBuilder: isPostImage
            ? (context, url, progress) {
                return Container(
                  width: width,
                  height: height,
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          strokeWidth: 2,
                          value: progress.progress,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                        if (progress.progress != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '${(progress.progress! * 100).round()}%',
                              style: FlutterFlowTheme.of(context).labelSmall,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }
            : null,

        errorWidget: (context, url, error) {
          print('CachedNetworkImage loading error: $error');

          return isPostImage
              ? Container(
                  width: width,
                  height: height,
                  color: FlutterFlowTheme.of(context).alternate,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image_outlined,
                        size: 48,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Resim yüklenemedi',
                        style: FlutterFlowTheme.of(context).labelSmall,
                      ),
                    ],
                  ),
                )
              : normalImageErrorWidget(context, size: width);
        },
      ),
    );
  }

  /// Image.network için profile resmi wrapper - OPTIMIZE EDİLMİŞ
  static Widget networkProfileImage({
    required BuildContext context,
    required String imageUrl,
    required String displayName,
    double width = 44.0,
    double height = 44.0,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(width / 5.5),
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        cacheWidth: (width * MediaQuery.of(context).devicePixelRatio).round(),
        cacheHeight: (height * MediaQuery.of(context).devicePixelRatio).round(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return loadingPlaceholder(context, size: width);
        },
        errorBuilder: (context, error, stackTrace) {
          print('Network profile image loading error: $error');
          return profileImageErrorWidget(context, displayName, size: width);
        },
      ),
    );
  }

  /// Image.network için normal resim wrapper - OPTIMIZE EDİLMİŞ
  static Widget networkNormalImage({
    required BuildContext context,
    required String imageUrl,
    double width = 44.0,
    double height = 44.0,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(width / 5.5),
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        cacheWidth: (width * MediaQuery.of(context).devicePixelRatio).round(),
        cacheHeight: (height * MediaQuery.of(context).devicePixelRatio).round(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return loadingPlaceholder(context, size: width);
        },
        errorBuilder: (context, error, stackTrace) {
          print('Image loading error: $error');
          return normalImageErrorWidget(context, size: width);
        },
      ),
    );
  }

  // YARDIMCI METODLAR

  /// Resim preload için
  static void preloadImage(String imageUrl, BuildContext context) {
    if (imageUrl.isNotEmpty) {
      precacheImage(CachedNetworkImageProvider(imageUrl), context);
    }
  }

  /// Cache temizleme
  static Future<void> clearImageCache() async {
    await DefaultCacheManager().emptyCache();
  }

  /// Cache boyutunu artır - daha iyi kalite için - SINGLETON
  static CacheManager? _customCacheManager;
  static CacheManager get customCacheManager {
    _customCacheManager ??= CacheManager(
      Config(
        'customImageCache',
        stalePeriod: const Duration(days: 7), // 7 gün cache
        maxNrOfCacheObjects: 1000, // Daha fazla resim cache'le
        repo: JsonCacheInfoRepository(databaseName: 'customImageCache'),
        fileService: HttpFileService(),
      ),
    );
    return _customCacheManager!;
  }

  /// Belirli resmi cache'den silme
  static Future<void> removeFromCache(String imageUrl) async {
    await DefaultCacheManager().removeFile(imageUrl);
    await customCacheManager.removeFile(imageUrl);
  }

  /// Cache durumunu kontrol et - DEBUG
  static Future<void> debugCacheStatus(String imageUrl) async {
    print('=== CACHE DEBUG for: $imageUrl ===');

    // Default cache manager kontrolü
    final defaultFile = await DefaultCacheManager().getFileFromCache(imageUrl);
    print('Default Cache: ${defaultFile != null ? "CACHED" : "NOT CACHED"}');

    // Custom cache manager kontrolü
    final customFile = await customCacheManager.getFileFromCache(imageUrl);
    print('Custom Cache: ${customFile != null ? "CACHED" : "NOT CACHED"}');

    if (customFile != null) {
      print('Custom Cache File Size: ${customFile.file.lengthSync()} bytes');
      print('Custom Cache File Path: ${customFile.file.path}');
    }

    print('================================');
  }

  /// Cache istatistikleri - basitleştirilmiş
  static Future<void> printCacheStats() async {
    print('=== CACHE STATISTICS ===');

    try {
      // Test bir resim cache'de var mı kontrol et
      final testUrl = 'https://picsum.photos/200/200';
      final cachedFile = await customCacheManager.getFileFromCache(testUrl);
      print('Test URL cached: ${cachedFile != null}');

      // Default cache manager test
      final defaultCached = await DefaultCacheManager().getFileFromCache(testUrl);
      print('Default cache test: ${defaultCached != null}');
    } catch (e) {
      print('Error getting cache stats: $e');
    }

    print('========================');
  }
}
