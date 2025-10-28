import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sosyal_medya/backend/schema/badge_model/badge_model.dart';
import 'package:sosyal_medya/components/multiple_badges_display/multiple_badges_display_widget.dart';
import 'package:sosyal_medya/components/verified/verified_widget.dart';
import 'package:sosyal_medya/extension/dynamic_extensions.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_media_display.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_video_player.dart';
import 'package:sosyal_medya/helper/file_download.dart';
import 'package:sosyal_medya/helper/show_dialogs.dart';
import 'package:sosyal_medya/pages/education_information/model/education_information_model.dart';
import 'package:sosyal_medya/pages/turkey_education_information/turkey_education_information_model/turkey_education_information_model.dart';
import 'package:sosyal_medya/pages/working_life/model/working_life_model.dart';
import 'package:sosyal_medya/util/base_utility.dart';

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
import 'dart:async';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'view_profile_page_other_model.dart';
export 'view_profile_page_other_model.dart';

class ViewProfilePageOtherWidget extends StatefulWidget {
  const ViewProfilePageOtherWidget({
    super.key,
    this.userDetails,
    this.showPage,
    String? pageTitle,
  }) : this.pageTitle = pageTitle ?? 'Page';

  final UsersRecord? userDetails;
  final bool? showPage;
  final String pageTitle;

  static String routeName = 'viewProfilePageOther';
  static String routePath = '/viewProfilePageOther';

  @override
  State<ViewProfilePageOtherWidget> createState() => _ViewProfilePageOtherWidgetState();
}

