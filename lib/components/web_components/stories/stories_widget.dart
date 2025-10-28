import 'package:sosyal_medya/auth/firebase_auth/auth_util.dart';
import 'package:sosyal_medya/backend/schema/badge_model/badge_model.dart';
import 'package:sosyal_medya/components/multiple_badges_display/multiple_badges_display_widget.dart';
import 'package:sosyal_medya/components/verified/verified_widget.dart';
import 'package:sosyal_medya/extension/dynamic_extensions.dart';
import 'package:sosyal_medya/helper/file_download.dart';
import 'package:sosyal_medya/helper/show_dialogs.dart';
import 'package:sosyal_medya/util/base_utility.dart';

import '/backend/backend.dart';
import '/backend/schema/users_record_extensions.dart';
import '/components/comments/comments_widget.dart';
import '/components/delete_story/delete_story_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_video_player.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart' as smooth_page_indicator;
import 'package:flutter/material.dart';
import 'stories_model.dart';
export 'stories_model.dart';

class StoriesWidget extends StatefulWidget {
  const StoriesWidget({
    super.key,
    this.initialIndex,
  });

  final int? initialIndex;

  @override
  State<StoriesWidget> createState() => _StoriesWidgetState();
}

class _StoriesWidgetState extends State<StoriesWidget> {
  late StoriesModel _model;

  DynamicViewExtensions dynamicViewExtensions = DynamicViewExtensions();

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StoriesModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
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
              List<UserStoriesRecord> pageViewUserStoriesRecordList = snapshot.data!;

