import 'package:flutter_svg/svg.dart';
import 'package:sosyal_medya/backend/schema/badge_model/badge_model.dart';
import 'package:sosyal_medya/components/delete_post/delete_post_widget.dart' show DeletePostWidget;
import 'package:sosyal_medya/components/multiple_badges_display/multiple_badges_display_widget.dart';
import 'package:sosyal_medya/components/verified/verified_widget.dart';
import 'package:sosyal_medya/extension/dynamic_extensions.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_media_display.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_video_player.dart';
import 'package:sosyal_medya/helper/show_dialogs.dart';
import 'package:sosyal_medya/helper/image_error_helper.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/users_record_extensions.dart';
import '/components/user_list/user_list_widget.dart';
import '/components/web_components/side_nav/side_nav_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/updated_chat/empty_state_simple/empty_state_simple_widget.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'main_profile_model.dart';
export 'main_profile_model.dart';

class MainProfileWidget extends StatefulWidget {
  const MainProfileWidget({super.key});

  static String routeName = 'main_Profile';
  static String routePath = '/mainProfile';

  @override
  State<MainProfileWidget> createState() => _MainProfileWidgetState();
}

class _MainProfileWidgetState extends State<MainProfileWidget> with TickerProviderStateMixin {
  late MainProfileModel _model;

  DynamicViewExtensions dynamicViewExtensions = DynamicViewExtensions();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MainProfileModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UsersRecord>(
      stream: UsersRecord.getDocument(currentUserReference!),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }

        final mainProfileUsersRecord = snapshot.data!;

