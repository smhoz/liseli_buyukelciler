import 'package:firebase_auth/firebase_auth.dart';
import 'package:sosyal_medya/backend/schema/badge_model/badge_model.dart';
import 'package:sosyal_medya/components/multiple_badges_display/multiple_badges_display_widget.dart';
import 'package:sosyal_medya/components/verified/verified_widget.dart';
import 'package:sosyal_medya/extension/dynamic_extensions.dart';
import 'package:sosyal_medya/helper/show_dialogs.dart';
import 'package:sosyal_medya/helper/image_error_helper.dart';

import '/backend/schema/users_record_extensions.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/updated_chat/empty_state_simple/empty_state_simple_widget.dart';
import '/flutter_flow/random_data_util.dart' as random_data;
import '/index.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'chat2_invite_users_model.dart';
export 'chat2_invite_users_model.dart';

class Chat2InviteUsersWidget extends StatefulWidget {
  const Chat2InviteUsersWidget({
    super.key,
    this.chatRef,
  });

  final ChatsRecord? chatRef;

  static String routeName = 'chat_2_InviteUsers';
  static String routePath = '/chat2InviteUsers';

  @override
  State<Chat2InviteUsersWidget> createState() => _Chat2InviteUsersWidgetState();
}

class _Chat2InviteUsersWidgetState extends State<Chat2InviteUsersWidget> {
  late Chat2InviteUsersModel _model;

