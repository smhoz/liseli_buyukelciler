import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:sosyal_medya/auth/firebase_auth/auth_util.dart';
import 'package:sosyal_medya/backend/firebase_storage/storage.dart';
import 'package:sosyal_medya/backend/schema/user_posts_record.dart' show UserPostsRecord, createUserPostsRecordData;
import 'package:sosyal_medya/flutter_flow/custom_functions.dart' as functions;
import 'package:sosyal_medya/flutter_flow/flutter_flow_icon_button.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_media_display.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_theme.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_util.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_video_player.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_widgets.dart';
import 'package:sosyal_medya/flutter_flow/upload_data.dart';
import 'package:sosyal_medya/helper/image_editor_helper.dart';
import 'package:sosyal_medya/helper/show_dialogs.dart';
import 'package:sosyal_medya/pages/create_activity/create_activity_viewmodel.dart';
import 'package:sosyal_medya/pages/create_activity/model/acitivity_model.dart';
import 'package:sosyal_medya/service/badge_service.dart';
import 'package:sosyal_medya/pages/create_post/create_post_model.dart';
import 'package:sosyal_medya/pages/main_feed/main_feed_widget.dart';
import 'package:sosyal_medya/util/base_utility.dart';

class CreateActivityView extends StatefulWidget {
  const CreateActivityView({super.key});
  static String routeName = 'createAcitivity';
  static String routePath = '/createAcitivity';

  @override
  State<CreateActivityView> createState() => _CreateActivityViewState();
}

