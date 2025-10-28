import 'package:sosyal_medya/extension/dynamic_extensions.dart';
import 'package:sosyal_medya/helper/file_download.dart';
import 'package:sosyal_medya/helper/show_dialogs.dart';
import 'package:sosyal_medya/util/base_utility.dart';

import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'delete_post_model.dart';
export 'delete_post_model.dart';

class DeletePostWidget extends StatefulWidget {
  const DeletePostWidget({
    super.key,
    this.postParameters,
  });

  final UserPostsRecord? postParameters;

  @override
  State<DeletePostWidget> createState() => _DeletePostWidgetState();
}

class _DeletePostWidgetState extends State<DeletePostWidget> {
  late DeletePostModel _model;

  DynamicViewExtensions dynamicViewExtensions = DynamicViewExtensions();
  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DeletePostModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 1.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxWidth: 570.0,
              ),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4.0,
                    color: Color(0x33000000),
                    offset: Offset(
                      0.0,
                      3.0,
                    ),
                  )
                ],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                      child: Container(
                        width: 60.0,
                        height: 4.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).alternate,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ),
                    FFButtonWidget(
                      onPressed: () async {
                        await widget.postParameters!.reference.delete();

                        context.pushNamed(
                          MainFeedWidget.routeName,
                          extra: <String, dynamic>{
                            kTransitionInfoKey: TransitionInfo(
                              hasTransition: true,
                              transitionType: PageTransitionType.leftToRight,
                              duration: Duration(milliseconds: 220),
                            ),
                          },
                        );
                      },
                      text: 'Gönderiyi Sil',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 60.0,
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: Color(0xFFFF5963),
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
                    widget.postParameters!.postPhoto.isEmpty
                        ? const SizedBox()
                        : Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 16.0, 0.0, 0.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                CodeNoahDialogs(context).showModalNewBottom(
                                  dynamicViewExtensions,
                                  'GÖNDERİ AYARLARI',
                                  dynamicViewExtensions.dynamicHeight(
                                      context, 0.2),
                                  [
                                    GestureDetector(
                                      onTap: () async {
                                        if (widget.postParameters!.postPhoto
                                            .contains(".mp4")) {
                                          print("MP4 geçiyor");
                                          FileDownloadService(context)
                                              .saveNetworkVideoFile(widget
                                                  .postParameters!.postPhoto);
                                        } else if (widget
                                                .postParameters!.postPhoto
                                                .contains(".jpg") ||
                                            widget.postParameters!.postPhoto
                                                .contains(".png")) {
                                          print("JPG VE PNG destekliyor");
                                          FileDownloadService(context)
                                              .saveNetworkImage(widget
                                                  .postParameters!.postPhoto);
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
                                                  BaseUtility
                                                      .paddingNormalValue,
                                                ),
                                                child: Text(
                                                  'Gönderiyi İndir',
                                                  style: FlutterFlowTheme.of(
                                                          context)
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
                              text: 'Gönderiyi Ayarları',
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 60.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
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
                    // Padding(
                    //   padding:
                    //       EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                    //   child: FFButtonWidget(
                    //     onPressed: () async {
                    //       context.pop();
                    //     },
                    //     text: 'İptal',
                    //     options: FFButtonOptions(
                    //       width: double.infinity,
                    //       height: 60.0,
                    //       padding: EdgeInsetsDirectional.fromSTEB(
                    //           0.0, 0.0, 0.0, 0.0),
                    //       iconPadding: EdgeInsetsDirectional.fromSTEB(
                    //           0.0, 0.0, 0.0, 0.0),
                    //       color:
                    //           FlutterFlowTheme.of(context).secondaryBackground,
                    //       textStyle:
                    //           FlutterFlowTheme.of(context).bodyLarge.override(
                    //                 fontFamily: 'Figtree',
                    //                 letterSpacing: 0.0,
                    //               ),
                    //       elevation: 0.0,
                    //       borderSide: BorderSide(
                    //         color: FlutterFlowTheme.of(context).alternate,
                    //         width: 2.0,
                    //       ),
                    //       borderRadius: BorderRadius.circular(12.0),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
