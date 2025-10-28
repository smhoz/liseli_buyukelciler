import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:sosyal_medya/helper/show_dialogs.dart';
import 'package:sosyal_medya/service/mail_sender_service.dart';
import 'package:sosyal_medya/util/base_utility.dart';
import 'package:sosyal_medya/utils/app_version_util.dart';
import 'package:url_launcher/url_launcher.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'create_account_model.dart';
export 'create_account_model.dart';

enum GenderType { man, women }

class CreateAccountWidget extends StatefulWidget {
  const CreateAccountWidget({super.key});

  static String routeName = 'createAccount';
  static String routePath = '/createAccount';

  @override
  State<CreateAccountWidget> createState() => _CreateAccountWidgetState();
}

class _CreateAccountWidgetState extends State<CreateAccountWidget> with TickerProviderStateMixin {
  late CreateAccountModel _model;

  late bool isAgree = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  GenderType? selectGender = GenderType.man;

  Future<void> sendFcmMessage(accessToken) async {
    try {} catch (e) {
      if (kDebugMode) {
        print('Bildirim:  ${e.toString()}');
      }
    }
  }

  Future<String> getAccessToken() async {
    final jsonString = await rootBundle.loadString(
      'assets/jsons/liseli-buyukelciler-db-firebase-adminsdk-fbsvc-d071931178.json',
    );
    final jsonMap = json.decode(jsonString);
    final accountCredentials = ServiceAccountCredentials.fromJson(jsonMap);
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    final client = await clientViaServiceAccount(accountCredentials, scopes);
    final accessToken = client.credentials.accessToken.data;
    client.close();

    return accessToken;
  }

