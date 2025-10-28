import 'package:sosyal_medya/backend/schema/badge_model/badge_model.dart';
import 'package:sosyal_medya/components/multiple_badges_display/multiple_badges_display_widget.dart';
import 'package:sosyal_medya/components/verified/verified_widget.dart';
import 'package:sosyal_medya/extension/dynamic_extensions.dart';
import 'package:sosyal_medya/helper/file_download.dart';
import 'package:sosyal_medya/helper/show_dialogs.dart';
import 'package:sosyal_medya/pages/create_activity/model/acitivity_model.dart';
import 'package:sosyal_medya/util/base_utility.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/users_record_extensions.dart';
import '/components/delete_post/delete_post_widget.dart';
import '/components/empty_list_2/empty_list2_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_media_display.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_video_player.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'post_details_base_model.dart';
export 'post_details_base_model.dart';

class PostDetailsBaseWidget extends StatefulWidget {
  const PostDetailsBaseWidget({
    super.key,
    this.postRef,
    required this.userRef,
  });

  final DocumentReference? postRef;
  final UsersRecord? userRef;

  @override
  State<PostDetailsBaseWidget> createState() => _PostDetailsBaseWidgetState();
}

class _PostDetailsBaseWidgetState extends State<PostDetailsBaseWidget>
    with TickerProviderStateMixin {
  late PostDetailsBaseModel _model;

  DynamicViewExtensions dynamicViewExtensions = DynamicViewExtensions();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PostDetailsBaseModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, 20.0),
            end: Offset(0.0, 0.0),
          ),
          TiltEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.698, 0),
            end: Offset(0, 0),
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserPostsRecord>(
      stream: UserPostsRecord.getDocument(widget.postRef!),
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

        final containerUserPostsRecord = snapshot.data!;

        return Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: 770.0,
          ),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Stack(
                        children: [
                          containerUserPostsRecord.postPhoto.isEmpty
                              ? const SizedBox()
                              : Container(
                                  width: MediaQuery.sizeOf(context).width * 1.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: FlutterFlowMediaDisplay(
                                    path: containerUserPostsRecord.postPhoto,
                                    imageBuilder: (path) => CachedNetworkImage(
                                      fadeInDuration: Duration(milliseconds: 0),
                                      fadeOutDuration: Duration(milliseconds: 0),
                                      imageUrl: path,
                                      width: MediaQuery.sizeOf(context).width * 1.0,
                                      height: 430.0,
                                      fit: BoxFit.cover,
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
                                ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(16.0, 64.0, 16.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  color: FlutterFlowTheme.of(context).accent4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40.0),
                                  ),
                                  child: FlutterFlowIconButton(
                                    borderColor: Colors.transparent,
                                    borderRadius: 30.0,
                                    buttonSize: 46.0,
                                    icon: Icon(
                                      Icons.arrow_back_rounded,
                                      color: FlutterFlowTheme.of(context).primaryText,
                                      size: 25.0,
                                    ),
                                    onPressed: () async {
                                      context.safePop();
                                    },
                                  ),
                                ),
                                widget.userRef?.reference == currentUserReference
                                    ? FlutterFlowIconButton(
                                        borderColor: Colors.transparent,
                                        borderRadius: 30.0,
                                        borderWidth: 1.0,
                                        buttonSize: 44.0,
                                        fillColor: FlutterFlowTheme.of(context).accent4,
                                        icon: Icon(
                                          Icons.more_vert_sharp,
                                          color: FlutterFlowTheme.of(context).primaryText,
                                          size: 24.0,
                                        ),
                                        onPressed: () async {
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
                                                    postParameters: containerUserPostsRecord,
                                                  ),
                                                ),
                                              );
                                            },
                                          ).then((value) => safeSetState(() {}));
                                        },
                                      )
                                    : containerUserPostsRecord.postPhoto.isEmpty
                                        ? const SizedBox()
                                        : FlutterFlowIconButton(
                                            borderColor: Colors.transparent,
                                            borderRadius: 30.0,
                                            borderWidth: 1.0,
                                            buttonSize: 44.0,
                                            fillColor: FlutterFlowTheme.of(context).accent4,
                                            icon: Icon(
                                              Icons.more_vert_sharp,
                                              color: FlutterFlowTheme.of(context).primaryText,
                                              size: 24.0,
                                            ),
                                            onPressed: () async {
                                              CodeNoahDialogs(context).showModalNewBottom(
                                                dynamicViewExtensions,
                                                'GÖNDERİ AYARLARI',
                                                dynamicViewExtensions.dynamicHeight(context, 0.2),
                                                [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      if (containerUserPostsRecord.postPhoto
                                                          .contains(".mp4")) {
                                                        print("MP4 geçiyor");
                                                        FileDownloadService(context)
                                                            .saveNetworkVideoFile(
                                                                containerUserPostsRecord.postPhoto);
                                                      } else if (containerUserPostsRecord.postPhoto
                                                              .contains(".jpg") ||
                                                          containerUserPostsRecord.postPhoto
                                                              .contains(".png")) {
                                                        print("JPG VE PNG destekliyor");
                                                        FileDownloadService(context)
                                                            .saveNetworkImage(
                                                                containerUserPostsRecord.postPhoto);
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
                                            },
                                          ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      containerUserPostsRecord.postIsActivity == true
                          ? Row(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: BaseUtility.paddingMediumValue,
                                      horizontal: BaseUtility.paddingNormalValue,
                                    ),
                                    margin: EdgeInsets.symmetric(
                                      vertical: BaseUtility.marginNormalValue,
                                      horizontal: BaseUtility.marginNormalValue,
                                    ),
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primary
                                          .withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          BaseUtility.radiusNormalValue,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: Icon(
                                            Icons.local_activity,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Padding(
                                          padding: BaseUtility.left(
                                            BaseUtility.paddingNormalValue,
                                          ),
                                          child: FutureBuilder(
                                            future: containerUserPostsRecord.postCategory!.get(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return Text(
                                                  'Aktivite Bulunamadı',
                                                  style: FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .copyWith(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                );
                                              }

                                              if (snapshot.hasData) {
                                                final model = ActivityModel.fromJson(
                                                    snapshot.data!.data() as Map<String, dynamic>);
                                                return Text(
                                                  model.name,
                                                  style: FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .copyWith(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                );
                                              }

                                              return Text(
                                                '',
                                                style: FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .copyWith(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      Container(
                        margin: EdgeInsets.only(
                            top: containerUserPostsRecord.postPhoto.isEmpty ? 17 : 0),
                        padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 0.0),
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
                                  widget.userRef,
                                  ParamType.Document,
                                ),
                                'showPage': serializeParam(
                                  true,
                                  ParamType.bool,
                                ),
                                'pageTitle': serializeParam(
                                  'Post Details',
                                  ParamType.String,
                                ),
                              }.withoutNulls,
                              extra: <String, dynamic>{
                                'userDetails': widget.userRef,
                              },
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: 48.0,
                                height: 48.0,
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
                                    borderRadius: BorderRadius.circular(
                                        widget.userRef!.photoUrl.isEmpty ? 120.0 : 0),
                                    color: widget.userRef!.photoUrl.isEmpty ? Colors.white : null,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(120.0),
                                    child: Image.network(
                                      valueOrDefault<String>(
                                        widget.userRef?.photoUrl,
                                        'https://firebasestorage.googleapis.com/v0/b/liseli-buyukelciler-db.firebasestorage.app/o/app_ico%2Ficons8-account-96.png?alt=media&token=4104ae4d-7566-449c-81d8-ebbb1fac88e6',
                                      ),
                                      width: 300.0,
                                      height: 200.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(
                                                  12.0, 0.0, 0.0, 0.0),
                                              child: Text(
                                                valueOrDefault<String>(
                                                  widget.userRef?.displayName,
                                                  'Bilinmeyen Kullanıcı',
                                                ),
                                                style: FlutterFlowTheme.of(context)
                                                    .titleLarge
                                                    .override(
                                                      fontFamily: 'Outfit',
                                                      letterSpacing: 0.0,
                                                    ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            widget.userRef!.badges.isNotEmpty
                                                ? MultipleBadgesDisplayWidget(
                                                    badgeIds: widget.userRef!.badges,
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(12.0, 4.0, 0.0, 0.0),
                                          child: Text(
                                            valueOrDefault<String>(
                                              '@${widget.userRef?.userName}',
                                              '@noone',
                                            ),
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                  fontFamily: 'Figtree',
                                                  color: FlutterFlowTheme.of(context).primary,
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        dateTimeFormat(
                                            "relative", containerUserPostsRecord.timePosted!),
                                        style: FlutterFlowTheme.of(context).labelSmall.override(
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
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                                child: Text(
                                  valueOrDefault<String>(
                                    containerUserPostsRecord.postDescription,
                                    '--',
                                  ).maybeHandleOverflow(
                                    maxChars: 200,
                                    replacement: '…',
                                  ),
                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                        fontFamily: 'Figtree',
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 16.0, 6.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      ToggleIcon(
                                        onPressed: () async {
                                          final likesElement = currentUserReference;
                                          final likesUpdate =
                                              containerUserPostsRecord.likes.contains(likesElement)
                                                  ? FieldValue.arrayRemove([likesElement])
                                                  : FieldValue.arrayUnion([likesElement]);
                                          await containerUserPostsRecord.reference.update({
                                            ...mapToFirestore(
                                              {
                                                'likes': likesUpdate,
                                              },
                                            ),
                                          });
                                        },
                                        value: containerUserPostsRecord.likes
                                            .contains(currentUserReference),
                                        onIcon: Icon(
                                          Icons.favorite_sharp,
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
                                        padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          valueOrDefault<String>(
                                            formatNumber(
                                              functions.likes(containerUserPostsRecord),
                                              formatType: FormatType.compact,
                                            ),
                                            '0',
                                          ),
                                          style: FlutterFlowTheme.of(context).labelMedium.override(
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
                                      padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        valueOrDefault<String>(
                                          formatNumber(
                                            containerUserPostsRecord.numComments,
                                            formatType: FormatType.compact,
                                          ),
                                          '0',
                                        ),
                                        style: FlutterFlowTheme.of(context).labelMedium.override(
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
                                Icon(
                                  Icons.ios_share,
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  size: 24.0,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Yorumlar',
                                    style: FlutterFlowTheme.of(context).labelMedium.override(
                                          fontFamily: 'Figtree',
                                          fontSize: 12.0,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            StreamBuilder<List<PostCommentsRecord>>(
                              stream: queryPostCommentsRecord(
                                queryBuilder: (postCommentsRecord) => postCommentsRecord
                                    .where(
                                      'post',
                                      isEqualTo: widget.postRef,
                                    )
                                    .orderBy('timePosted', descending: true),
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
                                List<PostCommentsRecord> commentListPostCommentsRecordList =
                                    snapshot.data!;
                                if (commentListPostCommentsRecordList.isEmpty) {
                                  return Center(
                                    child: Container(
                                      height: 300.0,
                                      child: EmptyList2Widget(),
                                    ),
                                  );
                                }

                                return Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: List.generate(commentListPostCommentsRecordList.length,
                                      (commentListIndex) {
                                    final commentListPostCommentsRecord =
                                        commentListPostCommentsRecordList[commentListIndex];
                                    return Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 2.0),
                                      child: StreamBuilder<UsersRecord>(
                                        stream: UsersRecord.getDocument(
                                            commentListPostCommentsRecord.user!),
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

                                          final commentUsersRecord = snapshot.data!;

                                          return Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context).secondaryBackground,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                                  offset: Offset(
                                                    0.0,
                                                    1.0,
                                                  ),
                                                )
                                              ],
                                              borderRadius: BorderRadius.circular(0.0),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 12.0, 16.0, 12.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 44.0,
                                                    height: 44.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme.of(context).accent1,
                                                      borderRadius: BorderRadius.circular(10.0),
                                                      border: Border.all(
                                                        color: FlutterFlowTheme.of(context).primary,
                                                        width: 2.0,
                                                      ),
                                                    ),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: commentUsersRecord.photoUrl.isEmpty
                                                            ? Colors.white
                                                            : null,
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(
                                                            commentUsersRecord.photoUrl.isEmpty
                                                                ? 10.0
                                                                : 0,
                                                          ),
                                                        ),
                                                      ),
                                                      padding: EdgeInsets.all(2.0),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(8.0),
                                                        child: Image.network(
                                                          valueOrDefault<String>(
                                                            commentUsersRecord.photoUrl,
                                                            'https://firebasestorage.googleapis.com/v0/b/liseli-buyukelciler-db.firebasestorage.app/o/app_ico%2Ficons8-account-96.png?alt=media&token=4104ae4d-7566-449c-81d8-ebbb1fac88e6',
                                                          ),
                                                          width: 300.0,
                                                          height: 200.0,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                          12.0, 0.0, 0.0, 0.0),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            children: <Widget>[
                                                              Text(
                                                                valueOrDefault<String>(
                                                                  commentUsersRecord.displayName,
                                                                  'Benim Adım Burada',
                                                                ),
                                                                style: FlutterFlowTheme.of(context)
                                                                    .bodyLarge
                                                                    .override(
                                                                      fontFamily: 'Figtree',
                                                                      letterSpacing: 0.0,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                              ),
                                                              commentUsersRecord.badges.isNotEmpty
                                                                  ? MultipleBadgesDisplayWidget(
                                                                      badgeIds:
                                                                          commentUsersRecord.badges,
                                                                    )
                                                                  : const SizedBox(),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                0.0, 4.0, 0.0, 8.0),
                                                            child: Text(
                                                              commentListPostCommentsRecord.comment,
                                                              style: FlutterFlowTheme.of(context)
                                                                  .labelLarge
                                                                  .override(
                                                                    fontFamily: 'Figtree',
                                                                    letterSpacing: 0.0,
                                                                  ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                0.0, 4.0, 0.0, 0.0),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(0.0, 0.0, 4.0, 0.0),
                                                                  child: Text(
                                                                    'Gönderildi',
                                                                    style:
                                                                        FlutterFlowTheme.of(context)
                                                                            .labelSmall
                                                                            .override(
                                                                              fontFamily: 'Figtree',
                                                                              letterSpacing: 0.0,
                                                                            ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  dateTimeFormat(
                                                                      "relative",
                                                                      commentListPostCommentsRecord
                                                                          .timePosted!),
                                                                  style:
                                                                      FlutterFlowTheme.of(context)
                                                                          .labelSmall
                                                                          .override(
                                                                            fontFamily: 'Figtree',
                                                                            letterSpacing: 0.0,
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
                                          ).animateOnPageLoad(
                                              animationsMap['containerOnPageLoadAnimation']!);
                                        },
                                      ),
                                    );
                                  }),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Form(
                      key: _model.formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * 1.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primaryBackground,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 3.0,
                                color: Color(0x3A000000),
                                offset: Offset(
                                  0.0,
                                  1.0,
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 0.0, 4.0),
                                  child: TextFormField(
                                    controller: _model.textController,
                                    focusNode: _model.textFieldFocusNode,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      hintText: 'Buraya yorum yapın...',
                                      hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                            fontFamily: 'Figtree',
                                            letterSpacing: 0.0,
                                          ),
                                      errorStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Figtree',
                                            color: FlutterFlowTheme.of(context).error,
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                          ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      errorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedErrorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Figtree',
                                          letterSpacing: 0.0,
                                        ),
                                    validator: _model.textControllerValidator.asValidator(context),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 4.0, 0.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    if (_model.formKey.currentState == null ||
                                        !_model.formKey.currentState!.validate()) {
                                      return;
                                    }

                                    var postCommentsRecordReference =
                                        PostCommentsRecord.collection.doc();
                                    await postCommentsRecordReference
                                        .set(createPostCommentsRecordData(
                                      timePosted: getCurrentTimestamp,
                                      comment: _model.textController.text,
                                      user: currentUserReference,
                                      post: containerUserPostsRecord.reference,
                                    ));
                                    _model.newComment = PostCommentsRecord.getDocumentFromData(
                                        createPostCommentsRecordData(
                                          timePosted: getCurrentTimestamp,
                                          comment: _model.textController.text,
                                          user: currentUserReference,
                                          post: containerUserPostsRecord.reference,
                                        ),
                                        postCommentsRecordReference);
                                    safeSetState(() {
                                      _model.textController?.clear();
                                    });

                                    await containerUserPostsRecord.reference.update({
                                      ...mapToFirestore(
                                        {
                                          'numComments': FieldValue.increment(1),
                                        },
                                      ),
                                    });

                                    safeSetState(() {});
                                  },
                                  text: 'Post',
                                  options: FFButtonOptions(
                                    width: 70.0,
                                    height: 40.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                    color: FlutterFlowTheme.of(context).primaryBackground,
                                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                          fontFamily: 'Figtree',
                                          color: FlutterFlowTheme.of(context).primary,
                                          letterSpacing: 0.0,
                                        ),
                                    elevation: 0.0,
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
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
              ),
            ],
          ),
        );
      },
    );
  }
}
