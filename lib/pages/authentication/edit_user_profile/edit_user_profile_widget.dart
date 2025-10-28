import 'package:dropdown_search/dropdown_search.dart';
import 'package:sosyal_medya/helper/show_dialogs.dart';
import 'package:sosyal_medya/pages/education_information/model/state_model/state_model.dart';
import 'package:sosyal_medya/pages/main_feed/main_feed_widget.dart';
import 'package:sosyal_medya/util/base_utility.dart' show BaseUtility;

import '../../../helper/image_editor_helper.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'package:flutter/material.dart';
import 'edit_user_profile_model.dart';
export 'edit_user_profile_model.dart';

class EditUserProfileWidget extends StatefulWidget {
  const EditUserProfileWidget({super.key, this.mainProfileUsersRecord});

  static String routeName = 'editUserProfile';
  static String routePath = '/editUserProfile';
  final UsersRecord? mainProfileUsersRecord;

  @override
  State<EditUserProfileWidget> createState() => _EditUserProfileWidgetState();
}

class _EditUserProfileWidgetState extends State<EditUserProfileWidget> {
  late EditUserProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  late int phoneNumber = 0;
  late String city = "";
  late String userInterest = "";
  @override
  void initState() {
    super.initState();
    fetchStateDetails();
    fetchStates();
    _model = createModel(context, () => EditUserProfileModel());

    _model.yourNameFocusNode ??= FocusNode();

    _model.userNameFocusNode ??= FocusNode();

    _model.bioFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
    userOtherInformation();
  }

  StateModel? selectedState;
  List<StateModel> states = [];
  bool isStateLoading = true;

  Future<void> fetchStateDetails() async {
    try {
      DocumentSnapshot userSnapshot = await currentUserReference!.get();

      DocumentReference stateRef = userSnapshot.get('state_id');

      DocumentSnapshot stateSnapshot = await stateRef.get();

      if (stateSnapshot.exists) {
        StateModel state = StateModel.fromJson(stateSnapshot.data() as Map<String, dynamic>);

        setState(() {
          selectedState = state;
        });
      }
    } catch (e) {
      print("Şehir bilgisi çekme hatası: $e");
    }
  }

  Future<void> fetchStates() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('state')
          .where('is_deleted', isEqualTo: false)
          .get();

      states = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        data['id'] = doc.id;

