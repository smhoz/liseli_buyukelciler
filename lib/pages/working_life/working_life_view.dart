import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sosyal_medya/auth/firebase_auth/auth_util.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_icon_button.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_theme.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_util.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_widgets.dart';
import 'package:sosyal_medya/helper/show_dialogs.dart';
import 'package:sosyal_medya/pages/working_life/model/working_life_model.dart';
import 'package:sosyal_medya/pages/working_life/view/working_life_create/working_life_create_view.dart';
import 'package:sosyal_medya/pages/working_life/view/working_life_edit/working_life_edit_view.dart';
import 'package:sosyal_medya/pages/working_life/working_life_viewmodel.dart';

class WorkingLifeView extends StatefulWidget {
  const WorkingLifeView({super.key});

  @override
  State<WorkingLifeView> createState() => _WorkingLifeViewState();
}

class _WorkingLifeViewState extends WorkingLifeViewModel {
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
          'Çalışma Hayatı',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Outfit',
                letterSpacing: 0.0,
              ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            // body
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('working_life')
                    .where('user_ref', isEqualTo: currentUserReference)
                    .where('is_deleted', isEqualTo: false)
                    .orderBy('created_at', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const SizedBox();
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasData) {
                    List<WorkingLifeModel> educationList =
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      final Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;

                      return WorkingLifeModel.fromJson(data);
                    }).toList();

                    return ListView.builder(
                      itemCount: educationList.length,
                      itemBuilder: (context, index) {
                        final model = educationList[index];

                        return GestureDetector(
                          onTap: () {
                            CodeNoahDialogs(context).showModalNewBottom(
                              barrierColor: FlutterFlowTheme.of(context)
                                  .secondaryBackground
                                  .withValues(alpha: 0.4),
                              dynamicViewExtensions,
                              'AYARLAR',
                              dynamicViewExtensions.dynamicHeight(
                                  context, 0.25),
                              [
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    children: <Widget>[
                                      // edit
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  WorkingLifeEditView(
                                                model: model,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 16),
                                          child: Container(
                                            padding: EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(16),
                                                ),
                                                border: Border.all(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 0.5,
                                                )),
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.edit_outlined,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 21,
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                    child: Text(
                                                      'Güncelle',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .copyWith(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                              ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      // delete
                                      GestureDetector(
                                        onTap: () async {
                                          await FirebaseFirestore.instance
                                              .collection('working_life')
                                              .doc(model.id)
                                              .update({
                                            'is_deleted': true
                                          }).then((val) {
                                            Navigator.pop(context);
                                            CodeNoahDialogs(context).showFlush(
                                              type: SnackType.success,
                                              message:
                                                  'Çalışma Bilgisi Silindi',
                                            );
                                          }).catchError((val) {
                                            Navigator.pop(context);
                                            CodeNoahDialogs(context).showFlush(
                                              type: SnackType.warning,
                                              message:
                                                  'Hata oluştu, lütfen daha sonra tekrar deneyiniz',
                                            );
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 16),
                                          child: Container(
                                            padding: EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(16),
                                                ),
                                                border: Border.all(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  width: 0.5,
                                                )),
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.delete_outline,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  size: 21,
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                    child: Text(
                                                      'Sil',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .copyWith(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .error,
                                                              ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                          child: Card(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            margin: EdgeInsets.only(bottom: 16),
                            child: SizedBox(
                              width: dynamicViewExtensions.maxWidth(context),
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 0.5,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16))),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.school_outlined,
                                      size: 21,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Column(
                                          children: <Widget>[
                                            // company
                                            SizedBox(
                                              width: dynamicViewExtensions
                                                  .maxWidth(context),
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 10),
                                                child: Text(
                                                  model.company_name,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium,
                                                ),
                                              ),
                                            ),
                                            // task
                                            SizedBox(
                                              width: dynamicViewExtensions
                                                  .maxWidth(context),
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 10),
                                                child: Text(
                                                  "${model.task}",
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium,
                                                ),
                                              ),
                                            ),
                                            // change year date
                                            SizedBox(
                                              width: dynamicViewExtensions
                                                  .maxWidth(context),
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 10),
                                                child: Text(
                                                  "${model.date_start!.toDate().day.toString().padLeft(2, '0')}.${model.date_start!.toDate().month.toString().padLeft(2, '0')}.${model.date_start!.toDate().year.toString().padLeft(2, '0')} - ${model.is_working == false ? "${model.date_end!.toDate().day.toString().padLeft(2, '0')}.${model.date_end!.toDate().month.toString().padLeft(2, '0')}.${model.date_end!.toDate().year.toString().padLeft(2, '0')}" : 'Devam Ediyor'}",
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium,
                                                ),
                                              ),
                                            ),
                                            // date calculate
                                            SizedBox(
                                              width: dynamicViewExtensions
                                                  .maxWidth(context),
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 10),
                                                child: Text(
                                                  calculateDateDifference(
                                                      model.date_start!
                                                          .toDate(),
                                                      model.date_end!.toDate()),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 21,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
            // footer button
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: FFButtonWidget(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WorkingLifeCreateView(),
                    ),
                  );
                },
                text: 'Çalışma Bilgisi Oluştur',
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
    );
  }
}
