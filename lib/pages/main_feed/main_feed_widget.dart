import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sosyal_medya/backend/schema/badge_model/badge_model.dart';
import 'package:sosyal_medya/components/multiple_badges_display/multiple_badges_display_widget.dart';
import 'package:sosyal_medya/components/verified/verified_widget.dart';
import 'package:sosyal_medya/extension/dynamic_extensions.dart';
import 'package:sosyal_medya/helper/file_download.dart';
import 'package:sosyal_medya/helper/show_dialogs.dart';
import 'package:sosyal_medya/helper/image_error_helper.dart';
import 'package:sosyal_medya/util/base_utility.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/users_record_extensions.dart';
import '/components/create_modal/create_modal_widget.dart';
import '/components/empty_list_1/empty_list1_widget.dart';
import '/components/web_components/post_modal_view/post_modal_view_widget.dart';
import '/components/web_components/side_nav/side_nav_widget.dart';
import '/components/web_components/story_modal_view/story_modal_view_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_media_display.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_video_player.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'main_feed_model.dart';
export 'main_feed_model.dart';

class MainFeedWidget extends StatefulWidget {
  const MainFeedWidget({super.key});

  static String routeName = 'main_Feed';
  static String routePath = '/mainFeed';

  @override
  State<MainFeedWidget> createState() => _MainFeedWidgetState();
}

class _MainFeedWidgetState extends State<MainFeedWidget> with TickerProviderStateMixin {
  late MainFeedModel _model;

  DynamicViewExtensions dynamicViewExtensions = DynamicViewExtensions();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  var hasIconTriggered = false;
  final animationsMap = <String, AnimationInfo>{};