class _CreateActivityViewState extends CreateActivityViewModel {
  late CreatePostModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreatePostModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

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
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: responsiveVisibility(
        context: context,
        tabletLandscape: false,
        desktop: false,
      )
          ? AppBar(
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              automaticallyImplyLeading: false,
              title: Text(
                'Aktivite Oluştur',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      fontFamily: 'Outfit',
                      letterSpacing: 0.0,
                    ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
                  child: FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30.0,
                    buttonSize: 48.0,
                    icon: Icon(
                      Icons.close_rounded,
                      color: Color(0xFF95A1AC),
                      size: 25.0,
                    ),
                    onPressed: () async {
                      context.pop();
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
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: 570.0,
          ),
          decoration: BoxDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (responsiveVisibility(
                context: context,
                phone: false,
                tablet: false,
              ))
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 12.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16.0, 2.0, 0.0, 2.0),
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
                          padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                          child: Icon(
                            Icons.chevron_right_rounded,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 16.0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                          child: Container(
                            height: 36.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).accent2,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).secondary,
                              ),
                            ),
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                              child: Text(
                                'Aktivite Oluştur',
                                style: FlutterFlowTheme.of(context).bodyLarge.override(
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * 1.0,
                          decoration: BoxDecoration(),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // add image
                              Container(
                                height: 350.0,
                                child: Stack(
                                  children: [
                                    if (!functions.hasUploadedMedia(_model.uploadedFileUrl))
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: InkWell(
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
                                                      safeSetState(() => _model.isDataUploading = true);

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
                                                            _model.uploadedLocalFile = editedFile;
                                                            _model.uploadedFileUrl = downloadUrl;
                                                          });
                                                          showUploadMessage(context, 'Başarılı!');
                                                        } else {
                                                          showUploadMessage(context, 'Yükleme hatası');
                                                        }
                                                      } finally {
                                                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                        _model.isDataUploading = false;
                                                      }
                                                    }
                                                  },
                                                );
                                              } else {
                                                // Video ise direkt yükle
                                                safeSetState(() => _model.isDataUploading = true);

                                                try {
                                                  showUploadMessage(context, 'Dosya yükleme...', showLoading: true);

                                                  final downloadUrl = await uploadData(selectedMedia.first.storagePath, selectedMedia.first.bytes);

                                                  if (downloadUrl != null) {
                                                    safeSetState(() {
                                                      _model.uploadedLocalFile = selectedFile;
                                                      _model.uploadedFileUrl = downloadUrl;
                                                    });
                                                    showUploadMessage(context, 'Başarılı!');
                                                  } else {
                                                    showUploadMessage(context, 'Yükleme hatası');
                                                  }
                                                } finally {
                                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                  _model.isDataUploading = false;
                                                }
                                              }
                                            }
                                          },
                                          child: Container(
                                            width: MediaQuery.sizeOf(context).width * 1.0,
                                            height: 350.0,
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).primaryBackground,
                                              borderRadius: BorderRadius.circular(12.0),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
                                                  child: Icon(
                                                    Icons.add_a_photo_outlined,
                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                    size: 72.0,
                                                  ),
                                                ),
                                                Text(
                                                  'Buraya resim veya video ekleyin.',
                                                  style: FlutterFlowTheme.of(context).labelMedium.override(
                                                        fontFamily: 'Figtree',
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (functions.hasUploadedMedia(_model.uploadedFileUrl))
                                      Align(
                                        alignment: AlignmentDirectional(0.0, 0.0),
                                        child: FlutterFlowMediaDisplay(
                                          path: _model.uploadedFileUrl,
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
                                  ],
                                ),
                              ),
                              // category
                              isActivityLoading
                                  ? const SizedBox()
                                  : Padding(
                                      padding: BaseUtility.all(
                                        BaseUtility.paddingNormalValue,
                                      ),
                                      child: DropdownSearch<ActivityModel>(
                                        popupProps: PopupProps.menu(
                                          emptyBuilder: (context, searchEntry) {
                                            return SizedBox(
                                              height: 150,
                                              child: Padding(
                                                padding: BaseUtility.vertical(
                                                  BaseUtility.paddingNormalValue,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Aktivite Bilgisi Bulunamadı.',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          showSearchBox: true,
                                          fit: FlexFit.loose,
                                          constraints: BoxConstraints(
                                            maxHeight: 400,
                                          ),
                                          title: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Aktivite Seç",
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          searchFieldProps: TextFieldProps(
                                            decoration: InputDecoration(
                                              hintText: "Aktivite Ara...",
                                              prefixIcon: Icon(Icons.search),
                                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                            ),
                                          ),
                                          itemBuilder: (context, item, isSelected) => Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                            decoration: BoxDecoration(
                                              color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : null,
                                              border: Border(
                                                bottom: BorderSide(color: Colors.grey.shade200),
                                              ),
                                            ),
                                            child: Text(item.name),
                                          ),
                                        ),
                                        dropdownButtonProps: DropdownButtonProps(
                                          icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
                                        ),
                                        items: activity,
                                        itemAsString: (ActivityModel school) => school.name,
                                        dropdownDecoratorProps: DropDownDecoratorProps(
                                          dropdownSearchDecoration: InputDecoration(
                                            labelText: "Aktivite Seçiniz",
                                            labelStyle: TextStyle(
                                              color: FlutterFlowTheme.of(context).primary,
                                            ),
                                            prefixIcon: Icon(
                                              Icons.local_activity,
                                              color: FlutterFlowTheme.of(context).primary,
                                            ),
                                            filled: true,
                                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: BorderSide(color: Colors.grey.shade400),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: BorderSide(color: Colors.grey.shade400),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: FlutterFlowTheme.of(context).primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        selectedItem: selectedActivity,
                                        onChanged: (ActivityModel? newValue) {
                                          setState(() {
                                            selectedActivity = newValue;
                                          });
                                        },
                                      ),
                                    ),
                              // explanation
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _model.textController,
                                        focusNode: _model.textFieldFocusNode,
                                        textCapitalization: TextCapitalization.sentences,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          hintText: 'Yorum....',
                                          hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                fontFamily: 'Figtree',
                                                letterSpacing: 0.0,
                                              ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).alternate,
                                              width: 2.0,
                                            ),
                                            borderRadius: BorderRadius.circular(0.0),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).primary,
                                              width: 2.0,
                                            ),
                                            borderRadius: BorderRadius.circular(0.0),
                                          ),
                                          errorBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).error,
                                              width: 2.0,
                                            ),
                                            borderRadius: BorderRadius.circular(0.0),
                                          ),
                                          focusedErrorBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: FlutterFlowTheme.of(context).error,
                                              width: 2.0,
                                            ),
                                            borderRadius: BorderRadius.circular(0.0),
                                          ),
                                          contentPadding: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 12.0),
                                        ),
                                        style: FlutterFlowTheme.of(context).titleSmall.override(
                                              fontFamily: 'Figtree',
                                              color: FlutterFlowTheme.of(context).primaryText,
                                              letterSpacing: 0.0,
                                            ),
                                        textAlign: TextAlign.start,
                                        maxLines: 4,
                                        cursorColor: FlutterFlowTheme.of(context).primary,
                                        validator: _model.textControllerValidator.asValidator(context),
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
              ),
              Container(
                width: double.infinity,
                height: 100.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0.0),
                    bottomRight: Radius.circular(0.0),
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 40.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      if (_model.uploadedFileUrl.isEmpty && _model.textController.text.isEmpty) {
                        CodeNoahDialogs(context).showFlush(
                          type: SnackType.error,
                          message: 'Lütfen gerekli alanları doldurun.',
                        );
                      } else {
                        if (selectedActivity != null) {
                          final activityRef = FirebaseFirestore.instance.collection('activity').doc(selectedActivity!.id);
                          await UserPostsRecord.collection.doc().set(createUserPostsRecordData(
                                postPhoto: _model.uploadedFileUrl,
                                postDescription: _model.textController.text,
                                postUser: currentUserReference,
                                postTitle: '',
                                timePosted: getCurrentTimestamp,
                                postOwner: true,
                                postIsActivity: true,
                                postCategory: activityRef,
                                postShow: true,
                              ));
                          
                          // İlk aktivite rozeti kontrol et ve ver
                          await BadgeService().checkAndAwardFirstActivityBadge();
                          
                          Navigator.pop(context);
                          context.goNamed(
                            MainFeedWidget.routeName,
                            extra: <String, dynamic>{
                              kTransitionInfoKey: TransitionInfo(
                                hasTransition: true,
                                transitionType: PageTransitionType.leftToRight,
                                duration: Duration(milliseconds: 250),
                              ),
                            },
                          );
                        } else {
                          CodeNoahDialogs(context).showFlush(
                            type: SnackType.warning,
                            message: 'Lütfen Aktivite Türü seçiminizi yapınız',
                          );
                        }
                      }
                    },
                    text: 'Aktivite Oluştur',
                    options: FFButtonOptions(
                      width: 270.0,
                      height: 50.0,
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                            fontFamily: 'Outfit',
                            color: Colors.white,
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                      elevation: 0.0,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
