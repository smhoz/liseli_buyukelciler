import '/backend/backend.dart';
import '/backend/schema/badge_model/badge_model.dart';
import '/backend/schema/users_record_extensions.dart';
import '/components/admin_user_list_item/admin_user_list_item_widget.dart';
import '/components/badge_actions_bottom_sheet/badge_actions_bottom_sheet_widget.dart';
import '/components/send_badge_message_dialog/send_badge_message_dialog_widget.dart';
import '/components/send_badge_notification_dialog/send_badge_notification_dialog_widget.dart';
import '/components/send_badge_notification_and_message_dialog/send_badge_notification_and_message_dialog_widget.dart';
import '/components/event_announcement_dialog/event_announcement_dialog_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'user_list_page_model.dart';
export 'user_list_page_model.dart';

class UserListPageWidget extends StatefulWidget {
  const UserListPageWidget({super.key});

  static String routeName = 'user_List_Page';
  static String routePath = '/userListPage';

  @override
  State<UserListPageWidget> createState() => _UserListPageWidgetState();
}

class _UserListPageWidgetState extends State<UserListPageWidget> {
  late UserListPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UserListPageModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  /// Clean up system chats and messages
  Future<void> _cleanupSystemData() async {
    print('🧹 [CLEANUP] Starting system data cleanup...');

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('🧹 Sistem Verilerini Temizle'),
        content: Text(
          'Tüm sistem chat\'leri ve mesajları silinecek.\n\n'
          'Bu işlem geri alınamaz!\n\n'
          'Devam etmek istiyor musunuz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text('Sil'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      print('🧹 [CLEANUP] User cancelled cleanup');
      return;
    }

    print('🧹 [CLEANUP] User confirmed cleanup');

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('Temizleniyor...'),
          ],
        ),
      ),
    );

    try {
      print('🧹 [CLEANUP] Initializing Firestore...');
      final firestore = FirebaseFirestore.instance;
      int deletedChats = 0;
      int deletedMessages = 0;

      // Delete system chats
      print('🧹 [CLEANUP] Querying system chats...');
      final chatsSnapshot =
          await firestore.collection('chats').where('is_system_chat', isEqualTo: true).get();

      print('🧹 [CLEANUP] Found ${chatsSnapshot.docs.length} system chats');

      if (chatsSnapshot.docs.isNotEmpty) {
        print('🧹 [CLEANUP] Deleting ${chatsSnapshot.docs.length} system chats...');
        final batch = firestore.batch();
        for (var doc in chatsSnapshot.docs) {
          print('🧹 [CLEANUP] Deleting chat: ${doc.id}');
          batch.delete(doc.reference);
          deletedChats++;
        }
        await batch.commit();
        print('🧹 [CLEANUP] ✅ Successfully deleted $deletedChats system chats');
      } else {
        print('🧹 [CLEANUP] ℹ️  No system chats to delete');
      }

      // Delete system messages
      print('🧹 [CLEANUP] Querying system messages...');
      final messagesSnapshot = await firestore
          .collection('chat_messages')
          .where('is_system_message', isEqualTo: true)
          .get();

      print('🧹 [CLEANUP] Found ${messagesSnapshot.docs.length} system messages');

      if (messagesSnapshot.docs.isNotEmpty) {
        print('🧹 [CLEANUP] Deleting ${messagesSnapshot.docs.length} system messages...');
        final batch = firestore.batch();
        for (var doc in messagesSnapshot.docs) {
          print('🧹 [CLEANUP] Deleting message: ${doc.id}');
          batch.delete(doc.reference);
          deletedMessages++;
        }
        await batch.commit();
        print('🧹 [CLEANUP] ✅ Successfully deleted $deletedMessages system messages');
      } else {
        print('🧹 [CLEANUP] ℹ️  No system messages to delete');
      }

      // Close loading dialog
      Navigator.pop(context);

      print('🧹 [CLEANUP] ✅ Cleanup completed successfully!');
      print('🧹 [CLEANUP] Summary: $deletedChats chats, $deletedMessages messages deleted');

      // Show success dialog
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('✅ Temizleme Tamamlandı'),
          content: Text(
            'Silinen sistem chat\'leri: $deletedChats\n'
            'Silinen sistem mesajları: $deletedMessages',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Tamam'),
            ),
          ],
        ),
      );
    } catch (e, stackTrace) {
      print('🧹 [CLEANUP] ❌ Error during cleanup: $e');
      print('🧹 [CLEANUP] Stack trace: $stackTrace');

      // Close loading dialog
      Navigator.pop(context);

      // Show error dialog
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('❌ Hata'),
          content: Text('Temizleme sırasında hata oluştu:\n$e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Tamam'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          buttonSize: 46.0,
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 25.0,
          ),
          onPressed: () async {
            context.pop();
          },
        ),
        title: Text(
          'Üyeler',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Outfit',
                letterSpacing: 0.0,
              ),
        ),
        actions: [
          /*  // Cleanup button
          FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            buttonSize: 46.0,
            icon: Icon(
              Icons.cleaning_services,
              color: FlutterFlowTheme.of(context).error,
              size: 24.0,
            ),
            onPressed: () async {
              await _cleanupSystemData();
            },
          ),*/
        ],
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _model.textController,
                        focusNode: _model.textFieldFocusNode,
                        onChanged: (_) => safeSetState(() {}),
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Kullanıcı ara...',
                          labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                fontFamily: 'Figtree',
                                letterSpacing: 0.0,
                              ),
                          hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                fontFamily: 'Figtree',
                                letterSpacing: 0.0,
                              ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          filled: true,
                          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                          prefixIcon: Icon(
                            Icons.search,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                          suffixIcon: _model.textController!.text.isNotEmpty
                              ? InkWell(
                                  onTap: () async {
                                    _model.textController?.clear();
                                    safeSetState(() {});
                                  },
                                  child: Icon(
                                    Icons.clear,
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    size: 22.0,
                                  ),
                                )
                              : null,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Figtree',
                              letterSpacing: 0.0,
                            ),
                        validator: _model.textControllerValidator.asValidator(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Badge Filter Section
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('badge')
                  .where('is_deleted', isEqualTo: false)
                  .snapshots(),
              builder: (context, badgeSnapshot) {
                if (!badgeSnapshot.hasData) {
                  return const SizedBox.shrink();
                }

                final badges = badgeSnapshot.data!.docs
                    .map((doc) => BadgeModel.fromJson({
                          'id': doc.id,
                          ...doc.data() as Map<String, dynamic>,
                        }))
                    .toList();

                if (badges.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Container(
                  width: double.infinity,
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rozet Filtresi',
                            style: FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'Figtree',
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Row(
                            children: [
                              if (_model.selectedBadgeIds.isNotEmpty)
                                Container(
                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Text(
                                    '${_model.selectedBadgeIds.length} seçili',
                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                          fontFamily: 'Figtree',
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              if (_model.selectedBadgeIds.isNotEmpty) SizedBox(width: 8.0),
                              // Show "Aksiyonlar" button always (for all filters)
                              InkWell(
                                onTap: () async {
                                  // Determine filter type and get appropriate data
                                  List<String> badgeIds = [];
                                  List<String> selectedBadgeNames = [];
                                  int targetUserCount = 0;

                                  if (_model.selectedBadgeIds.isNotEmpty) {
                                    // Specific badges selected
                                    badgeIds = _model.selectedBadgeIds.toList();
                                    selectedBadgeNames = badges
                                        .where(
                                            (badge) => _model.selectedBadgeIds.contains(badge.id))
                                        .map((badge) => badge.name)
                                        .toList();

                                    // Calculate target user count
                                    final allUsers = await queryUsersRecordOnce();
                                    targetUserCount = allUsers.where((user) {
                                      return user.badges.any(
                                          (badgeId) => _model.selectedBadgeIds.contains(badgeId));
                                    }).length;
                                  } else if (_model.showOnlyUsersWithBadges) {
                                    // "Rozetli Kullanıcılar" selected - send to all users with any badge
                                    badgeIds = badges.map((badge) => badge.id).toList();
                                    selectedBadgeNames = ['Rozetli Kullanıcılar'];

                                    // Calculate target user count (users with any badge)
                                    final allUsers = await queryUsersRecordOnce();
                                    targetUserCount =
                                        allUsers.where((user) => user.hasAnyBadges).length;
                                  } else {
                                    // "Tümü" selected
                                    badgeIds = []; // Empty means all users
                                    selectedBadgeNames = ['Tüm Kullanıcılar'];

                                    // Calculate target user count (all users)
                                    final allUsers = await queryUsersRecordOnce();
                                    targetUserCount = allUsers.length;
                                  }

                                  // Show actions bottom sheet
                                  final action = await showModalBottomSheet<String>(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => BadgeActionsBottomSheetWidget(
                                      badgeIds: badgeIds,
                                      badgeNames: selectedBadgeNames,
                                      userCount: targetUserCount,
                                    ),
                                  );

                                  // Handle selected action
                                  if (action == 'notification') {
                                    // Show notification dialog
                                    await showDialog(
                                      context: context,
                                      builder: (context) => SendBadgeNotificationDialogWidget(
                                        badgeIds: badgeIds.toSet(),
                                        badgeNames: selectedBadgeNames,
                                        userCount: targetUserCount,
                                      ),
                                    );
                                  } else if (action == 'message') {
                                    // Show message dialog
                                    await showDialog(
                                      context: context,
                                      builder: (context) => SendBadgeMessageDialogWidget(
                                        badgeIds: badgeIds,
                                        badgeNames: selectedBadgeNames,
                                        userCount: targetUserCount,
                                      ),
                                    );
                                  } else if (action == 'both') {
                                    // Show notification and message dialog
                                    await showDialog(
                                      context: context,
                                      builder: (context) =>
                                          SendBadgeNotificationAndMessageDialogWidget(
                                        badgeIds: badgeIds,
                                        badgeNames: selectedBadgeNames,
                                        userCount: targetUserCount,
                                      ),
                                    );
                                  } else if (action == 'event_announcement') {
                                    // Show event announcement dialog
                                    await showDialog(
                                      context: context,
                                      builder: (context) => EventAnnouncementDialogWidget(
                                        badgeIds: badgeIds,
                                        badgeNames: selectedBadgeNames,
                                        userCount: targetUserCount,
                                      ),
                                    );
                                  }
                                },
                                child: Material(
                                  color: Colors.transparent,
                                  elevation: 2.0,
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Container(
                                    padding: EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).primary,
                                      borderRadius: BorderRadius.circular(12.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              FlutterFlowTheme.of(context).primary.withOpacity(0.3),
                                          blurRadius: 8.0,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.flash_on,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          'Aksiyonlar',
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Figtree',
                                                color: Colors.white,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        SizedBox(width: 4),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // "Tümü" chip
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                              child: FilterChip(
                                label: Text('Tümü'),
                                selected: _model.selectedBadgeIds.isEmpty &&
                                    !_model.showOnlyUsersWithBadges,
                                onSelected: (selected) {
                                  safeSetState(() {
                                    _model.selectedBadgeIds.clear();
                                    _model.showOnlyUsersWithBadges = false;
                                  });
                                },
                                backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                                selectedColor: FlutterFlowTheme.of(context).primary,
                                labelStyle: TextStyle(
                                  color: _model.selectedBadgeIds.isEmpty &&
                                          !_model.showOnlyUsersWithBadges
                                      ? Colors.white
                                      : FlutterFlowTheme.of(context).primaryText,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: BorderSide(
                                    color: FlutterFlowTheme.of(context).alternate,
                                  ),
                                ),
                              ),
                            ),
                            // "Rozetli Kullanıcılar" chip
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                              child: FilterChip(
                                label: Text('Rozetli Kullanıcılar'),
                                selected: _model.showOnlyUsersWithBadges &&
                                    _model.selectedBadgeIds.isEmpty,
                                onSelected: (selected) {
                                  safeSetState(() {
                                    _model.showOnlyUsersWithBadges = selected;
                                    _model.selectedBadgeIds.clear();
                                  });
                                },
                                backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                                selectedColor: FlutterFlowTheme.of(context).primary,
                                labelStyle: TextStyle(
                                  color: _model.showOnlyUsersWithBadges &&
                                          _model.selectedBadgeIds.isEmpty
                                      ? Colors.white
                                      : FlutterFlowTheme.of(context).primaryText,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: BorderSide(
                                    color: FlutterFlowTheme.of(context).alternate,
                                  ),
                                ),
                              ),
                            ),
                            // Individual badge chips (multiple selection)
                            ...badges.map((badge) {
                              final isSelected = _model.selectedBadgeIds.contains(badge.id);
                              return Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                                child: FilterChip(
                                  label: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: badge.file_url,
                                        width: 20,
                                        height: 20,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(width: 6.0),
                                      Text(badge.name),
                                    ],
                                  ),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    safeSetState(() {
                                      if (selected) {
                                        _model.selectedBadgeIds.add(badge.id);
                                      } else {
                                        _model.selectedBadgeIds.remove(badge.id);
                                      }
                                      _model.showOnlyUsersWithBadges = false;
                                    });
                                  },
                                  backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                                  selectedColor: FlutterFlowTheme.of(context).primary,
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : FlutterFlowTheme.of(context).primaryText,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    side: BorderSide(
                                      color: FlutterFlowTheme.of(context).alternate,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: StreamBuilder<List<UsersRecord>>(
                stream: queryUsersRecord(
                  queryBuilder: (usersRecord) => usersRecord.orderBy('display_name'),
                ),
                builder: (context, snapshot) {
                  // Customize what your widget looks like when it's loading.
                  if (!snapshot.hasData) {
                    return Center(
                      child: SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      ),
                    );
                  }
                  List<UsersRecord> listViewUsersRecordList = snapshot.data!;

                  // Filter users based on search text
                  if (_model.textController.text.isNotEmpty) {
                    listViewUsersRecordList = listViewUsersRecordList.where((user) {
                      final searchLower = _model.textController.text.toLowerCase();
                      final displayNameLower = user.displayName.toLowerCase();
                      final userNameLower = user.userName.toLowerCase();
                      return displayNameLower.contains(searchLower) ||
                          userNameLower.contains(searchLower);
                    }).toList();
                  }

                  // Filter users based on badge selection (OR logic - any of selected badges)
                  if (_model.selectedBadgeIds.isNotEmpty) {
                    // Filter users who have ANY of the selected badges
                    listViewUsersRecordList = listViewUsersRecordList.where((user) {
                      // Check if user has at least one of the selected badges
                      return user.badges
                          .any((badgeId) => _model.selectedBadgeIds.contains(badgeId));
                    }).toList();
                  } else if (_model.showOnlyUsersWithBadges) {
                    // Filter users who have any badges
                    listViewUsersRecordList = listViewUsersRecordList.where((user) {
                      return user.hasAnyBadges;
                    }).toList();
                  }

                  if (listViewUsersRecordList.isEmpty) {
                    return Center(
                      child: Text(
                        'Kullanıcı bulunamadı',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Figtree',
                              letterSpacing: 0.0,
                            ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                    scrollDirection: Axis.vertical,
                    itemCount: listViewUsersRecordList.length,
                    separatorBuilder: (_, __) => SizedBox(height: 1.0),
                    itemBuilder: (context, listViewIndex) {
                      final listViewUsersRecord = listViewUsersRecordList[listViewIndex];
                      return wrapWithModel(
                        model: _model.userListModels.getModel(
                          listViewUsersRecord.reference.id,
                          listViewIndex,
                        ),
                        updateCallback: () => safeSetState(() {}),
                        child: AdminUserListItemWidget(
                          key: Key(
                            'Key_${listViewUsersRecord.reference.id}',
                          ),
                          userRef: listViewUsersRecord.reference,
                          userRecord: listViewUsersRecord,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