              return Container(
                width: double.infinity,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _model.pageViewController ??= PageController(
                          initialPage: max(
                              0,
                              min(
                                  valueOrDefault<int>(
                                    widget.initialIndex,
                                    0,
                                  ),
                                  pageViewUserStoriesRecordList.length - 1))),
                      scrollDirection: Axis.vertical,
                      itemCount: pageViewUserStoriesRecordList.length,
                      itemBuilder: (context, pageViewIndex) {
                        final pageViewUserStoriesRecord =
                            pageViewUserStoriesRecordList[pageViewIndex];
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              height: MediaQuery.sizeOf(context).height * 0.82,
                              child: Stack(
                                children: [
                                  if (pageViewUserStoriesRecord.storyPhoto != '')
                                    GestureDetector(
                                      onTap: () async {
                                        if (pageViewUserStoriesRecord.storyPhoto.isNotEmpty) {
                                          CodeNoahDialogs(context).showModalNewBottom(
                                            dynamicViewExtensions,
                                            'HİKAYE AYARLARI',
                                            dynamicViewExtensions.dynamicHeight(context, 0.2),
                                            [
                                              GestureDetector(
                                                onTap: () async {
                                                  if (pageViewUserStoriesRecord.storyPhoto
                                                      .contains(".mp4")) {
                                                    print("MP4 geçiyor");
                                                    FileDownloadService(context)
                                                        .saveNetworkVideoFile(
                                                            pageViewUserStoriesRecord.storyPhoto);
                                                  } else if (pageViewUserStoriesRecord.storyPhoto
                                                          .contains(".jpg") ||
                                                      pageViewUserStoriesRecord.storyPhoto
                                                          .contains(".png")) {
                                                    print("JPG VE PNG destekliyor");
                                                    FileDownloadService(context).saveNetworkImage(
                                                        pageViewUserStoriesRecord.storyPhoto);
                                                  } else {
                                                    print("Tanımsız");
                                                    CodeNoahDialogs(context).showFlush(
                                                      type: SnackType.warning,
                                                      message:
                                                          'Tanımsız dosya biçimi, lütfen daha sonra tekrar deneyiniz!',
                                                    );
                                                  }
                                                },
                                                child: Padding(
                                                  padding: BaseUtility.all(
                                                    BaseUtility.paddingNormalValue,
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.download,
                                                        size: BaseUtility.iconNormalSize,
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding: BaseUtility.horizontal(
                                                            BaseUtility.paddingNormalValue,
                                                          ),
                                                          child: Text(
                                                            'Gönderiyi İndir',
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
                                                        Icons.arrow_forward_ios,
                                                        size: BaseUtility.iconNormalSize,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.network(
                                          valueOrDefault<String>(
                                            pageViewUserStoriesRecord.storyPhoto,
                                            'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/sample-app-social-app-tx2kqp/assets/be7tvmob7nwb/richard-brutyo-Sg3XwuEpybU-unsplash.jpg',
                                          ),
                                          width: MediaQuery.sizeOf(context).width * 1.0,
                                          height: MediaQuery.sizeOf(context).height * 1.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  if (pageViewUserStoriesRecord.storyVideo != '')
                                    GestureDetector(
                                      onTap: () async {
                                        if (pageViewUserStoriesRecord.storyVideo.isNotEmpty) {
                                          CodeNoahDialogs(context).showModalNewBottom(
                                            dynamicViewExtensions,
                                            'HİKAYE AYARLARI',
                                            dynamicViewExtensions.dynamicHeight(context, 0.2),
                                            [
                                              GestureDetector(
                                                onTap: () async {
                                                  if (pageViewUserStoriesRecord.storyVideo
                                                      .contains(".mp4")) {
                                                    print("MP4 geçiyor");
                                                    FileDownloadService(context)
                                                        .saveNetworkVideoFile(
                                                            pageViewUserStoriesRecord.storyVideo);
                                                  } else if (pageViewUserStoriesRecord.storyVideo
                                                          .contains(".jpg") ||
                                                      pageViewUserStoriesRecord.storyVideo
                                                          .contains(".png")) {
                                                    print("JPG VE PNG destekliyor");
                                                    FileDownloadService(context).saveNetworkImage(
                                                        pageViewUserStoriesRecord.storyVideo);
                                                  } else {
                                                    print("Tanımsız");
                                                    CodeNoahDialogs(context).showFlush(
                                                      type: SnackType.warning,
                                                      message:
                                                          'Tanımsız dosya biçimi, lütfen daha sonra tekrar deneyiniz!',
                                                    );
                                                  }
                                                },
                                                child: Padding(
                                                  padding: BaseUtility.all(
                                                    BaseUtility.paddingNormalValue,
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.download,
                                                        size: BaseUtility.iconNormalSize,
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding: BaseUtility.horizontal(
                                                            BaseUtility.paddingNormalValue,
                                                          ),
                                                          child: Text(
                                                            'Gönderiyi İndir',
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
                                                        Icons.arrow_forward_ios,
                                                        size: BaseUtility.iconNormalSize,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                      },
                                      child: Align(
                                        alignment: AlignmentDirectional(0.0, 0.0),
                                        child: FlutterFlowVideoPlayer(
                                          path: pageViewUserStoriesRecord.storyVideo,
                                          videoType: VideoType.network,
                                          aspectRatio: 1.7,
                                          autoPlay: true,
                                          looping: true,
                                          showControls: true,
                                          allowFullScreen: true,
                                          allowPlaybackSpeedMenu: false,
                                        ),
                                      ),
                                    ),
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 102.0,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [Color(0xFF1A1F24), Color(0x001A1F24)],
                                              stops: [0.0, 1.0],
                                              begin: AlignmentDirectional(0.0, -1.0),
                                              end: AlignmentDirectional(0, 1.0),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 12.0, 16.0, 36.0),
                                                child: StreamBuilder<UsersRecord>(
                                                  stream: UsersRecord.getDocument(
                                                      pageViewUserStoriesRecord.user!),
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
                                                              FlutterFlowTheme.of(context).primary,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }

                                                    final userInfoUsersRecord = snapshot.data!;

                                                    return Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          width: 40.0,
                                                          height: 40.0,
                                                          clipBehavior: Clip.antiAlias,
                                                          decoration: BoxDecoration(
                                                            color:
                                                                userInfoUsersRecord.photoUrl.isEmpty
                                                                    ? Colors.white
                                                                    : null,
                                                            shape: BoxShape.circle,
                                                          ),
                                                          padding:
                                                              userInfoUsersRecord.photoUrl.isEmpty
                                                                  ? BaseUtility.all(
                                                                      BaseUtility.paddingSmallValue,
                                                                    )
                                                                  : null,
                                                          child: Image.network(
                                                            valueOrDefault<String>(
                                                              userInfoUsersRecord.photoUrl,
                                                              'https://firebasestorage.googleapis.com/v0/b/liseli-buyukelciler-db.firebasestorage.app/o/app_ico%2Ficons8-account-96.png?alt=media&token=4104ae4d-7566-449c-81d8-ebbb1fac88e6',
                                                            ),
                                                            fit: BoxFit.fitHeight,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                children: <Widget>[
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            12.0, 0.0, 0.0, 0.0),
                                                                    child: Text(
                                                                      valueOrDefault<String>(
                                                                        userInfoUsersRecord
                                                                            .displayName,
                                                                        'Kullanıcı Adı',
                                                                      ),
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .override(
                                                                            fontFamily: 'Figtree',
                                                                            letterSpacing: 0.0,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  userInfoUsersRecord
                                                                          .badges.isNotEmpty
                                                                      ? MultipleBadgesDisplayWidget(
                                                                          badgeIds:
                                                                              userInfoUsersRecord
                                                                                  .badges,
                                                                        )
                                                                      : const SizedBox(),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional.fromSTEB(
                                                                        12.0, 4.0, 0.0, 0.0),
                                                                child: Text(
                                                                  userInfoUsersRecord.userName,
                                                                  style:
                                                                      FlutterFlowTheme.of(context)
                                                                          .labelMedium
                                                                          .override(
                                                                            fontFamily: 'Figtree',
                                                                            color:
                                                                                Color(0xCCFFFFFF),
                                                                            letterSpacing: 0.0,
                                                                          ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        if (pageViewUserStoriesRecord.user ==
                                                            currentUserReference)
                                                          Card(
                                                            clipBehavior:
                                                                Clip.antiAliasWithSaveLayer,
                                                            color: Color(0xFF262D34),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(60.0),
                                                            ),
                                                            child: FlutterFlowIconButton(
                                                              borderColor: Colors.transparent,
                                                              borderRadius: 30.0,
                                                              buttonSize: 46.0,
                                                              icon: Icon(
                                                                Icons.more_vert,
                                                                color: FlutterFlowTheme.of(context)
                                                                    .info,
                                                                size: 25.0,
                                                              ),
                                                              onPressed: () async {
                                                                await showModalBottomSheet(
                                                                  isScrollControlled: true,
                                                                  backgroundColor:
                                                                      FlutterFlowTheme.of(context)
                                                                          .accent4,
                                                                  barrierColor: Color(0x00000000),
                                                                  context: context,
                                                                  builder: (context) {
                                                                    return Padding(
                                                                      padding:
                                                                          MediaQuery.viewInsetsOf(
                                                                              context),
                                                                      child: Container(
                                                                        height: 240.0,
                                                                        child: DeleteStoryWidget(
                                                                          storyDetails:
                                                                              pageViewUserStoriesRecord,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ).then(
                                                                    (value) => safeSetState(() {}));
                                                              },
                                                            ),
                                                          ),
                                                        Card(
                                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                                          color: Color(0xFF262D34),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(60.0),
                                                          ),
                                                          child: FlutterFlowIconButton(
                                                            borderColor: Colors.transparent,
                                                            borderRadius: 30.0,
                                                            buttonSize: 46.0,
                                                            icon: Icon(
                                                              Icons.close_rounded,
                                                              color:
                                                                  FlutterFlowTheme.of(context).info,
                                                              size: 25.0,
                                                            ),
                                                            onPressed: () async {
                                                              context.pop();
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [Color(0x001A1F24), Color(0xFF1A1F24)],
                                              stops: [0.0, 1.0],
                                              begin: AlignmentDirectional(0.0, -1.0),
                                              end: AlignmentDirectional(0, 1.0),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Text(
                                                  valueOrDefault<String>(
                                                    pageViewUserStoriesRecord.storyDescription,
                                                    '',
                                                  ),
                                                  textAlign: TextAlign.start,
                                                  style: FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .override(
                                                        fontFamily: 'Figtree',
                                                        letterSpacing: 0.0,
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
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      await showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: FlutterFlowTheme.of(context).accent4,
                                        barrierColor: Color(0x00000000),
                                        context: context,
                                        builder: (context) {
                                          return Padding(
                                            padding: MediaQuery.viewInsetsOf(context),
                                            child: CommentsWidget(
                                              story: pageViewUserStoriesRecord,
                                            ),
                                          );
                                        },
                                      ).then((value) => safeSetState(() {}));
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(
                                          Icons.mode_comment_outlined,
                                          color: FlutterFlowTheme.of(context).secondaryText,
                                          size: 24.0,
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            pageViewUserStoriesRecord.numComments.toString(),
                                            style:
                                                FlutterFlowTheme.of(context).labelMedium.override(
                                                      fontFamily: 'Figtree',
                                                      letterSpacing: 0.0,
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
                        );
                      },
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.95, 0.7),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                        child: smooth_page_indicator.SmoothPageIndicator(
                          controller: _model.pageViewController ??= PageController(
                              initialPage: max(
                                  0,
                                  min(
                                      valueOrDefault<int>(
                                        widget.initialIndex,
                                        0,
                                      ),
                                      pageViewUserStoriesRecordList.length - 1))),
                          count: pageViewUserStoriesRecordList.length,
                          axisDirection: Axis.vertical,
                          onDotClicked: (i) async {
                            await _model.pageViewController!.animateToPage(
                              i,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                            safeSetState(() {});
                          },
                          effect: smooth_page_indicator.ExpandingDotsEffect(
                            expansionFactor: 2.0,
                            spacing: 8.0,
                            radius: 16.0,
                            dotWidth: 8.0,
                            dotHeight: 4.0,
                            dotColor: FlutterFlowTheme.of(context).accent1,
                            activeDotColor: FlutterFlowTheme.of(context).primary,
                            paintStyle: PaintingStyle.fill,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
