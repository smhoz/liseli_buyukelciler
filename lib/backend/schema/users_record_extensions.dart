import 'users_record.dart';

/// Extension methods for UsersRecord to handle badge-related operations
extension UsersRecordBadgeExtensions on UsersRecord {
  /// Returns the first badge ID if available, otherwise returns null
  /// This is useful for backward compatibility when displaying a single badge
  String? get firstBadgeId {
    if (badges.isEmpty) return null;
    return badges.first;
  }

  /// Returns the first badge ID or empty string if no badges
  /// This is useful for Firestore queries that expect a String
  String get firstBadgeIdOrEmpty {
    if (badges.isEmpty) return '';
    return badges.first;
  }

  /// Returns true if user has any badges
  bool get hasAnyBadges {
    return badges.isNotEmpty;
  }

  /// Returns the count of badges the user has
  int get badgeCount {
    return badges.length;
  }

  /// Returns true if user has more than one badge
  bool get hasMultipleBadges {
    return badges.length > 1;
  }
}
