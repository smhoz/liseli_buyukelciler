import 'package:flutter/material.dart';
import 'package:sosyal_medya/auth/firebase_auth/auth_util.dart';
import 'package:sosyal_medya/backend/schema/index.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_icon_button.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_theme.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_util.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_widgets.dart';
import 'package:sosyal_medya/helper/show_dialogs.dart';
import 'package:sosyal_medya/pages/education_information/education_information_viewmodel.dart';
import 'package:sosyal_medya/pages/education_information/model/education_information_model.dart';
import 'package:sosyal_medya/pages/education_information/view/education_information_create/education_information_create_view.dart';
import 'package:sosyal_medya/pages/education_information/view/education_information_edit/education_information_edit_view.dart';

class EducationInformationView extends StatefulWidget {
  const EducationInformationView({super.key});
  static String routeName = 'education_information';
  static String routePath = '/educationInfrmation';

  @override
  State<EducationInformationView> createState() => _EducationInformationViewState();
}

class _EducationInformationViewState extends EducationInformationViewModel {
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
          'Değişim Yılı Eğitim Bilgileri',
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
                    .collection('education_year_change')
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
                    List<EducationInformationModel> educationList =
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      final Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                      return EducationInformationModel.fromJson(data);
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
                              dynamicViewExtensions.dynamicHeight(context, 0.25),
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
                                              builder: (context) => EducationInformationEditView(
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
                                                color: FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(16),
                                                ),
                                                border: Border.all(
                                                  color: FlutterFlowTheme.of(context).primary,
                                                  width: 0.5,
                                                )),
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.edit_outlined,
                                                  color: FlutterFlowTheme.of(context).primary,
                                                  size: 21,
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                                    child: Text(
                                                      'Güncelle',
                                                      style: FlutterFlowTheme.of(context)
                                                          .bodyMedium
                                                          .copyWith(
                                                            color: FlutterFlowTheme.of(context)
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
                                              .collection('education_year_change')
                                              .doc(model.id)
                                              .update({'is_deleted': true}).then((val) {
                                            Navigator.pop(context);
                                            CodeNoahDialogs(context).showFlush(
                                              type: SnackType.success,
                                              message: 'Değişim Yılı Eğitim Bilgisi Silindi',
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
                                                color: FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(16),
                                                ),
                                                border: Border.all(
                                                  color: FlutterFlowTheme.of(context).error,
                                                  width: 0.5,
                                                )),
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.delete_outline,
                                                  color: FlutterFlowTheme.of(context).error,
                                                  size: 21,
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                                    child: Text(
                                                      'Sil',
                                                      style: FlutterFlowTheme.of(context)
                                                          .bodyMedium
                                                          .copyWith(
                                                            color:
                                                                FlutterFlowTheme.of(context).error,
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
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            margin: EdgeInsets.only(bottom: 16),
                            child: SizedBox(
                              width: dynamicViewExtensions.maxWidth(context),
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(16))),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.school_outlined,
                                      size: 21,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        child: Column(
                                          children: <Widget>[
                                            // school name
                                            SizedBox(
                                              width: dynamicViewExtensions.maxWidth(context),
                                              child: Padding(
                                                padding: EdgeInsets.only(bottom: 10),
                                                child: Text(
                                                  model.school_name ?? 'Okul bilgisi yok',
                                                  style: FlutterFlowTheme.of(context).bodyMedium,
                                                ),
                                              ),
                                            ),

                                            // state and class

                                            SizedBox(
                                              width: dynamicViewExtensions.maxWidth(context),
                                              child: Padding(
                                                padding: EdgeInsets.only(bottom: 10),
                                                child: Text(
                                                  '${model.state_name ?? 'Şehir bilgisi yok'} / ${model.class_name ?? 'Sınıf bilgisi yok'}',
                                                  style: FlutterFlowTheme.of(context).bodyMedium,
                                                ),
                                              ),
                                            ),

                                            // country with flag
                                            if (model.country_name != null ||
                                                model.country_code != null)
                                              SizedBox(
                                                width: dynamicViewExtensions.maxWidth(context),
                                                child: Padding(
                                                  padding: EdgeInsets.only(bottom: 10),
                                                  child: Row(
                                                    children: [
                                                      if (model.country_code != null)
                                                        Padding(
                                                          padding: EdgeInsets.only(right: 8),
                                                          child: Text(
                                                            getCountryFlag(model.country_code!),
                                                            style: TextStyle(fontSize: 20),
                                                          ),
                                                        ),
                                                      Text(
                                                        model.country_name ?? 'Ülke bilgisi yok',
                                                        style:
                                                            FlutterFlowTheme.of(context).bodyMedium,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            // change year date
                                            SizedBox(
                                              width: dynamicViewExtensions.maxWidth(context),
                                              child: Padding(
                                                padding: EdgeInsets.only(bottom: 10),
                                                child: Text(
                                                  "${model.date_start ?? 'Başlangıç bilinmiyor'} - ${model.date_end ?? 'Bitiş bilinmiyor'}",
                                                  style: FlutterFlowTheme.of(context).bodyMedium,
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
                      builder: (context) => const EducationInformationCreateView(),
                    ),
                  );
                },
                text: 'Değişim Yılı Eğitim Bilgisi Oluştur',
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
    );
  }
}