        return StateModel.fromJson(data);
      }).toList();

      setState(() {
        isStateLoading = false;
      });
    } catch (e) {
      print("Okullar çekme hatası: $e");
      setState(() {
        isStateLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  DateTime selectedBirhtDate = DateTime.now();

  Future<void> selectBirthDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedBirhtDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: Locale('tr', 'TR'),
    );

    if (pickedDate != null) {
      setState(() {
        selectedBirhtDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
        );
      });
    }
  }

  Future<void> userOtherInformation() async {
    print("${currentUser!.uid}");
    try {
      final docSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();

      if (docSnapshot.exists) {
        final userData = docSnapshot.data();

        if (userData != null) {
          setState(() {
            phoneNumber = int.tryParse(userData['user_phone_number'].toString()) ?? 0;

            city = userData['city'] ?? "";
            userInterest = userData['user_interest'] ?? "";

            if (userData['birth_date'] != null && userData['birth_date'] is Timestamp) {
              selectedBirhtDate = (userData['birth_date'] as Timestamp).toDate();
            }
          });
        }
      }
    } catch (e) {
      print("Kullanıcı bilgileri alınırken hata oluştu: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UsersRecord>(
      stream: UsersRecord.getDocument(currentUserReference!),
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

        final editUserProfileUsersRecord = snapshot.data!;

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
                      // context.pop();
                      context.goNamedAuth(MainFeedWidget.routeName, context.mounted);
                    },
                  ),
                  title: Text(
                    'Sizin Profiliniz',
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'Outfit',
                          letterSpacing: 0.0,
                        ),
                  ),
                  actions: [],
                  centerTitle: false,
                  elevation: 0.0,
                )
              : null,
          body: SafeArea(
            top: true,
            child: Align(
              alignment: AlignmentDirectional(0.0, -1.0),
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxWidth: 870.0,
                ),
                decoration: BoxDecoration(),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (responsiveVisibility(
                        context: context,
                        phone: false,
                        tablet: false,
                      ))
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).secondaryBackground,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(0.0),
                                bottomRight: Radius.circular(0.0),
                                topLeft: Radius.circular(12.0),
                                topRight: Radius.circular(12.0),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  FlutterFlowIconButton(
                                    borderColor: Colors.transparent,
                                    borderRadius: 30.0,
                                    buttonSize: 40.0,
                                    icon: Icon(
                                      Icons.arrow_back_rounded,
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      size: 25.0,
                                    ),
                                    onPressed: () async {
                                      context.pop();
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Profili düzenle',
                                          style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                fontFamily: 'Figtree',
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                          child: Text(
                                            'Profilinizin kurulumunu tamamlamak için profilinizi şimdi doldurun.',
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
                        ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (responsiveVisibility(
                            context: context,
                            tabletLandscape: false,
                            desktop: false,
                          ))
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 0.0),
                              child: Text(
                                'Profilinizin kurulumunu tamamlamak için profilinizi şimdi doldurun.',
                                style: FlutterFlowTheme.of(context).labelMedium.override(
                                      fontFamily: 'Figtree',
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                final selectedMedia = await selectMediaWithSourceBottomSheet(
                                  context: context,
                                  allowPhoto: true,
                                  backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                                  textColor: FlutterFlowTheme.of(context).primaryText,
                                  pickerFontFamily: 'Figtree',
                                  compressImages: true,
                                  imageType: 'profile',
                                );
                                if (selectedMedia == null) {
                                  return;
                                }
                                final selectedFile = FFUploadedFile(
                                  name: selectedMedia.first.storagePath.split('/').last,
                                  bytes: selectedMedia.first.bytes,
                                  height: selectedMedia.first.dimensions?.height,
                                  width: selectedMedia.first.dimensions?.width,
                                  blurHash: selectedMedia.first.blurHash,
                                );
                                await ImageEditorHelper.showEditDialog(
                                  context: context,
                                  selectedFile: selectedFile,
                                  isCircle: true,
                                  onEditComplete: (editedFile) async {
                                    safeSetState(() => _model.isDataUploading = true);
                                    var selectedUploadedFiles = <FFUploadedFile>[];

                                    var downloadUrls = <String>[];
                                    try {
                                      showUploadMessage(
                                        context,
                                        'Dosya yükleme...',
                                        showLoading: true,
                                      );

                                      downloadUrls = (await Future.wait(
                                        selectedMedia.map(
                                          (m) async => await uploadData(
                                              selectedMedia.first.storagePath, editedFile!.bytes!),
                                        ),
                                      ))
                                          .where((u) => u != null)
                                          .map((u) => u!)
                                          .toList();
                                      selectedUploadedFiles.add(FFUploadedFile(
                                        name: selectedMedia.first.storagePath.split('/').last,
                                        bytes: editedFile?.bytes,
                                        height: editedFile?.height,
                                        width: editedFile?.width,
                                        blurHash: editedFile?.blurHash,
                                      ));
                                    } finally {
                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                      _model.isDataUploading = false;
                                    }
                                    if (downloadUrls.isNotEmpty) {
                                      safeSetState(() {
                                        _model.uploadedLocalFile = selectedUploadedFiles.first;
                                        _model.uploadedFileUrl = downloadUrls.first;
                                      });
                                      showUploadMessage(context, 'Başarılı!');
                                    } else {
                                      safeSetState(() {});
                                      showUploadMessage(context, 'Veri yüklenemedi');
                                      return;
                                    }
                                  },
                                );
                              },
                              child: Container(
                                width: 120.0,
                                height: 120.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: Image.network(
                                      valueOrDefault<String>(
                                        ((_model.uploadedFileUrl ?? "").isEmpty
                                            ? widget.mainProfileUsersRecord?.photoUrl
                                            : _model.uploadedFileUrl),
                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/sample-app-social-app-tx2kqp/assets/7dvyeuxvy2dg/addUser@2x.png',
                                      ),
                                    ).image,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 24.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _model.yourNameTextController ??=
                                        TextEditingController(
                                      text: editUserProfileUsersRecord.displayName,
                                    ),
                                    focusNode: _model.yourNameFocusNode,
                                    textCapitalization: TextCapitalization.words,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      isDense: false,
                                      labelText: 'Sizin Adınız',
                                      labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                            fontFamily: 'Figtree',
                                            letterSpacing: 0.0,
                                          ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context).alternate,
                                          width: 2.0,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context).primary,
                                          width: 2.0,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      errorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context).error,
                                          width: 2.0,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedErrorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context).error,
                                          width: 2.0,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      contentPadding:
                                          EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 16.0),
                                    ),
                                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                                          fontFamily: 'Outfit',
                                          letterSpacing: 0.0,
                                        ),
                                    minLines: 1,
                                    cursorColor: FlutterFlowTheme.of(context).primary,
                                    validator:
                                        _model.yourNameTextControllerValidator.asValidator(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(24.0, 4.0, 24.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                                    child: TextFormField(
                                      controller: _model.userNameTextController ??=
                                          TextEditingController(
                                        text: editUserProfileUsersRecord.userName,
                                      ),
                                      focusNode: _model.userNameFocusNode,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Kullanıcı Adı',
                                        labelStyle:
                                            FlutterFlowTheme.of(context).labelMedium.override(
                                                  fontFamily: 'Figtree',
                                                  letterSpacing: 0.0,
                                                ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context).alternate,
                                            width: 2.0,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context).primary,
                                            width: 2.0,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context).error,
                                            width: 2.0,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        focusedErrorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context).error,
                                            width: 2.0,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        contentPadding:
                                            EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 16.0),
                                      ),
                                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                                            fontFamily: 'Outfit',
                                            letterSpacing: 0.0,
                                          ),
                                      minLines: 1,
                                      cursorColor: FlutterFlowTheme.of(context).primary,
                                      validator: _model.userNameTextControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // phone number
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(24.0, 4.0, 24.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                                    child: TextFormField(
                                      controller: _model.phoneNumberTextController ??=
                                          TextEditingController(
                                        text: phoneNumber.toString(),
                                      ),
                                      focusNode: _model.phoneNumberFocusNode,
                                      obscureText: false,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        labelText: 'Telefon Numarası',
                                        labelStyle:
                                            FlutterFlowTheme.of(context).labelMedium.override(
                                                  fontFamily: 'Figtree',
                                                  letterSpacing: 0.0,
                                                ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context).alternate,
                                            width: 2.0,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context).primary,
                                            width: 2.0,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context).error,
                                            width: 2.0,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        focusedErrorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context).error,
                                            width: 2.0,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        contentPadding:
                                            EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 16.0),
                                      ),
                                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                                            fontFamily: 'Outfit',
                                            letterSpacing: 0.0,
                                          ),
                                      minLines: 1,
                                      cursorColor: FlutterFlowTheme.of(context).primary,
                                      validator: (phoneNumberVal) {
                                        bool isNumeric(String? s) {
                                          if (s == null) {
                                            return false;
                                          }
                                          return double.tryParse(s) != null;
                                        }

                                        if (phoneNumberVal == null || phoneNumberVal.isEmpty) {
                                          return "Zorunlu Alan";
                                        } else if (!isNumeric(phoneNumberVal)) {
                                          return "Geçersiz Telefon Numarası";
                                        } else if (!RegExp(r"^[1-9][0-9]{9}$")
                                            .hasMatch(phoneNumberVal)) {
                                          return "Geçersiz Telefon Numarası";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          // city
                          isStateLoading
                              ? const SizedBox()
                              : Container(
                                  margin: BaseUtility.horizontal(
                                    BaseUtility.marginNormalValue,
                                  ),
                                  child: DropdownSearch<StateModel>(
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
                                                'Şehir Bilgisi Bulunamadı.',
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
                                          "Şehir Seç",
                                          style:
                                              TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      searchFieldProps: TextFieldProps(
                                        decoration: InputDecoration(
                                          hintText: "Şehir Ara...",
                                          prefixIcon: Icon(Icons.search),
                                          contentPadding:
                                              EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12)),
                                        ),
                                      ),
                                      itemBuilder: (context, item, isSelected) => Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.1)
                                              : null,
                                          border: Border(
                                            bottom: BorderSide(color: Colors.grey.shade200),
                                          ),
                                        ),
                                        child: Text(item.name),
                                      ),
                                    ),
                                    dropdownButtonProps: DropdownButtonProps(
                                      icon: Icon(Icons.keyboard_arrow_down_rounded,
                                          color: Colors.grey),
                                    ),
                                    items: states,
                                    itemAsString: (StateModel school) => school.name,
                                    dropdownDecoratorProps: DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Şehir Seçiniz",
                                        labelStyle: TextStyle(
                                          color: FlutterFlowTheme.of(context).primary,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.location_on,
                                          color: FlutterFlowTheme.of(context).primary,
                                        ),
                                        filled: true,
                                        contentPadding:
                                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                                    selectedItem: selectedState,
                                    onChanged: (StateModel? newValue) {
                                      setState(() {
                                        selectedState = newValue;
                                      });
                                    },
                                  ),
                                ),
                          // Padding(
                          //   padding: EdgeInsetsDirectional.fromSTEB(
                          //       24.0, 4.0, 24.0, 0.0),
                          //   child: Row(
                          //     mainAxisSize: MainAxisSize.max,
                          //     children: [
                          //       Expanded(
                          //         child: Padding(
                          //           padding: EdgeInsetsDirectional.fromSTEB(
                          //               0.0, 12.0, 0.0, 0.0),
                          //           child: TextFormField(
                          //             controller: _model.cityTextController ??=
                          //                 TextEditingController(
                          //               text: city,
                          //             ),
                          //             focusNode: _model.cityFocusNode,
                          //             obscureText: false,
                          //             decoration: InputDecoration(
                          //               labelText: 'Şehir',
                          //               labelStyle: FlutterFlowTheme.of(context)
                          //                   .labelMedium
                          //                   .override(
                          //                     fontFamily: 'Figtree',
                          //                     letterSpacing: 0.0,
                          //                   ),
                          //               enabledBorder: UnderlineInputBorder(
                          //                 borderSide: BorderSide(
                          //                   color: FlutterFlowTheme.of(context)
                          //                       .alternate,
                          //                   width: 2.0,
                          //                 ),
                          //                 borderRadius: const BorderRadius.only(
                          //                   topLeft: Radius.circular(4.0),
                          //                   topRight: Radius.circular(4.0),
                          //                 ),
                          //               ),
                          //               focusedBorder: UnderlineInputBorder(
                          //                 borderSide: BorderSide(
                          //                   color: FlutterFlowTheme.of(context)
                          //                       .primary,
                          //                   width: 2.0,
                          //                 ),
                          //                 borderRadius: const BorderRadius.only(
                          //                   topLeft: Radius.circular(4.0),
                          //                   topRight: Radius.circular(4.0),
                          //                 ),
                          //               ),
                          //               errorBorder: UnderlineInputBorder(
                          //                 borderSide: BorderSide(
                          //                   color: FlutterFlowTheme.of(context)
                          //                       .error,
                          //                   width: 2.0,
                          //                 ),
                          //                 borderRadius: const BorderRadius.only(
                          //                   topLeft: Radius.circular(4.0),
                          //                   topRight: Radius.circular(4.0),
                          //                 ),
                          //               ),
                          //               focusedErrorBorder:
                          //                   UnderlineInputBorder(
                          //                 borderSide: BorderSide(
                          //                   color: FlutterFlowTheme.of(context)
                          //                       .error,
                          //                   width: 2.0,
                          //                 ),
                          //                 borderRadius: const BorderRadius.only(
                          //                   topLeft: Radius.circular(4.0),
                          //                   topRight: Radius.circular(4.0),
                          //                 ),
                          //               ),
                          //               contentPadding:
                          //                   EdgeInsetsDirectional.fromSTEB(
                          //                       0.0, 12.0, 0.0, 16.0),
                          //             ),
                          //             style: FlutterFlowTheme.of(context)
                          //                 .headlineSmall
                          //                 .override(
                          //                   fontFamily: 'Outfit',
                          //                   letterSpacing: 0.0,
                          //                 ),
                          //             minLines: 1,
                          //             cursorColor:
                          //                 FlutterFlowTheme.of(context).primary,
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // birth date
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            padding: EdgeInsetsDirectional.fromSTEB(17, 30, 0, 16),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () => selectBirthDate(),
                              child: Column(
                                children: <Widget>[
                                  // label
                                  SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 16),
                                      child: Text(
                                        'Doğum Tarihi',
                                        style: FlutterFlowTheme.of(context).labelMedium.override(
                                              fontFamily: 'Figtree',
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                  ),
                                  // date select
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Icon(
                                        Icons.date_range_outlined,
                                        size: 21,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(16, 0.0, 16, 0.0),
                                          child: Text(
                                            '${selectedBirhtDate.day.toString().padLeft(2, '0')}.${selectedBirhtDate.month.toString().padLeft(2, '0')}.${selectedBirhtDate.year.toString().padLeft(2, '0')}',
                                            textAlign: TextAlign.left,
                                            style:
                                                FlutterFlowTheme.of(context).headlineSmall.override(
                                                      fontFamily: 'Outfit',
                                                      letterSpacing: 0.0,
                                                    ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(24.0, 4.0, 24.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                                    child: TextFormField(
                                      controller: _model.userInterestTextController ??=
                                          TextEditingController(
                                        text: userInterest,
                                      ),
                                      focusNode: _model.userInterestFocusNode,
                                      obscureText: false,
                                      maxLines: 3,
                                      decoration: InputDecoration(
                                        labelText: 'İlgi Alanları ',
                                        labelStyle:
                                            FlutterFlowTheme.of(context).labelMedium.override(
                                                  fontFamily: 'Figtree',
                                                  letterSpacing: 0.0,
                                                ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context).alternate,
                                            width: 2.0,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context).primary,
                                            width: 2.0,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context).error,
                                            width: 2.0,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        focusedErrorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context).error,
                                            width: 2.0,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        contentPadding:
                                            EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 16.0),
                                      ),
                                      style: FlutterFlowTheme.of(context).headlineMedium.override(
                                            fontFamily: 'Outfit',
                                            letterSpacing: 0.0,
                                          ),
                                      minLines: 1,
                                      cursorColor: FlutterFlowTheme.of(context).primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // bio
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(24.0, 4.0, 24.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                                    child: TextFormField(
                                      controller: _model.bioTextController ??=
                                          TextEditingController(
                                        text: editUserProfileUsersRecord.bio,
                                      ),
                                      focusNode: _model.bioFocusNode,
                                      textCapitalization: TextCapitalization.sentences,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelStyle:
                                            FlutterFlowTheme.of(context).labelMedium.override(
                                                  fontFamily: 'Figtree',
                                                  letterSpacing: 0.0,
                                                ),
                                        hintText: 'Biyografiniz',
                                        hintStyle:
                                            FlutterFlowTheme.of(context).labelMedium.override(
                                                  fontFamily: 'Figtree',
                                                  letterSpacing: 0.0,
                                                ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context).alternate,
                                            width: 2.0,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context).primary,
                                            width: 2.0,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context).error,
                                            width: 2.0,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        focusedErrorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context).error,
                                            width: 2.0,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        contentPadding:
                                            EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                                      ),
                                      style: FlutterFlowTheme.of(context).headlineMedium.override(
                                            fontFamily: 'Figtree',
                                            letterSpacing: 0.0,
                                          ),
                                      textAlign: TextAlign.start,
                                      maxLines: 4,
                                      minLines: 1,
                                      cursorColor: FlutterFlowTheme.of(context).primary,
                                      validator:
                                          _model.bioTextControllerValidator.asValidator(context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24.0, 80.0, 24.0, 40.0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            if (selectedState == null ||
                                _model.bioTextController.text.isEmpty ||
                                _model.phoneNumberTextController.text.isEmpty ||
                                _model.userInterestTextController.text.isEmpty) {
                              CodeNoahDialogs(context).showFlush(
                                type: SnackType.error,
                                message: 'Devam etmek için, lütfen gerekli alanları doldurunuz.',
                              );
                            } else {
                              await currentUserReference!
                                  .update(createUsersRecordData(
                                displayName: _model.yourNameTextController.text,
                                userName: _model.userNameTextController.text,
                                photoUrl: _model.uploadedFileUrl,
                                bio: _model.bioTextController.text,
                                phoneNumber: _model.phoneNumberTextController.text,
                              ))
                                  .then((val) async {
                                if (selectedState != null) {
                                  final stateRef = FirebaseFirestore.instance
                                      .collection('state')
                                      .doc(selectedState!.id);
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(currentUserUid)
                                      .update({
                                    'state_id': stateRef,
                                    'phone_number': _model.phoneNumberTextController.text,
                                    'birth_date': selectedBirhtDate,
                                    'user_interest': _model.userInterestTextController.text,
                                  }).then((val) {});
                                } else {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(currentUserUid)
                                      .update({
                                    'phone_number': _model.phoneNumberTextController.text,
                                    'birth_date': selectedBirhtDate,
                                    'user_interest': _model.userInterestTextController.text,
                                  }).then((val) {});
                                }
                              });
                              context.goNamedAuth(MainFeedWidget.routeName, context.mounted);
                            }
                          },
                          text: 'Değişiklikleri Kaydet',
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
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
