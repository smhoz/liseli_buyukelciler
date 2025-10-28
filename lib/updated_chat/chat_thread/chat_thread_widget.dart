import 'package:sosyal_medya/backend/schema/badge_model/badge_model.dart';
import 'package:sosyal_medya/components/multiple_badges_display/multiple_badges_display_widget.dart';
import 'package:sosyal_medya/components/verified/verified_widget.dart';
import 'package:sosyal_medya/extension/dynamic_extensions.dart';
import 'package:sosyal_medya/helper/show_dialogs.dart';
import 'package:sosyal_medya/pages/event/model/event_model.dart';
import 'package:sosyal_medya/pages/event/view/event_detail/event_detail_view.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/users_record_extensions.dart';
import '/flutter_flow/flutter_flow_media_display.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_video_player.dart';
import '/index.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'chat_thread_model.dart';
export 'chat_thread_model.dart';

class ChatThreadWidget extends StatefulWidget {
  const ChatThreadWidget({
    super.key,
    required this.chatMessagesRef,
  });

  final ChatMessagesRecord? chatMessagesRef;

  @override
  State<ChatThreadWidget> createState() => _ChatThreadWidgetState();
}

class _ChatThreadWidgetState extends State<ChatThreadWidget> {
  late ChatThreadModel _model;

