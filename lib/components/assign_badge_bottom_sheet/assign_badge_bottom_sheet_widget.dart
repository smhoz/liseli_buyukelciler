import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import '/backend/schema/badge_model/badge_model.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:sosyal_medya/service/notification_service.dart';
import 'package:sosyal_medya/service/system_user_initializer.dart';
import 'assign_badge_bottom_sheet_model.dart';
export 'assign_badge_bottom_sheet_model.dart';

class AssignBadgeBottomSheetWidget extends StatefulWidget {
  const AssignBadgeBottomSheetWidget({
    super.key,
    required this.userId,
    required this.userName,
    this.currentBadgeIds,
  });

  final String userId;
  final String userName;
  final List<String>? currentBadgeIds;

  @override
  State<AssignBadgeBottomSheetWidget> createState() => _AssignBadgeBottomSheetWidgetState();
}

class _AssignBadgeBottomSheetWidgetState extends State<AssignBadgeBottomSheetWidget> {
  late AssignBadgeBottomSheetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AssignBadgeBottomSheetModel());
    // Initialize with current badges
    if (widget.currentBadgeIds != null) {
      _model.selectedBadgeIds = Set<String>.from(widget.currentBadgeIds!);
    }
    _model.searchController ??= TextEditingController();
    _model.searchFocusNode ??= FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Future<void> _assignBadges() async {
    if (_model.selectedBadgeIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lütfen en az bir rozet seçin'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }

    try {
      // Determine newly added badges
      final currentBadges = widget.currentBadgeIds?.toSet() ?? <String>{};
      final newBadges = _model.selectedBadgeIds.difference(currentBadges);

      // Update user's badges (as list)
      await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
        'badges': _model.selectedBadgeIds.toList(),
        'is_badge': _model.selectedBadgeIds.isNotEmpty,
      });

      // Send notification and message for each newly added badge
      if (newBadges.isNotEmpty) {
        await _sendNotificationsForNewBadges(newBadges);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rozetler başarıyla atandı!'),
            backgroundColor: FlutterFlowTheme.of(context).success,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $e'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    }
  }

  Future<void> _sendNotificationsForNewBadges(Set<String> newBadgeIds) async {
    try {
      // Get user's FCM token
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();

      final fcmToken = userDoc.data()?['fcm_token'] as String?;

      for (final badgeId in newBadgeIds) {
        // Fetch badge details
        final badgeDoc = await FirebaseFirestore.instance.collection('badge').doc(badgeId).get();

        if (!badgeDoc.exists) continue;

        final badgeData = badgeDoc.data() as Map<String, dynamic>;
        final badgeName = badgeData['name'] as String? ?? 'Rozet';

        // Send FCM notification if user has a token
        if (fcmToken != null && fcmToken.isNotEmpty) {
          try {
            await _sendSingleNotification(
              fcmToken: fcmToken,
              title: '🏆 Yeni Rozet Kazandın!',
              body: '"$badgeName" rozeti sana verildi. Tebrikler!',
              badgeId: badgeId,
            );
          } catch (e) {
            print('Bildirim gönderme hatası: $e');
          }
        }

        // Send system message
        try {
          await _sendSingleSystemMessage(
            userId: widget.userId,
            message: '🏆 Tebrikler! "$badgeName" rozeti sana verildi.',
            badgeId: badgeId,
          );
        } catch (e) {
          print('Sistem mesajı gönderme hatası: $e');
        }
      }
    } catch (e) {
      print('Bildirim/mesaj gönderme genel hatası: $e');
    }
  }

  Future<void> _sendSingleNotification({
    required String fcmToken,
    required String title,
    required String body,
    required String badgeId,
  }) async {
    try {
      final notificationService = NotificationService();
      final accessToken = await notificationService.getAccessToken();

      final payload = {
        'message': {
          'token': fcmToken,
          'notification': {
            'title': title,
            'body': body,
          },
          'data': {
            'type': 'badge_notification',
            'badge_ids': badgeId,
          },
          'android': {
            'priority': 'high',
            'notification': {
              'channel_id': 'badge_channel',
            }
          },
          'apns': {
            'headers': {
              'apns-priority': '10',
            },
            'payload': {
              'aps': {
                'sound': 'default',
                'badge': 1,
              }
            }
          }
        }
      };

      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/v1/projects/liseli-buyukelciler-db/messages:send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('✅ Bildirim başarıyla gönderildi');
      } else {
        print('❌ Bildirim gönderilemedi: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Bildirim gönderme hatası: $e');
      rethrow;
    }
  }

  Future<void> _sendSingleSystemMessage({
    required String userId,
    required String message,
    required String badgeId,
  }) async {
    try {
      final systemUserRef =
          FirebaseFirestore.instance.collection('users').doc(SystemUserInitializer.SYSTEM_USER_ID);
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

      // Get or create system chat
      final chatRef = await _getOrCreateSystemChat(systemUserRef, userRef);

      if (chatRef == null) {
        print('❌ Chat oluşturulamadı');
        return;
      }

      // Send message
      final messageRef = FirebaseFirestore.instance.collection('chat_messages').doc();

      final batch = FirebaseFirestore.instance.batch();

      batch.set(messageRef, {
        'user': systemUserRef,
        'chat': chatRef,
        'text': message,
        'timestamp': FieldValue.serverTimestamp(),
        'image': '',
        'video': '',
        'is_system_message': true,
        'badge_ids': badgeId,
      });

      batch.update(chatRef, {
        'last_message': message,
        'last_message_time': FieldValue.serverTimestamp(),
        'last_message_sent_by': systemUserRef,
        'last_message_seen_by': [systemUserRef],
      });

      await batch.commit();
      print('✅ Sistem mesajı başarıyla gönderildi');
    } catch (e) {
      print('❌ Sistem mesajı gönderme hatası: $e');
      rethrow;
    }
  }

  Future<DocumentReference?> _getOrCreateSystemChat(
    DocumentReference systemUserRef,
    DocumentReference userRef,
  ) async {
    try {
      // Check if system chat already exists
      final existingChats = await FirebaseFirestore.instance
          .collection('chats')
          .where('users', arrayContains: systemUserRef)
          .get();

      // Find chat with this specific user
      for (var chatDoc in existingChats.docs) {
        final chatData = chatDoc.data();
        final users = List<DocumentReference>.from(chatData['users'] ?? []);

        if (users.contains(userRef)) {
          return chatDoc.reference;
        }
      }

      // Create new system chat
      final chatRef = FirebaseFirestore.instance.collection('chats').doc();

      await chatRef.set({
        'users': [systemUserRef, userRef],
        'user_a': systemUserRef,
        'user_b': userRef,
        'last_message': '',
        'last_message_time': FieldValue.serverTimestamp(),
        'last_message_sent_by': systemUserRef,
        'last_message_seen_by': [systemUserRef],
        'group_chat_id': DateTime.now().millisecondsSinceEpoch % 9999999,
        'is_system_chat': true,
      });

      return chatRef;
    } catch (e) {
      print('❌ Chat oluşturma hatası: $e');
      return null;
    }
  }

  Future<void> _removeAllBadges() async {
    try {
      // Remove all user's badges
      await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
        'badges': [],
        'is_badge': false,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tüm rozetler kaldırıldı'),
            backgroundColor: FlutterFlowTheme.of(context).success,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $e'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rozet Ata',
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                          fontFamily: 'Outfit',
                          letterSpacing: 0.0,
                        ),
                  ),
                  FlutterFlowIconButton(
                    borderColor: FlutterFlowTheme.of(context).alternate,
                    borderRadius: 12.0,
                    borderWidth: 1.0,
                    buttonSize: 44.0,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    icon: Icon(
                      Icons.close_rounded,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 24.0,
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Text(
                widget.userName,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Figtree',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Rozetler',
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'Figtree',
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 12.0),
              // Search TextField
              TextFormField(
                controller: _model.searchController,
                focusNode: _model.searchFocusNode,
                onChanged: (_) => setState(() {}),
                autofocus: false,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: 'Rozet Ara...',
                  hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Figtree',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).primary,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).error,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                  suffixIcon: _model.searchController!.text.isNotEmpty
                      ? InkWell(
                          onTap: () async {
                            _model.searchController?.clear();
                            setState(() {});
                          },
                          child: Icon(
                            Icons.clear,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 20.0,
                          ),
                        )
                      : null,
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Figtree',
                      letterSpacing: 0.0,
                    ),
                validator: _model.searchControllerValidator.asValidator(context),
              ),
              SizedBox(height: 12.0),
              Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('badge')
                      .where('is_deleted', isEqualTo: false)
                      .snapshots(),
                  builder: (context, snapshot) {
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

                    var badges = snapshot.data!.docs;

                    // Filter badges based on search
                    final searchTerm = _model.searchController?.text ?? '';
                    if (searchTerm.isNotEmpty) {
                      badges = badges.where((badgeDoc) {
                        final badgeData = badgeDoc.data() as Map<String, dynamic>;
                        final badgeName = (badgeData['name'] ?? '').toString().toLowerCase();
                        return badgeName.contains(searchTerm.toLowerCase());
                      }).toList();
                    }

                    if (badges.isEmpty) {
                      return Center(
                        child: Text(
                          searchTerm.isNotEmpty ? 'Rozet bulunamadı' : 'Henüz rozet bulunmuyor',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Figtree',
                                letterSpacing: 0.0,
                              ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: badges.length,
                      itemBuilder: (context, index) {
                        final badgeDoc = badges[index];
                        final badgeData = badgeDoc.data() as Map<String, dynamic>;
                        final badge = BadgeModel.fromJson({
                          'id': badgeDoc.id,
                          ...badgeData,
                        });

                        final isSelected = _model.selectedBadgeIds.contains(badgeDoc.id);

                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _model.selectedBadgeIds.remove(badgeDoc.id);
                              } else {
                                _model.selectedBadgeIds.add(badgeDoc.id);
                              }
                            });
                          },
                          child: Container(
                            margin: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                            padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 12.0),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? FlutterFlowTheme.of(context).accent1
                                  : FlutterFlowTheme.of(context).primaryBackground,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: isSelected
                                    ? FlutterFlowTheme.of(context).primary
                                    : FlutterFlowTheme.of(context).alternate,
                                width: 2.0,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: CachedNetworkImage(
                                    imageUrl: badge.file_url,
                                    width: 40.0,
                                    height: 40.0,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, error, stackTrace) => Icon(
                                      Icons.emoji_events,
                                      size: 40.0,
                                      color: FlutterFlowTheme.of(context).primary,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.0),
                                Expanded(
                                  child: Text(
                                    badge.name,
                                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                                          fontFamily: 'Figtree',
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              isSelected ? FontWeight.w600 : FontWeight.normal,
                                        ),
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 24.0,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (widget.currentBadgeIds != null && widget.currentBadgeIds!.isNotEmpty)
                    Expanded(
                      child: FFButtonWidget(
                        onPressed: _removeAllBadges,
                        text: 'Tümünü Kaldır',
                        icon: Icon(
                          Icons.remove_circle_outline,
                          size: 20.0,
                        ),
                        options: FFButtonOptions(
                          height: 50.0,
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).error,
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Figtree',
                                color: Colors.white,
                                letterSpacing: 0.0,
                              ),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  if (widget.currentBadgeIds != null && widget.currentBadgeIds!.isNotEmpty)
                    SizedBox(width: 12.0),
                  Expanded(
                    child: FFButtonWidget(
                      onPressed: _assignBadges,
                      text: 'Kaydet',
                      icon: Icon(
                        Icons.check,
                        size: 20.0,
                      ),
                      options: FFButtonOptions(
                        height: 50.0,
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                              fontFamily: 'Figtree',
                              color: Colors.white,
                              letterSpacing: 0.0,
                            ),
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
