import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sosyal_medya/auth/firebase_auth/auth_util.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_icon_button.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_theme.dart'
    show FlutterFlowTheme, TextStyleHelper;
import 'package:sosyal_medya/flutter_flow/flutter_flow_util.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_widgets.dart';
import 'package:sosyal_medya/helper/show_dialogs.dart';
import 'package:sosyal_medya/pages/turkey_education_information/view/education_create/education_create_viewmodel.dart';

class EducationCreateView extends StatefulWidget {
  const EducationCreateView({super.key});

  @override
  State<EducationCreateView> createState() => _EducationCreateViewState();
}

class _EducationCreateViewState extends EducationCreateViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: AppBar(
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
        title: Text(
          'Eğitim Bilgisi Oluştur',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Outfit',
                letterSpacing: 0.0,
              ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 0.0,
      ),
      body: Form(
        key: scaffoldKey,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: ListView(
            children: <Widget>[
              // select education type
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: <Widget>[
                    // label
                    SizedBox(
                      width: dynamicViewExtensions.maxWidth(context),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Eğitim Seviyesi',
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ),
                    ),
                    // select
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: <Widget>[
                          // highschool
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 1,
                            child: Row(
                              children: <Widget>[
                                Radio<EducationCreateType>(
                                  value: EducationCreateType.highSchool,
                                  groupValue: selectEducationType,
                                  onChanged: (value) {
                                    selectEducationType = value;
                                    selectedSchool = null;
                                    updateFilteredSchools();
                                    setState(() {});
                                  },
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      'Lise',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // university
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 1,
                            child: Row(
                              children: <Widget>[
                                Radio<EducationCreateType>(
                                  value: EducationCreateType.university,
                                  groupValue: selectEducationType,
                                  onChanged: (value) {
                                    selectEducationType = value;
                                    selectedSchool = null;
                                    updateFilteredSchools();
                                    setState(() {});
                                  },
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      'Üniversite',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // school
              // Padding(
              //   padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0.0),
              //   child: Row(
              //     mainAxisSize: MainAxisSize.max,
              //     children: [
              //       Expanded(
              //         child: TextFormField(
              //           controller: schoolNameTextController,
              //           focusNode: schoolNameFocusNode,
              //           textCapitalization: TextCapitalization.words,
              //           obscureText: false,
              //           decoration: InputDecoration(
              //             isDense: false,
              //             labelText:
              //                 '${selectEducationType == EducationCreateType.highSchool ? 'Lise' : 'Üniversite'} Adı',
              //             labelStyle:
              //                 FlutterFlowTheme.of(context).labelMedium.override(
              //                       fontFamily: 'Figtree',
              //                       letterSpacing: 0.0,
              //                     ),
              //             enabledBorder: UnderlineInputBorder(
              //               borderSide: BorderSide(
              //                 color: FlutterFlowTheme.of(context).alternate,
              //                 width: 2.0,
              //               ),
              //               borderRadius: const BorderRadius.only(
              //                 topLeft: Radius.circular(4.0),
              //                 topRight: Radius.circular(4.0),
              //               ),
              //             ),
              //             focusedBorder: UnderlineInputBorder(
              //               borderSide: BorderSide(
              //                 color: FlutterFlowTheme.of(context).primary,
              //                 width: 2.0,
              //               ),
              //               borderRadius: const BorderRadius.only(
              //                 topLeft: Radius.circular(4.0),
              //                 topRight: Radius.circular(4.0),
              //               ),
              //             ),
              //             errorBorder: UnderlineInputBorder(
              //               borderSide: BorderSide(
              //                 color: FlutterFlowTheme.of(context).error,
              //                 width: 2.0,
              //               ),
              //               borderRadius: const BorderRadius.only(
              //                 topLeft: Radius.circular(4.0),
              //                 topRight: Radius.circular(4.0),
              //               ),
              //             ),
              //             focusedErrorBorder: UnderlineInputBorder(
              //               borderSide: BorderSide(
              //                 color: FlutterFlowTheme.of(context).error,
              //                 width: 2.0,
              //               ),
              //               borderRadius: const BorderRadius.only(
              //                 topLeft: Radius.circular(4.0),
              //                 topRight: Radius.circular(4.0),
              //               ),
              //             ),
              //             contentPadding: EdgeInsetsDirectional.fromSTEB(
              //                 0.0, 12.0, 0.0, 16.0),
              //           ),
              //           style: FlutterFlowTheme.of(context)
              //               .headlineMedium
              //               .override(
              //                 fontFamily: 'Outfit',
              //                 letterSpacing: 0.0,
              //               ),
              //           minLines: 1,
              //           cursorColor: FlutterFlowTheme.of(context).primary,
              //           validator: (val) {
              //             if (val == null || val.isEmpty) {
              //               return 'Zorunlu Alan';
              //             }
              //             return null;
              //           },
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: isSchoolLoading
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : filteredSchools.isEmpty
                              ? Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    'Bu eğitim seviyesi için kayıtlı okul bulunamadı',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Figtree',
                                          color: FlutterFlowTheme.of(context).error,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                )
                              : InkWell(
                                  onTap: showSchoolSelectionBottomSheet,
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      isDense: false,
                                      labelText:
                                          '${selectEducationType == EducationCreateType.highSchool ? 'Lise' : 'Üniversite'} Seçin',
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
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                    ),
                                    child: Text(
                                      selectedSchool?.name ?? '',
                                      style: selectedSchool != null
                                          ? FlutterFlowTheme.of(context).headlineMedium.override(
                                                fontFamily: 'Outfit',
                                                letterSpacing: 0.0,
                                              )
                                          : FlutterFlowTheme.of(context).labelMedium.override(
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
              const SizedBox(
                height: 23,
              ),
              //  date
              Container(
                padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    // selected dates
                    Row(
                      children: <Widget>[
                        // date one
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              // label
                              SizedBox(
                                width: dynamicViewExtensions.maxWidth(context),
                                child: Text(
                                  'Giriş Yılı',
                                  style: FlutterFlowTheme.of(context).bodyMedium,
                                ),
                              ),
                              // date
                              GestureDetector(
                                onTap: () => selectDateTimeEntry(),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.date_range,
                                        size: 21,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Text(
                                            '${selectedDateTimeEntry.year}',
                                            style: FlutterFlowTheme.of(context).bodyMedium,
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
                        //  date second
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              // label
                              SizedBox(
                                width: dynamicViewExtensions.maxWidth(context),
                                child: Text(
                                  'Mezuniyet Yılı',
                                  style: FlutterFlowTheme.of(context).bodyMedium,
                                ),
                              ),
                              // date
                              GestureDetector(
                                onTap: () {
                                  if (isEducation == false) {
                                    selectDateTimeGraduation();
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.date_range,
                                        size: 21,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Text(
                                            '${selectedDateTimeGraduation.year}',
                                            style: isEducation == false
                                                ? FlutterFlowTheme.of(context).bodyMedium
                                                : FlutterFlowTheme.of(context).labelMedium,
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
                      ],
                    ),
                    // checkbox
                    Row(
                      children: <Widget>[
                        Checkbox(
                          activeColor: FlutterFlowTheme.of(context).primary,
                          value: isEducation,
                          onChanged: (val) {
                            setState(() {
                              isEducation = val!;
                            });
                          },
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'Eğitimim Devam Ediyor',
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // chapter
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: chapterTextController,
                        focusNode: chapterFocusNode,
                        textCapitalization: TextCapitalization.words,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: false,
                          labelText: 'Bölüm',
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
                          contentPadding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 16.0),
                        ),
                        style: FlutterFlowTheme.of(context).headlineMedium.override(
                              fontFamily: 'Outfit',
                              letterSpacing: 0.0,
                            ),
                        minLines: 1,
                        cursorColor: FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ],
                ),
              ),
              // save button
              Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: FFButtonWidget(
                  onPressed: () async {
                    if (scaffoldKey.currentState!.validate()) {
                      if (selectedSchool != null) {
                        await FirebaseFirestore.instance.collection('education_information').add({
                          'id': null,
                          'user_ref': currentUserReference,
                          'school_name': selectedSchool!.name,
                          'school_ref': FirebaseFirestore.instance
                              .collection('school')
                              .doc(selectedSchool!.id),
                          'chapter': chapterTextController.text,
                          'date_entry': selectedDateTimeEntry.year,
                          'date_graduation': selectedDateTimeGraduation.year,
                          'is_continues': isEducation,
                          'is_education_type':
                              selectEducationType == EducationCreateType.highSchool ? false : true,
                          'created_at': FieldValue.serverTimestamp(),
                          'is_deleted': false,
                        }).then((val) async {
                          await val.update({'id': val.id});
                          Navigator.pop(context);
                          await CodeNoahDialogs(context).showFlush(
                            type: SnackType.success,
                            message: 'Değişim Yılı Eğitim Bilgisi Oluşturuldu',
                          );
                        }).catchError((err) {
                          print(err);
                          Navigator.pop(context);
                          CodeNoahDialogs(context).showFlush(
                            type: SnackType.warning,
                            message: 'Hata oluştu, lütfen daha sonra tekrar deneyiniz',
                          );
                        });
                      } else {
                        CodeNoahDialogs(context).showFlush(
                          type: SnackType.warning,
                          message: 'Lütfen gerekli alanları doldurunuz!',
                        );
                      }
                    }
                  },
                  text: 'Eğitim Bilgisi Oluştur',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 50.0,
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
    );
  }
}
