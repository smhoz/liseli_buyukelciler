import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "userName" field.
  String? _userName;
  String get userName => _userName ?? '';
  bool hasUserName() => _userName != null;

  // "bio" field.
  String? _bio;
  String get bio => _bio ?? '';
  bool hasBio() => _bio != null;

  // "isFollowed" field.
  bool? _isFollowed;
  bool get isFollowed => _isFollowed ?? false;
  bool hasIsFollowed() => _isFollowed != null;

  // "shortDescription" field.
  String? _shortDescription;
  String get shortDescription => _shortDescription ?? '';
  bool hasShortDescription() => _shortDescription != null;

  // "last_active_time" field.
  DateTime? _lastActiveTime;
  DateTime? get lastActiveTime => _lastActiveTime;
  bool hasLastActiveTime() => _lastActiveTime != null;

  // "role" field.
  String? _role;
  String get role => _role ?? '';
  bool hasRole() => _role != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "is_gender" field.
  bool? _isGender;
  bool get isGender => _isGender ?? false;
  bool hasIsGender() => _isGender != null;

  // is_badge ve is_approved eklemeleri yapılacak
  bool? _isBadge;
  bool get isBadge => _isBadge ?? false;
  bool hasIsBadge() => _isBadge != null;

  bool? _isApproved;
  bool get isApproved => _isApproved ?? false;
  bool hasIsApproved() => _isApproved != null;

  // "is_admin" field.
  bool? _isAdmin;
  bool get isAdmin => _isAdmin ?? false;
  bool hasIsAdmin() => _isAdmin != null;

  List<String>? _badges;
  List<String> get badges => _badges ?? const [];
  bool hasBadges() => _badges != null && _badges!.isNotEmpty;

  List<dynamic>? _engellenen;
  List<dynamic> get engellenen => _engellenen ?? [];
  bool hasEngellenen() => _engellenen != null && _engellenen!.isNotEmpty;

  List<dynamic>? _engelleyen;
  List<dynamic> get engelleyen => _engelleyen ?? [];
  bool hasEngelleyenngellenen() => _engelleyen != null && _engelleyen!.isNotEmpty;

  // "app_version" field.
  String? _appVersion;
  String get appVersion => _appVersion ?? '1.0.0';
  bool hasAppVersion() => _appVersion != null;

  void _initializeFields() {
    _displayName = snapshotData['display_name'] as String?;
    _email = snapshotData['email'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _userName = snapshotData['userName'] as String?;
    _bio = snapshotData['bio'] as String?;
    _isFollowed = snapshotData['isFollowed'] as bool?;
    _shortDescription = snapshotData['shortDescription'] as String?;
    _lastActiveTime = snapshotData['last_active_time'] as DateTime?;
    _role = snapshotData['role'] as String?;
    _title = snapshotData['title'] as String?;
    _isGender = snapshotData['is_gender'] as bool?;
    _isBadge = snapshotData['is_badge'] as bool?;
    _isApproved = snapshotData['is_approved'] as bool?;
    _isAdmin = snapshotData['is_admin'] as bool?;

    // Backward compatibility: handle both String and List<String> for badges
    final badgesData = snapshotData['badges'];
    if (badgesData is String) {
      // Old format: single badge as string
      _badges = badgesData.isNotEmpty ? [badgesData] : null;
    } else if (badgesData is List) {
      // New format: list of badges
      _badges = badgesData.cast<String>();
    } else {
      _badges = null;
    }

    _engellenen = snapshotData['engellenen'] as List<dynamic>?;
    _engelleyen = snapshotData['engelleyen'] as List<dynamic>?;
    _appVersion = snapshotData['app_version'] as String?;
  }

  static CollectionReference get collection => FirebaseFirestore.instance.collection('users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UsersRecord.fromSnapshot(s));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UsersRecord.fromSnapshot(s));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() => 'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UsersRecord && reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUsersRecordData({
  String? displayName,
  String? email,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  String? userName,
  String? bio,
  bool? isFollowed,
  String? shortDescription,
  DateTime? lastActiveTime,
  String? role,
  String? title,
  bool? isGender,
  bool? isBadge,
  bool? isApproved,
  bool? isAdmin,
  List<String>? badges,
  List<String>? engellenen,
  List<String>? engelleyen,
  String? appVersion,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'display_name': displayName,
      'email': email,
      'photo_url': photoUrl,
      'uid': uid,
      'created_time': createdTime,
      'phone_number': phoneNumber,
      'userName': userName,
      'bio': bio,
      'isFollowed': isFollowed,
      'shortDescription': shortDescription,
      'last_active_time': lastActiveTime,
      'role': role,
      'title': title,
      'is_gender': isGender,
      'is_badge': isBadge,
      'is_approved': isApproved,
      'is_admin': isAdmin,
      'badges': badges,
      'engellenen': engellenen,
      'engelleyen': engelleyen,
      'app_version': appVersion,
    }.withoutNulls,
  );

  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(UsersRecord? e1, UsersRecord? e2) {
    return e1?.displayName == e2?.displayName &&
        e1?.email == e2?.email &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.userName == e2?.userName &&
        e1?.bio == e2?.bio &&
        e1?.isFollowed == e2?.isFollowed &&
        e1?.shortDescription == e2?.shortDescription &&
        e1?.lastActiveTime == e2?.lastActiveTime &&
        e1?.role == e2?.role &&
        e1?.title == e2?.title &&
        e1?.isGender == e2?.isGender &&
        e1?.isBadge == e2?.isBadge &&
        e1?.isApproved == e2?.isApproved &&
        e1?.isAdmin == e2?.isAdmin &&
        e1?.badges == e2?.badges &&
        e1?.engellenen == e2?.engellenen &&
        e1?.engelleyen == e2?.engelleyen;
  }

  @override
  int hash(UsersRecord? e) => const ListEquality().hash([
        e?.displayName,
        e?.email,
        e?.photoUrl,
        e?.uid,
        e?.createdTime,
        e?.phoneNumber,
        e?.userName,
        e?.bio,
        e?.isFollowed,
        e?.shortDescription,
        e?.lastActiveTime,
        e?.role,
        e?.title,
        e?.isGender,
        e?.isBadge,
        e?.isApproved,
        e?.isAdmin,
        e?.badges,
        e?.engellenen,
        e?.engelleyen,
      ]);

  @override
  bool isValidKey(Object? o) => o is UsersRecord;
}