  DynamicViewExtensions dynamicViewExtensions = DynamicViewExtensions();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  late List<String> engellenen = [];
  late List<String> engelleyen = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Chat2InviteUsersModel());

    // Initialize text controller
    _model.textController ??= TextEditingController();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (widget.chatRef != null) {
        // addChatUsers_ToList
        _model.friendsList = widget.chatRef!.users.toList().cast<DocumentReference>();
        safeSetState(() {});
      } else {
        // addUser_ToList
        _model.addToFriendsList(currentUserReference!);
        safeSetState(() {});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));

    getBlockedUsers().then((value) {
      setState(() {
        engellenen = value;
      });
    });
    getBlockedUsers2().then((value) {
      setState(() {
        engelleyen = value;
      });
    });
  }

  Future<List<String>> getBlockedUsers() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      final data = userDoc.data();
      final engellenen = data?['engellenen'];

      if (engellenen is List) {
        return engellenen.map((e) => e.toString()).toList();
      }
    }

    return [];
  }

  Future<List<String>> getBlockedUsers2() async {
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
                title: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Arkadaşlarınızı Davet Edin',
                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                            fontFamily: 'Outfit',
                            letterSpacing: 0.0,
                          ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                      child: Text(
                        'Sohbet başlatmak için aşağıdan kullanıcıları seçin.',
                        style: FlutterFlowTheme.of(context).labelSmall.override(
                              fontFamily: 'Figtree',
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 12.0, 4.0),
                    child: FlutterFlowIconButton(
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
                        context.safePop();
                      },
                    ),
                  ),
                ],
                centerTitle: false,
                elevation: 0.0,
              )
            : null,
        body: Align(
          alignment: AlignmentDirectional(0.0, -1.0),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 670.0,
            ),
            decoration: BoxDecoration(),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (responsiveVisibility(
                      context: context,
                      phone: false,
                      tablet: false,
                    ))
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Arkadaşlarınızı Davet Edin',
                                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                                        fontFamily: 'Outfit',
                                        letterSpacing: 0.0,
                                      ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                  child: Text(
                                    'Sohbet başlatmak için aşağıdan kullanıcıları seçin.',
                                    style: FlutterFlowTheme.of(context).labelSmall.override(
                                          fontFamily: 'Figtree',
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 12.0, 4.0),
                              child: FlutterFlowIconButton(
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
                                  context.safePop();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 0.0, 0.0),
                              child: Text(
                                'Arkadaşlarınızı Davet Edin',
                                style: FlutterFlowTheme.of(context).labelMedium.override(
                                      fontFamily: 'Figtree',
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 0.0, 0.0),
                            child: Text(
                              ((valueOrDefault<int>(
                                        _model.friendsList.length,
                                        0,
                                      ) -
                                      1))
                                  .toString(),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Figtree',
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(2.0, 12.0, 0.0, 0.0),
                            child: Text(
                              'Seçildi',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Figtree',
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.0),
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _model.textController,
                        onChanged: (_) {
                          _model.onSearchChanged();
                        },
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'Arkadaşını Ara',
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
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Figtree',
                              letterSpacing: 0.0,
                            ),
                        maxLines: null,
                        validator: _model.textControllerValidator.asValidator(context),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                        child: PagedListView<DocumentSnapshot<Object?>?, UsersRecord>(
                          key: ValueKey('paged_list_${_model.textController?.text ?? 'all'}'),
                          pagingController: _model.setListViewController(
                            UsersRecord.collection.orderBy('display_name'),
                          ),
                          padding: EdgeInsets.fromLTRB(
                            0,
                            0,
                            0,
                            160.0,
                          ),
                          reverse: false,
                          scrollDirection: Axis.vertical,
                          builderDelegate: PagedChildBuilderDelegate<UsersRecord>(
                            // Customize what your widget looks like when it's loading the first page.
                            firstPageProgressIndicatorBuilder: (_) => Center(
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
                            // Customize what your widget looks like when it's loading another page.
                            newPageProgressIndicatorBuilder: (_) => Center(
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
                            noItemsFoundIndicatorBuilder: (_) => EmptyStateSimpleWidget(
                              icon: Icon(
                                Icons.groups_outlined,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 90.0,
                              ),
                              title: 'Arkadaş Yok',
                              body: 'Sohbet oluşturabileceğiniz kullanıcı yok.',
                            ),
                            itemBuilder: (context, _, listViewIndex) {
                              final itemList = _model.listViewPagingController?.itemList;
                              if (itemList == null || listViewIndex >= itemList.length) {
                                return SizedBox();
                              }
                              final listViewUsersRecord = itemList[listViewIndex];

                              final listUserID = listViewUsersRecord.uid;

                              if (engellenen.contains(listUserID)) {
                                return SizedBox();
                              }
                              if (engelleyen.contains(listUserID)) {
                                return SizedBox();
                              }

                              // Client-side case-insensitive search filtering
                              final searchTerm = _model.textController?.text ?? '';
                              if (searchTerm.isNotEmpty) {
                                final displayName = listViewUsersRecord.displayName.toLowerCase();
                                final userName = listViewUsersRecord.userName.toLowerCase();
                                final searchLower = searchTerm.toLowerCase();

                                if (!displayName.contains(searchLower) &&
                                    !userName.contains(searchLower)) {
                                  return SizedBox();
                                }
                              }

                              return Visibility(
                                visible: listViewUsersRecord.reference != currentUserReference,
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 8.0),
                                  child: Container(
                                    width: 100.0,
                                    height: 80.0,
                                    decoration: BoxDecoration(
                                      color:
                                          _model.friendsList.contains(listViewUsersRecord.reference)
                                              ? FlutterFlowTheme.of(context).accent1
                                              : FlutterFlowTheme.of(context).secondaryBackground,
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                        color: _model.friendsList
                                                .contains(listViewUsersRecord.reference)
                                            ? FlutterFlowTheme.of(context).primary
                                            : FlutterFlowTheme.of(context).alternate,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            final userRecord = await UsersRecord.getDocumentOnce(
                                                listViewUsersRecord.reference);

                                            context.pushNamed(
                                              ViewProfilePageOtherWidget.routeName,
                                              queryParameters: {
                                                'userDetails': serializeParam(
                                                  userRecord,
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
                                              },
                                            );
                                          },
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                                            child: Container(
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
                                                padding: EdgeInsets.all(2.0),
                                                decoration: BoxDecoration(
                                                  color: listViewUsersRecord.photoUrl.isEmpty
                                                      ? Colors.white
                                                      : null,
                                                  borderRadius: BorderRadius.circular(
                                                      listViewUsersRecord.photoUrl.isEmpty
                                                          ? 10.0
                                                          : 0),
                                                ),
                                                child: ImageErrorHelper.cachedProfileImage(
                                                  context: context,
                                                  imageUrl: listViewUsersRecord.photoUrl.isEmpty
                                                      ? 'https://firebasestorage.googleapis.com/v0/b/liseli-buyukelciler-db.firebasestorage.app/o/app_ico%2Ficons8-account-96.png?alt=media&token=4104ae4d-7566-449c-81d8-ebbb1fac88e6'
                                                      : listViewUsersRecord.photoUrl,
                                                  displayName: listViewUsersRecord.displayName,
                                                  width: 44.0,
                                                  height: 44.0,
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Material(
                                            color: Colors.transparent,
                                            child: Theme(
                                              data: ThemeData(
                                                unselectedWidgetColor:
                                                    FlutterFlowTheme.of(context).secondaryText,
                                              ),
                                              child: CheckboxListTile(
                                                value: _model.checkboxListTileValueMap[
                                                    listViewUsersRecord] ??= _model.friendsList
                                                        .contains(listViewUsersRecord.reference) ==
                                                    true,
                                                onChanged: (newValue) async {
                                                  setState(() {
                                                    _model.checkboxListTileValueMap[
                                                        listViewUsersRecord] = newValue!;
                                                    if (newValue) {
                                                      // addUser
                                                      _model.addToFriendsList(
                                                          listViewUsersRecord.reference);
                                                    } else {
                                                      // removeUsser
                                                      _model.removeFromFriendsList(
                                                          listViewUsersRecord.reference);
                                                    }
                                                  });
                                                },
                                                title: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      valueOrDefault<String>(
                                                        listViewUsersRecord.displayName,
                                                        'Hayalet Kullanıcı',
                                                      ),
                                                      style: FlutterFlowTheme.of(context)
                                                          .bodyLarge
                                                          .override(
                                                            fontFamily: 'Figtree',
                                                            letterSpacing: 0.0,
                                                            lineHeight: 2.0,
                                                          ),
                                                    ),
                                                    listViewUsersRecord.hasAnyBadges
                                                        ? MultipleBadgesDisplayWidget(
                                                            badgeIds: listViewUsersRecord.badges,
                                                          )
                                                        : const SizedBox(),
                                                  ],
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      valueOrDefault<String>(
                                                        listViewUsersRecord.email,
                                                        'casper@ghost.io',
                                                      ),
                                                      style: FlutterFlowTheme.of(context)
                                                          .labelSmall
                                                          .override(
                                                            fontFamily: 'Figtree',
                                                            color: FlutterFlowTheme.of(context)
                                                                .secondary,
                                                            letterSpacing: 0.0,
                                                          ),
                                                    ),
                                                    Text(
                                                      valueOrDefault<String>(
                                                        "@" + listViewUsersRecord.userName,
                                                        '@username',
                                                      ),
                                                      style: FlutterFlowTheme.of(context)
                                                          .labelSmall
                                                          .override(
                                                            fontFamily: 'Figtree',
                                                            color: FlutterFlowTheme.of(context)
                                                                .secondary,
                                                            letterSpacing: 0.0,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                tileColor: FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                                activeColor: FlutterFlowTheme.of(context).primary,
                                                checkColor: Colors.white,
                                                dense: false,
                                                controlAffinity: ListTileControlAffinity.trailing,
                                                contentPadding: EdgeInsetsDirectional.fromSTEB(
                                                    12.0, 0.0, 8.0, 39.0),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
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
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: AlignmentDirectional(0.0, 1.0),
                  child: Container(
                    width: double.infinity,
                    height: 140.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          FlutterFlowTheme.of(context).accent4,
                          FlutterFlowTheme.of(context).secondaryBackground
                        ],
                        stops: [0.0, 1.0],
                        begin: AlignmentDirectional(0.0, -1.0),
                        end: AlignmentDirectional(0, 1.0),
                      ),
                    ),
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          if (_model.friendsList.length >= 2) {
                            if (widget.chatRef != null) {
                              // updateChat

                              await widget.chatRef!.reference.update({
                                ...mapToFirestore(
                                  {
                                    'users': _model.friendsList,
                                  },
                                ),
                              });
                              // updateChat
                              _model.updatedChatThread = await queryChatsRecordOnce(
                                queryBuilder: (chatsRecord) => chatsRecord.where(
                                  'group_chat_id',
                                  isEqualTo: widget.chatRef?.groupChatId,
                                ),
                                singleRecord: true,
                              ).then((s) => s.firstOrNull);
                              if (Navigator.of(context).canPop()) {
                                context.pop();
                              }
                              context.pushNamed(
                                Chat2DetailsWidget.routeName,
                                queryParameters: {
                                  'chatRef': serializeParam(
                                    _model.updatedChatThread,
                                    ParamType.Document,
                                  ),
                                }.withoutNulls,
                                extra: <String, dynamic>{
                                  'chatRef': _model.updatedChatThread,
                                },
                              );
                            } else {
                              // newChat

                              var chatsRecordReference = ChatsRecord.collection.doc();
                              await chatsRecordReference.set({
                                ...createChatsRecordData(
                                  userA: currentUserReference,
                                  userB: _model.friendsList.elementAtOrNull(1),
                                  lastMessage: '',
                                  lastMessageTime: getCurrentTimestamp,
                                  lastMessageSentBy: currentUserReference,
                                  groupChatId: random_data.randomInteger(1000000, 9999999),
                                ),
                                ...mapToFirestore(
                                  {
                                    'users': _model.friendsList,
                                  },
                                ),
                              });
                              _model.newChatThread = ChatsRecord.getDocumentFromData({
                                ...createChatsRecordData(
                                  userA: currentUserReference,
                                  userB: _model.friendsList.elementAtOrNull(1),
                                  lastMessage: '',
                                  lastMessageTime: getCurrentTimestamp,
                                  lastMessageSentBy: currentUserReference,
                                  groupChatId: random_data.randomInteger(1000000, 9999999),
                                ),
                                ...mapToFirestore(
                                  {
                                    'users': _model.friendsList,
                                  },
                                ),
                              }, chatsRecordReference);
                              if (Navigator.of(context).canPop()) {
                                context.pop();
                              }
                              context.pushNamed(
                                Chat2DetailsWidget.routeName,
                                queryParameters: {
                                  'chatRef': serializeParam(
                                    _model.newChatThread,
                                    ParamType.Document,
                                  ),
                                }.withoutNulls,
                                extra: <String, dynamic>{
                                  'chatRef': _model.newChatThread,
                                },
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Sohbet başlatmak için en az bir başka kullanıcı seçmelisiniz.',
                                  style: FlutterFlowTheme.of(context).titleSmall.override(
                                        fontFamily: 'Figtree',
                                        color: FlutterFlowTheme.of(context).info,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                                duration: Duration(milliseconds: 3000),
                                backgroundColor: FlutterFlowTheme.of(context).primary,
                              ),
                            );
                          }

                          safeSetState(() {});
                        },
                        text: widget.chatRef != null ? 'Sohbete Ekle' : 'Davetiye Gönder',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 50.0,
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
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
                          borderRadius: BorderRadius.circular(50.0),
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
    );
  }
}


/**
                                       */