  DynamicViewExtensions dynamicViewExtensions = DynamicViewExtensions();

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatThreadModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  /// Navigate to event detail page if message has event_id
  Future<void> _handleEventMessageTap() async {
    final eventId = widget.chatMessagesRef?.eventId;
    if (eventId == null || eventId.isEmpty) return;

    try {
      // Fetch event from Firestore
      final eventDoc = await FirebaseFirestore.instance.collection('events').doc(eventId).get();

      if (!eventDoc.exists) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Etkinlik bulunamadı'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final eventData = eventDoc.data()!;
      eventData['id'] = eventDoc.id;
      final event = EventModel.fromJson(eventData);

      if (!mounted) return;

      // Navigate to event detail page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventDetailView(eventModel: event),
        ),
      );
    } catch (e) {
      print('❌ Etkinlik yükleme hatası: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Etkinlik yüklenirken hata oluştu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.chatMessagesRef?.user != currentUserReference)
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 1.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 0.0,
                    color: FlutterFlowTheme.of(context).alternate,
                    offset: Offset(
                      0.0,
                      1.0,
                    ),
                  )
                ],
                borderRadius: BorderRadius.circular(0.0),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 0.0),
                child: FutureBuilder<UsersRecord>(
                  future: _model.chatUser(
                    uniqueQueryKey: widget.chatMessagesRef?.reference.id,
                    requestFn: () => UsersRecord.getDocumentOnce(widget.chatMessagesRef!.user!),
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

                    final otherUserUsersRecord = snapshot.data!;

                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 8.0, 16.0),
                          child: Container(
                            width: 36.0,
                            height: 36.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).accent1,
                              borderRadius: BorderRadius.circular(10.0),
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2.0,
                              ),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                color: otherUserUsersRecord.photoUrl.isEmpty ? Colors.white : null,
                                borderRadius: BorderRadius.circular(
                                    otherUserUsersRecord.photoUrl.isEmpty ? 10.0 : 0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: CachedNetworkImage(
                                  fadeInDuration: Duration(milliseconds: 200),
                                  fadeOutDuration: Duration(milliseconds: 200),
                                  imageUrl: otherUserUsersRecord.photoUrl.isEmpty
                                      ? 'https://firebasestorage.googleapis.com/v0/b/liseli-buyukelciler-db.firebasestorage.app/o/app_ico%2Ficons8-account-96.png?alt=media&token=4104ae4d-7566-449c-81d8-ebbb1fac88e6'
                                      : otherUserUsersRecord.photoUrl,
                                  width: 44.0,
                                  height: 44.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SelectionArea(
                                        child: AutoSizeText(
                                      otherUserUsersRecord.displayName,
                                      textAlign: TextAlign.start,
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Figtree',
                                            letterSpacing: 0.0,
                                            lineHeight: 1.5,
                                          ),
                                    )),
                                    FutureBuilder<UsersRecord>(
                                      future: UsersRecord.getDocumentOnce(
                                          otherUserUsersRecord.reference),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return const SizedBox();
                                        }

                                        final mainProfileUsersRecord = snapshot.data!;

                                        return mainProfileUsersRecord.badges.isNotEmpty
                                            ? MultipleBadgesDisplayWidget(
                                                badgeIds: mainProfileUsersRecord.badges,
                                              )
                                            : const SizedBox();
                                      },
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                      child: Text(
                                        valueOrDefault<String>(
                                          dateTimeFormat(
                                              "relative", widget.chatMessagesRef?.timestamp),
                                          '--',
                                        ),
                                        style: FlutterFlowTheme.of(context).labelSmall.override(
                                              fontFamily: 'Figtree',
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 4.0)),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                  child: widget.chatMessagesRef?.hasEventId() == true
                                      ? Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: _handleEventMessageTap,
                                            borderRadius: BorderRadius.circular(12.0),
                                            child: Container(
                                              padding: EdgeInsetsDirectional.fromSTEB(
                                                  12.0, 12.0, 12.0, 12.0),
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(context)
                                                    .primary
                                                    .withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(12.0),
                                                border: Border.all(
                                                  color: FlutterFlowTheme.of(context).primary,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Expanded(
                                                    child: AutoSizeText(
                                                      valueOrDefault<String>(
                                                        widget.chatMessagesRef?.text,
                                                        '--',
                                                      ),
                                                      textAlign: TextAlign.start,
                                                      style: FlutterFlowTheme.of(context)
                                                          .labelLarge
                                                          .override(
                                                            fontFamily: 'Figtree',
                                                            letterSpacing: 0.0,
                                                            lineHeight: 1.5,
                                                          ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 8.0),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: FlutterFlowTheme.of(context).primary,
                                                    size: 16.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : SelectionArea(
                                          child: AutoSizeText(
                                            valueOrDefault<String>(
                                              widget.chatMessagesRef?.text,
                                              '--',
                                            ),
                                            textAlign: TextAlign.start,
                                            style: FlutterFlowTheme.of(context).labelLarge.override(
                                                  fontFamily: 'Figtree',
                                                  letterSpacing: 0.0,
                                                  lineHeight: 1.5,
                                                ),
                                          ),
                                        ),
                                ),
                                if (widget.chatMessagesRef?.image != null &&
                                    widget.chatMessagesRef?.image != '')
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 4.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        context.pushNamed(
                                          ImageDetailsWidget.routeName,
                                          queryParameters: {
                                            'chatMessage': serializeParam(
                                              widget.chatMessagesRef,
                                              ParamType.Document,
                                            ),
                                          }.withoutNulls,
                                          extra: <String, dynamic>{
                                            'chatMessage': widget.chatMessagesRef,
                                          },
                                        );
                                      },
                                      child: FlutterFlowMediaDisplay(
                                        path: widget.chatMessagesRef!.image,
                                        imageBuilder: (path) => ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: CachedNetworkImage(
                                            fadeInDuration: Duration(milliseconds: 500),
                                            fadeOutDuration: Duration(milliseconds: 500),
                                            imageUrl: path,
                                            width: 300.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        videoPlayerBuilder: (path) => FlutterFlowVideoPlayer(
                                          path: path,
                                          width: 300.0,
                                          autoPlay: false,
                                          looping: false,
                                          showControls: true,
                                          allowFullScreen: true,
                                          allowPlaybackSpeedMenu: false,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 1.0),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxWidth: double.infinity,
            ),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
              boxShadow: [
                BoxShadow(
                  blurRadius: 0.0,
                  color: FlutterFlowTheme.of(context).alternate,
                  offset: Offset(
                    0.0,
                    1.0,
                  ),
                )
              ],
              borderRadius: BorderRadius.circular(0.0),
            ),
            child: Visibility(
              visible: widget.chatMessagesRef?.user == currentUserReference,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 8.0, 16.0),
                      child: Container(
                        width: 36.0,
                        height: 36.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).accent1,
                          borderRadius: BorderRadius.circular(10.0),
                          shape: BoxShape.rectangle,
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 2.0,
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            color: currentUserPhoto.isEmpty ? Colors.white : null,
                            borderRadius:
                                BorderRadius.circular(currentUserPhoto.isEmpty ? 10.0 : 0),
                          ),
                          child: AuthUserStreamWidget(
                            builder: (context) => ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: CachedNetworkImage(
                                fadeInDuration: Duration(milliseconds: 200),
                                fadeOutDuration: Duration(milliseconds: 200),
                                imageUrl: currentUserPhoto.isEmpty
                                    ? 'https://firebasestorage.googleapis.com/v0/b/liseli-buyukelciler-db.firebasestorage.app/o/app_ico%2Ficons8-account-96.png?alt=media&token=4104ae4d-7566-449c-81d8-ebbb1fac88e6'
                                    : currentUserPhoto,
                                width: 44.0,
                                height: 44.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                AuthUserStreamWidget(
                                  builder: (context) => SelectionArea(
                                      child: AutoSizeText(
                                    valueOrDefault<String>(
                                      currentUserDisplayName,
                                      'Ben',
                                    ),
                                    textAlign: TextAlign.start,
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Figtree',
                                          letterSpacing: 0.0,
                                          lineHeight: 1.5,
                                        ),
                                  )),
                                ),
                                FutureBuilder<UsersRecord>(
                                  future: UsersRecord.getDocumentOnce(currentUserReference!),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const SizedBox();
                                    }

                                    final mainProfileUsersRecord = snapshot.data!;

                                    return mainProfileUsersRecord.badges.isNotEmpty
                                        ? MultipleBadgesDisplayWidget(
                                            badgeIds: mainProfileUsersRecord.badges,
                                          )
                                        : const SizedBox();
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                  child: Text(
                                    valueOrDefault<String>(
                                      dateTimeFormat("relative", widget.chatMessagesRef?.timestamp),
                                      '--',
                                    ),
                                    style: FlutterFlowTheme.of(context).labelSmall.override(
                                          fontFamily: 'Figtree',
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ),
                              ].divide(SizedBox(width: 4.0)),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                              child: widget.chatMessagesRef?.hasEventId() == true
                                  ? Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: _handleEventMessageTap,
                                        borderRadius: BorderRadius.circular(12.0),
                                        child: Container(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              12.0, 12.0, 12.0, 12.0),
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primary
                                                .withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12.0),
                                            border: Border.all(
                                              color: FlutterFlowTheme.of(context).primary,
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  valueOrDefault<String>(
                                                    widget.chatMessagesRef?.text,
                                                    '--',
                                                  ),
                                                  style: FlutterFlowTheme.of(context)
                                                      .labelLarge
                                                      .override(
                                                        fontFamily: 'Figtree',
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                              SizedBox(width: 8.0),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                color: FlutterFlowTheme.of(context).primary,
                                                size: 16.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : SelectionArea(
                                      child: Text(
                                        valueOrDefault<String>(
                                          widget.chatMessagesRef?.text,
                                          '--',
                                        ),
                                        style: FlutterFlowTheme.of(context).labelLarge.override(
                                              fontFamily: 'Figtree',
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                            ),
                            if (widget.chatMessagesRef?.image != null &&
                                widget.chatMessagesRef?.image != '')
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 4.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    context.pushNamed(
                                      ImageDetailsWidget.routeName,
                                      queryParameters: {
                                        'chatMessage': serializeParam(
                                          widget.chatMessagesRef,
                                          ParamType.Document,
                                        ),
                                      }.withoutNulls,
                                      extra: <String, dynamic>{
                                        'chatMessage': widget.chatMessagesRef,
                                      },
                                    );
                                  },
                                  child: FlutterFlowMediaDisplay(
                                    path: widget.chatMessagesRef!.image,
                                    imageBuilder: (path) => ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: CachedNetworkImage(
                                        fadeInDuration: Duration(milliseconds: 500),
                                        fadeOutDuration: Duration(milliseconds: 500),
                                        imageUrl: path,
                                        width: 300.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    videoPlayerBuilder: (path) => FlutterFlowVideoPlayer(
                                      path: path,
                                      width: 300.0,
                                      autoPlay: false,
                                      looping: true,
                                      showControls: true,
                                      allowFullScreen: true,
                                      allowPlaybackSpeedMenu: false,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