        return Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          body: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              wrapWithModel(
                model: _model.sideNavModel,
                updateCallback: () => safeSetState(() {}),
                child: SideNavWidget(
                  selectedNav: 3,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional(0.0, -1.0),
                  child: Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxWidth: 1070.0,
                    ),
                    decoration: BoxDecoration(),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (responsiveVisibility(
                          context: context,
                          phone: false,
                          tablet: false,
                        ))
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 12.0),
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 150,
                                  height: 55,
                                  child: Container(
                                    child: SvgPicture.asset(
                                      'assets/logo/liseslibuyukelciler-01.svg',
                                      color: FlutterFlowTheme.of(context).primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: 100.0,
                            constraints: BoxConstraints(
                              maxWidth: 870.0,
                            ),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).secondaryBackground,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (responsiveVisibility(
                                  context: context,
                                  tabletLandscape: false,
                                  desktop: false,
                                ))
                                  Align(
                                    alignment: AlignmentDirectional(0.0, -1.0),
                                    child: Container(
                                      width: 300.0,
                                      height: 64.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                      ),
                                    ),
                                  ),
                                Container(
                                  width: MediaQuery.sizeOf(context).width * 1.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment: AlignmentDirectional(0.85, 0.68),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
                                            child: Container(
                                              width: 80.0,
                                              height: 80.0,
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(context).accent1,
                                                borderRadius: BorderRadius.circular(120.0),
                                                border: Border.all(
                                                  color: FlutterFlowTheme.of(context).primary,
                                                  width: 2.0,
                                                ),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(120.0),
                                                ),
                                                padding: EdgeInsets.all(3.0),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(120.0),
                                                  child: ImageErrorHelper.networkProfileImage(
                                                    context: context,
                                                    imageUrl: valueOrDefault<String>(
                                                      mainProfileUsersRecord.photoUrl,
                                                      'https://firebasestorage.googleapis.com/v0/b/liseli-buyukelciler-db.firebasestorage.app/o/app_ico%2Ficons8-account-96.png?alt=media&token=4104ae4d-7566-449c-81d8-ebbb1fac88e6',
                                                    ),
                                                    displayName: mainProfileUsersRecord.displayName,
                                                    width: 300.0,
                                                    height: 200.0,
                                                    borderRadius: BorderRadius.circular(120.0),
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    valueOrDefault<String>(
                                                      mainProfileUsersRecord.displayName,
                                                      'Kullanıcı Adı',
                                                    ),
                                                    textAlign: TextAlign.start,
                                                    style: FlutterFlowTheme.of(context)
                                                        .headlineSmall
                                                        .override(
                                                          fontFamily: 'Outfit',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  mainProfileUsersRecord.badges.isNotEmpty
                                                      ? MultipleBadgesDisplayWidget(
                                                          badgeIds: mainProfileUsersRecord.badges,
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional(-1.0, 0.0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(
                                                      0.0, 4.0, 0.0, 0.0),
                                                  child: Text(
                                                    mainProfileUsersRecord.email,
                                                    textAlign: TextAlign.start,
                                                    style: FlutterFlowTheme.of(context)
                                                        .bodyLarge
                                                        .override(
                                                          fontFamily: 'Figtree',
                                                          color:
                                                              FlutterFlowTheme.of(context).primary,
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional(-1.0, 0.0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(
                                                      0.0, 8.0, 0.0, 0.0),
                                                  child: Text(
                                                    mainProfileUsersRecord.bio,
                                                    textAlign: TextAlign.start,
                                                    style: FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Figtree',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 8.0),
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      context.pushNamed(
                                        EditSettingsWidget.routeName,
                                        extra: <String, dynamic>{
                                          kTransitionInfoKey: TransitionInfo(
                                            hasTransition: true,
                                            transitionType: PageTransitionType.bottomToTop,
                                            duration: Duration(milliseconds: 250),
                                          ),
                                          "mainProfileUsersRecord": mainProfileUsersRecord,
                                        },
                                      );
                                    },
                                    text: 'Ayarlar',
                                    options: FFButtonOptions(
                                      width: double.infinity,
                                      height: 40.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                      color: FlutterFlowTheme.of(context).primaryBackground,
                                      textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Figtree',
                                            letterSpacing: 0.0,
                                          ),
                                      elevation: 0.0,
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).alternate,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                ),
                                if (mainProfileUsersRecord.isAdmin)
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 8.0),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        context.pushNamed(
                                          AdminFeaturesWidget.routeName,
                                          extra: <String, dynamic>{
                                            kTransitionInfoKey: TransitionInfo(
                                              hasTransition: true,
                                              duration: Duration(milliseconds: 250),
                                            ),
                                          },
                                        );
                                      },
                                      text: 'Admin Özellikleri',
                                      icon: Icon(
                                        Icons.admin_panel_settings,
                                        size: 20.0,
                                      ),
                                      options: FFButtonOptions(
                                        width: double.infinity,
                                        height: 40.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context).primary,
                                        textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Figtree',
                                              color: Colors.white,
                                              letterSpacing: 0.0,
                                            ),
                                        elevation: 2.0,
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 0.0,
                                        ),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                    ),
                                  ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment(0.0, 0),
                                        child: TabBar(
                                          labelColor: FlutterFlowTheme.of(context).primary,
                                          unselectedLabelColor:
                                              FlutterFlowTheme.of(context).secondaryText,
                                          labelStyle:
                                              FlutterFlowTheme.of(context).titleSmall.override(
                                                    fontFamily: 'Figtree',
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                          unselectedLabelStyle:
                                              FlutterFlowTheme.of(context).titleSmall.override(
                                                    fontFamily: 'Figtree',
                                                    letterSpacing: 0.0,
                                                  ),
                                          indicatorColor: FlutterFlowTheme.of(context).primary,
                                          indicatorWeight: 2.0,
                                          tabs: [
                                            Tab(
                                              text: 'Gönderilerim',
                                            ),
                                            Tab(
                                              text: 'Arkadaşlar',
                                            ),
                                            Tab(
                                              text: 'Aktiviteler',
                                            ),
                                          ],
                                          controller: _model.tabBarController,
                                          onTap: (i) async {
                                            [() async {}, () async {}][i]();
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: TabBarView(
                                          controller: _model.tabBarController,
                                          children: [
                                            // my post
                                            buildMyPostListWidget(mainProfileUsersRecord),
                                            // friends
                                            buildFriendListWidget,
                                            // activity
                                            buildActivityListWidget(mainProfileUsersRecord),
                                          ],
                                        ),
                                      ),
                                    ],
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
            ],
          ),
        );
      },
    );
  }

  // my post
  Widget buildMyPostListWidget(UsersRecord mainProfileUsersRecord) => Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 32.0),
        child: StreamBuilder<List<UserPostsRecord>>(
          stream: queryUserPostsRecord(
            queryBuilder: (userPostsRecord) => userPostsRecord
                .where(
                  'postUser',
                  isEqualTo: mainProfileUsersRecord.reference,
                )
                .orderBy('timePosted', descending: true),
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
            List<UserPostsRecord> socialFeedUserPostsRecordList = snapshot.data!;
            if (socialFeedUserPostsRecordList.isEmpty) {
              return Center(
                child: EmptyStateSimpleWidget(
                  icon: Icon(
                    Icons.local_activity_rounded,
                    color: FlutterFlowTheme.of(context).primary,
                    size: 72.0,
                  ),
                  title: 'Gönderi Bulunmuyor',
                  body: 'Henüz yeni bir gönderiniz bulunmuyor, gönderi oluşturabilirsiniz.',
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              itemCount: socialFeedUserPostsRecordList.length,
              separatorBuilder: (_, __) => SizedBox(height: 1.0),
              itemBuilder: (context, socialFeedIndex) {
                final socialFeedUserPostsRecord = socialFeedUserPostsRecordList[socialFeedIndex];
                return Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                  child: StreamBuilder<UsersRecord>(
                    stream: UsersRecord.getDocument(socialFeedUserPostsRecord.postUser!),
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

                      final userPostUsersRecord = snapshot.data!;

                      return Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
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
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.pushNamed(
                              PostDetailsPageWidget.routeName,
                              queryParameters: {
                                'userRecord': serializeParam(
                                  userPostUsersRecord,
                                  ParamType.Document,
                                ),
                                'postReference': serializeParam(
                                  socialFeedUserPostsRecord,
                                  ParamType.Document,
                                ),
                              }.withoutNulls,
                              extra: <String, dynamic>{
                                'userRecord': userPostUsersRecord,
                                'postReference': socialFeedUserPostsRecord,
                              },
                            );
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 2.0, 4.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                                      child: Container(
                                        width: 36.0,
                                        height: 36.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context).accent1,
                                          borderRadius: BorderRadius.circular(120.0),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context).primary,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(120.0),
                                              color: Colors.white),
                                          padding: EdgeInsets.all(2.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(120.0),
                                            child: Image.network(
                                              valueOrDefault<String>(
                                                userPostUsersRecord.photoUrl,
                                                'https://firebasestorage.googleapis.com/v0/b/liseli-buyukelciler-db.firebasestorage.app/o/app_ico%2Ficons8-account-96.png?alt=media&token=4104ae4d-7566-449c-81d8-ebbb1fac88e6',
                                              ),
                                              width: 300.0,
                                              height: 200.0,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(
                                                    12.0, 0.0, 0.0, 0.0),
                                                child: Text(
                                                  valueOrDefault<String>(
                                                    userPostUsersRecord.userName,
                                                    'Benim Kullanıcı Adım',
                                                  ),
                                                  style: FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .override(
                                                        fontFamily: 'Figtree',
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                              userPostUsersRecord.badges.isNotEmpty
                                                  ? MultipleBadgesDisplayWidget(
                                                      badgeIds: userPostUsersRecord.badges,
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                          FlutterFlowIconButton(
                                            borderColor: Colors.transparent,
                                            borderRadius: 30.0,
                                            buttonSize: 46.0,
                                            icon: Icon(
                                              Icons.keyboard_control,
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              size: 25.0,
                                            ),
                                            onPressed: () {
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                backgroundColor: Color(0x00000000),
                                                barrierColor: FlutterFlowTheme.of(context).accent4,
                                                context: context,
                                                builder: (context) {
                                                  return Padding(
                                                    padding: MediaQuery.viewInsetsOf(context),
                                                    child: Container(
                                                      height: 230.0,
                                                      child: DeletePostWidget(
                                                        postParameters: socialFeedUserPostsRecord,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ).then((value) => safeSetState(() {}));
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              socialFeedUserPostsRecord.postPhoto.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(0.0),
                                      child: FlutterFlowMediaDisplay(
                                        path: socialFeedUserPostsRecord.postPhoto,
                                        imageBuilder: (path) => CachedNetworkImage(
                                          fadeInDuration: Duration(milliseconds: 0),
                                          fadeOutDuration: Duration(milliseconds: 0),
                                          imageUrl: path,
                                          width: MediaQuery.sizeOf(context).width * 1.0,
                                          height: 430.0,
                                          fit: BoxFit.contain,
                                        ),
                                        videoPlayerBuilder: (path) => FlutterFlowVideoPlayer(
                                          path: path,
                                          width: double.infinity,
                                          height: double.infinity,
                                          autoPlay: true,
                                          looping: true,
                                          showControls: false,
                                          allowFullScreen: true,
                                          allowPlaybackSpeedMenu: false,
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                              socialFeedUserPostsRecord.postDescription.isNotEmpty
                                  ? Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(2.0, 4.0, 0.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(
                                                  12.0, 0.0, 12.0, 12.0),
                                              child: Text(
                                                socialFeedUserPostsRecord.postDescription,
                                                style: FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Figtree',
                                                      letterSpacing: 0.0,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              ToggleIcon(
                                                onPressed: () async {
                                                  final likesElement =
                                                      mainProfileUsersRecord.reference;
                                                  final likesUpdate = socialFeedUserPostsRecord
                                                          .likes
                                                          .contains(likesElement)
                                                      ? FieldValue.arrayRemove([likesElement])
                                                      : FieldValue.arrayUnion([likesElement]);
                                                  await socialFeedUserPostsRecord.reference.update({
                                                    ...mapToFirestore(
                                                      {
                                                        'likes': likesUpdate,
                                                      },
                                                    ),
                                                  });
                                                },
                                                value: socialFeedUserPostsRecord.likes
                                                    .contains(mainProfileUsersRecord.reference),
                                                onIcon: Icon(
                                                  Icons.favorite_rounded,
                                                  color: Colors.red,
                                                  size: 25.0,
                                                ),
                                                offIcon: Icon(
                                                  Icons.favorite_border,
                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                  size: 25.0,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(
                                                    4.0, 0.0, 0.0, 0.0),
                                                child: Text(
                                                  valueOrDefault<String>(
                                                    functions
                                                        .likes(socialFeedUserPostsRecord)
                                                        .toString(),
                                                    '0',
                                                  ),
                                                  style: FlutterFlowTheme.of(context)
                                                      .labelSmall
                                                      .override(
                                                        fontFamily: 'Figtree',
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Icon(
                                              Icons.mode_comment_outlined,
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              size: 24.0,
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(
                                                  4.0, 0.0, 0.0, 0.0),
                                              child: Text(
                                                socialFeedUserPostsRecord.numComments.toString(),
                                                style: FlutterFlowTheme.of(context)
                                                    .labelSmall
                                                    .override(
                                                      fontFamily: 'Figtree',
                                                      letterSpacing: 0.0,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 8.0, 0.0),
                                          child: Text(
                                            dateTimeFormat(
                                                "relative", socialFeedUserPostsRecord.timePosted!),
                                            style:
                                                FlutterFlowTheme.of(context).labelMedium.override(
                                                      fontFamily: 'Figtree',
                                                      letterSpacing: 0.0,
                                                    ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              socialFeedUserPostsRecord.postDescription.isNotEmpty
                                  ? const SizedBox()
                                  : Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(2.0, 4.0, 0.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(
                                                  12.0, 0.0, 12.0, 12.0),
                                              child: Text(
                                                socialFeedUserPostsRecord.postDescription,
                                                style: FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Figtree',
                                                      letterSpacing: 0.0,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      );

  // friends
  Widget get buildFriendListWidget => Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
        ),
        child: StreamBuilder<List<FriendsRecord>>(
          stream: queryFriendsRecord(
            queryBuilder: (friendsRecord) => friendsRecord.where(
              'followee',
              isEqualTo: currentUserReference,
            ),
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
            List<FriendsRecord> listViewFriendsRecordList = snapshot.data!;
            if (listViewFriendsRecordList.isEmpty) {
              return Center(
                child: EmptyStateSimpleWidget(
                  icon: Icon(
                    Icons.groups_outlined,
                    color: FlutterFlowTheme.of(context).primary,
                    size: 72.0,
                  ),
                  title: 'Arkadaş Yok',
                  body: 'Hiç arkadaşın yok..',
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              itemCount: listViewFriendsRecordList.length,
              separatorBuilder: (_, __) => SizedBox(height: 1.0),
              itemBuilder: (context, listViewIndex) {
                final listViewFriendsRecord = listViewFriendsRecordList[listViewIndex];
                return wrapWithModel(
                  model: _model.userListModels.getModel(
                    listViewFriendsRecord.reference.id,
                    listViewIndex,
                  ),
                  updateCallback: () => safeSetState(() {}),
                  child: UserListWidget(
                    key: Key(
                      'Keyjbr_${listViewFriendsRecord.reference.id}',
                    ),
                    userRef: listViewFriendsRecord.follower!,
                  ),
                );
              },
            );
          },
        ),
      );

  // activity
  Widget buildActivityListWidget(UsersRecord mainProfileUsersRecord) => Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 32.0),
        child: StreamBuilder<List<UserPostsRecord>>(
          stream: queryUserPostsRecord(
            queryBuilder: (userPostsRecord) => userPostsRecord
                .where(
                  'postUser',
                  isEqualTo: mainProfileUsersRecord.reference,
                )
                .where('postIsActivity', isEqualTo: true)
                .orderBy('timePosted', descending: true),
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
            List<UserPostsRecord> socialFeedUserPostsRecordList = snapshot.data!;
            if (socialFeedUserPostsRecordList.isEmpty) {
              return Center(
                child: EmptyStateSimpleWidget(
                  icon: Icon(
                    Icons.local_activity_rounded,
                    color: FlutterFlowTheme.of(context).primary,
                    size: 72.0,
                  ),
                  title: 'Aktivite Bulunmuyor',
                  body: 'Henüz yeni bir aktiviteniz bulunmuyor, aktivite oluşturabilirsiniz.',
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              itemCount: socialFeedUserPostsRecordList.length,
              separatorBuilder: (_, __) => SizedBox(height: 1.0),
              itemBuilder: (context, socialFeedIndex) {
                final socialFeedUserPostsRecord = socialFeedUserPostsRecordList[socialFeedIndex];
                return Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                  child: StreamBuilder<UsersRecord>(
                    stream: UsersRecord.getDocument(socialFeedUserPostsRecord.postUser!),
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

                      final userPostUsersRecord = snapshot.data!;

                      return Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
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
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.pushNamed(
                              PostDetailsPageWidget.routeName,
                              queryParameters: {
                                'userRecord': serializeParam(
                                  userPostUsersRecord,
                                  ParamType.Document,
                                ),
                                'postReference': serializeParam(
                                  socialFeedUserPostsRecord,
                                  ParamType.Document,
                                ),
                              }.withoutNulls,
                              extra: <String, dynamic>{
                                'userRecord': userPostUsersRecord,
                                'postReference': socialFeedUserPostsRecord,
                              },
                            );
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 2.0, 4.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                                      child: Container(
                                        width: 36.0,
                                        height: 36.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context).accent1,
                                          borderRadius: BorderRadius.circular(120.0),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context).primary,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(120.0),
                                            color: Colors.white,
                                          ),
                                          padding: EdgeInsets.all(2.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(120.0),
                                            child: Image.network(
                                              valueOrDefault<String>(
                                                userPostUsersRecord.photoUrl,
                                                'https://firebasestorage.googleapis.com/v0/b/liseli-buyukelciler-db.firebasestorage.app/o/app_ico%2Ficons8-account-96.png?alt=media&token=4104ae4d-7566-449c-81d8-ebbb1fac88e6',
                                              ),
                                              width: 300.0,
                                              height: 200.0,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(
                                                    12.0, 0.0, 0.0, 0.0),
                                                child: Text(
                                                  valueOrDefault<String>(
                                                    userPostUsersRecord.userName,
                                                    'Benim Kullanıcı Adım',
                                                  ),
                                                  style: FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .override(
                                                        fontFamily: 'Figtree',
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                              userPostUsersRecord.badges.isNotEmpty
                                                  ? MultipleBadgesDisplayWidget(
                                                      badgeIds: userPostUsersRecord.badges,
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                          FlutterFlowIconButton(
                                            borderColor: Colors.transparent,
                                            borderRadius: 30.0,
                                            buttonSize: 46.0,
                                            icon: Icon(
                                              Icons.keyboard_control,
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              size: 25.0,
                                            ),
                                            onPressed: () {
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                backgroundColor: Color(0x00000000),
                                                barrierColor: FlutterFlowTheme.of(context).accent4,
                                                context: context,
                                                builder: (context) {
                                                  return Padding(
                                                    padding: MediaQuery.viewInsetsOf(context),
                                                    child: Container(
                                                      height: 230.0,
                                                      child: DeletePostWidget(
                                                        postParameters: socialFeedUserPostsRecord,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ).then((value) => safeSetState(() {}));
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              socialFeedUserPostsRecord.postPhoto.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(0.0),
                                      child: FlutterFlowMediaDisplay(
                                        path: socialFeedUserPostsRecord.postPhoto,
                                        imageBuilder: (path) => CachedNetworkImage(
                                          fadeInDuration: Duration(milliseconds: 0),
                                          fadeOutDuration: Duration(milliseconds: 0),
                                          imageUrl: path,
                                          width: MediaQuery.sizeOf(context).width * 1.0,
                                          height: 430.0,
                                          fit: BoxFit.contain,
                                        ),
                                        videoPlayerBuilder: (path) => FlutterFlowVideoPlayer(
                                          path: path,
                                          width: double.infinity,
                                          height: double.infinity,
                                          autoPlay: true,
                                          looping: true,
                                          showControls: false,
                                          allowFullScreen: true,
                                          allowPlaybackSpeedMenu: false,
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                              socialFeedUserPostsRecord.postDescription.isNotEmpty
                                  ? Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(2.0, 4.0, 0.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(
                                                  12.0, 0.0, 12.0, 12.0),
                                              child: Text(
                                                socialFeedUserPostsRecord.postDescription,
                                                style: FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Figtree',
                                                      letterSpacing: 0.0,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              ToggleIcon(
                                                onPressed: () async {
                                                  final likesElement =
                                                      mainProfileUsersRecord.reference;
                                                  final likesUpdate = socialFeedUserPostsRecord
                                                          .likes
                                                          .contains(likesElement)
                                                      ? FieldValue.arrayRemove([likesElement])
                                                      : FieldValue.arrayUnion([likesElement]);
                                                  await socialFeedUserPostsRecord.reference.update({
                                                    ...mapToFirestore(
                                                      {
                                                        'likes': likesUpdate,
                                                      },
                                                    ),
                                                  });
                                                },
                                                value: socialFeedUserPostsRecord.likes
                                                    .contains(mainProfileUsersRecord.reference),
                                                onIcon: Icon(
                                                  Icons.favorite_rounded,
                                                  color: Colors.red,
                                                  size: 25.0,
                                                ),
                                                offIcon: Icon(
                                                  Icons.favorite_border,
                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                  size: 25.0,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(
                                                    4.0, 0.0, 0.0, 0.0),
                                                child: Text(
                                                  valueOrDefault<String>(
                                                    functions
                                                        .likes(socialFeedUserPostsRecord)
                                                        .toString(),
                                                    '0',
                                                  ),
                                                  style: FlutterFlowTheme.of(context)
                                                      .labelSmall
                                                      .override(
                                                        fontFamily: 'Figtree',
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Icon(
                                              Icons.mode_comment_outlined,
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              size: 24.0,
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(
                                                  4.0, 0.0, 0.0, 0.0),
                                              child: Text(
                                                socialFeedUserPostsRecord.numComments.toString(),
                                                style: FlutterFlowTheme.of(context)
                                                    .labelSmall
                                                    .override(
                                                      fontFamily: 'Figtree',
                                                      letterSpacing: 0.0,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 8.0, 0.0),
                                          child: Text(
                                            dateTimeFormat(
                                                "relative", socialFeedUserPostsRecord.timePosted!),
                                            style:
                                                FlutterFlowTheme.of(context).labelMedium.override(
                                                      fontFamily: 'Figtree',
                                                      letterSpacing: 0.0,
                                                    ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              socialFeedUserPostsRecord.postDescription.isNotEmpty
                                  ? const SizedBox()
                                  : Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(2.0, 4.0, 0.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(
                                                  12.0, 0.0, 12.0, 12.0),
                                              child: Text(
                                                socialFeedUserPostsRecord.postDescription,
                                                style: FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Figtree',
                                                      letterSpacing: 0.0,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      );
}
