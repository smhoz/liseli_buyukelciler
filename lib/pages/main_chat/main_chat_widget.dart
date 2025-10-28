import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sosyal_medya/backend/schema/badge_model/badge_model.dart';
import 'package:sosyal_medya/components/multiple_badges_display/multiple_badges_display_widget.dart';
import 'package:sosyal_medya/components/verified/verified_widget.dart';
import 'package:sosyal_medya/extension/dynamic_extensions.dart';
import 'package:sosyal_medya/helper/show_dialogs.dart';
import 'package:sosyal_medya/helper/image_error_helper.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/users_record_extensions.dart';
import '/components/empty_list_2/empty_list2_widget.dart';
import '/components/web_components/side_nav/side_nav_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'main_chat_model.dart';
export 'main_chat_model.dart';

class MainChatWidget extends StatefulWidget {
  const MainChatWidget({super.key});

  static String routeName = 'main_Chat';
  static String routePath = '/mainChat';

  @override
  State<MainChatWidget> createState() => _MainChatWidgetState();
}

class _MainChatWidgetState extends State<MainChatWidget> {
  late MainChatModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  DynamicViewExtensions dynamicViewExtensions = DynamicViewExtensions();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MainChatModel());

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
                backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                automaticallyImplyLeading: false,
                title: Text(
                  'Sohbetlerim',
                  style: FlutterFlowTheme.of(context).headlineLarge.override(
                        fontFamily: 'Outfit',
                        letterSpacing: 0.0,
                      ),
                ),
                actions: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 16.0, 8.0),
                    child: FlutterFlowIconButton(
                      borderColor: FlutterFlowTheme.of(context).primary,
                      borderRadius: 12.0,
                      borderWidth: 1.0,
                      buttonSize: 40.0,
                      fillColor: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.2),
                      icon: Icon(
                        Icons.add_comment,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        context.pushNamed(
                          Chat2InviteUsersWidget.routeName,
                          extra: <String, dynamic>{
                            kTransitionInfoKey: TransitionInfo(
                              hasTransition: true,
                              transitionType: PageTransitionType.bottomToTop,
                              duration: Duration(milliseconds: 270),
                            ),
                          },
                        );
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
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              wrapWithModel(
                model: _model.sideNavModel,
                updateCallback: () => safeSetState(() {}),
                child: SideNavWidget(
                  selectedNav: 2,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional(0.0, -1.0),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 1070.0,
                    ),
                    decoration: BoxDecoration(),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (responsiveVisibility(
                          context: context,
                          phone: false,
                          tablet: false,
                        ))
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
                            child: SizedBox(
                              width: 150,
                              height: 55,
                              child: Container(
                                child: SvgPicture.asset(
                                  'assets/logo/liseslibuyukelciler-01.svg',
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                            ),
                          ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                          child: Text(
                            'Sohbetleriniz ve grup sohbetleriniz aşağıdadır',
                            style: FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'Figtree',
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                        Expanded(
                          child: StreamBuilder<List<ChatsRecord>>(
                            stream: queryChatsRecord(
                              queryBuilder: (chatsRecord) => chatsRecord
                                  .where(
                                    'users',
                                    arrayContains: currentUserReference,
                                  )
                                  .orderBy('last_message_time', descending: true),
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
                              List<ChatsRecord> listViewChatsRecordList = snapshot.data!;
                              if (listViewChatsRecordList.isEmpty) {
                                return EmptyList2Widget();
                              }

                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.vertical,
                                itemCount: listViewChatsRecordList.length,
                                itemBuilder: (context, listViewIndex) {
                                  final listViewChatsRecord =
                                      listViewChatsRecordList[listViewIndex];
                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 1.0, 0.0, 0.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        context.pushNamed(
                                          Chat2DetailsWidget.routeName,
                                          queryParameters: {
                                            'chatRef': serializeParam(
                                              listViewChatsRecord,
                                              ParamType.Document,
                                            ),
                                          }.withoutNulls,
                                          extra: <String, dynamic>{
                                            'chatRef': listViewChatsRecord,
                                          },
                                        );
                                      },
                                      child: Material(
                                        color: Colors.transparent,
                                        elevation: 0.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(0.0),
                                        ),
                                        child: Container(
                                          width: 800.0,
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
                                          child: Builder(
                                            builder: (context) {
                                              if (listViewChatsRecord.users.length <= 2) {
                                                return Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(
                                                      16.0, 12.0, 12.0, 12.0),
                                                  child: FutureBuilder<UsersRecord>(
                                                    future: FFAppState().userDocQuery(
                                                      uniqueQueryKey:
                                                          listViewChatsRecord.reference.id,
                                                      requestFn: () => UsersRecord.getDocumentOnce(
                                                          listViewChatsRecord.users
                                                              .where(
                                                                  (e) => e != currentUserReference)
                                                              .toList()
                                                              .firstOrNull!),
                                                    ),
                                                    builder: (context, snapshot) {
                                                      // Customize what your widget looks like when it's loading.
                                                      if (!snapshot.hasData) {
                                                        return Center(
                                                          child: SizedBox(
                                                            width: 50.0,
                                                            height: 50.0,
                                                            child: CircularProgressIndicator(
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<Color>(
                                                                FlutterFlowTheme.of(context)
                                                                    .primary,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }

                                                      final rowUsersRecord = snapshot.data!;

                                                      return Row(
                                                        mainAxisSize: MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          Align(
                                                            alignment:
                                                                AlignmentDirectional(1.0, 1.0),
                                                            child: Container(
                                                              width: 44.0,
                                                              height: 44.0,
                                                              decoration: BoxDecoration(
                                                                color: FlutterFlowTheme.of(context)
                                                                    .accent1,
                                                                borderRadius:
                                                                    BorderRadius.circular(10.0),
                                                                shape: BoxShape.rectangle,
                                                                border: Border.all(
                                                                  color:
                                                                      FlutterFlowTheme.of(context)
                                                                          .primary,
                                                                  width: 2.0,
                                                                ),
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets.all(2.0),
                                                                child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius.circular(8.0),
                                                                  child: CachedNetworkImage(
                                                                    imageUrl:
                                                                        valueOrDefault<String>(
                                                                      rowUsersRecord.photoUrl,
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
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional.fromSTEB(
                                                                      8.0, 0.0, 0.0, 0.0),
                                                              child: Column(
                                                                mainAxisSize: MainAxisSize.max,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment.start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisSize: MainAxisSize.max,
                                                                    children: [
                                                                      Expanded(
                                                                        child: Padding(
                                                                          padding:
                                                                              EdgeInsetsDirectional
                                                                                  .fromSTEB(
                                                                                      0.0,
                                                                                      0.0,
                                                                                      12.0,
                                                                                      0.0),
                                                                          child: Row(
                                                                            children: <Widget>[
                                                                              // System chat icon
                                                                              if (listViewChatsRecord
                                                                                  .isSystemChat)
                                                                                Padding(
                                                                                  padding:
                                                                                      EdgeInsetsDirectional
                                                                                          .fromSTEB(
                                                                                              0.0,
                                                                                              0.0,
                                                                                              6.0,
                                                                                              0.0),
                                                                                  child: Icon(
                                                                                    Icons
                                                                                        .campaign_rounded,
                                                                                    color: FlutterFlowTheme.of(
                                                                                            context)
                                                                                        .warning,
                                                                                    size: 20.0,
                                                                                  ),
                                                                                ),
                                                                              Text(
                                                                                valueOrDefault<
                                                                                    String>(
                                                                                  rowUsersRecord
                                                                                      .displayName,
                                                                                  'Hayalet Kullanıcı',
                                                                                ),
                                                                                textAlign:
                                                                                    TextAlign.start,
                                                                                style: FlutterFlowTheme
                                                                                        .of(context)
                                                                                    .bodyLarge
                                                                                    .override(
                                                                                      fontFamily:
                                                                                          'Figtree',
                                                                                      letterSpacing:
                                                                                          0.0,
                                                                                    ),
                                                                              ),
                                                                              rowUsersRecord.badges
                                                                                      .isNotEmpty
                                                                                  ? MultipleBadgesDisplayWidget(
                                                                                      badgeIds:
                                                                                          rowUsersRecord
                                                                                              .badges,
                                                                                    )
                                                                                  : const SizedBox(),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      if (!listViewChatsRecord
                                                                          .lastMessageSeenBy
                                                                          .contains(
                                                                              currentUserReference))
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsetsDirectional
                                                                                  .fromSTEB(
                                                                                      0.0,
                                                                                      0.0,
                                                                                      8.0,
                                                                                      0.0),
                                                                          child: Container(
                                                                            width: 12.0,
                                                                            height: 12.0,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: FlutterFlowTheme
                                                                                      .of(context)
                                                                                  .accent1,
                                                                              shape:
                                                                                  BoxShape.circle,
                                                                              border: Border.all(
                                                                                color: FlutterFlowTheme
                                                                                        .of(context)
                                                                                    .primary,
                                                                                width: 2.0,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0, 4.0, 0.0, 0.0),
                                                                    child: Text(
                                                                      listViewChatsRecord
                                                                          .lastMessage,
                                                                      textAlign: TextAlign.start,
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .override(
                                                                            fontFamily: 'Figtree',
                                                                            letterSpacing: 0.0,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    mainAxisSize: MainAxisSize.max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsetsDirectional
                                                                                .fromSTEB(0.0, 4.0,
                                                                                    0.0, 0.0),
                                                                        child: Text(
                                                                          dateTimeFormat(
                                                                              "relative",
                                                                              listViewChatsRecord
                                                                                  .lastMessageTime!),
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                          style: FlutterFlowTheme
                                                                                  .of(context)
                                                                              .labelSmall
                                                                              .override(
                                                                                fontFamily:
                                                                                    'Figtree',
                                                                                letterSpacing: 0.0,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                      Icon(
                                                                        Icons.chevron_right_rounded,
                                                                        color: FlutterFlowTheme.of(
                                                                                context)
                                                                            .secondaryText,
                                                                        size: 24.0,
                                                                      ),
                                                                    ].divide(SizedBox(width: 16.0)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                );
                                              } else {
                                                return Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(
                                                      16.0, 12.0, 12.0, 12.0),
                                                  child: FutureBuilder<UsersRecord>(
                                                    future: FFAppState().userDocQuery(
                                                      uniqueQueryKey:
                                                          listViewChatsRecord.reference.id,
                                                      requestFn: () => UsersRecord.getDocumentOnce(
                                                          listViewChatsRecord.users
                                                              .where(
                                                                  (e) => e != currentUserReference)
                                                              .toList()
                                                              .firstOrNull!),
                                                    ),
                                                    builder: (context, snapshot) {
                                                      // Customize what your widget looks like when it's loading.
                                                      if (!snapshot.hasData) {
                                                        return Center(
                                                          child: SizedBox(
                                                            width: 50.0,
                                                            height: 50.0,
                                                            child: CircularProgressIndicator(
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<Color>(
                                                                FlutterFlowTheme.of(context)
                                                                    .primary,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }

                                                      final rowUsersRecord = snapshot.data!;

                                                      return Row(
                                                        mainAxisSize: MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                0.0, 0.0, 0.0, 8.0),
                                                            child: Container(
                                                              width: 44.0,
                                                              height: 54.0,
                                                              child: Stack(
                                                                children: [
                                                                  Align(
                                                                    alignment: AlignmentDirectional(
                                                                        1.0, 1.0),
                                                                    child:
                                                                        FutureBuilder<UsersRecord>(
                                                                      future: UsersRecord
                                                                          .getDocumentOnce(
                                                                              listViewChatsRecord
                                                                                  .users
                                                                                  .where((e) =>
                                                                                      e !=
                                                                                      currentUserReference)
                                                                                  .toList()
                                                                                  .lastOrNull!),
                                                                      builder: (context, snapshot) {
                                                                        // Customize what your widget looks like when it's loading.
                                                                        if (!snapshot.hasData) {
                                                                          return Center(
                                                                            child: SizedBox(
                                                                              width: 50.0,
                                                                              height: 50.0,
                                                                              child:
                                                                                  CircularProgressIndicator(
                                                                                valueColor:
                                                                                    AlwaysStoppedAnimation<
                                                                                        Color>(
                                                                                  FlutterFlowTheme.of(
                                                                                          context)
                                                                                      .primary,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }

                                                                        final containerUsersRecord =
                                                                            snapshot.data!;

                                                                        return Container(
                                                                          width: 32.0,
                                                                          height: 32.0,
                                                                          decoration: BoxDecoration(
                                                                            color:
                                                                                FlutterFlowTheme.of(
                                                                                        context)
                                                                                    .accent1,
                                                                            borderRadius:
                                                                                BorderRadius
                                                                                    .circular(10.0),
                                                                            shape:
                                                                                BoxShape.rectangle,
                                                                            border: Border.all(
                                                                              color: FlutterFlowTheme
                                                                                      .of(context)
                                                                                  .primary,
                                                                              width: 2.0,
                                                                            ),
                                                                          ),
                                                                          child: Container(
                                                                            padding:
                                                                                EdgeInsets.all(2.0),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color:
                                                                                  containerUsersRecord
                                                                                          .photoUrl
                                                                                          .isEmpty
                                                                                      ? Colors.white
                                                                                      : null,
                                                                              borderRadius:
                                                                                  BorderRadius.circular(
                                                                                      containerUsersRecord
                                                                                              .photoUrl
                                                                                              .isEmpty
                                                                                          ? 10.0
                                                                                          : 0),
                                                                            ),
                                                                            child: ImageErrorHelper
                                                                                .cachedProfileImage(
                                                                              context: context,
                                                                              imageUrl: containerUsersRecord
                                                                                      .photoUrl
                                                                                      .isNotEmpty
                                                                                  ? containerUsersRecord
                                                                                      .photoUrl
                                                                                  : 'https://firebasestorage.googleapis.com/v0/b/liseli-buyukelciler-db.firebasestorage.app/o/app_ico%2Ficons8-account-96.png?alt=media&token=4104ae4d-7566-449c-81d8-ebbb1fac88e6',
                                                                              displayName:
                                                                                  containerUsersRecord
                                                                                      .displayName,
                                                                              width: 44.0,
                                                                              height: 44.0,
                                                                              borderRadius:
                                                                                  BorderRadius
                                                                                      .circular(
                                                                                          8.0),
                                                                              fadeInDuration:
                                                                                  Duration(
                                                                                      milliseconds:
                                                                                          300),
                                                                              fadeOutDuration:
                                                                                  Duration(
                                                                                      milliseconds:
                                                                                          300),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                  Align(
                                                                    alignment: AlignmentDirectional(
                                                                        -1.0, -1.0),
                                                                    child: Container(
                                                                      width: 32.0,
                                                                      height: 32.0,
                                                                      decoration: BoxDecoration(
                                                                        color: FlutterFlowTheme.of(
                                                                                context)
                                                                            .accent1,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10.0),
                                                                        shape: BoxShape.rectangle,
                                                                        border: Border.all(
                                                                          color:
                                                                              FlutterFlowTheme.of(
                                                                                      context)
                                                                                  .primary,
                                                                          width: 2.0,
                                                                        ),
                                                                      ),
                                                                      child: Container(
                                                                        padding:
                                                                            EdgeInsets.all(2.0),
                                                                        decoration: BoxDecoration(
                                                                          color: rowUsersRecord
                                                                                  .photoUrl
                                                                                  .isNotEmpty
                                                                              ? null
                                                                              : Colors.white,
                                                                          borderRadius:
                                                                              BorderRadius.circular(
                                                                                  rowUsersRecord
                                                                                          .photoUrl
                                                                                          .isNotEmpty
                                                                                      ? 0
                                                                                      : 10.0),
                                                                        ),
                                                                        child: ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(
                                                                                  8.0),
                                                                          child: CachedNetworkImage(
                                                                            imageUrl: rowUsersRecord
                                                                                    .photoUrl
                                                                                    .isNotEmpty
                                                                                ? rowUsersRecord
                                                                                    .photoUrl
                                                                                : 'https://firebasestorage.googleapis.com/v0/b/liseli-buyukelciler-db.firebasestorage.app/o/app_ico%2Ficons8-account-96.png?alt=media&token=4104ae4d-7566-449c-81d8-ebbb1fac88e6',
                                                                            width: 44.0,
                                                                            height: 44.0,
                                                                            fit: BoxFit.cover,
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
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional.fromSTEB(
                                                                      8.0, 0.0, 0.0, 0.0),
                                                              child: Column(
                                                                mainAxisSize: MainAxisSize.max,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment.start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisSize: MainAxisSize.max,
                                                                    children: [
                                                                      Expanded(
                                                                        child: Padding(
                                                                          padding:
                                                                              EdgeInsetsDirectional
                                                                                  .fromSTEB(
                                                                                      0.0,
                                                                                      0.0,
                                                                                      12.0,
                                                                                      0.0),
                                                                          child: Text(
                                                                            'Grup Sohbeti',
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style:
                                                                                FlutterFlowTheme.of(
                                                                                        context)
                                                                                    .bodyLarge
                                                                                    .override(
                                                                                      fontFamily:
                                                                                          'Figtree',
                                                                                      letterSpacing:
                                                                                          0.0,
                                                                                    ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      if (!listViewChatsRecord
                                                                          .lastMessageSeenBy
                                                                          .contains(
                                                                              currentUserReference))
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsetsDirectional
                                                                                  .fromSTEB(
                                                                                      0.0,
                                                                                      0.0,
                                                                                      8.0,
                                                                                      0.0),
                                                                          child: Container(
                                                                            width: 12.0,
                                                                            height: 12.0,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: FlutterFlowTheme
                                                                                      .of(context)
                                                                                  .accent1,
                                                                              shape:
                                                                                  BoxShape.circle,
                                                                              border: Border.all(
                                                                                color: FlutterFlowTheme
                                                                                        .of(context)
                                                                                    .primary,
                                                                                width: 2.0,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0, 4.0, 0.0, 0.0),
                                                                    child: Text(
                                                                      listViewChatsRecord
                                                                          .lastMessage,
                                                                      textAlign: TextAlign.start,
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .override(
                                                                            fontFamily: 'Figtree',
                                                                            letterSpacing: 0.0,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    mainAxisSize: MainAxisSize.max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsetsDirectional
                                                                                .fromSTEB(0.0, 4.0,
                                                                                    0.0, 0.0),
                                                                        child: Text(
                                                                          valueOrDefault<String>(
                                                                            dateTimeFormat(
                                                                                "relative",
                                                                                listViewChatsRecord
                                                                                    .lastMessageTime),
                                                                            '--',
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                          style: FlutterFlowTheme
                                                                                  .of(context)
                                                                              .labelSmall
                                                                              .override(
                                                                                fontFamily:
                                                                                    'Figtree',
                                                                                letterSpacing: 0.0,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                      Icon(
                                                                        Icons.chevron_right_rounded,
                                                                        color: FlutterFlowTheme.of(
                                                                                context)
                                                                            .secondaryText,
                                                                        size: 24.0,
                                                                      ),
                                                                    ].divide(SizedBox(width: 16.0)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
