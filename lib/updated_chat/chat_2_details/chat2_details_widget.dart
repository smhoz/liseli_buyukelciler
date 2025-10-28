import 'package:sosyal_medya/backend/schema/badge_model/badge_model.dart';
import 'package:sosyal_medya/components/multiple_badges_display/multiple_badges_display_widget.dart';
import 'package:sosyal_medya/components/verified/verified_widget.dart';
import 'package:sosyal_medya/extension/dynamic_extensions.dart';
import 'package:sosyal_medya/helper/show_dialogs.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/users_record_extensions.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/updated_chat/chat_details_overlay/chat_details_overlay_widget.dart';
import '/updated_chat/chat_thread_component/chat_thread_component_widget.dart';
import 'dart:async';
import '/index.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'chat2_details_model.dart';
export 'chat2_details_model.dart';

class Chat2DetailsWidget extends StatefulWidget {
  const Chat2DetailsWidget({
    super.key,
    required this.chatRef,
  });

  final ChatsRecord? chatRef;

  static String routeName = 'chat_2_Details';
  static String routePath = '/chat2Details';

  @override
  State<Chat2DetailsWidget> createState() => _Chat2DetailsWidgetState();
}

class _Chat2DetailsWidgetState extends State<Chat2DetailsWidget> {
  late Chat2DetailsModel _model;

