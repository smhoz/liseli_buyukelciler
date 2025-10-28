import '/backend/backend.dart';
import '/components/assign_badge_bottom_sheet/assign_badge_bottom_sheet_widget.dart';
import '/components/multiple_badges_display/multiple_badges_display_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'admin_user_list_item_model.dart';
export 'admin_user_list_item_model.dart';

class AdminUserListItemWidget extends StatefulWidget {
  const AdminUserListItemWidget({
    super.key,
    this.userRef,
    this.userRecord,
  });

  final DocumentReference? userRef;
  final UsersRecord? userRecord;

  @override
  State<AdminUserListItemWidget> createState() => _AdminUserListItemWidgetState();
}

class _AdminUserListItemWidgetState extends State<AdminUserListItemWidget> {
  late AdminUserListItemModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminUserListItemModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use provided userRecord or fetch if not provided (backward compatibility)
    if (widget.userRecord != null) {
      final containerUsersRecord = widget.userRecord!;

      return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 1.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Profile Photo
                Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).accent1,
                    shape: BoxShape.circle,
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
                SizedBox(width: 12.0),
                // User Info
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                            child: Text(
                              containerUsersRecord.displayName,
                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                    fontFamily: 'Figtree',
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          if (containerUsersRecord.badges.isNotEmpty)
                            MultipleBadgesDisplayWidget(
                              badgeIds: containerUsersRecord.badges,
                            ),
                        ],
                      ),
                      Text(
                        '@${containerUsersRecord.userName}',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Figtree',
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ],
                  ),
                ),
                // Badge Assign Button - Modern Design
                GestureDetector(
                  onTap: () async {
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      enableDrag: false,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: MediaQuery.viewInsetsOf(context),
                          child: AssignBadgeBottomSheetWidget(
                            userId: containerUsersRecord.reference.id,
                            userName: containerUsersRecord.displayName,
                            currentBadgeIds: containerUsersRecord.badges,
                          ),
                        );
                      },
                    ).then((value) {
                      if (value == true) {
                        // Refresh the list
                        safeSetState(() {});
                      }
                    });
                  },
                  child: Container(
                    width: 44.0,
                    height: 44.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          FlutterFlowTheme.of(context).primary,
                          FlutterFlowTheme.of(context).secondary,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Icon(
                      Icons.workspace_premium_rounded,
                      color: Colors.white,
                      size: 24.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // Fallback: fetch user if userRecord not provided (backward compatibility)
      return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 1.0),
        child: FutureBuilder<UsersRecord>(
          future: UsersRecord.getDocumentOnce(widget.userRef!),
          builder: (context, snapshot) {
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

            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
                child: Text('User data not available'),
              ),
            );
          },
        ),
      );
    }
  }
}