  @override
  void initState() {
    super.initState();

    _model = createModel(context, () => CreateAccountModel());

    _model.emailTextController ??= TextEditingController();
    _model.emailFocusNode ??= FocusNode();

    _model.passwordTextController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();

    animationsMap.addAll({
      'containerOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: Offset(1.4, 1.4),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'imageOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 400.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 400.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 400.0.ms,
            duration: 400.0.ms,
            begin: Offset(2.0, 2.0),
            end: Offset(1.0, 1.0),
          ),
          RotateEffect(
            curve: Curves.easeInOut,
            delay: 400.0.ms,
            duration: 400.0.ms,
            begin: 0.6,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 400.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, -50.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 400.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 400.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 400.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, 40.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'rowOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 500.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 500.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 500.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, 40.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'rowOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 550.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 550.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 550.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, 40.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 600.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 600.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 600.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, 40.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation4': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 650.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 650.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 650.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, 40.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'rowOnPageLoadAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 700.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 700.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 700.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, 40.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'buttonOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 750.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 750.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 750.0.ms,
            duration: 400.0.ms,
            begin: Offset(0.0, 40.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });

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
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF00ABC0), // Üstteki renk
              Color(0xFF90DEE7), // Alttaki renk
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: BaseUtility.horizontal(BaseUtility.paddingNormalValue),
                child: Center(
                  child: SizedBox(
                    height: 140.0,
                    width: double.infinity,
                    child: SvgPicture.asset(
                      'assets/logo/liseslibuyukelciler-01.svg',
                      color: Colors.white,
                    ).animateOnPageLoad(
                      animationsMap['imageOnPageLoadAnimation']!,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //   colors: [
                    //     Color(0x001A1F24).withValues(alpha: 0.1),
                    //     FlutterFlowTheme.of(context).secondaryBackground
                    //   ],
                    //   stops: [0.0, 0.3],
                    //   begin: AlignmentDirectional(0.0, -1.0),
                    //   end: AlignmentDirectional(0, 1.0),
                    // ),
                    ),
                alignment: AlignmentDirectional(0.0, 0.8),
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxWidth: 600.0,
                  ),
                  decoration: BoxDecoration(),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 44.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              alignment: Alignment.center,
                              padding: EdgeInsetsDirectional.fromSTEB(0, 44.0, 0, 0.0),
                              child: Text(
                                'Hoş geldiniz,',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context).headlineLarge.override(
                                      fontFamily: 'Outfit',
                                      letterSpacing: 0.0,
                                    ),
                              ).animateOnPageLoad(
                                animationsMap['rowOnPageLoadAnimation1']!,
                              )),
                          Container(
                            alignment: Alignment.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 24.0, 21.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Hesabınızı aşağıda oluşturun veya',
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme.of(context).labelMedium.override(
                                              fontFamily: 'Figtree',
                                              letterSpacing: 0.0,
                                              color: const Color.fromARGB(255, 7, 134, 188),
                                            ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          context.pushNamed(
                                            LoginWidget.routeName,
                                            extra: <String, dynamic>{
                                              kTransitionInfoKey: TransitionInfo(
                                                hasTransition: true,
                                                transitionType: PageTransitionType.fade,
                                                duration: Duration(milliseconds: 200),
                                              ),
                                            },
                                          );
                                        },
                                        child: Text(
                                          'Giriş yap',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context).labelMedium.override(
                                                color: Colors.black54,
                                                fontFamily: 'Figtree',
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                      // FFButtonWidget(
                                      //   onPressed: () async {
                                      //     context.pushNamed(
                                      //       LoginWidget.routeName,
                                      //       extra: <String, dynamic>{
                                      //         kTransitionInfoKey:
                                      //             TransitionInfo(
                                      //           hasTransition: true,
                                      //           transitionType:
                                      //               PageTransitionType.fade,
                                      //           duration:
                                      //               Duration(milliseconds: 200),
                                      //         ),
                                      //       },
                                      //     );
                                      //   },
                                      //   text: 'Login',
                                      //   options: FFButtonOptions(
                                      //     width: 70.0,
                                      //     height: 48.0,
                                      //     padding:
                                      //         EdgeInsetsDirectional.fromSTEB(
                                      //             0.0, 0.0, 0.0, 0.0),
                                      //     iconPadding:
                                      //         EdgeInsetsDirectional.fromSTEB(
                                      //             0.0, 0.0, 0.0, 0.0),
                                      //     color: Color(0x00FFFFFF),
                                      //     textStyle: FlutterFlowTheme.of(
                                      //             context)
                                      //         .titleSmall
                                      //         .override(
                                      //           fontFamily: 'Figtree',
                                      //           color:
                                      //               FlutterFlowTheme.of(context)
                                      //                   .primary,
                                      //           fontSize: 14.0,
                                      //           letterSpacing: 0.0,
                                      //         ),
                                      //     elevation: 0.0,
                                      //     borderSide: BorderSide(
                                      //       color: Colors.transparent,
                                      //       width: 1.0,
                                      //     ),
                                      //     borderRadius:
                                      //         BorderRadius.circular(8.0),
                                      //   ),
                                      // ),
                                    ],
                                  ).animateOnPageLoad(animationsMap['rowOnPageLoadAnimation2']!),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3.0,
                                    color: Color(0x33000000),
                                    offset: Offset(
                                      0.0,
                                      1.0,
                                    ),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: TextFormField(
                                controller: _model.emailTextController,
                                focusNode: _model.emailFocusNode,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'E-posta adresiniz...',
                                  labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                        fontFamily: 'Figtree',
                                        letterSpacing: 0.0,
                                      ),
                                  contentPadding:
                                      EdgeInsetsDirectional.symmetric(vertical: 16, horizontal: 16),
                                ),
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Figtree',
                                      letterSpacing: 0.0,
                                      color: Colors.black,
                                    ),
                                cursorColor: FlutterFlowTheme.of(context).primary,
                                validator: _model.emailTextControllerValidator.asValidator(context),
                              ),
                            ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation3']!),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 24.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3.0,
                                    color: Color(0x33000000),
                                    offset: Offset(
                                      0.0,
                                      1.0,
                                    ),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: TextFormField(
                                controller: _model.passwordTextController,
                                focusNode: _model.passwordFocusNode,
                                obscureText: !_model.passwordVisibility,
                                decoration: InputDecoration(
                                  labelText: 'Şifre',
                                  labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                        fontFamily: 'Figtree',
                                        letterSpacing: 0.0,
                                      ),
                                  contentPadding:
                                      EdgeInsetsDirectional.symmetric(vertical: 16, horizontal: 16),
                                  suffixIcon: InkWell(
                                    onTap: () => safeSetState(
                                      () => _model.passwordVisibility = !_model.passwordVisibility,
                                    ),
                                    focusNode: FocusNode(skipTraversal: true),
                                    child: Icon(
                                      _model.passwordVisibility
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      size: 22.0,
                                    ),
                                  ),
                                ),
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Figtree',
                                      letterSpacing: 0.0,
                                      color: Colors.black,
                                    ),
                                cursorColor: FlutterFlowTheme.of(context).primary,
                                validator:
                                    _model.passwordTextControllerValidator.asValidator(context),
                              ),
                            ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation4']!),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          // // select gender
                          // Padding(
                          //   padding: EdgeInsetsDirectional.fromSTEB(
                          //       24.0, 16.0, 24.0, 0),
                          //   child: Column(
                          //     children: <Widget>[
                          //       // label
                          //       SizedBox(
                          //         width: MediaQuery.of(context).size.width,
                          //         child: Padding(
                          //           padding: EdgeInsets.only(
                          //             bottom: 16,
                          //           ),
                          //           child: Text(
                          //             'Cinsiyet Seçimi',
                          //             style: Theme.of(context)
                          //                 .textTheme
                          //                 .bodyMedium!
                          //                 .copyWith(
                          //                   color: Colors.white,
                          //                   fontWeight: FontWeight.bold,
                          //                 ),
                          //           ),
                          //         ),
                          //       ),
                          //       // select
                          //       Row(
                          //         children: <Widget>[
                          //           Flexible(
                          //             fit: FlexFit.tight,
                          //             flex: 1,
                          //             child: Padding(
                          //               padding: EdgeInsets.all(10),
                          //               child: Row(
                          //                 children: <Widget>[
                          //                   Radio<GenderType>(
                          //                     groupValue: selectGender,
                          //                     activeColor: Colors.white,
                          //                     value: GenderType.man,
                          //                     onChanged: (GenderType? value) {
                          //                       setState(() {
                          //                         selectGender = value;
                          //                       });
                          //                     },
                          //                   ),
                          //                   Expanded(
                          //                     child: Text(
                          //                       'Erkek',
                          //                       style:
                          //                           FlutterFlowTheme.of(context)
                          //                               .bodyMedium
                          //                               .copyWith(
                          //                                 color: Colors.white,
                          //                                 fontWeight:
                          //                                     FontWeight.bold,
                          //                               ),
                          //                     ),
                          //                   ),
                          //                 ],
                          //               ),
                          //             ),
                          //           ),
                          //           Flexible(
                          //             fit: FlexFit.tight,
                          //             flex: 1,
                          //             child: Row(
                          //               children: <Widget>[
                          //                 Radio<GenderType>(
                          //                   groupValue: selectGender,
                          //                   value: GenderType.women,
                          //                   onChanged: (GenderType? value) {
                          //                     setState(() {
                          //                       selectGender = value;
                          //                     });
                          //                   },
                          //                 ),
                          //                 Expanded(
                          //                   child: Text(
                          //                     'Kadın',
                          //                     style:
                          //                         FlutterFlowTheme.of(context)
                          //                             .bodyMedium
                          //                             .copyWith(
                          //                               color: Colors.white,
                          //                               fontWeight:
                          //                                   FontWeight.bold,
                          //                             ),
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 24.0, 12.0),
                            child: Row(
                              children: <Widget>[
                                // checkbox
                                Checkbox(
                                  activeColor: FlutterFlowTheme.of(context).primary,
                                  value: isAgree,
                                  onChanged: (val) {
                                    setState(() {
                                      isAgree = val!;
                                    });
                                  },
                                ),
                                // text
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      final Uri _url = Uri.parse(
                                          'https://www.liselibuyukelciler.org/mobil_eula.html');

                                      if (!await launchUrl(_url,
                                          mode: LaunchMode.externalApplication)) {
                                        throw 'URL açılamadı: $_url';
                                      }
                                    },
                                    child: Text(
                                      "Sözleşmeyi okudum ve kabul ediyorum.",
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Figtree',
                                            letterSpacing: 0.0,
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 24.0, 12.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FFButtonWidget(
                                  onPressed: () async {
                                    if (isAgree == true) {
                                      GoRouter.of(context).prepareAuthEvent();

                                      final user = await authManager.createAccountWithEmail(
                                        context,
                                        _model.emailTextController.text,
                                        _model.passwordTextController.text,
                                      );

                                      if (user == null) {
                                        return;
                                      } else {
                                        final fcmToken =
                                            await FirebaseMessaging.instance.getToken();
                                        final appVersion = await AppVersionUtil.getAppVersion();

                                        // ignore: unused_local_variable
                                        final accessToken = await getAccessToken();

                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(user.uid)
                                            .update({
                                          'fcm_token': fcmToken ?? '',
                                          'app_version': appVersion,
                                          'bio': '',
                                          'badges': '',
                                          'is_gender':
                                              selectGender == GenderType.man ? true : false,
                                          'is_badge': false,
                                          'is_approval': false,
                                          'engellenen': [],
                                        });

                                        MailSenderService(context)
                                            .sendTemplateEmail(_model.emailTextController.text);

                                        GoRouter.of(context).prepareAuthEvent();
                                        await authManager.signOut();
                                        GoRouter.of(context).clearRedirectLocation();
                                      }

                                      CodeNoahDialogs(context).showFlush(
                                        type: SnackType.success,
                                        message:
                                            'Üye kaydınız oluşturulmuştur. Hesabınız onaylandıktan sonra uygulamaya giriş yapabilirsiniz.',
                                      );
                                    } else {
                                      CodeNoahDialogs(context).showFlush(
                                        type: SnackType.warning,
                                        message:
                                            'Üye olmadan önce sözleşmeyi onaylamanız gerekiyor!',
                                      );
                                    }
                                  },
                                  text: 'Hesap Oluştur',
                                  options: FFButtonOptions(
                                    height: 48.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(32.0, 0.0, 32.0, 0.0),
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
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ],
                            ).animateOnPageLoad(animationsMap['rowOnPageLoadAnimation3']!),
                          ),
                          // Align(
                          //   alignment: AlignmentDirectional(0.0, -1.0),
                          //   child: Padding(
                          //     padding: EdgeInsetsDirectional.fromSTEB(
                          //         2.0, 24.0, 0.0, 12.0),
                          //     child: FFButtonWidget(
                          //       onPressed: () async {
                          //         GoRouter.of(context).prepareAuthEvent();
                          //         final user = await authManager
                          //             .signInAnonymously(context);
                          //         if (user == null) {
                          //           return;
                          //         }

                          //         context.goNamedAuth(MainFeedWidget.routeName,
                          //             context.mounted);
                          //       },
                          //       text: 'Continue as guest',
                          //       options: FFButtonOptions(
                          //         width: 200.0,
                          //         height: 40.0,
                          //         padding: EdgeInsetsDirectional.fromSTEB(
                          //             0.0, 0.0, 0.0, 0.0),
                          //         iconPadding: EdgeInsetsDirectional.fromSTEB(
                          //             0.0, 0.0, 0.0, 0.0),
                          //         color: FlutterFlowTheme.of(context)
                          //             .secondaryBackground,
                          //         textStyle: FlutterFlowTheme.of(context)
                          //             .labelMedium
                          //             .override(
                          //               fontFamily: 'Figtree',
                          //               letterSpacing: 0.0,
                          //             ),
                          //         elevation: 0.0,
                          //         borderSide: BorderSide(
                          //           color:
                          //               FlutterFlowTheme.of(context).alternate,
                          //           width: 2.0,
                          //         ),
                          //         borderRadius: BorderRadius.circular(8.0),
                          //       ),
                          //     ).animateOnPageLoad(
                          //         animationsMap['buttonOnPageLoadAnimation']!),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation2']!),
            ),
          ],
        ),
      ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation1']!),
    );
  }
}
