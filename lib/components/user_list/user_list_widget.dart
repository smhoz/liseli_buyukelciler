import 'package:sosyal_medya/backend/schema/badge_model/badge_model.dart';
import 'package:sosyal_medya/components/multiple_badges_display/multiple_badges_display_widget.dart';
import 'package:sosyal_medya/components/verified/verified_widget.dart';
import 'package:sosyal_medya/extension/dynamic_extensions.dart';
import 'package:sosyal_medya/helper/show_dialogs.dart';
import 'package:sosyal_medya/pages/view_profile_page_other/view_profile_page_other_widget.dart';

import '/backend/backend.dart';
import '/backend/schema/users_record_extensions.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'user_list_model.dart';
export 'user_list_model.dart';

class UserListWidget extends StatefulWidget {
  const UserListWidget({
    super.key,
    required this.userRef,
  });

  final DocumentReference? userRef;

  @override
  State<UserListWidget> createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<UserListWidget> {
  late UserListModel _model;

  DynamicViewExtensions dynamicViewExtensions = DynamicViewExtensions();

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UserListModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 1.0),
      child: FutureBuilder<UsersRecord>(
        future: UsersRecord.getDocumentOnce(widget.userRef!),
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

          final containerUsersRecord = snapshot.data!;

          return GestureDetector(
            onTap: () {
              context.pushNamed(
                ViewProfilePageOtherWidget.routeName,
                queryParameters: {
                  'userDetails': serializeParam(
                    containerUsersRecord,
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
                  'userDetails': containerUsersRecord,
                },
              );
            },
            child: Container(
              width: double.infinity,
              height: 60.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 44.0,
                      height: 44.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(120.0),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).primary,
                          width: 2.0,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(120.0),
                          child: CachedNetworkImage(
                            fadeInDuration: Duration(milliseconds: 300),
                            fadeOutDuration: Duration(milliseconds: 300),
                            imageUrl: valueOrDefault<String>(
                              containerUsersRecord.photoUrl,
                              'https://firebasestorage.googleapis.com/v0/b/liseli-buyukelciler-db.firebasestorage.app/o/app_ico%2Ficons8-account-96.png?alt=media&token=4104ae4d-7566-449c-81d8-ebbb1fac88e6',
                            ),
                            width: 40.0,
                            height: 40.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: <Widget>[
                                Text(
                                  valueOrDefault<String>(
                                    containerUsersRecord.displayName,
                                    'Hayalet Kullanıcı',
                                  ),
                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                        fontFamily: 'Figtree',
                                        letterSpacing: 0.0,
                                      ),
                                ),
                                containerUsersRecord.hasAnyBadges
                                    ? MultipleBadgesDisplayWidget(
                                        badgeIds: containerUsersRecord.badges,
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                              child: Text(
                                valueOrDefault<String>(
                                  containerUsersRecord.email,
                                  '--',
                                ),
                                style: FlutterFlowTheme.of(context).labelMedium.override(
                                      fontFamily: 'Figtree',
                                      color: FlutterFlowTheme.of(context).primary,
                                      letterSpacing: 0.0,
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
          );
        },
      ),
    );
  }
}