class _ViewProfilePageOtherWidgetState extends State<ViewProfilePageOtherWidget>
    with TickerProviderStateMixin {
  DynamicViewExtensions dynamicViewExtensions = DynamicViewExtensions();
  late ViewProfilePageOtherModel _model;

  String calculateDateDifference(DateTime start, DateTime end) {
    if (end.isBefore(start)) {
      return 'Geçersiz Tarih Aralığı';
    }

    int years = end.year - start.year;
    int months = end.month - start.month;
    int days = end.day - start.day;

    if (days < 0) {
      months -= 1;
      final prevMonth = DateTime(end.year, end.month, 0);
      days += prevMonth.day;
    }

    if (months < 0) {
      years -= 1;
      months += 12;
    }

    String result = '';
    if (years > 0) result += '$years Yıl ';
    if (months > 0) result += '$months Ay ';
    if (days > 0) result += '$days Gün';

    return result.trim().isEmpty ? 'Aynı Gün' : result.trim();
  }

  // Ülke kodundan bayrak emojisi oluştur
  String _getCountryFlag(String countryCode) {
    // Ülke kodunu büyük harfe çevir (TR, US, DE, vb.)
    final code = countryCode.toUpperCase();

    // Her harf için Unicode regional indicator symbol oluştur
    // A = 🇦 (U+1F1E6), B = 🇧 (U+1F1E7), vb.
    return code.runes.map((rune) {
      // A-Z arasındaki harfleri regional indicator'a çevir
      if (rune >= 0x41 && rune <= 0x5A) {
        return String.fromCharCode(0x1F1E6 + (rune - 0x41));
      }
      return String.fromCharCode(rune);
    }).join();
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ViewProfilePageOtherModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 1,
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
    return FutureBuilder<UsersRecord>(
      future: UsersRecord.getDocumentOnce(widget.userDetails!.reference),
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

        final viewProfilePageOtherUsersRecord = snapshot.data!;

        return Scaffold(
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
                  leading: FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30.0,
                    buttonSize: 46.0,
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 25.0,
                    ),
                    onPressed: () async {
                      context.pop();
                    },
                  ),
                  actions: [
                    FirebaseAuth.instance.currentUser!.uid == viewProfilePageOtherUsersRecord.uid
                        ? const SizedBox()
                        : GestureDetector(
                            onTap: () {
                              CodeNoahDialogs(context).showModalNewBottom(
                                dynamicViewExtensions,
                                'AYARLAR',
                                dynamicViewExtensions.dynamicHeight(context, 0.2),
                                [
                                  GestureDetector(
                                    onTap: () async {
                                      if (FirebaseAuth.instance.currentUser!.uid !=
                                          viewProfilePageOtherUsersRecord.uid) {
                                        final currentUser = FirebaseAuth.instance.currentUser!;
                                        final currentUserId = currentUser.uid;
                                        final otherUserId = viewProfilePageOtherUsersRecord.uid;

                                        final currentUserDoc = FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(currentUserId);
                                        final otherUserDoc = FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(otherUserId);

                                        final currentUserSnapshot = await currentUserDoc.get();
                                        //final otherUserSnapshot = await otherUserDoc.get();

                                        List<dynamic> engellenenList =
                                            currentUserSnapshot.data()?['engellenen'] ?? [];

                                        final isBlocked = engellenenList.contains(otherUserId);

                                        if (isBlocked) {
                                          // Engellemeyi kaldır
                                          await currentUserDoc.update({
                                            'engellenen': FieldValue.arrayRemove([otherUserId])
                                          });

                                          await otherUserDoc.update({
                                            'engelleyen': FieldValue.arrayRemove([currentUserId])
                                          });

                                          Navigator.pop(context);
                                          CodeNoahDialogs(context).showFlush(
                                            type: SnackType.success,
                                            message: 'Engelleme kaldırıldı!',
                                          );
                                        } else {
                                          // Engelle
                                          await currentUserDoc.set({
                                            'engellenen': FieldValue.arrayUnion([otherUserId])
                                          }, SetOptions(merge: true));

                                          await otherUserDoc.set({
                                            'engelleyen': FieldValue.arrayUnion([currentUserId])
                                          }, SetOptions(merge: true));

                                          Navigator.pop(context);
                                          CodeNoahDialogs(context).showFlush(
                                            type: SnackType.warning,
                                            message: 'Kullanıcı Engellendi!',
                                          );
                                        }
                                      }
                                    },
                                    child: FutureBuilder<DocumentSnapshot>(
                                      future: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth.instance.currentUser!.uid)
                                          .get(),
                                      builder: (context, snapshot) {
                                        bool isBlocked = false;

                                        if (snapshot.hasData) {
                                          final data =
                                              snapshot.data!.data() as Map<String, dynamic>;
                                          final List<dynamic> engellenen = data['engellenen'] ?? [];
                                          isBlocked = engellenen
                                              .contains(viewProfilePageOtherUsersRecord.uid);
                                        }

                                        return Padding(
                                          padding: BaseUtility.all(BaseUtility.paddingNormalValue),
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.close,
                                                size: BaseUtility.iconNormalSize,
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: BaseUtility.horizontal(
                                                      BaseUtility.paddingNormalValue),
                                                  child: Text(
                                                    isBlocked
                                                        ? 'Kullanıcıyı Engellemeden Kaldır'
                                                        : 'Kullanıcıyı Engelle',
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
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                            child: Padding(
                              padding: BaseUtility.horizontal(
                                BaseUtility.paddingNormalValue,
                              ),
                              child: Icon(
                                Icons.settings_outlined,
                                color: Colors.black54,
                                size: 21,
                              ),
                            ),
                          ),
                  ],
                  centerTitle: false,
                  elevation: 0.0,
                )
              : null,
          body: SafeArea(
            top: true,
            child: Align(
              alignment: AlignmentDirectional(0.0, -1.0),
              child: Row(
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
                          maxWidth: 870.0,
                        ),
                        decoration: BoxDecoration(),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            if (responsiveVisibility(
                              context: context,
                              phone: false,
                            ))
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 12.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(16.0, 2.0, 0.0, 2.0),
                                          child: FlutterFlowIconButton(
                                            borderColor: Colors.transparent,
                                            borderRadius: 30.0,
                                            borderWidth: 1.0,
                                            buttonSize: 40.0,
                                            icon: Icon(
                                              Icons.home_rounded,
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              size: 22.0,
                                            ),
                                            onPressed: () async {
                                              context.pushNamed(
                                                MainFeedWidget.routeName,
                                                extra: <String, dynamic>{
                                                  kTransitionInfoKey: TransitionInfo(
                                                    hasTransition: true,
                                                    transitionType: PageTransitionType.fade,
                                                    duration: Duration(milliseconds: 0),
                                                  ),
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                                          child: Icon(
                                            Icons.chevron_right_rounded,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                            size: 16.0,
                                          ),
                                        ),
                                        if (widget.showPage ?? true)
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                              ),
                                              alignment: AlignmentDirectional(0.0, 0.0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 0.0, 16.0, 0.0),
                                                child: Text(
                                                  widget.pageTitle,
                                                  style: FlutterFlowTheme.of(context)
                                                      .labelLarge
                                                      .override(
                                                        fontFamily: 'Figtree',
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (widget.showPage ?? true)
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                12.0, 0.0, 12.0, 0.0),
                                            child: Icon(
                                              Icons.chevron_right_rounded,
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              size: 16.0,
                                            ),
                                          ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 16.0, 8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).accent2,
                                              borderRadius: BorderRadius.circular(8.0),
                                              border: Border.all(
                                                color: FlutterFlowTheme.of(context).secondary,
                                              ),
                                            ),
                                            alignment: AlignmentDirectional(0.0, 0.0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 16.0, 0.0),
                                              child: Text(
                                                viewProfilePageOtherUsersRecord.displayName,
                                                style:
                                                    FlutterFlowTheme.of(context).bodyLarge.override(
                                                          fontFamily: 'Figtree',
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                                    padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
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
                                                color: FlutterFlowTheme.of(context).accent2,
                                                borderRadius: BorderRadius.circular(120.0),
                                                border: Border.all(
                                                  color: FlutterFlowTheme.of(context).secondary,
                                                  width: 2.0,
                                                ),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: widget.userDetails!.photoUrl.isEmpty
                                                      ? Colors.white
                                                      : null,
                                                  borderRadius: BorderRadius.circular(
                                                      widget.userDetails!.photoUrl.isEmpty
                                                          ? 120.0
                                                          : 0),
                                                ),
                                                padding: EdgeInsets.all(2.0),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(120.0),
                                                  child: Image.network(
                                                    widget.userDetails!.photoUrl.isEmpty
                                                        ? 'https://firebasestorage.googleapis.com/v0/b/liseli-buyukelciler-db.firebasestorage.app/o/app_ico%2Ficons8-account-96.png?alt=media&token=4104ae4d-7566-449c-81d8-ebbb1fac88e6'
                                                        : widget.userDetails!.photoUrl,
                                                    width: 300.0,
                                                    height: 200.0,
                                                    fit: BoxFit.cover,
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
                                                      viewProfilePageOtherUsersRecord.displayName,
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
                                                  viewProfilePageOtherUsersRecord.badges.isNotEmpty
                                                      ? MultipleBadgesDisplayWidget(
                                                          badgeIds: viewProfilePageOtherUsersRecord
                                                              .badges,
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
                                                    viewProfilePageOtherUsersRecord.email,
                                                    textAlign: TextAlign.start,
                                                    style: FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Lexend Deca',
                                                          color: Color(0xFFEE8B60),
                                                          fontSize: 14.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight: FontWeight.normal,
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
                                                    viewProfilePageOtherUsersRecord.bio,
                                                    textAlign: TextAlign.start,
                                                    style: FlutterFlowTheme.of(context)
                                                        .labelMedium
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

                                  // On this stack we query the "Friends" collection. If a document exists where the authenticated user == follower and the userRef == followee -- then you are currently following the user, if not you should be able to follow the user and unfollow them.
                                  StreamBuilder<List<FriendsRecord>>(
                                    stream: queryFriendsRecord(
                                      queryBuilder: (friendsRecord) => friendsRecord
                                          .where(
                                            'follower',
                                            isEqualTo: currentUserReference,
                                          )
                                          .where(
                                            'followee',
                                            isEqualTo: viewProfilePageOtherUsersRecord.reference,
                                          ),
                                      singleRecord: true,
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
                                      List<FriendsRecord> stackFriendsRecordList = snapshot.data!;
                                      final stackFriendsRecord = stackFriendsRecordList.isNotEmpty
                                          ? stackFriendsRecordList.first
                                          : null;

                                      return Stack(
                                        children: [
                                          if (stackFriendsRecord != null)
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 12.0, 16.0, 12.0),
                                              child: FFButtonWidget(
                                                onPressed: () async {
                                                  unawaited(
                                                    () async {
                                                      await stackFriendsRecord.reference.delete();
                                                    }(),
                                                  );
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'İzninizi başarıyla kaldırdınız ${viewProfilePageOtherUsersRecord.displayName}',
                                                        style: FlutterFlowTheme.of(context)
                                                            .titleSmall
                                                            .override(
                                                              fontFamily: 'Figtree',
                                                              color:
                                                                  FlutterFlowTheme.of(context).info,
                                                              letterSpacing: 0.0,
                                                            ),
                                                      ),
                                                      duration: Duration(milliseconds: 4000),
                                                      backgroundColor:
                                                          FlutterFlowTheme.of(context).primary,
                                                    ),
                                                  );
                                                },
                                                text: 'Takip Ediliyor',
                                                options: FFButtonOptions(
                                                  width: double.infinity,
                                                  height: 40.0,
                                                  padding: EdgeInsetsDirectional.fromSTEB(
                                                      0.0, 0.0, 0.0, 0.0),
                                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                      0.0, 0.0, 0.0, 0.0),
                                                  color: FlutterFlowTheme.of(context)
                                                      .primary
                                                      .withValues(alpha: 0.2),
                                                  textStyle: FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .override(
                                                        fontFamily: 'Figtree',
                                                        letterSpacing: 0.0,
                                                      ),
                                                  elevation: 0.0,
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(context).primary,
                                                    width: 2.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(12.0),
                                                ),
                                              ),
                                            ),
                                          if (!(stackFriendsRecord != null))
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 12.0, 16.0, 12.0),
                                              child: FFButtonWidget(
                                                onPressed: () async {
                                                  var friendsRecordReference =
                                                      FriendsRecord.collection.doc();
                                                  await friendsRecordReference
                                                      .set(createFriendsRecordData(
                                                    follower: currentUserReference,
                                                    followee:
                                                        viewProfilePageOtherUsersRecord.reference,
                                                  ));
                                                  _model.customFriendsDoc =
                                                      FriendsRecord.getDocumentFromData(
                                                          createFriendsRecordData(
                                                            follower: currentUserReference,
                                                            followee:
                                                                viewProfilePageOtherUsersRecord
                                                                    .reference,
                                                          ),
                                                          friendsRecordReference);

                                                  safeSetState(() {});
                                                },
                                                text: 'Takip Et',
                                                options: FFButtonOptions(
                                                  width: double.infinity,
                                                  height: 40.0,
                                                  padding: EdgeInsetsDirectional.fromSTEB(
                                                      0.0, 0.0, 0.0, 0.0),
                                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                      0.0, 0.0, 0.0, 0.0),
                                                  color: FlutterFlowTheme.of(context).primary,
                                                  textStyle: FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .override(
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
                                              ),
                                            ),
                                        ],
                                      );
                                    },
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Flexible(
                                        fit: FlexFit.tight,
                                        flex: 1,
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              16.0, 12.0, 16.0, 12.0),
                                          child: FFButtonWidget(
                                            onPressed: () async {
                                              CodeNoahDialogs(context).showModalNewBottom(
                                                backgroundColor: FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                                barrierColor: Colors.black54,
                                                dynamicViewExtensions,
                                                'ÇALIŞMA HAYATI',
                                                dynamicViewExtensions.dynamicHeight(context, 0.4),
                                                [
                                                  Padding(
                                                    padding: BaseUtility.all(
                                                      BaseUtility.paddingNormalValue,
                                                    ),
                                                    child: FutureBuilder<QuerySnapshot>(
                                                      future: FirebaseFirestore.instance
                                                          .collection('working_life')
                                                          .where('user_ref',
                                                              isEqualTo: FirebaseFirestore.instance
                                                                  .collection('users')
                                                                  .doc(widget.userDetails!.uid))
                                                          .where('is_deleted', isEqualTo: false)
                                                          .orderBy('created_at', descending: true)
                                                          .get(),
                                                      builder: (context, snapshot) {
                                                        if (snapshot.hasError) {
                                                          return const Text('Hata oluştu');
                                                        }

                                                        if (snapshot.connectionState ==
                                                            ConnectionState.waiting) {
                                                          return const CircularProgressIndicator();
                                                        }

                                                        if (snapshot.hasData) {
                                                          List<WorkingLifeModel> workingLife =
                                                              snapshot.data!.docs
                                                                  .map((DocumentSnapshot document) {
                                                            final Map<String, dynamic> data =
                                                                document.data()!
                                                                    as Map<String, dynamic>;

                                                            return WorkingLifeModel.fromJson(data);
                                                          }).toList();

                                                          return workingLife.isEmpty
                                                              ? Center(
                                                                  child: EmptyStateSimpleWidget(
                                                                    icon: Icon(
                                                                      Icons.work,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                      size: 72.0,
                                                                    ),
                                                                    title:
                                                                        'Çalışma Hayatı Bulunmuyor',
                                                                    body:
                                                                        'Kullanıcının Henüz Çalışma Hayatı bulunmuyor.',
                                                                  ),
                                                                )
                                                              : ListView.builder(
                                                                  shrinkWrap: true,
                                                                  physics:
                                                                      NeverScrollableScrollPhysics(),
                                                                  itemCount: workingLife.length,
                                                                  itemBuilder: (context, index) {
                                                                    final model =
                                                                        workingLife[index];
                                                                    return Card(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryBackground,
                                                                      margin: EdgeInsets.only(
                                                                          bottom: 16),
                                                                      child: SizedBox(
                                                                        width: dynamicViewExtensions
                                                                            .maxWidth(context),
                                                                        child: Container(
                                                                          padding:
                                                                              EdgeInsets.all(16),
                                                                          decoration: BoxDecoration(
                                                                              color: FlutterFlowTheme
                                                                                      .of(context)
                                                                                  .secondaryBackground,
                                                                              border: Border.all(
                                                                                color: Colors.white,
                                                                                width: 0.5,
                                                                              ),
                                                                              borderRadius:
                                                                                  BorderRadius.all(
                                                                                      Radius
                                                                                          .circular(
                                                                                              16))),
                                                                          child: Row(
                                                                            children: <Widget>[
                                                                              Icon(
                                                                                Icons
                                                                                    .school_outlined,
                                                                                size: 21,
                                                                              ),
                                                                              Expanded(
                                                                                child: Padding(
                                                                                  padding: EdgeInsets
                                                                                      .symmetric(
                                                                                          horizontal:
                                                                                              16),
                                                                                  child: Column(
                                                                                    children: <Widget>[
                                                                                      // company
                                                                                      SizedBox(
                                                                                        width: dynamicViewExtensions
                                                                                            .maxWidth(
                                                                                                context),
                                                                                        child:
                                                                                            Padding(
                                                                                          padding: EdgeInsets.only(
                                                                                              bottom:
                                                                                                  10),
                                                                                          child:
                                                                                              Text(
                                                                                            model
                                                                                                .company_name,
                                                                                            style: FlutterFlowTheme.of(context)
                                                                                                .bodyMedium,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      // task
                                                                                      SizedBox(
                                                                                        width: dynamicViewExtensions
                                                                                            .maxWidth(
                                                                                                context),
                                                                                        child:
                                                                                            Padding(
                                                                                          padding: EdgeInsets.only(
                                                                                              bottom:
                                                                                                  10),
                                                                                          child:
                                                                                              Text(
                                                                                            "${model.task}",
                                                                                            style: FlutterFlowTheme.of(context)
                                                                                                .bodyMedium,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      // change year date
                                                                                      SizedBox(
                                                                                        width: dynamicViewExtensions
                                                                                            .maxWidth(
                                                                                                context),
                                                                                        child:
                                                                                            Padding(
                                                                                          padding: EdgeInsets.only(
                                                                                              bottom:
                                                                                                  10),
                                                                                          child:
                                                                                              Text(
                                                                                            "${model.date_start!.toDate().day.toString().padLeft(2, '0')}.${model.date_start!.toDate().month.toString().padLeft(2, '0')}.${model.date_start!.toDate().year.toString().padLeft(2, '0')} - ${model.is_working == false ? "${model.date_end!.toDate().day.toString().padLeft(2, '0')}.${model.date_end!.toDate().month.toString().padLeft(2, '0')}.${model.date_end!.toDate().year.toString().padLeft(2, '0')}" : 'Devam Ediyor'}",
                                                                                            style: FlutterFlowTheme.of(context)
                                                                                                .bodyMedium,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      // date calculate
                                                                                      SizedBox(
                                                                                        width: dynamicViewExtensions
                                                                                            .maxWidth(
                                                                                                context),
                                                                                        child:
                                                                                            Padding(
                                                                                          padding: EdgeInsets.only(
                                                                                              bottom:
                                                                                                  10),
                                                                                          child:
                                                                                              Text(
                                                                                            calculateDateDifference(
                                                                                                model.date_start!.toDate(),
                                                                                                model.date_end!.toDate()),
                                                                                            style: FlutterFlowTheme.of(context)
                                                                                                .bodyMedium,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              // Icon(
                                                                              //   Icons.arrow_forward_ios,
                                                                              //   size: 21,
                                                                              // ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                        }

                                                        return const CircularProgressIndicator();
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                            text: 'Çalışma Hayatı',
                                            options: FFButtonOptions(
                                              width: double.infinity,
                                              height: 40.0,
                                              padding: EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                              color: FlutterFlowTheme.of(context).primary,
                                              textStyle:
                                                  FlutterFlowTheme.of(context).titleSmall.override(
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
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        fit: FlexFit.tight,
                                        flex: 1,
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              16.0, 12.0, 16.0, 12.0),
                                          child: FFButtonWidget(
                                            onPressed: () async {
                                              CodeNoahDialogs(context).showModalBottom(
                                                backgroundColor: FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                                barrierColor: Colors.black54,
                                                Column(
                                                  children: <Widget>[
                                                    // appbar
                                                    Padding(
                                                      padding: BaseUtility.all(
                                                        BaseUtility.paddingNormalValue,
                                                      ),
                                                      child: Row(
                                                        children: <Widget>[
                                                          // text
                                                          Expanded(
                                                            child: Text(
                                                              'EĞİTİM BİLGİLERİ',
                                                              textAlign: TextAlign.center,
                                                              style: FlutterFlowTheme.of(context)
                                                                  .bodyMedium
                                                                  .copyWith(
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                            ),
                                                          ),
                                                          // icon
                                                          GestureDetector(
                                                            onTap: () => Navigator.pop(context),
                                                            child: Icon(
                                                              Icons.close,
                                                              size: BaseUtility.iconNormalSize,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // body
                                                    Expanded(
                                                      child: ContainedTabBarView(
                                                        tabs: [
                                                          Text(
                                                            'Değişim Yılı Eğitim Bilgileri',
                                                            style: FlutterFlowTheme.of(context)
                                                                .bodyMedium,
                                                          ),
                                                          Text(
                                                            'Türkiyedeki Eğitim Bilgileri',
                                                            style: FlutterFlowTheme.of(context)
                                                                .bodyMedium,
                                                          ),
                                                        ],
                                                        views: [
                                                          Padding(
                                                            padding: BaseUtility.all(
                                                              BaseUtility.paddingNormalValue,
                                                            ),
                                                            child: FutureBuilder<QuerySnapshot>(
                                                              future: FirebaseFirestore.instance
                                                                  .collection(
                                                                      'education_year_change')
                                                                  .where('user_ref',
                                                                      isEqualTo: FirebaseFirestore
                                                                          .instance
                                                                          .collection('users')
                                                                          .doc(widget
                                                                              .userDetails!.uid))
                                                                  .where('is_deleted',
                                                                      isEqualTo: false)
                                                                  .orderBy('created_at',
                                                                      descending: true)
                                                                  .get(),
                                                              builder: (context, snapshot) {
                                                                if (snapshot.hasError) {
                                                                  return const Text('Hata oluştu');
                                                                }

                                                                if (snapshot.connectionState ==
                                                                    ConnectionState.waiting) {
                                                                  return const CircularProgressIndicator();
                                                                }

                                                                if (snapshot.hasData) {
                                                                  List<EducationInformationModel>
                                                                      workingLife = snapshot
                                                                          .data!.docs
                                                                          .map((DocumentSnapshot
                                                                              document) {
                                                                    final Map<String, dynamic>
                                                                        data = document.data()!
                                                                            as Map<String, dynamic>;

                                                                    return EducationInformationModel
                                                                        .fromJson(data);
                                                                  }).toList();

                                                                  return workingLife.isEmpty
                                                                      ? Center(
                                                                          child:
                                                                              EmptyStateSimpleWidget(
                                                                            icon: Icon(
                                                                              Icons.work,
                                                                              color: FlutterFlowTheme
                                                                                      .of(context)
                                                                                  .primary,
                                                                              size: 72.0,
                                                                            ),
                                                                            title:
                                                                                'Değişim Yılı Eğitim Bilgileri Bulunmuyor',
                                                                            body:
                                                                                'Kullanıcının Henüz Değişim Yılı Eğitim Bilgileri bulunmuyor.',
                                                                          ),
                                                                        )
                                                                      : ListView.builder(
                                                                          shrinkWrap: true,
                                                                          physics:
                                                                              NeverScrollableScrollPhysics(),
                                                                          itemCount:
                                                                              workingLife.length,
                                                                          itemBuilder:
                                                                              (context, index) {
                                                                            final model =
                                                                                workingLife[index];
                                                                            return Card(
                                                                              color: FlutterFlowTheme
                                                                                      .of(context)
                                                                                  .secondaryBackground,
                                                                              margin:
                                                                                  EdgeInsets.only(
                                                                                      bottom: 16),
                                                                              child: SizedBox(
                                                                                width:
                                                                                    dynamicViewExtensions
                                                                                        .maxWidth(
                                                                                            context),
                                                                                child: Container(
                                                                                  padding:
                                                                                      EdgeInsets
                                                                                          .all(16),
                                                                                  decoration:
                                                                                      BoxDecoration(
                                                                                          color: FlutterFlowTheme.of(
                                                                                                  context)
                                                                                              .secondaryBackground,
                                                                                          border:
                                                                                              Border
                                                                                                  .all(
                                                                                            color: Colors
                                                                                                .white,
                                                                                            width:
                                                                                                0.5,
                                                                                          ),
                                                                                          borderRadius:
                                                                                              BorderRadius.all(
                                                                                                  Radius.circular(16))),
                                                                                  child: Row(
                                                                                    children: <Widget>[
                                                                                      Icon(
                                                                                        Icons
                                                                                            .school_outlined,
                                                                                        size: 21,
                                                                                      ),
                                                                                      Expanded(
                                                                                        child:
                                                                                            Padding(
                                                                                          padding: EdgeInsets.symmetric(
                                                                                              horizontal:
                                                                                                  16),
                                                                                          child:
                                                                                              Column(
                                                                                            children: <Widget>[
                                                                                              // school name
                                                                                              SizedBox(
                                                                                                width:
                                                                                                    dynamicViewExtensions.maxWidth(context),
                                                                                                child:
                                                                                                    Padding(
                                                                                                  padding: EdgeInsets.only(bottom: 10),
                                                                                                  child: Text(
                                                                                                    model.school_name ?? 'Okul bilgisi yok',
                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                                                                                  ),
                                                                                                ),
                                                                                              ),

                                                                                              // state and class

                                                                                              SizedBox(
                                                                                                width:
                                                                                                    dynamicViewExtensions.maxWidth(context),
                                                                                                child:
                                                                                                    Padding(
                                                                                                  padding: EdgeInsets.only(bottom: 10),
                                                                                                  child: Text(
                                                                                                    '${model.state_name ?? 'Şehir bilgisi yok'} / ${model.class_name ?? 'Sınıf bilgisi yok'}',
                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                                                                                  ),
                                                                                                ),
                                                                                              ),

                                                                                              // country with flag
                                                                                              if (model.country_name != null ||
                                                                                                  model.country_code != null)
                                                                                                SizedBox(
                                                                                                  width: dynamicViewExtensions.maxWidth(context),
                                                                                                  child: Padding(
                                                                                                    padding: EdgeInsets.only(bottom: 10),
                                                                                                    child: Row(
                                                                                                      children: [
                                                                                                        if (model.country_code != null)
                                                                                                          Padding(
                                                                                                            padding: EdgeInsets.only(right: 8),
                                                                                                            child: Text(
                                                                                                              _getCountryFlag(model.country_code!),
                                                                                                              style: TextStyle(fontSize: 20),
                                                                                                            ),
                                                                                                          ),
                                                                                                        Text(
                                                                                                          model.country_name ?? 'Ülke bilgisi yok',
                                                                                                          style: FlutterFlowTheme.of(context).bodyMedium,
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              // change year date
                                                                                              SizedBox(
                                                                                                width:
                                                                                                    dynamicViewExtensions.maxWidth(context),
                                                                                                child:
                                                                                                    Padding(
                                                                                                  padding: EdgeInsets.only(bottom: 10),
                                                                                                  child: Text(
                                                                                                    "${model.date_start} - ${model.date_end}",
                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      // Icon(
                                                                                      //   Icons.arrow_forward_ios,
                                                                                      //   size: 21,
                                                                                      // ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        );
                                                                }

                                                                return const CircularProgressIndicator();
                                                              },
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: BaseUtility.all(
                                                              BaseUtility.paddingNormalValue,
                                                            ),
                                                            child: FutureBuilder<QuerySnapshot>(
                                                              future: FirebaseFirestore.instance
                                                                  .collection(
                                                                      'education_information')
                                                                  .where('user_ref',
                                                                      isEqualTo: FirebaseFirestore
                                                                          .instance
                                                                          .collection('users')
                                                                          .doc(widget
                                                                              .userDetails!.uid))
                                                                  .where('is_deleted',
                                                                      isEqualTo: false)
                                                                  .orderBy('created_at',
                                                                      descending: true)
                                                                  .get(),
                                                              builder: (context, snapshot) {
                                                                if (snapshot.hasError) {
                                                                  return const Text('Hata oluştu');
                                                                }

                                                                if (snapshot.connectionState ==
                                                                    ConnectionState.waiting) {
                                                                  return const CircularProgressIndicator();
                                                                }

                                                                if (snapshot.hasData) {
                                                                  List<TurkeyEducationInformationModel>
                                                                      workingLife = snapshot
                                                                          .data!.docs
                                                                          .map((DocumentSnapshot
                                                                              document) {
                                                                    final Map<String, dynamic>
                                                                        data = document.data()!
                                                                            as Map<String, dynamic>;

                                                                    return TurkeyEducationInformationModel
                                                                        .fromJson(data);
                                                                  }).toList();

                                                                  return workingLife.isEmpty
                                                                      ? Center(
                                                                          child:
                                                                              EmptyStateSimpleWidget(
                                                                            icon: Icon(
                                                                              Icons.work,
                                                                              color: FlutterFlowTheme
                                                                                      .of(context)
                                                                                  .primary,
                                                                              size: 72.0,
                                                                            ),
                                                                            title:
                                                                                'Türkiyedeki Eğitim Bilgileri Bulunmuyor',
                                                                            body:
                                                                                'Kullanıcının Henüz Türkiyedeki Eğitim Bilgileri bulunmuyor.',
                                                                          ),
                                                                        )
                                                                      : ListView.builder(
                                                                          shrinkWrap: true,
                                                                          physics:
                                                                              NeverScrollableScrollPhysics(),
                                                                          itemCount:
                                                                              workingLife.length,
                                                                          itemBuilder:
                                                                              (context, index) {
                                                                            final model =
                                                                                workingLife[index];
                                                                            return Card(
                                                                              color: FlutterFlowTheme
                                                                                      .of(context)
                                                                                  .secondaryBackground,
                                                                              margin:
                                                                                  EdgeInsets.only(
                                                                                      bottom: 16),
                                                                              child: SizedBox(
                                                                                width:
                                                                                    dynamicViewExtensions
                                                                                        .maxWidth(
                                                                                            context),
                                                                                child: Container(
                                                                                  padding:
                                                                                      EdgeInsets
                                                                                          .all(16),
                                                                                  decoration:
                                                                                      BoxDecoration(
                                                                                          color: FlutterFlowTheme.of(
                                                                                                  context)
                                                                                              .secondaryBackground,
                                                                                          border:
                                                                                              Border
                                                                                                  .all(
                                                                                            color: Colors
                                                                                                .white,
                                                                                            width:
                                                                                                0.5,
                                                                                          ),
                                                                                          borderRadius:
                                                                                              BorderRadius.all(
                                                                                                  Radius.circular(16))),
                                                                                  child: Row(
                                                                                    children: <Widget>[
                                                                                      Icon(
                                                                                        Icons
                                                                                            .school_outlined,
                                                                                        size: 21,
                                                                                      ),
                                                                                      Expanded(
                                                                                        child:
                                                                                            Padding(
                                                                                          padding: EdgeInsets.symmetric(
                                                                                              horizontal:
                                                                                                  16),
                                                                                          child:
                                                                                              Column(
                                                                                            children: <Widget>[
                                                                                              // school name
                                                                                              SizedBox(
                                                                                                width:
                                                                                                    dynamicViewExtensions.maxWidth(context),
                                                                                                child:
                                                                                                    Padding(
                                                                                                  padding: EdgeInsets.only(bottom: 10),
                                                                                                  child: Text(
                                                                                                    model.school_name ?? 'Okul bilgisi yok',
                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              // chapter
                                                                                              SizedBox(
                                                                                                width:
                                                                                                    dynamicViewExtensions.maxWidth(context),
                                                                                                child:
                                                                                                    Padding(
                                                                                                  padding: EdgeInsets.only(bottom: 10),
                                                                                                  child: Text(
                                                                                                    "${(model.chapter?.isEmpty ?? true) ? 'Bölüm Bilgisi Bulunmuyor' : model.chapter}",
                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              // education type
                                                                                              SizedBox(
                                                                                                width:
                                                                                                    dynamicViewExtensions.maxWidth(context),
                                                                                                child:
                                                                                                    Padding(
                                                                                                  padding: EdgeInsets.only(bottom: 10),
                                                                                                  child: Text(
                                                                                                    "${model.is_education_type == true ? 'Üniversite' : 'Lise'}",
                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              // change year date
                                                                                              SizedBox(
                                                                                                width:
                                                                                                    dynamicViewExtensions.maxWidth(context),
                                                                                                child:
                                                                                                    Padding(
                                                                                                  padding: EdgeInsets.only(bottom: 10),
                                                                                                  child: Text(
                                                                                                    "${model.date_entry} - ${model.is_continues == false ? model.date_graduation : 'Devam Ediyor'}",
                                                                                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      // Icon(
                                                                                      //   Icons.arrow_forward_ios,
                                                                                      //   size: 21,
                                                                                      // ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        );
                                                                }

                                                                return const CircularProgressIndicator();
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            text: 'Eğitim Bilgileri',
                                            options: FFButtonOptions(
                                              width: double.infinity,
                                              height: 40.0,
                                              padding: EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                              color: FlutterFlowTheme.of(context).primary,
                                              textStyle:
                                                  FlutterFlowTheme.of(context).titleSmall.override(
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
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
                                      labelStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                                            fontFamily: 'Figtree',
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                      unselectedLabelStyle:
                                          FlutterFlowTheme.of(context).labelLarge.override(
                                                fontFamily: 'Figtree',
                                                letterSpacing: 0.0,
                                              ),
                                      indicatorColor: FlutterFlowTheme.of(context).primary,
                                      indicatorWeight: 2.0,
                                      tabs: [
                                        Tab(
                                          text: 'Gönderiler',
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
                                        // posts
                                        buildPostsWidget(viewProfilePageOtherUsersRecord),
                                        // friends
                                        buildFriendsListWidget,
                                        // activity
                                        buildActivityWidget(viewProfilePageOtherUsersRecord),
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
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // posts
  Widget buildPostsWidget(UsersRecord viewProfilePageOtherUsersRecord) =>
      StreamBuilder<List<UserPostsRecord>>(
        stream: queryUserPostsRecord(
          queryBuilder: (userPostsRecord) => userPostsRecord
              .where(
                'postUser',
                isEqualTo: viewProfilePageOtherUsersRecord.reference,
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
                body: 'Kullanıcının Henüz yeni bir gönderisi bulunmuyor.',
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            itemCount: socialFeedUserPostsRecordList.length,
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
                                        color: FlutterFlowTheme.of(context).accent2,
                                        borderRadius: BorderRadius.circular(120.0),
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context).secondary,
                                          width: 2.0,
                                        ),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(2.0),
                                        decoration: BoxDecoration(
                                          color: userPostUsersRecord.photoUrl.isEmpty
                                              ? Colors.white
                                              : null,
                                          borderRadius: BorderRadius.circular(
                                              userPostUsersRecord.photoUrl.isEmpty ? 120.0 : 0),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(120.0),
                                          child: Image.network(
                                            userPostUsersRecord.photoUrl.isEmpty
                                                ? 'https://firebasestorage.googleapis.com/v0/b/liseli-buyukelciler-db.firebasestorage.app/o/app_ico%2Ficons8-account-96.png?alt=media&token=4104ae4d-7566-449c-81d8-ebbb1fac88e6'
                                                : userPostUsersRecord.photoUrl,
                                            width: 300.0,
                                            height: 200.0,
                                            fit: BoxFit.cover,
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
                                                style:
                                                    FlutterFlowTheme.of(context).bodyLarge.override(
                                                          fontFamily: 'Figtree',
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                            ),
                                            userPostUsersRecord.hasAnyBadges
                                                ? MultipleBadgesDisplayWidget(
                                                    badgeIds: userPostUsersRecord.badges,
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                        socialFeedUserPostsRecord.postPhoto.isEmpty
                                            ? const SizedBox()
                                            : FlutterFlowIconButton(
                                                borderColor: Colors.transparent,
                                                borderRadius: 30.0,
                                                buttonSize: 46.0,
                                                icon: Icon(
                                                  Icons.keyboard_control,
                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                  size: 25.0,
                                                ),
                                                onPressed: () {
                                                  CodeNoahDialogs(context).showModalNewBottom(
                                                    dynamicViewExtensions,
                                                    'GÖNDERİ AYARLARI',
                                                    dynamicViewExtensions.dynamicHeight(
                                                        context, 0.2),
                                                    [
                                                      GestureDetector(
                                                        onTap: () async {
                                                          if (socialFeedUserPostsRecord.postPhoto
                                                              .contains(".mp4")) {
                                                            print("MP4 geçiyor");
                                                            FileDownloadService(context)
                                                                .saveNetworkVideoFile(
                                                                    socialFeedUserPostsRecord
                                                                        .postPhoto);
                                                          } else if (socialFeedUserPostsRecord
                                                                  .postPhoto
                                                                  .contains(".jpg") ||
                                                              socialFeedUserPostsRecord.postPhoto
                                                                  .contains(".png")) {
                                                            print("JPG VE PNG destekliyor");
                                                            FileDownloadService(context)
                                                                .saveNetworkImage(
                                                                    socialFeedUserPostsRecord
                                                                        .postPhoto);
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
                                                                    style:
                                                                        FlutterFlowTheme.of(context)
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
                                  )
                                : const SizedBox(),
                            socialFeedUserPostsRecord.postPhoto.isNotEmpty
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
                                              style:
                                                  FlutterFlowTheme.of(context).bodyMedium.override(
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
                                                final likesElement = userPostUsersRecord.reference;
                                                final likesUpdate = socialFeedUserPostsRecord.likes
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
                                                  .contains(userPostUsersRecord.reference),
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
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              socialFeedUserPostsRecord.numComments.toString(),
                                              style: FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .override(
                                                    fontFamily: 'Figtree',
                                                    color:
                                                        FlutterFlowTheme.of(context).secondaryText,
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
                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 8.0, 0.0),
                                        child: Text(
                                          dateTimeFormat(
                                              "relative", socialFeedUserPostsRecord.timePosted!),
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Figtree',
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
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
                            socialFeedUserPostsRecord.postPhoto.isEmpty
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
                                              style:
                                                  FlutterFlowTheme.of(context).bodyMedium.override(
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
      );

  // friends
  Widget get buildFriendsListWidget => Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
        ),
        child: StreamBuilder<List<FriendsRecord>>(
          stream: queryFriendsRecord(
            queryBuilder: (friendsRecord) => friendsRecord.where(
              'followee',
              isEqualTo: widget.userDetails?.reference,
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
                  body: 'Bu kullanıcının hiç arkadaşı yok gibi görünüyor.',
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
                      'Keyet5_${listViewFriendsRecord.reference.id}',
                    ),
                    userRef: listViewFriendsRecord.follower!,
                  ),
                );
              },
            );
          },
        ),
      );

  // acitivity
  Widget buildActivityWidget(UsersRecord viewProfilePageOtherUsersRecord) =>
      StreamBuilder<List<UserPostsRecord>>(
        stream: queryUserPostsRecord(
          queryBuilder: (userPostsRecord) => userPostsRecord
              .where(
                'postUser',
                isEqualTo: viewProfilePageOtherUsersRecord.reference,
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
                body: 'Kullanıcının Henüz yeni bir aktivitesi bulunmuyor.',
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            itemCount: socialFeedUserPostsRecordList.length,
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
                                        borderRadius: BorderRadius.circular(120.0),
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context).secondary,
                                          width: 2.0,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(2.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(120.0),
                                          child: Image.network(
                                            userPostUsersRecord.photoUrl.isEmpty
                                                ? 'https://firebasestorage.googleapis.com/v0/b/liseli-buyukelciler-db.firebasestorage.app/o/app_ico%2Ficons8-account-96.png?alt=media&token=4104ae4d-7566-449c-81d8-ebbb1fac88e6'
                                                : userPostUsersRecord.photoUrl,
                                            width: 300.0,
                                            height: 200.0,
                                            fit: BoxFit.cover,
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
                                                style:
                                                    FlutterFlowTheme.of(context).bodyLarge.override(
                                                          fontFamily: 'Figtree',
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                            ),
                                            userPostUsersRecord.hasAnyBadges
                                                ? MultipleBadgesDisplayWidget(
                                                    badgeIds: userPostUsersRecord.badges,
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                        socialFeedUserPostsRecord.postPhoto.isEmpty
                                            ? const SizedBox()
                                            : FlutterFlowIconButton(
                                                borderColor: Colors.transparent,
                                                borderRadius: 30.0,
                                                buttonSize: 46.0,
                                                icon: Icon(
                                                  Icons.keyboard_control,
                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                  size: 25.0,
                                                ),
                                                onPressed: () {
                                                  CodeNoahDialogs(context).showModalNewBottom(
                                                    dynamicViewExtensions,
                                                    'GÖNDERİ AYARLARI',
                                                    dynamicViewExtensions.dynamicHeight(
                                                        context, 0.2),
                                                    [
                                                      GestureDetector(
                                                        onTap: () async {
                                                          if (socialFeedUserPostsRecord.postPhoto
                                                              .contains(".mp4")) {
                                                            print("MP4 geçiyor");
                                                            FileDownloadService(context)
                                                                .saveNetworkVideoFile(
                                                                    socialFeedUserPostsRecord
                                                                        .postPhoto);
                                                          } else if (socialFeedUserPostsRecord
                                                                  .postPhoto
                                                                  .contains(".jpg") ||
                                                              socialFeedUserPostsRecord.postPhoto
                                                                  .contains(".png")) {
                                                            print("JPG VE PNG destekliyor");
                                                            FileDownloadService(context)
                                                                .saveNetworkImage(
                                                                    socialFeedUserPostsRecord
                                                                        .postPhoto);
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
                                                                    style:
                                                                        FlutterFlowTheme.of(context)
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
                                  )
                                : const SizedBox(),
                            socialFeedUserPostsRecord.postPhoto.isNotEmpty
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
                                              style:
                                                  FlutterFlowTheme.of(context).bodyMedium.override(
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
                                                final likesElement = userPostUsersRecord.reference;
                                                final likesUpdate = socialFeedUserPostsRecord.likes
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
                                                  .contains(userPostUsersRecord.reference),
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
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              socialFeedUserPostsRecord.numComments.toString(),
                                              style: FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .override(
                                                    fontFamily: 'Figtree',
                                                    color:
                                                        FlutterFlowTheme.of(context).secondaryText,
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
                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 8.0, 0.0),
                                        child: Text(
                                          dateTimeFormat(
                                              "relative", socialFeedUserPostsRecord.timePosted!),
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Figtree',
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
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
                            socialFeedUserPostsRecord.postPhoto.isEmpty
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
                                              style:
                                                  FlutterFlowTheme.of(context).bodyMedium.override(
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
      );
}
