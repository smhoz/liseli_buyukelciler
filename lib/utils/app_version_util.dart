import 'package:package_info_plus/package_info_plus.dart';

/// Utility class for getting app version information
class AppVersionUtil {
  static String? _cachedVersion;

  /// Get the current app version
  /// Returns cached version if available, otherwise fetches from package info
  static Future<String> getAppVersion() async {
    if (_cachedVersion != null) {
      return _cachedVersion!;
    }

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      _cachedVersion = packageInfo.version;
      return _cachedVersion!;
    } catch (e) {
      print('❌ App version alınamadı: $e');
      // Fallback to default version
      return '1.0.0';
    }
  }

  /// Clear cached version (useful for testing)
  static void clearCache() {
    _cachedVersion = null;
  }
}

