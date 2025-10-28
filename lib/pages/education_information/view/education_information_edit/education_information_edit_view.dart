import 'package:flutter/material.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_icon_button.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_theme.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_util.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_widgets.dart';
import 'package:sosyal_medya/helper/show_dialogs.dart';
import 'package:sosyal_medya/pages/education_information/model/education_information_model.dart';
import 'package:sosyal_medya/pages/education_information/view/education_information_edit/education_information_edit_viewmodel.dart';

class EducationInformationEditView extends StatefulWidget {
  const EducationInformationEditView({
    super.key,
    required this.model,
  });

  final EducationInformationModel model;

  @override
  State<EducationInformationEditView> createState() => _EducationInformationEditViewState();
}

class _EducationInformationEditViewState extends EducationInformationEditViewModel {
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
          'Değişim Yılı Bilgisi Güncelle',
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
              const SizedBox(
                height: 25,
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
              //             labelText: 'Okul',
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
                      child: TextFormField(
                        controller: schoolNameTextController,
                        focusNode: schoolNameFocusNode,
                        textCapitalization: TextCapitalization.words,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: false,
                          labelText: 'Okul',
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
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Zorunlu Alan';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 23,
              ),
              // state
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: stateTextController,
                        focusNode: stateFocusNode,
                        textCapitalization: TextCapitalization.words,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: false,
                          labelText: 'Şehir',
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
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Zorunlu Alan';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 23,
              ),
              // country
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: showCountrySelectionBottomSheet,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            isDense: false,
                            labelText: 'Ülke Seçin',
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
                            suffixIcon: Icon(Icons.arrow_drop_down),
                          ),
                          child: Text(
                            selectedCountry?.name ?? '',
                            style: selectedCountry != null
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
              // Padding(
              //   padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0.0),
              //   child: Row(
              //     mainAxisSize: MainAxisSize.max,
              //     children: [
              //       Expanded(
              //         child: TextFormField(
              //           controller: stateTextController,
              //           focusNode: stateFocusNode,
              //           textCapitalization: TextCapitalization.words,
              //           obscureText: false,
              //           decoration: InputDecoration(
              //             isDense: false,
              //             labelText: 'Şehir',
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
              // class
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: classTextController,
                        focusNode: classFocusNode,
                        textCapitalization: TextCapitalization.words,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: false,
                          labelText: 'Sınıf',
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
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Zorunlu Alan';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // change date
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
                child: Row(
                  children: <Widget>[
                    // start date
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          // label
                          SizedBox(
                            width: dynamicViewExtensions.maxWidth(context),
                            child: Text(
                              'Değişim Yılı Başlangıç',
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                          ),
                          // date
                          GestureDetector(
                            onTap: () => selectDateTimeStart(),
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
                                        '${selectedDateTimeStart.year}',
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
                    // end date
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          // label
                          SizedBox(
                            width: dynamicViewExtensions.maxWidth(context),
                            child: Text(
                              'Değişim Yılı Bitiş',
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                          ),
                          // date
                          GestureDetector(
                            onTap: () => selectDateTimeEnd(),
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
                                        '${selectedDateTimeEnd.year}',
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
                  ],
                ),
              ),
              // save button
              Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: FFButtonWidget(
                  onPressed: () async {
                    if (scaffoldKey.currentState!.validate()) {
                      if (schoolNameTextController.text.isNotEmpty &&
                          stateTextController.text.isNotEmpty &&
                          selectedCountry != null) {
                        await FirebaseFirestore.instance
                            .collection('education_year_change')
                            .doc(widget.model.id)
                            .update({
                          'class_name': classTextController.text,
                          'school_name': schoolNameTextController.text,
                          'state_name': stateTextController.text,
                          'country_name': selectedCountry!.name,
                          'country_code': selectedCountry!.countryCode,
                          'date_start': selectedDateTimeStart.year,
                          'date_end': selectedDateTimeEnd.year,
                        }).then((val) {
                          Navigator.pop(context);
                          CodeNoahDialogs(context).showFlush(
                            type: SnackType.success,
                            message: 'Değişim Yılı Eğitim Bilgisi Güncellendi',
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
                  text: 'Güncelle',
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
