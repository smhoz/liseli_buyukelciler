import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import 'package:sosyal_medya/service/badge_service.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_media_display.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_video_player.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/helper/image_editor_helper.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'create_story_model.dart';
export 'create_story_model.dart';

class CreateStoryWidget extends StatefulWidget {
  const CreateStoryWidget({super.key});

  static String routeName = 'createStory';
  static String routePath = '/createStory';

  @override
  State<CreateStoryWidget> createState() => _CreateStoryWidgetState();
}

class _CreateStoryWidgetState extends State<CreateStoryWidget> {
  late CreateStoryModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreateStoryModel());

    _model.storyDescriptionTextController ??= TextEditingController();
    _model.storyDescriptionFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFF1A1F24),
      body: SafeArea(
        top: true,
        child: Align(
          alignment: AlignmentDirectional(0.0, -1.0),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 570.0,
            ),
            decoration: BoxDecoration(),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: MediaQuery.sizeOf(context).height * 0.8,
                    child: Stack(
                      children: [
                        if (!functions.hasUploadedMedia(_model.uploadedFileUrl3))
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              final selectedMedia = await selectMediaWithSourceBottomSheet(
                                context: context,
                                allowPhoto: true,
                                allowVideo: true,
                                backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                                textColor: FlutterFlowTheme.of(context).primaryText,
                                pickerFontFamily: 'Figtree',
                                compressImages: false, // Compress'i kapatıyoruz çünkü editörde işleyeceğiz
                                imageType: 'story',
                              );
                              if (selectedMedia != null && selectedMedia.every((m) => validateFileFormat(m.storagePath, context))) {
                                final selectedFile = FFUploadedFile(
                                  name: selectedMedia.first.storagePath.split('/').last,
                                  bytes: selectedMedia.first.bytes,
                                  height: selectedMedia.first.dimensions?.height,
                                  width: selectedMedia.first.dimensions?.width,
                                  blurHash: selectedMedia.first.blurHash,
                                );

                                // Resim ise Pro Image Editor ile editlemek için sor
                                if (selectedMedia.first.storagePath.contains('.jpg') ||
                                    selectedMedia.first.storagePath.contains('.jpeg') ||
                                    selectedMedia.first.storagePath.contains('.png') ||
                                    selectedMedia.first.storagePath.contains('.gif')) {
                                  await ImageEditorHelper.showEditDialog(
                                    context: context,
                                    selectedFile: selectedFile,
                                    onEditComplete: (editedFile) async {
                                      if (editedFile != null) {
                                        safeSetState(() => _model.isDataUploading1 = true);

                                        try {
                                          showUploadMessage(
                                            context,
                                            'Dosya yükleme...',
                                            showLoading: true,
                                          );

                                          // Editlenmiş dosyayı Firebase'e yükle
                                          final downloadUrl = await uploadData(selectedMedia.first.storagePath, editedFile.bytes!);

                                          if (downloadUrl != null) {
                                            safeSetState(() {
                                              _model.uploadedLocalFile1 = editedFile;
                                              _model.uploadedFileUrl1 = downloadUrl;
                                            });
                                            showUploadMessage(context, 'Başarılı!');
                                          } else {
                                            showUploadMessage(context, 'Yükleme hatası');
                                          }
                                        } finally {
                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                          _model.isDataUploading1 = false;
                                        }
                                      }
                                    },
                                  );
                                } else {
                                  // Video ise direkt yükle
                                  safeSetState(() => _model.isDataUploading1 = true);

                                  try {
                                    showUploadMessage(context, 'Dosya yükleme...', showLoading: true);

                                    final downloadUrl = await uploadData(selectedMedia.first.storagePath, selectedMedia.first.bytes);

                                    if (downloadUrl != null) {
                                      safeSetState(() {
                                        _model.uploadedLocalFile1 = selectedFile;
                                        _model.uploadedFileUrl1 = downloadUrl;
                                      });
                                      showUploadMessage(context, 'Başarılı!');
                                    } else {
                                      showUploadMessage(context, 'Yükleme hatası');
                                    }
                                  } finally {
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                    _model.isDataUploading1 = false;
                                  }
                                }
                              }
                            },
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 1.0,
                              height: MediaQuery.sizeOf(context).height * 0.8,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: Image.asset(
                                    'assets/images/emptyPost@3x.png',
                                  ).image,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3.0,
                                    color: Color(0x2D000000),
                                    offset: Offset(
                                      0.0,
                                      1.0,
                                    ),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                            ),
                          ),
                        if (functions.hasUploadedMedia(_model.uploadedFileUrl3))
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: FlutterFlowMediaDisplay(
                              path: _model.uploadedFileUrl3,
                              imageBuilder: (path) => Image.network(
                                path,
                                width: MediaQuery.sizeOf(context).width * 1.0,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              videoPlayerBuilder: (path) => FlutterFlowVideoPlayer(
                                path: path,
                                width: MediaQuery.sizeOf(context).width * 1.0,
                                autoPlay: false,
                                looping: true,
                                showControls: true,
                                allowFullScreen: true,
                                allowPlaybackSpeedMenu: false,
                              ),
                            ),
                          ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FlutterFlowIconButton(
                                    borderColor: Colors.transparent,
                                    borderRadius: 30.0,
                                    borderWidth: 1.0,
                                    buttonSize: 40.0,
                                    fillColor: Color(0x41000000),
                                    icon: Icon(
                                      Icons.close_rounded,
                                      color: FlutterFlowTheme.of(context).info,
                                      size: 20.0,
                                    ),
                                    onPressed: () async {
                                      context.pop();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: MediaQuery.sizeOf(context).width * 1.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.transparent, Color(0xFF1A1F24)],
                                        stops: [0.0, 1.0],
                                        begin: AlignmentDirectional(0.0, -1.0),
                                        end: AlignmentDirectional(0, 1.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                                      child: TextFormField(
                                        controller: _model.storyDescriptionTextController,
                                        focusNode: _model.storyDescriptionFocusNode,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          hintText: 'Yorum....',
                                          hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                fontFamily: 'Figtree',
                                                letterSpacing: 0.0,
                                              ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).dark800Persist,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(0.0),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(0.0),
                                          ),
                                          errorBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(0.0),
                                          ),
                                          focusedErrorBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(0.0),
                                          ),
                                          contentPadding: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 12.0),
                                        ),
                                        style: FlutterFlowTheme.of(context).titleSmall.override(
                                              fontFamily: 'Figtree',
                                              letterSpacing: 0.0,
                                            ),
                                        textAlign: TextAlign.start,
                                        maxLines: 4,
                                        validator: _model.storyDescriptionTextControllerValidator.asValidator(context),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                final selectedMedia = await selectMediaWithSourceBottomSheet(
                                  context: context,
                                  allowPhoto: false,
                                  allowVideo: true,
                                  compressImages: true,
                                  imageType: 'story',
                                );
                                if (selectedMedia != null && selectedMedia.every((m) => validateFileFormat(m.storagePath, context))) {
                                  safeSetState(() => _model.isDataUploading2 = true);
                                  var selectedUploadedFiles = <FFUploadedFile>[];

                                  var downloadUrls = <String>[];
                                  try {
                                    showUploadMessage(
                                      context,
                                      'Dosya yükleme...',
                                      showLoading: true,
                                    );
                                    selectedUploadedFiles = selectedMedia
                                        .map((m) => FFUploadedFile(
                                              name: m.storagePath.split('/').last,
                                              bytes: m.bytes,
                                              height: m.dimensions?.height,
                                              width: m.dimensions?.width,
                                              blurHash: m.blurHash,
                                            ))
                                        .toList();

                                    downloadUrls = (await Future.wait(
                                      selectedMedia.map(
                                        (m) async => await uploadData(m.storagePath, m.bytes),
                                      ),
                                    ))
                                        .where((u) => u != null)
                                        .map((u) => u!)
                                        .toList();
                                  } finally {
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                    _model.isDataUploading2 = false;
                                  }
                                  if (selectedUploadedFiles.length == selectedMedia.length && downloadUrls.length == selectedMedia.length) {
                                    safeSetState(() {
                                      _model.uploadedLocalFile2 = selectedUploadedFiles.first;
                                      _model.uploadedFileUrl2 = downloadUrls.first;
                                    });
                                    showUploadMessage(context, 'Başarılı!');
                                  } else {
                                    safeSetState(() {});
                                    showUploadMessage(context, 'Veri yüklenemedi');
                                    return;
                                  }
                                }
                              },
                              child: Container(
                                width: 70.0,
                                height: 70.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    color: Color(0xFF262D34),
                                    width: 2.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.videocam_sharp,
                                        color: FlutterFlowTheme.of(context).info,
                                        size: 32.0,
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                        child: Text(
                                          'Video',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context).labelMedium.override(
                                                fontFamily: 'Figtree',
                                                color: FlutterFlowTheme.of(context).info,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                final selectedMedia = await selectMediaWithSourceBottomSheet(
                                  context: context,
                                  allowPhoto: true,
                                  backgroundColor: Color(0xFF262D34),
                                  textColor: FlutterFlowTheme.of(context).tertiary,
                                  pickerFontFamily: 'Lexend Deca',
                                  compressImages: false, // Compress'i kapatıyoruz çünkü editörde işleyeceğiz
                                  imageType: 'story',
                                );
                                if (selectedMedia != null && selectedMedia.every((m) => validateFileFormat(m.storagePath, context))) {
                                  final selectedFile = FFUploadedFile(
                                    name: selectedMedia.first.storagePath.split('/').last,
                                    bytes: selectedMedia.first.bytes,
                                    height: selectedMedia.first.dimensions?.height,
                                    width: selectedMedia.first.dimensions?.width,
                                    blurHash: selectedMedia.first.blurHash,
                                  );

                                  // Pro Image Editor ile editlemek için sor
                                  await ImageEditorHelper.showEditDialog(
                                    context: context,
                                    selectedFile: selectedFile,
                                    onEditComplete: (editedFile) async {
                                      if (editedFile != null) {
                                        safeSetState(() => _model.isDataUploading3 = true);

                                        try {
                                          showUploadMessage(
                                            context,
                                            'Dosya yükleme...',
                                            showLoading: true,
                                          );

                                          // Editlenmiş dosyayı Firebase'e yükle
                                          final downloadUrl = await uploadData(selectedMedia.first.storagePath, editedFile.bytes!);

                                          if (downloadUrl != null) {
                                            safeSetState(() {
                                              _model.uploadedLocalFile3 = editedFile;
                                              _model.uploadedFileUrl3 = downloadUrl;
                                            });
                                            showUploadMessage(context, 'Başarılı!');
                                          } else {
                                            showUploadMessage(context, 'Yükleme hatası');
                                          }
                                        } finally {
                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                          _model.isDataUploading3 = false;
                                        }
                                      }
                                    },
                                  );
                                }
                              },
                              child: Container(
                                width: 70.0,
                                height: 70.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    color: Color(0xFF262D34),
                                    width: 2.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.photo_library,
                                        color: FlutterFlowTheme.of(context).info,
                                        size: 32.0,
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                        child: Text(
                                          'Fotoğraf',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context).labelMedium.override(
                                                fontFamily: 'Figtree',
                                                color: FlutterFlowTheme.of(context).info,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ].divide(SizedBox(width: 12.0)),
                        ),
                        FFButtonWidget(
                          onPressed: () async {
                            await UserStoriesRecord.collection.doc().set(createUserStoriesRecordData(
                                  user: currentUserReference,
                                  storyVideo: _model.uploadedFileUrl2,
                                  storyPhoto: _model.uploadedFileUrl3,
                                  storyDescription: _model.storyDescriptionTextController.text,
                                  storyPostedAt: getCurrentTimestamp,
                                  isOwner: true,
                                ));

                            // İlk hikaye rozeti kontrol et ve ver
                            await BadgeService().checkAndAwardFirstStoryBadge();

                            context.pushNamed(MainFeedWidget.routeName);
                          },
                          text: 'Hikaye Oluştur',
                          options: FFButtonOptions(
                            width: 140.0,
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
                            borderRadius: BorderRadius.circular(40.0),
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
      ),
    );
  }
}