  DynamicViewExtensions dynamicViewExtensions = DynamicViewExtensions();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Chat2DetailsModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      unawaited(
        () async {
          await widget.chatRef!.reference.update({
            ...mapToFirestore(
              {
                'last_message_seen_by': FieldValue.arrayUnion([currentUserReference]),
              },
            ),
          });
        }(),
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: responsiveVisibility(
          context: context,
          tabletLandscape: false,
          desktop: false,
        )
            ? AppBar(
                backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
                automaticallyImplyLeading: false,
                leading: FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 30.0,
                  borderWidth: 1.0,
                  buttonSize: 60.0,
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 30.0,
                  ),
                  onPressed: () async {
                    context.goNamed(
                      MainChatWidget.routeName,
                      extra: <String, dynamic>{
                        kTransitionInfoKey: TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.leftToRight,
                          duration: Duration(milliseconds: 230),
                        ),
                      },
                    );
                  },
                ),
                title: FutureBuilder<UsersRecord>(
                  future: UsersRecord.getDocumentOnce(widget.chatRef!.users
                      .where((e) => e != currentUserReference)
                      .toList()
                      .firstOrNull!),
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

                    final conditionalBuilderUsersRecord = snapshot.data!;

                    return Builder(
                      builder: (context) {
                        if (widget.chatRef!.users.length <= 2) {
                          return Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (conditionalBuilderUsersRecord.photoUrl != '')
                                Align(
                                  alignment: AlignmentDirectional(-1.0, -1.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        context.pushNamed(
                                          ViewProfilePageOtherWidget.routeName,
                                          queryParameters: {
                                            'userDetails': serializeParam(
                                              conditionalBuilderUsersRecord,
                                              ParamType.Document,
                                            ),
                                            'showPage': serializeParam(
                                              false,
                                              ParamType.bool,
                                            ),
                                            'pageTitle': serializeParam(
                                              'Chat',
                                              ParamType.String,
                                            ),
                                          }.withoutNulls,
                                          extra: <String, dynamic>{
                                            'userDetails': conditionalBuilderUsersRecord,
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: 44.0,
                                        height: 44.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context).accent1,
                                          borderRadius: BorderRadius.circular(10.0),
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context).primary,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(2.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8.0),
                                            child: Image.network(
                                              conditionalBuilderUsersRecord.photoUrl,
                                              width: 44.0,
                                              height: 44.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          valueOrDefault<String>(
                                            conditionalBuilderUsersRecord.displayName,
                                            'Hayalet Kullanıcı',
                                          ),
                                          style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                fontFamily: 'Figtree',
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        conditionalBuilderUsersRecord.hasAnyBadges
                                            ? MultipleBadgesDisplayWidget(
                                                badgeIds: conditionalBuilderUsersRecord.badges,
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                      child: AutoSizeText(
                                        valueOrDefault<String>(
                                          conditionalBuilderUsersRecord.email,
                                          'casper@ghost.io',
                                        ).maybeHandleOverflow(
                                          maxChars: 40,
                                          replacement: '…',
                                        ),
                                        minFontSize: 10.0,
                                        style: FlutterFlowTheme.of(context).labelSmall.override(
                                              fontFamily: 'Figtree',
                                              color: FlutterFlowTheme.of(context).primary,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 12.0, 4.0),
                                child: Container(
                                  width: 54.0,
                                  height: 44.0,
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: AlignmentDirectional(1.0, 1.0),
                                        child: FutureBuilder<UsersRecord>(
                                          future: UsersRecord.getDocumentOnce(widget.chatRef!.users
                                              .where((e) => e != currentUserReference)
                                              .toList()
                                              .lastOrNull!),
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

                                            final secondUserUsersRecord = snapshot.data!;

                                            return InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor: Colors.transparent,
                                              onTap: () async {
                                                context.pushNamed(
                                                  ViewProfilePageOtherWidget.routeName,
                                                  queryParameters: {
                                                    'userDetails': serializeParam(
                                                      secondUserUsersRecord,
                                                      ParamType.Document,
                                                    ),
                                                    'showPage': serializeParam(
                                                      false,
                                                      ParamType.bool,
                                                    ),
                                                    'pageTitle': serializeParam(
                                                      'Chat',
                                                      ParamType.String,
                                                    ),
                                                  }.withoutNulls,
                                                  extra: <String, dynamic>{
                                                    'userDetails': secondUserUsersRecord,
                                                  },
                                                );
                                              },
                                              child: Container(
                                                width: 32.0,
                                                height: 32.0,
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
                                                    color: secondUserUsersRecord.photoUrl.isEmpty
                                                        ? Colors.white
                                                        : null,
                                                    borderRadius: BorderRadius.circular(
                                                        secondUserUsersRecord.photoUrl.isEmpty
                                                            ? 10.0
                                                            : 0),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(8.0),
                                                    child: CachedNetworkImage(
                                                      fadeInDuration: Duration(milliseconds: 300),
                                                      fadeOutDuration: Duration(milliseconds: 300),
                                                      imageUrl: valueOrDefault<String>(
                                                        secondUserUsersRecord.photoUrl,
                                                        'https://firebasestorage.googleapis.com/v0/b/liseli-buyukelciler-db.firebasestorage.app/o/app_ico%2Ficons8-account-96.png?alt=media&token=4104ae4d-7566-449c-81d8-ebbb1fac88e6',
                                                      ),
                                                      width: 44.0,
                                                      height: 44.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Align(
                                        alignment: AlignmentDirectional(-1.0, -1.0),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            context.pushNamed(
                                              ViewProfilePageOtherWidget.routeName,
                                              queryParameters: {
                                                'userDetails': serializeParam(
                                                  conditionalBuilderUsersRecord,
                                                  ParamType.Document,
                                                ),
                                                'showPage': serializeParam(
                                                  false,
                                                  ParamType.bool,
                                                ),
                                                'pageTitle': serializeParam(
                                                  'Chat',
                                                  ParamType.String,
                                                ),
                                              }.withoutNulls,
                                              extra: <String, dynamic>{
                                                'userDetails': conditionalBuilderUsersRecord,
                                              },
                                            );
                                          },
                                          child: Container(
                                            width: 32.0,
                                            height: 32.0,
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
                                                color:
                                                    conditionalBuilderUsersRecord.photoUrl.isEmpty
                                                        ? Colors.white
                                                        : null,
                                                borderRadius: BorderRadius.circular(
                                                    conditionalBuilderUsersRecord.photoUrl.isEmpty
                                                        ? 10.0
                                                        : 0),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(8.0),
                                                child: Image.network(
                                                  valueOrDefault<String>(
                                                    conditionalBuilderUsersRecord.photoUrl,
                                                    'https://firebasestorage.googleapis.com/v0/b/liseli-buyukelciler-db.firebasestorage.app/o/app_ico%2Ficons8-account-96.png?alt=media&token=4104ae4d-7566-449c-81d8-ebbb1fac88e6',
                                                  ),
                                                  width: 44.0,
                                                  height: 44.0,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Grup Sohbeti',
                                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                                            fontFamily: 'Figtree',
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                      child: Text(
                                        '${valueOrDefault<String>(
                                          widget.chatRef?.users.length.toString(),
                                          '2',
                                        )} üyeler',
                                        style: FlutterFlowTheme.of(context).labelSmall.override(
                                              fontFamily: 'Figtree',
                                              color: FlutterFlowTheme.of(context).primary,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    );
                  },
                ),
                actions: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 16.0, 8.0),
                    child: FlutterFlowIconButton(
                      borderColor: FlutterFlowTheme.of(context).alternate,
                      borderRadius: 12.0,
                      borderWidth: 2.0,
                      buttonSize: 40.0,
                      fillColor: FlutterFlowTheme.of(context).primaryBackground,
                      icon: Icon(
                        Icons.more_vert,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        await showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: FlutterFlowTheme.of(context).accent4,
                          barrierColor: Color(0x00FFFFFF),
                          context: context,
                          builder: (context) {
                            return GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              child: Padding(
                                padding: MediaQuery.viewInsetsOf(context),
                                child: ChatDetailsOverlayWidget(
                                  chatRef: widget.chatRef!,
                                ),
                              ),
                            );
                          },
                        ).then((value) => safeSetState(() {}));
                      },
                    ),
                  ),
                ],
                centerTitle: false,
                elevation: 0.0,
              )
            : null,
        body: SafeArea(
          top: true,
          child: wrapWithModel(
            model: _model.chatThreadComponentModel,
            updateCallback: () => safeSetState(() {}),
            updateOnChange: true,
            child: ChatThreadComponentWidget(
              chatRef: widget.chatRef,
            ),
          ),
        ),
      ),
    );
  }
}
