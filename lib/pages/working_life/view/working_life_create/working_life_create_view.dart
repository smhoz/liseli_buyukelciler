import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sosyal_medya/auth/firebase_auth/auth_util.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_icon_button.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_theme.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_util.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_widgets.dart';
import 'package:sosyal_medya/helper/show_dialogs.dart'
    show CodeNoahDialogs, SnackType;
import 'package:sosyal_medya/pages/working_life/view/working_life_create/working_life_create_viewmodel.dart';

class WorkingLifeCreateView extends StatefulWidget {
  const WorkingLifeCreateView({super.key});

  @override
  State<WorkingLifeCreateView> createState() => _WorkingLifeCreateViewState();
}

class _WorkingLifeCreateViewState extends WorkingLifeCreateViewModel {
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
          'Çalışma Bilgisi Oluştur',
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
              // school
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: companyNameTextController,
                        focusNode: companyNameFocusNode,
                        textCapitalization: TextCapitalization.words,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: false,
                          labelText: 'Şirket Adı',
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
                          contentPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 12.0, 0.0, 16.0),
                        ),
                        style: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .override(
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
              // state
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: taskNameTextController,
                        focusNode: taskNameFocusNode,
                        textCapitalization: TextCapitalization.words,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: false,
                          labelText: 'Görevi',
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
                          contentPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 12.0, 0.0, 16.0),
                        ),
                        style: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .override(
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
                child: Column(
                  children: <Widget>[
                    // select dates
                    Row(
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
                                  'Başlangıç Tarihi',
                                  style:
                                      FlutterFlowTheme.of(context).bodyMedium,
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
                                            '${selectedDateTimeStart.day.toString().padLeft(2, '0')}.${selectedDateTimeStart.month.toString().padLeft(2, '0')}.${selectedDateTimeStart.year.toString().padLeft(2, '0')}',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
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
                                  'Bitiş Tarihi',
                                  style:
                                      FlutterFlowTheme.of(context).bodyMedium,
                                ),
                              ),
                              // date
                              GestureDetector(
                                onTap: () {
                                  if (isWorking == false) {
                                    selectDateTimeEnd();
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
                                            '${selectedDateTimeEnd.day.toString().padLeft(2, '0')}.${selectedDateTimeEnd.month.toString().padLeft(2, '0')}.${selectedDateTimeEnd.year}',
                                            style: isWorking == true
                                                ? FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                : FlutterFlowTheme.of(context)
                                                    .bodyMedium,
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
                    // is working check
                    Row(
                      children: <Widget>[
                        Checkbox(
                          activeColor: FlutterFlowTheme.of(context).primary,
                          value: isWorking,
                          onChanged: (val) {
                            setState(() {
                              isWorking = val!;
                            });
                          },
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'Çalışmaya devam ediyorum',
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                          ),
                        ),
                      ],
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
                      await FirebaseFirestore.instance
                          .collection('working_life')
                          .add({
                        'id': null,
                        'user_ref': currentUserReference,
                        'company_name': companyNameTextController.text,
                        'task': taskNameTextController.text,
                        'date_start': selectedDateTimeStart,
                        'date_end': selectedDateTimeEnd,
                        'is_working': isWorking,
                        'created_at': FieldValue.serverTimestamp(),
                        'is_deleted': false,
                      }).then((val) async {
                        await val.update({'id': val.id});
                        Navigator.pop(context);
                        await CodeNoahDialogs(context).showFlush(
                          type: SnackType.success,
                          message: 'Çalışma Bilgisi Oluşturuldu',
                        );
                      }).catchError((err) {
                        print(err);
                        Navigator.pop(context);
                        CodeNoahDialogs(context).showFlush(
                          type: SnackType.warning,
                          message:
                              'Hata oluştu, lütfen daha sonra tekrar deneyiniz',
                        );
                      });
                    }
                  },
                  text: 'Kaydet',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 50.0,
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
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