  late List<String> engelleyen = [];
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MainFeedModel());

    animationsMap.addAll({
      'iconOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: false,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(1.2, 0.0),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where(
          (anim) => anim.trigger == AnimationTrigger.onActionTrigger || !anim.applyInitialState),
      this,
    );

    // Add scroll listener to show/hide scroll to top button
    _model.scrollController?.addListener(() {
      if (_model.scrollController!.offset >= 400) {
        if (!_model.showScrollToTopButton) {
          setState(() {
            _model.showScrollToTopButton = true;
          });
        }
      } else {
        if (_model.showScrollToTopButton) {
          setState(() {
            _model.showScrollToTopButton = false;
          });
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));

    getBlockedUsers().then((value) {
      setState(() {
        engelleyen = value;
      });
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> onTapPostReported(UserPostsRecord socialFeedUserPostsRecord, String postId) async {
    try {
      await FirebaseFirestore.instance
          .collection('userPosts')
          .doc(socialFeedUserPostsRecord.reference.id)
          .update({
        'postShow': false,
      });

      await FirebaseFirestore.instance.collection('reportPosts').add({
        'id': null,
        'report_user': FirebaseAuth.instance.currentUser!.uid,
        'post_id': socialFeedUserPostsRecord.reference.id,
        'created_at': FieldValue.serverTimestamp(),
      });

      setState(() {
        visiblePostIds.remove(postId);
      });

      Navigator.pop(context); // Modal
      Navigator.pop(context); // Bir üst ekran
      CodeNoahDialogs(context).showFlush(
        type: SnackType.success,
        message: 'Gönderi şikayet edildi.',
      );
    } catch (e) {
      print('Hata: $e');
      CodeNoahDialogs(context).showFlush(
        type: SnackType.error,
        message: 'Şikayet sırasında bir hata oluştu.',
      );
    }
  }

  Future<List<String>> getBlockedUsers() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      final data = userDoc.data();
      final engelleyen = data?['engelleyen'];

      if (engelleyen is List) {
        return engelleyen.map((e) => e.toString()).toList();
      }
    }

    return [];
  }

  Set<String> visiblePostIds = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      floatingActionButton: Stack(
        children: [
          // Scroll to top button
          if (_model.showScrollToTopButton)
            Positioned(
              bottom: MediaQuery.sizeOf(context).width <= 990.0 ? 80.0 : 16.0,
              right: 16.0,
              child: FloatingActionButton(
                onPressed: () {
                  _model.scrollController?.animateTo(
                    0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                elevation: 8.0,
                mini: true,
                child: Icon(
                  Icons.arrow_upward_rounded,
                  color: FlutterFlowTheme.of(context).primary,
                  size: 20.0,
                ),
              ),
            ),
          // Create post button (only on mobile)
          if (MediaQuery.sizeOf(context).width <= 990.0)
            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: FloatingActionButton(
                onPressed: () async {
                  await showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Color(0x00000000),
                    barrierColor: FlutterFlowTheme.of(context).accent4,
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: MediaQuery.viewInsetsOf(context),
                        child: CreateModalWidget(),
                      );
                    },
                  ).then((value) => safeSetState(() {}));
                },
                backgroundColor: FlutterFlowTheme.of(context).primary,
                elevation: 8.0,
                child: Icon(
                  Icons.create_rounded,
                  color: Colors.white,
                  size: 24.0,
                ),
              ),
            ),
        ],
      ),
      appBar: responsiveVisibility(
        context: context,
        tabletLandscape: false,
        desktop: false,
      )
          ? AppBar(
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              automaticallyImplyLeading: false,
              title: SizedBox(
                width: 150,
                height: 55,
                child: Container(
                  child: SvgPicture.asset(
                    'assets/logo/liseslibuyukelciler-01.svg',
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
              actions: [],
              centerTitle: false,
              elevation: 0.0,
            )
          : null,
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          wrapWithModel(
            model: _model.sideNavModel,
            updateCallback: () => safeSetState(() {}),
            child: SideNavWidget(
              selectedNav: 1,
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
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: SingleChildScrollView(
                  controller: _model.scrollController,
                  primary: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // story
                      if (responsiveVisibility(
                        context: context,
                        phone: false,
                        tablet: false,
                      ))
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 55,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Flexible(
                                        fit: FlexFit.tight,
                                        flex: 1,
                                        child: Container(
                                          child: SvgPicture.asset(
                                            'assets/logo/liseslibuyukelciler-01.svg',
                                            color: FlutterFlowTheme.of(context).primary,
                                          ),
                                        ),
                                      ),
                                      const Spacer(
                                        flex: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    await showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Color(0x00000000),
                                      barrierColor: FlutterFlowTheme.of(context).accent4,
                                      context: context,
                                      builder: (context) {
                                        return Padding(
                                          padding: MediaQuery.viewInsetsOf(context),
                                          child: CreateModalWidget(),
                                        );
                                      },
                                    ).then((value) => safeSetState(() {}));
                                  },
                                  text: 'Yeni Gönderi',
                                  icon: Icon(
                                    Icons.mode_edit,
                                    size: 15.0,
                                  ),
                                  options: FFButtonOptions(
                                    height: 44.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                    color: FlutterFlowTheme.of(context).primary,
                                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                          fontFamily: 'Figtree',
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                        ),
                                    elevation: 2.0,
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  showLoadingIndicator: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Container(
                        height: 76.0,
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
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 8.0),
                          child: StreamBuilder<List<UserStoriesRecord>>(
                            stream: queryUserStoriesRecord(
                              queryBuilder: (userStoriesRecord) =>
                                  userStoriesRecord.orderBy('storyPostedAt', descending: true),
                              limit: 20,
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
                              List<UserStoriesRecord> listViewUserStoriesRecordList =
                                  snapshot.data!;

                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                itemCount: listViewUserStoriesRecordList.length,
                                itemBuilder: (context, listViewIndex) {
                                  final listViewUserStoriesRecord =
                                      listViewUserStoriesRecordList[listViewIndex];

                                  final postUserId =
                                      listViewUserStoriesRecord.user!.id.split('/').last;

                                  if (engelleyen.contains(postUserId)) {
                                    return SizedBox();
                                  }

                                  return Builder(
                                    builder: (context) => Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                      child: StreamBuilder<UsersRecord>(
                                        stream: UsersRecord.getDocument(
                                            listViewUserStoriesRecord.user!),
                                        builder: (context, snapshot) {
                                          // Customize what your widget looks like when it's loading.
                                          if (!snapshot.hasData) {
                                            return Center(
                                              child: SizedBox(
                                                width: 50.0,
                                                height: 50.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.withValues(alpha: 0.2),
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(
                                                        BaseUtility.radiusCircularHighValue,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }

                                          final columnUsersRecord = snapshot.data!;

                                          return InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              if (MediaQuery.sizeOf(context).width >= 1270.0) {
                                                await showDialog(
                                                  barrierColor: Colors.transparent,
                                                  context: context,
                                                  builder: (dialogContext) {
                                                    return Dialog(
                                                      elevation: 0,
                                                      insetPadding: EdgeInsets.zero,
                                                      backgroundColor: Colors.transparent,
                                                      alignment: AlignmentDirectional(0.0, 0.0)
                                                          .resolve(Directionality.of(context)),
                                                      child: StoryModalViewWidget(
                                                        initialIndex: listViewIndex,
                                                      ),
                                                    );
                                                  },
                                                );
                                              } else {
                                                context.pushNamed(
                                                  StoryDetailsWidget.routeName,
                                                  queryParameters: {
                                                    'initialStoryIndex': serializeParam(
                                                      listViewIndex,
                                                      ParamType.int,
                                                    ),
                                                  }.withoutNulls,
                                                  extra: <String, dynamic>{
                                                    kTransitionInfoKey: TransitionInfo(
                                                      hasTransition: true,
                                                      transitionType:
                                                          PageTransitionType.bottomToTop,
                                                      duration: Duration(milliseconds: 200),
                                                    ),
                                                  },
                                                );
                                              }
                                            },
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(
                                                      0.0, 4.0, 0.0, 0.0),
                                                  child: Container(
                                                    width: 40.0,
                                                    height: 40.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme.of(context).accent1,
                                                      borderRadius: BorderRadius.circular(120.0),
                                                      border: Border.all(
                                                        color: FlutterFlowTheme.of(context).primary,
                                                        width: 2.0,
                                                      ),
                                                    ),
                                                    child: Container(
                                                      padding: EdgeInsets.all(2.0),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(120.0),
                                                        color: columnUsersRecord.photoUrl.isEmpty
                                                            ? Colors.white
                                                            : null,
                                                      ),
                                                      child: ImageErrorHelper.cachedProfileImage(
                                                        context: context,
                                                        imageUrl: valueOrDefault<String>(
                                                          columnUsersRecord.photoUrl,
                                                          'https://firebasestorage.googleapis.com/v0/b/liseli-buyukelciler-db.firebasestorage.app/o/app_ico%2Ficons8-account-96.png?alt=media&token=4104ae4d-7566-449c-81d8-ebbb1fac88e6',
                                                        ),
                                                        displayName: columnUsersRecord.displayName,
                                                        width: 40.0,
                                                        height: 40.0,
                                                        borderRadius: BorderRadius.circular(120.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(
                                                      0.0, 4.0, 0.0, 0.0),
                                                  child: AutoSizeText(
                                                    valueOrDefault<String>(
                                                      columnUsersRecord.displayName,
                                                      'Ellie May',
                                                    ).maybeHandleOverflow(
                                                      maxChars: 8,
                                                      replacement: '…',
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
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      // posts
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 32.0),
                        child: StreamBuilder<List<UserPostsRecord>>(
                          stream: queryUserPostsRecord(
                            queryBuilder: (userPostsRecord) =>
                                userPostsRecord.orderBy('timePosted', descending: true),
                            limit: 50,
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
                                child: Container(
                                  width: 330.0,
                                  height: 330.0,
                                  child: EmptyList1Widget(),
                                ),
                              );
                            }

                            return Column(
                              mainAxisSize: MainAxisSize.max,
                              children: List.generate(socialFeedUserPostsRecordList.length,
                                  (socialFeedIndex) {
                                final socialFeedUserPostsRecord =
                                    socialFeedUserPostsRecordList[socialFeedIndex];
                                final postId = socialFeedUserPostsRecord.reference.id;
                                final isVisible = socialFeedUserPostsRecord.postShow ||
                                    visiblePostIds.contains(postId);
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                  child: FutureBuilder<UsersRecord>(
                                    future: UsersRecord.getDocumentOnce(
                                        socialFeedUserPostsRecord.postUser!),
                                    builder: (context, snapshot) {
                                      // Customize what your widget looks like when it's loading.
                                      if (!snapshot.hasData) {
                                        return Container(
                                          margin: BaseUtility.top(BaseUtility.marginNormalValue),
                                          child: Center(
                                            child: SizedBox(
                                                width: double.infinity,
                                                height: 250.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.withValues(alpha: 0.2),
                                                  ),
                                                )),
                                          ),
                                        );
                                      }

                                      final userPostUsersRecord = snapshot.data!;

                                      final postUserId =
                                          socialFeedUserPostsRecord.postUser!.id.split('/').last;

                                      if (engelleyen.contains(postUserId)) {
                                        return SizedBox();
                                      }

                                      return Container(
                                        width: double.infinity,
                                        constraints: BoxConstraints(
                                          maxWidth: 670.0,
                                        ),
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
                                          builder: (context) => InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              if (MediaQuery.sizeOf(context).width >= 1271.0) {
                                                await showDialog(
                                                  context: context,
                                                  builder: (dialogContext) {
                                                    return Dialog(
                                                      elevation: 0,
                                                      insetPadding: EdgeInsets.zero,
                                                      backgroundColor: Colors.transparent,
                                                      alignment: AlignmentDirectional(0.0, 0.0)
                                                          .resolve(Directionality.of(context)),
                                                      child: PostModalViewWidget(
                                                        postRef: socialFeedUserPostsRecord,
                                                        userRef: userPostUsersRecord,
                                                      ),
                                                    );
                                                  },
                                                );
                                              } else {
                                                if (socialFeedUserPostsRecord.postShow == false) {
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
                                                }
                                              }
                                            },
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                // post top section
                                                Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(
                                                      0.0, 0.0, 0.0, 1.0),
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 70.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme.of(context)
                                                          .secondaryBackground,
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                          12.0, 8.0, 12.0, 8.0),
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
                                                                userPostUsersRecord,
                                                                ParamType.Document,
                                                              ),
                                                              'showPage': serializeParam(
                                                                false,
                                                                ParamType.bool,
                                                              ),
                                                              'pageTitle': serializeParam(
                                                                'Home',
                                                                ParamType.String,
                                                              ),
                                                            }.withoutNulls,
                                                            extra: <String, dynamic>{
                                                              'userDetails': userPostUsersRecord,
                                                            },
                                                          );
                                                        },
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.max,
                                                          children: [
                                                            Container(
                                                              width: 44.0,
                                                              height: 44.0,
                                                              decoration: BoxDecoration(
                                                                color: FlutterFlowTheme.of(context)
                                                                    .accent1,
                                                                borderRadius:
                                                                    BorderRadius.circular(120.0),
                                                                border: Border.all(
                                                                  color:
                                                                      FlutterFlowTheme.of(context)
                                                                          .primary,
                                                                  width: 2.0,
                                                                ),
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets.all(2.0),
                                                                child: ImageErrorHelper
                                                                    .cachedProfileImage(
                                                                  context: context,
                                                                  imageUrl: userPostUsersRecord
                                                                          .photoUrl.isNotEmpty
                                                                      ? userPostUsersRecord.photoUrl
                                                                      : 'https://firebasestorage.googleapis.com/v0/b/liseli-buyukelciler-db.firebasestorage.app/o/app_ico%2Ficons8-account-96.png?alt=media&token=4104ae4d-7566-449c-81d8-ebbb1fac88e6',
                                                                  displayName: userPostUsersRecord
                                                                      .displayName,
                                                                  width: 40.0,
                                                                  height: 40.0,
                                                                  borderRadius:
                                                                      BorderRadius.circular(120.0),
                                                                  fadeInDuration:
                                                                      Duration(milliseconds: 500),
                                                                  fadeOutDuration:
                                                                      Duration(milliseconds: 500),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional.fromSTEB(
                                                                        12.0, 0.0, 0.0, 0.0),
                                                                child: Column(
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment.center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                  children: [
                                                                    Row(
                                                                      children: <Widget>[
                                                                        Text(
                                                                          valueOrDefault<String>(
                                                                            userPostUsersRecord
                                                                                .displayName,
                                                                            'Benim Adım',
                                                                          ),
                                                                          style: FlutterFlowTheme
                                                                                  .of(context)
                                                                              .bodyLarge
                                                                              .override(
                                                                                fontFamily:
                                                                                    'Figtree',
                                                                                letterSpacing: 0.0,
                                                                              ),
                                                                        ),
                                                                        userPostUsersRecord
                                                                                .badges.isNotEmpty
                                                                            ? MultipleBadgesDisplayWidget(
                                                                                badgeIds:
                                                                                    userPostUsersRecord
                                                                                        .badges,
                                                                              )
                                                                            : const SizedBox(),
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              0.0, 4.0, 0.0, 0.0),
                                                                      child: Text(
                                                                        valueOrDefault<String>(
                                                                          '@${userPostUsersRecord.userName}',
                                                                          '@noone',
                                                                        ),
                                                                        style: FlutterFlowTheme.of(
                                                                                context)
                                                                            .labelMedium
                                                                            .override(
                                                                              fontFamily: 'Figtree',
                                                                              color: FlutterFlowTheme
                                                                                      .of(context)
                                                                                  .primary,
                                                                              letterSpacing: 0.0,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            isVisible == false
                                                                ? const SizedBox()
                                                                : GestureDetector(
                                                                    onTap: () {
                                                                      CodeNoahDialogs(context)
                                                                          .showModalNewBottom(
                                                                        dynamicViewExtensions,
                                                                        'GÖNDERİ AYARLARI',
                                                                        dynamicViewExtensions
                                                                            .dynamicHeight(
                                                                                context, 0.3),
                                                                        [
                                                                          socialFeedUserPostsRecord
                                                                                      .postShow ==
                                                                                  false
                                                                              ? const SizedBox()
                                                                              : GestureDetector(
                                                                                  onTap: () async {
                                                                                    CodeNoahDialogs(
                                                                                            context)
                                                                                        .showModalNewBottom(
                                                                                      dynamicViewExtensions,
                                                                                      'GÖNDERİYİ ŞİKAYET ET',
                                                                                      700,
                                                                                      [
                                                                                        GestureDetector(
                                                                                          onTap: () =>
                                                                                              onTapPostReported(
                                                                                            socialFeedUserPostsRecord,
                                                                                            postId,
                                                                                          ),
                                                                                          child:
                                                                                              ListTile(
                                                                                            title:
                                                                                                Text(
                                                                                              "18 yaşından küçük bir kişiyle ilgili bir sorun",
                                                                                              style:
                                                                                                  TextStyle(
                                                                                                fontWeight:
                                                                                                    FontWeight.bold,
                                                                                              ),
                                                                                            ),
                                                                                            trailing:
                                                                                                Icon(
                                                                                              Icons
                                                                                                  .arrow_forward_ios,
                                                                                              size:
                                                                                                  21,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        GestureDetector(
                                                                                          onTap: () =>
                                                                                              onTapPostReported(
                                                                                            socialFeedUserPostsRecord,
                                                                                            postId,
                                                                                          ),
                                                                                          child:
                                                                                              ListTile(
                                                                                            title:
                                                                                                Text(
                                                                                              "Zorbalık, taciz veya istismar",
                                                                                              style:
                                                                                                  TextStyle(
                                                                                                fontWeight:
                                                                                                    FontWeight.bold,
                                                                                              ),
                                                                                            ),
                                                                                            trailing:
                                                                                                Icon(
                                                                                              Icons
                                                                                                  .arrow_forward_ios,
                                                                                              size:
                                                                                                  21,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        GestureDetector(
                                                                                          onTap: () =>
                                                                                              onTapPostReported(
                                                                                            socialFeedUserPostsRecord,
                                                                                            postId,
                                                                                          ),
                                                                                          child:
                                                                                              ListTile(
                                                                                            title:
                                                                                                Text(
                                                                                              "İntihar veya kendine zarar verme",
                                                                                              style:
                                                                                                  TextStyle(
                                                                                                fontWeight:
                                                                                                    FontWeight.bold,
                                                                                              ),
                                                                                            ),
                                                                                            trailing:
                                                                                                Icon(
                                                                                              Icons
                                                                                                  .arrow_forward_ios,
                                                                                              size:
                                                                                                  21,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        GestureDetector(
                                                                                          onTap: () =>
                                                                                              onTapPostReported(
                                                                                            socialFeedUserPostsRecord,
                                                                                            postId,
                                                                                          ),
                                                                                          child:
                                                                                              ListTile(
                                                                                            title:
                                                                                                Text(
                                                                                              "Şiddet, nefrest söylemi veya rahatsız edici",
                                                                                              style:
                                                                                                  TextStyle(
                                                                                                fontWeight:
                                                                                                    FontWeight.bold,
                                                                                              ),
                                                                                            ),
                                                                                            trailing:
                                                                                                Icon(
                                                                                              Icons
                                                                                                  .arrow_forward_ios,
                                                                                              size:
                                                                                                  21,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        GestureDetector(
                                                                                          onTap: () =>
                                                                                              onTapPostReported(
                                                                                            socialFeedUserPostsRecord,
                                                                                            postId,
                                                                                          ),
                                                                                          child:
                                                                                              ListTile(
                                                                                            title:
                                                                                                Text(
                                                                                              "Kısıtlamaya tabi ürünlerin satışı veya tanıtımını yapma",
                                                                                              style:
                                                                                                  TextStyle(
                                                                                                fontWeight:
                                                                                                    FontWeight.bold,
                                                                                              ),
                                                                                            ),
                                                                                            trailing:
                                                                                                Icon(
                                                                                              Icons
                                                                                                  .arrow_forward_ios,
                                                                                              size:
                                                                                                  21,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        GestureDetector(
                                                                                          onTap: () =>
                                                                                              onTapPostReported(
                                                                                            socialFeedUserPostsRecord,
                                                                                            postId,
                                                                                          ),
                                                                                          child:
                                                                                              ListTile(
                                                                                            title:
                                                                                                Text(
                                                                                              "Yetişkinlere yönelik içerik",
                                                                                              style:
                                                                                                  TextStyle(
                                                                                                fontWeight:
                                                                                                    FontWeight.bold,
                                                                                              ),
                                                                                            ),
                                                                                            trailing:
                                                                                                Icon(
                                                                                              Icons
                                                                                                  .arrow_forward_ios,
                                                                                              size:
                                                                                                  21,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        GestureDetector(
                                                                                          onTap: () =>
                                                                                              onTapPostReported(
                                                                                            socialFeedUserPostsRecord,
                                                                                            postId,
                                                                                          ),
                                                                                          child:
                                                                                              ListTile(
                                                                                            title:
                                                                                                Text(
                                                                                              "Dolandırıcılık, sahtekarlık veya yanlış bilgiler",
                                                                                              style:
                                                                                                  TextStyle(
                                                                                                fontWeight:
                                                                                                    FontWeight.bold,
                                                                                              ),
                                                                                            ),
                                                                                            trailing:
                                                                                                Icon(
                                                                                              Icons
                                                                                                  .arrow_forward_ios,
                                                                                              size:
                                                                                                  21,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        GestureDetector(
                                                                                          onTap: () =>
                                                                                              onTapPostReported(
                                                                                            socialFeedUserPostsRecord,
                                                                                            postId,
                                                                                          ),
                                                                                          child:
                                                                                              ListTile(
                                                                                            title:
                                                                                                Text(
                                                                                              "Fikri mülkiyet",
                                                                                              style:
                                                                                                  TextStyle(
                                                                                                fontWeight:
                                                                                                    FontWeight.bold,
                                                                                              ),
                                                                                            ),
                                                                                            trailing:
                                                                                                Icon(
                                                                                              Icons
                                                                                                  .arrow_forward_ios,
                                                                                              size:
                                                                                                  21,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        GestureDetector(
                                                                                          onTap: () =>
                                                                                              onTapPostReported(
                                                                                            socialFeedUserPostsRecord,
                                                                                            postId,
                                                                                          ),
                                                                                          child:
                                                                                              ListTile(
                                                                                            title:
                                                                                                Text(
                                                                                              "Bunu görmek istemiyorum",
                                                                                              style:
                                                                                                  TextStyle(
                                                                                                fontWeight:
                                                                                                    FontWeight.bold,
                                                                                              ),
                                                                                            ),
                                                                                            trailing:
                                                                                                Icon(
                                                                                              Icons
                                                                                                  .arrow_forward_ios,
                                                                                              size:
                                                                                                  21,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    );
                                                                                  },
                                                                                  child: Padding(
                                                                                    padding:
                                                                                        BaseUtility
                                                                                            .all(
                                                                                      BaseUtility
                                                                                          .paddingNormalValue,
                                                                                    ),
                                                                                    child: Row(
                                                                                      children: <Widget>[
                                                                                        Icon(
                                                                                          Icons
                                                                                              .report_problem,
                                                                                          size: BaseUtility
                                                                                              .iconNormalSize,
                                                                                        ),
                                                                                        Expanded(
                                                                                          child:
                                                                                              Padding(
                                                                                            padding:
                                                                                                BaseUtility.horizontal(
                                                                                              BaseUtility
                                                                                                  .paddingNormalValue,
                                                                                            ),
                                                                                            child:
                                                                                                Text(
                                                                                              'Gönderiyi Şikayet Et',
                                                                                              style: FlutterFlowTheme.of(context)
                                                                                                  .bodyLarge
                                                                                                  .override(
                                                                                                    fontFamily: 'Figtree',
                                                                                                    letterSpacing: 0.0,
                                                                                                  ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Icon(
                                                                                          Icons
                                                                                              .arrow_forward_ios,
                                                                                          size: BaseUtility
                                                                                              .iconNormalSize,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                          GestureDetector(
                                                                            onTap: () async {
                                                                              if (visiblePostIds
                                                                                  .contains(
                                                                                      postId)) {
                                                                                await FirebaseFirestore
                                                                                    .instance
                                                                                    .collection(
                                                                                        'userPosts')
                                                                                    .doc(socialFeedUserPostsRecord
                                                                                        .reference
                                                                                        .id)
                                                                                    .update({
                                                                                  'postShow': false,
                                                                                });
                                                                                setState(() {
                                                                                  visiblePostIds
                                                                                      .remove(
                                                                                          postId);
                                                                                });
                                                                                Navigator.pop(
                                                                                    context);
                                                                              } else {
                                                                                setState(() {
                                                                                  visiblePostIds
                                                                                      .add(postId);
                                                                                });
                                                                                Navigator.pop(
                                                                                    context);
                                                                              }
                                                                            },
                                                                            child: Padding(
                                                                              padding:
                                                                                  BaseUtility.all(
                                                                                BaseUtility
                                                                                    .paddingNormalValue,
                                                                              ),
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  Icon(
                                                                                    Icons.close,
                                                                                    size: BaseUtility
                                                                                        .iconNormalSize,
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Padding(
                                                                                      padding:
                                                                                          BaseUtility
                                                                                              .horizontal(
                                                                                        BaseUtility
                                                                                            .paddingNormalValue,
                                                                                      ),
                                                                                      child: Text(
                                                                                        'Gönderiyi Engelle',
                                                                                        style: FlutterFlowTheme.of(
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
                                                                                  Icon(
                                                                                    Icons
                                                                                        .arrow_forward_ios,
                                                                                    size: BaseUtility
                                                                                        .iconNormalSize,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          GestureDetector(
                                                                            onTap: () async {
                                                                              if (socialFeedUserPostsRecord
                                                                                  .postPhoto
                                                                                  .contains(
                                                                                      ".mp4")) {
                                                                                print(
                                                                                    "MP4 geçiyor");
                                                                                FileDownloadService(
                                                                                        context)
                                                                                    .saveNetworkVideoFile(
                                                                                        socialFeedUserPostsRecord
                                                                                            .postPhoto);
                                                                              } else if (socialFeedUserPostsRecord
                                                                                      .postPhoto
                                                                                      .contains(
                                                                                          ".jpg") ||
                                                                                  socialFeedUserPostsRecord
                                                                                      .postPhoto
                                                                                      .contains(
                                                                                          ".png")) {
                                                                                print(
                                                                                    "JPG VE PNG destekliyor");
                                                                                FileDownloadService(
                                                                                        context)
                                                                                    .saveNetworkImage(
                                                                                        socialFeedUserPostsRecord
                                                                                            .postPhoto);
                                                                              } else {
                                                                                print("Tanımsız");
                                                                                CodeNoahDialogs(
                                                                                        context)
                                                                                    .showFlush(
                                                                                  type: SnackType
                                                                                      .warning,
                                                                                  message:
                                                                                      'Tanımsız dosya biçimi, lütfen daha sonra tekrar deneyiniz!',
                                                                                );
                                                                              }
                                                                            },
                                                                            child: Padding(
                                                                              padding:
                                                                                  BaseUtility.all(
                                                                                BaseUtility
                                                                                    .paddingNormalValue,
                                                                              ),
                                                                              child: Row(
                                                                                children: <Widget>[
                                                                                  Icon(
                                                                                    Icons.download,
                                                                                    size: BaseUtility
                                                                                        .iconNormalSize,
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Padding(
                                                                                      padding:
                                                                                          BaseUtility
                                                                                              .horizontal(
                                                                                        BaseUtility
                                                                                            .paddingNormalValue,
                                                                                      ),
                                                                                      child: Text(
                                                                                        'Gönderiyi İndir',
                                                                                        style: FlutterFlowTheme.of(
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
                                                                                  Icon(
                                                                                    Icons
                                                                                        .arrow_forward_ios,
                                                                                    size: BaseUtility
                                                                                        .iconNormalSize,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                    child: Icon(
                                                                      Icons.more_vert,
                                                                      size: BaseUtility
                                                                          .iconNormalSize,
                                                                    )),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // show

                                                isVisible == false
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            visiblePostIds.add(postId);
                                                            print(isVisible);
                                                          });
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets.symmetric(
                                                              horizontal:
                                                                  BaseUtility.paddingHightValue,
                                                              vertical:
                                                                  BaseUtility.paddingNormalValue),
                                                          child: Container(
                                                            padding: BaseUtility.all(
                                                              BaseUtility.paddingMediumValue,
                                                            ),
                                                            decoration: BoxDecoration(
                                                              color: Colors.grey
                                                                  .withValues(alpha: 0.3),
                                                              borderRadius: BorderRadius.all(
                                                                Radius.circular(
                                                                  BaseUtility.radiusNormalValue,
                                                                ),
                                                              ),
                                                              border: Border.all(
                                                                color: Colors.black,
                                                                width: 0.5,
                                                              ),
                                                            ),
                                                            child: Row(
                                                              children: <Widget>[
                                                                Icon(
                                                                  Icons.warning,
                                                                  color: Colors.black,
                                                                  size: 22,
                                                                ),
                                                                Expanded(
                                                                  child: Padding(
                                                                    padding: BaseUtility.all(
                                                                      BaseUtility
                                                                          .paddingNormalValue,
                                                                    ),
                                                                    child: Text(
                                                                      "Hassas İçerik Görüntülemek İstiyor musunuz?\nGörüntülemek için dokunun!",
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : GestureDetector(
                                                        onTap: () {
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
                                                              'postReference':
                                                                  socialFeedUserPostsRecord,
                                                            },
                                                          );
                                                        },
                                                        child: Column(
                                                          children: <Widget>[
                                                            // post image
                                                            socialFeedUserPostsRecord
                                                                    .postPhoto.isEmpty
                                                                ? const SizedBox()
                                                                : FlutterFlowMediaDisplay(
                                                                    path: socialFeedUserPostsRecord
                                                                        .postPhoto,
                                                                    imageBuilder: (path) =>
                                                                        ImageErrorHelper
                                                                            .cachedNormalImage(
                                                                      context: context,
                                                                      imageUrl: path,
                                                                      width:
                                                                          MediaQuery.sizeOf(context)
                                                                                  .width *
                                                                              1.0,
                                                                      height: 350.0,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              0.0),
                                                                      fadeInDuration:
                                                                          Duration(milliseconds: 0),
                                                                      fadeOutDuration:
                                                                          Duration(milliseconds: 0),
                                                                    ),
                                                                    videoPlayerBuilder: (path) =>
                                                                        FlutterFlowVideoPlayer(
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
                                                            // explanation secondary variant
                                                            socialFeedUserPostsRecord
                                                                    .postPhoto.isEmpty
                                                                ? socialFeedUserPostsRecord
                                                                        .postDescription.isEmpty
                                                                    ? const SizedBox()
                                                                    : Padding(
                                                                        padding:
                                                                            EdgeInsetsDirectional
                                                                                .fromSTEB(2.0, 4.0,
                                                                                    0.0, 0.0),
                                                                        child: Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Padding(
                                                                                padding:
                                                                                    EdgeInsetsDirectional
                                                                                        .fromSTEB(
                                                                                            12.0,
                                                                                            0.0,
                                                                                            12.0,
                                                                                            12.0),
                                                                                child: Text(
                                                                                  valueOrDefault<
                                                                                      String>(
                                                                                    socialFeedUserPostsRecord
                                                                                        .postDescription,
                                                                                    '',
                                                                                  ),
                                                                                  style: FlutterFlowTheme
                                                                                          .of(context)
                                                                                      .bodyMedium
                                                                                      .override(
                                                                                        fontFamily:
                                                                                            'Figtree',
                                                                                        letterSpacing:
                                                                                            0.0,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                : const SizedBox(),
                                                            // like comment buttons
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional.fromSTEB(
                                                                      8.0, 4.0, 8.0, 0.0),
                                                              child: Row(
                                                                mainAxisSize: MainAxisSize.max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    mainAxisSize: MainAxisSize.max,
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsetsDirectional
                                                                                .fromSTEB(0.0, 0.0,
                                                                                    16.0, 0.0),
                                                                        child: Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          children: [
                                                                            Container(
                                                                              width: 41.0,
                                                                              height: 41.0,
                                                                              child: Stack(
                                                                                children: [
                                                                                  if (!socialFeedUserPostsRecord
                                                                                      .likes
                                                                                      .contains(
                                                                                          currentUserReference))
                                                                                    Align(
                                                                                      alignment:
                                                                                          AlignmentDirectional(
                                                                                              0.0,
                                                                                              0.25),
                                                                                      child:
                                                                                          InkWell(
                                                                                        splashColor:
                                                                                            Colors
                                                                                                .transparent,
                                                                                        focusColor:
                                                                                            Colors
                                                                                                .transparent,
                                                                                        hoverColor:
                                                                                            Colors
                                                                                                .transparent,
                                                                                        highlightColor:
                                                                                            Colors
                                                                                                .transparent,
                                                                                        onTap:
                                                                                            () async {
                                                                                          await socialFeedUserPostsRecord
                                                                                              .reference
                                                                                              .update({
                                                                                            ...mapToFirestore(
                                                                                              {
                                                                                                'likes':
                                                                                                    FieldValue.arrayUnion([
                                                                                                  currentUserReference
                                                                                                ]),
                                                                                              },
                                                                                            ),
                                                                                          });
                                                                                          if (animationsMap[
                                                                                                  'iconOnActionTriggerAnimation'] !=
                                                                                              null) {
                                                                                            safeSetState(() =>
                                                                                                hasIconTriggered =
                                                                                                    true);
                                                                                            SchedulerBinding
                                                                                                .instance
                                                                                                .addPostFrameCallback((_) async =>
                                                                                                    await animationsMap['iconOnActionTriggerAnimation']!.controller.forward(from: 0.0));
                                                                                          }
                                                                                        },
                                                                                        child: Icon(
                                                                                          Icons
                                                                                              .favorite_border,
                                                                                          color: FlutterFlowTheme.of(
                                                                                                  context)
                                                                                              .secondaryText,
                                                                                          size:
                                                                                              25.0,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  if (socialFeedUserPostsRecord
                                                                                      .likes
                                                                                      .contains(
                                                                                          currentUserReference))
                                                                                    Align(
                                                                                      alignment:
                                                                                          AlignmentDirectional(
                                                                                              0.0,
                                                                                              0.25),
                                                                                      child:
                                                                                          InkWell(
                                                                                        splashColor:
                                                                                            Colors
                                                                                                .transparent,
                                                                                        focusColor:
                                                                                            Colors
                                                                                                .transparent,
                                                                                        hoverColor:
                                                                                            Colors
                                                                                                .transparent,
                                                                                        highlightColor:
                                                                                            Colors
                                                                                                .transparent,
                                                                                        onTap:
                                                                                            () async {
                                                                                          await socialFeedUserPostsRecord
                                                                                              .reference
                                                                                              .update({
                                                                                            ...mapToFirestore(
                                                                                              {
                                                                                                'likes':
                                                                                                    FieldValue.arrayRemove([
                                                                                                  currentUserReference
                                                                                                ]),
                                                                                              },
                                                                                            ),
                                                                                          });
                                                                                        },
                                                                                        child: Icon(
                                                                                          Icons
                                                                                              .favorite_rounded,
                                                                                          color: Colors
                                                                                              .red,
                                                                                          size:
                                                                                              25.0,
                                                                                        ),
                                                                                      ).animateOnActionTrigger(
                                                                                              animationsMap[
                                                                                                  'iconOnActionTriggerAnimation']!,
                                                                                              hasBeenTriggered:
                                                                                                  hasIconTriggered),
                                                                                    ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding:
                                                                                  EdgeInsetsDirectional
                                                                                      .fromSTEB(
                                                                                          4.0,
                                                                                          0.0,
                                                                                          0.0,
                                                                                          0.0),
                                                                              child: Text(
                                                                                valueOrDefault<
                                                                                    String>(
                                                                                  functions
                                                                                      .likes(
                                                                                          socialFeedUserPostsRecord)
                                                                                      .toString(),
                                                                                  '0',
                                                                                ),
                                                                                style: FlutterFlowTheme
                                                                                        .of(context)
                                                                                    .labelMedium
                                                                                    .override(
                                                                                      fontFamily:
                                                                                          'Figtree',
                                                                                      letterSpacing:
                                                                                          0.0,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      InkWell(
                                                                        onTap: () {
                                                                          context.pushNamed(
                                                                            PostDetailsPageWidget
                                                                                .routeName,
                                                                            queryParameters: {
                                                                              'userRecord':
                                                                                  serializeParam(
                                                                                userPostUsersRecord,
                                                                                ParamType.Document,
                                                                              ),
                                                                              'postReference':
                                                                                  serializeParam(
                                                                                socialFeedUserPostsRecord,
                                                                                ParamType.Document,
                                                                              ),
                                                                            }.withoutNulls,
                                                                            extra: <String,
                                                                                dynamic>{
                                                                              'userRecord':
                                                                                  userPostUsersRecord,
                                                                              'postReference':
                                                                                  socialFeedUserPostsRecord,
                                                                            },
                                                                          );
                                                                        },
                                                                        child: Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          children: [
                                                                            Icon(
                                                                              Icons
                                                                                  .mode_comment_outlined,
                                                                              color: FlutterFlowTheme
                                                                                      .of(context)
                                                                                  .secondaryText,
                                                                              size: 24.0,
                                                                            ),
                                                                            Padding(
                                                                              padding:
                                                                                  EdgeInsetsDirectional
                                                                                      .fromSTEB(
                                                                                          4.0,
                                                                                          0.0,
                                                                                          0.0,
                                                                                          0.0),
                                                                              child: Text(
                                                                                socialFeedUserPostsRecord
                                                                                    .numComments
                                                                                    .toString(),
                                                                                style: FlutterFlowTheme
                                                                                        .of(context)
                                                                                    .labelMedium
                                                                                    .override(
                                                                                      fontFamily:
                                                                                          'Figtree',
                                                                                      letterSpacing:
                                                                                          0.0,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisSize: MainAxisSize.max,
                                                                    children: [
                                                                      Text(
                                                                        dateTimeFormat(
                                                                            "relative",
                                                                            socialFeedUserPostsRecord
                                                                                .timePosted!),
                                                                        style: FlutterFlowTheme.of(
                                                                                context)
                                                                            .labelSmall
                                                                            .override(
                                                                              fontFamily: 'Figtree',
                                                                              letterSpacing: 0.0,
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            // explanation
                                                            socialFeedUserPostsRecord
                                                                    .postPhoto.isEmpty
                                                                ? const SizedBox()
                                                                : socialFeedUserPostsRecord
                                                                        .postDescription.isEmpty
                                                                    ? const SizedBox()
                                                                    : Padding(
                                                                        padding:
                                                                            EdgeInsetsDirectional
                                                                                .fromSTEB(2.0, 4.0,
                                                                                    0.0, 0.0),
                                                                        child: Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Padding(
                                                                                padding:
                                                                                    EdgeInsetsDirectional
                                                                                        .fromSTEB(
                                                                                            12.0,
                                                                                            0.0,
                                                                                            12.0,
                                                                                            12.0),
                                                                                child: Text(
                                                                                  valueOrDefault<
                                                                                      String>(
                                                                                    socialFeedUserPostsRecord
                                                                                        .postDescription,
                                                                                    '',
                                                                                  ),
                                                                                  style: FlutterFlowTheme
                                                                                          .of(context)
                                                                                      .bodyMedium
                                                                                      .override(
                                                                                        fontFamily:
                                                                                            'Figtree',
                                                                                        letterSpacing:
                                                                                            0.0,
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
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
