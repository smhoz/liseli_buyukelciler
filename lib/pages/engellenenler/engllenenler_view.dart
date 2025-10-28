import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sosyal_medya/backend/schema/users_record.dart';
import 'package:sosyal_medya/extension/dynamic_extensions.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_icon_button.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_theme.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_util.dart';

class EngllenenlerView extends StatefulWidget {
  const EngllenenlerView({super.key});

  @override
  State<EngllenenlerView> createState() => _EngllenenlerViewState();
}

class _EngllenenlerViewState extends State<EngllenenlerView> {
  DynamicViewExtensions dynamicViewExtensions = DynamicViewExtensions();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UsersRecord>(
        future: UsersRecord.getDocumentOnce(FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)),
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

          final viewUserModel = snapshot.data!;

          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            appBar: responsiveVisibility(
              context: context,
              tabletLandscape: false,
              desktop: false,
            )
                ? AppBar(
                    backgroundColor:
                        FlutterFlowTheme.of(context).secondaryBackground,
                    automaticallyImplyLeading: false,
                    title: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Engellenenler',
                        style: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .override(
                              fontFamily: 'Outfit',
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
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
                    actions: [],
                    centerTitle: false,
                    elevation: 0.0,
                  )
                : null,
            body: viewUserModel.engellenen.isNotEmpty
                ? ListView.builder(
                    itemCount: viewUserModel.engellenen.length,
                    itemBuilder: (context, index) {
                      final blockedUserId = viewUserModel.engellenen[index];
                      return FutureBuilder<UsersRecord>(
                        future: UsersRecord.getDocumentOnce(FirebaseFirestore
                            .instance
                            .collection('users')
                            .doc(blockedUserId)),
                        builder: (context, snapshot) {
                          // Customize what your widget looks like when it's loading.
                          if (!snapshot.hasData) {
                            return Scaffold(
                              backgroundColor: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
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

                          final userModel = snapshot.data!;
                          return ListTile(
                            leading: Icon(
                              Icons.account_circle_outlined,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 22,
                            ),
                            title: Text(
                              userModel.displayName,
                            ),
                            subtitle: Text(userModel.userName),
                            trailing: IconButton(
                              icon: Icon(Icons.close, color: Colors.red),
                              onPressed: () async {
                                final currentUserId =
                                    FirebaseAuth.instance.currentUser!.uid;
                                final blockedUserId =
                                    viewUserModel.engellenen[index].toString();

                                final currentUserDoc = FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .doc(currentUserId);
                                final blockedUserDoc = FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .doc(blockedUserId);

                                // Kendi aengellenen listesinden kaldır
                                await currentUserDoc.update({
                                  'engellenen':
                                      FieldValue.arrayRemove([blockedUserId])
                                });

                                // Karşı kişinin engelleyen listesinden kendini kaldır
                                await blockedUserDoc.update({
                                  'engelleyen':
                                      FieldValue.arrayRemove([currentUserId])
                                });

                                setState(() {});

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Engelleme kaldırıldı')),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  )
                : Center(
                    child: Text("Engellediğin kullanıcı yok"),
                  ),
          );
        });
  }
}
