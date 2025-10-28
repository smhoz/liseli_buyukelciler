import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:sosyal_medya/helper/show_dialogs.dart';
import 'package:sosyal_medya/util/base_utility.dart';
import 'package:sosyal_medya/service/fcm_topic_service.dart';
import 'package:sosyal_medya/utils/app_version_util.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'login_model.dart';
export 'login_model.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  static String routeName = 'login';
  static String routePath = '/login';

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> with TickerProviderStateMixin {
  late LoginModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

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
    _model = createModel(context, () => LoginModel());

    _model.emailTextController ??= TextEditingController();
    _model.emailFocusNode ??= FocusNode();

    _model.passwordTextController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();

    animationsMap.addAll({
      'containerOnPageLoadAnimation1': AnimationInfo(
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
      'textOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 450.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 450.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 450.0.ms,
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
      'containerOnPageLoadAnimation3': AnimationInfo(
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
      'containerOnPageLoadAnimation4': AnimationInfo(
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
      'rowOnPageLoadAnimation2': AnimationInfo(
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
      'buttonOnPageLoadAnimation': AnimationInfo(
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
              flex: 3,
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
              flex: 4,
              child: Container(
                width: double.infinity,
                // decoration: BoxDecoration(
                //   gradient: LinearGradient(
                //     colors: [
                //       Color(0x001A1F24),
                //       FlutterFlowTheme.of(context).secondaryBackground
                //     ],
                //     stops: [0.0, 0.3],
                //     begin: AlignmentDirectional(0.0, -1.0),
                //     end: AlignmentDirectional(0, 1.0),
                //   ),
                // ),
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxWidth: 570.0,
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
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 89.0, 0.0, 0.0),
                            child: Text(
                              'Tekrar Hoş Geldiniz,',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context).headlineLarge.override(
                                    fontFamily: 'Outfit',
                                    letterSpacing: 0.0,
                                  ),
                            ).animateOnPageLoad(animationsMap['textOnPageLoadAnimation']!),
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsetsDirectional.fromSTEB(0, 10.0, 0, 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Hesabınıza aşağıdan erişin veya',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context).labelMedium.override(
                                        color: const Color.fromARGB(255, 7, 134, 188),
                                        fontFamily: 'Figtree',
                                        letterSpacing: 0.0,
                                      ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context.pushNamed(
                                      CreateAccountWidget.routeName,
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
                                    'Hesap Oluştur',
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

                                //   },
                                //   text: 'Hesap Oluştur',
                                //   options: FFButtonOptions(
                                //     width: 125.0,
                                //     height: 28.0,
                                //     padding: EdgeInsetsDirectional.fromSTEB(
                                //         0.0, 0.0, 0.0, 0.0),
                                //     iconPadding: EdgeInsetsDirectional.fromSTEB(
                                //         0.0, 0.0, 0.0, 0.0),
                                //     color: Color(0x00FFFFFF),
                                //     textStyle: FlutterFlowTheme.of(context)
                                //         .titleSmall
                                //         .override(
                                //           fontFamily: 'Figtree',
                                //           color: FlutterFlowTheme.of(context)
                                //               .accent4,
                                //           fontSize: 14.0,
                                //           letterSpacing: 0.0,
                                //         ),
                                //     elevation: 0.0,
                                //     borderSide: BorderSide(
                                //       color: Colors.transparent,
                                //       width: 1.0,
                                //     ),
                                //     borderRadius: BorderRadius.circular(8.0),
                                //   ),
                                // ),
                              ],
                            ).animateOnPageLoad(animationsMap['rowOnPageLoadAnimation1']!),
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
                                autofillHints: [AutofillHints.email],
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'E-posta adresiniz...',
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                  ),
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
                                keyboardType: TextInputType.emailAddress,
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
                                autofillHints: [AutofillHints.password],
                                obscureText: !_model.passwordVisibility,
                                decoration: InputDecoration(
                                  labelText: 'Şifre',
                                  labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                        fontFamily: 'Figtree',
                                        letterSpacing: 0.0,
                                      ),
                                  hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
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
                                keyboardType: TextInputType.visiblePassword,
                                cursorColor: FlutterFlowTheme.of(context).primary,
                                validator:
                                    _model.passwordTextControllerValidator.asValidator(context),
                              ),
                            ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation4']!),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 24.0, 12.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FFButtonWidget(
                                  onPressed: () async {
                                    context.pushNamed(ForgotPasswordWidget.routeName);
                                  },
                                  text: 'Şifremi Unuttum?',
                                  options: FFButtonOptions(
                                    width: 170.0,
                                    height: 50.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                    color: Colors.white,
                                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                          fontFamily: 'Figtree',
                                          color: FlutterFlowTheme.of(context).primary,
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
                                        ),
                                    elevation: 0.0,
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                FFButtonWidget(
                                  onPressed: () async {
                                    GoRouter.of(context).prepareAuthEvent();
                                    final user = await authManager.signInWithEmail(
                                      context,
                                      _model.emailTextController.text,
                                      _model.passwordTextController.text,
                                    );

                                    if (user == null) {
                                      return;
                                    } else {
                                      final fcmToken = await FirebaseMessaging.instance.getToken();
                                      final appVersion = await AppVersionUtil.getAppVersion();

                                      //final accessToken = await getAccessToken();

                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .update({
                                        'fcm_token': fcmToken ?? '',
                                        'app_version': appVersion,
                                      });

                                      // Subscribe user to FCM topics (non-blocking)
                                      if (user.uid != null && user.uid!.isNotEmpty) {
                                        // Run in background without blocking login
                                        Future.delayed(Duration(seconds: 1), () async {
                                          try {
                                            final fcmTopicService = FcmTopicService();
                                            await fcmTopicService.subscribeUserToTopics(user.uid!);
                                          } catch (e) {
                                            print('❌ Error subscribing to topics: $e');
                                          }
                                        });
                                      }

                                      //////////////////////
                                      ///
                                      ///
                                      ///

                                      // final accessToken =
                                      //     await getAccessToken();

                                      // FirebaseMessaging.onMessage
                                      //     .listen((RemoteMessage message) {
                                      //   if (kDebugMode) {
                                      //     print(
                                      //       "Bildirim Mesaj geldi (ön planda): ${message.notification?.title}",
                                      //     );
                                      //   }

                                      //   RemoteNotification? notification =
                                      //       message.notification;
                                      //   AndroidNotification? android =
                                      //       message.notification?.android;

                                      //   if (notification != null &&
                                      //       android != null) {
                                      //     flutterLocalNotificationsPlugin.show(
                                      //       notification.hashCode,
                                      //       notification.title,
                                      //       notification.body,
                                      //       const NotificationDetails(
                                      //         android:
                                      //             AndroidNotificationDetails(
                                      //           'default_channel_id',
                                      //           'Genel Bildirimler',
                                      //           importance: Importance.max,
                                      //           priority: Priority.high,
                                      //         ),
                                      //       ),
                                      //     );
                                      //   }
                                      // });

                                      // final response = await http.post(
                                      //   Uri.parse(
                                      //     'https://fcm.googleapis.com/v1/projects/socialmedia-test-2bdde/messages:send',
                                      //   ),
                                      //   headers: {
                                      //     'Content-Type': 'application/json',
                                      //     'Authorization':
                                      //         'Bearer $accessToken',
                                      //   },
                                      //   body: jsonEncode({
                                      //     'message': {
                                      //       'token': fcmToken,
                                      //       'notification': {
                                      //         'title':
                                      //             'Liseli Büyükelçiler Mezun Derneği',
                                      //         'body':
                                      //             'Hesabınız Onaylandı, giriş yapabilirsiniz!',
                                      //       },
                                      //     },
                                      //   }),
                                      // );

                                      // if (kDebugMode) {
                                      //   print(
                                      //       'Bildirim: Response: ${response.statusCode}');
                                      //   print(
                                      //       'Bildirim gönderildi: ${response.statusCode}');
                                      //   print(
                                      //       'Bildirim: Yanıt gövdesi: ${response.body}');
                                      // }

                                      //////////////////////

                                      final collection = await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .get();

                                      final bool isApproval =
                                          collection.data()?['is_approval'] ?? false;
                                      final String isBio = collection.data()?['bio'] ?? '';

                                      if (isApproval == true) {
                                        if (isBio.isEmpty) {
                                          context.goNamedAuth(
                                              EditUserProfileWidget.routeName, context.mounted);
                                        } else {
                                          context.goNamedAuth(
                                              MainFeedWidget.routeName, context.mounted);
                                        }
                                      } else {
                                        GoRouter.of(context).prepareAuthEvent();
                                        await authManager.signOut();
                                        GoRouter.of(context).clearRedirectLocation();
                                        CodeNoahDialogs(context).showFlush(
                                          type: SnackType.error,
                                          message:
                                              'Hesabınız henüz onaylanmadı, lütfen daha sonra tekrar deneyiniz.',
                                        );
                                      }
                                    }
                                  },
                                  text: 'Giriş',
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
                            ).animateOnPageLoad(animationsMap['rowOnPageLoadAnimation2']!),
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
