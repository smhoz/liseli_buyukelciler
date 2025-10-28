import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:sosyal_medya/pages/event/event_view.dart';
import 'package:sosyal_medya/service/badge_initializer.dart';
import 'package:sosyal_medya/service/system_user_initializer.dart';
import 'package:sosyal_medya/service/fcm_topic_service.dart';
import 'package:sosyal_medya/utils/app_version_util.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'auth/firebase_auth/firebase_user_provider.dart';
import 'auth/firebase_auth/auth_util.dart';

import 'backend/firebase/firebase_config.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'index.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// FCM sistemi kurulumu
Future<void> setupFCM() async {
  try {
    // Firebase'in tam olarak initialize olmasını bekle
    await Future.delayed(Duration(milliseconds: 1000));

    // Notification permission iste
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('Notification permission: ${settings.authorizationStatus}');

    // iOS için ön planda bildirim gösterme ayarı
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    print('📱 iOS foreground notification presentation options set');

    // FCM token al - network bağlantısı varsa
    String? token;
    int maxRetries = 3;
    int currentRetry = 0;

    while (currentRetry < maxRetries && token == null) {
      try {
        currentRetry++;
        print('FCM Token alma denemesi: $currentRetry');
        token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          print('FCM Token: $token');
        }
      } catch (tokenError) {
        print('Token alma hatası (deneme $currentRetry): $tokenError');
        if (tokenError.toString().contains('network connection was lost') ||
            tokenError.toString().contains('unknown')) {
          print('Network hatası tespit edildi');
          if (defaultTargetPlatform == TargetPlatform.iOS && kDebugMode) {
            print('iOS Simülatör network sorunu - gerçek cihazda düzelecek');
            break;
          }
        }
        if (currentRetry < maxRetries) {
          print('${3 - currentRetry} saniye sonra tekrar deneniyor...');
          await Future.delayed(Duration(seconds: 3));
        }
      }
    }

    if (token == null) {
      if (defaultTargetPlatform == TargetPlatform.iOS && kDebugMode) {
        print('iOS Simülatör: FCM Token alamadık ama notification listener\'lar kurulacak');
      } else {
        print('FCM Token alınamadı. Network bağlantısını kontrol edin.');
      }
    }

    // Genel bildirim dinleyicisi
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📱 Bildirim Mesaj geldi (ön planda): ${message.notification?.title}");
      print("📱 Message data: ${message.data}");
      print("📱 Message data type: ${message.data['type']}");

      RemoteNotification? notification = message.notification;

      if (notification != null) {
        print("📱 Notification is not null");
        print("📱 Notification title: ${notification.title}");
        print("📱 Notification body: ${notification.body}");

        // iOS'ta FCM otomatik gösteriyor (setForegroundNotificationPresentationOptions sayesinde)
        // Android'de manuel göstermemiz gerekiyor
        if (defaultTargetPlatform == TargetPlatform.android) {
          // Rozet bildirimi özel işlemi (badge_earned veya badge_notification)
          if (message.data['type'] == 'badge_earned' ||
              message.data['type'] == 'badge_notification') {
            print("📱 Showing badge notification (Android)...");
            flutterLocalNotificationsPlugin.show(
              message.hashCode,
              notification.title,
              notification.body,
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'badge_channel',
                  'Rozet Bildirimleri',
                  channelDescription: 'Rozet ile ilgili bildirimler',
                  importance: Importance.max,
                  priority: Priority.high,
                  showWhen: false,
                  playSound: true,
                  enableVibration: true,
                ),
              ),
            );
            print("📱 Badge notification shown (Android)!");
          } else {
            print("📱 Showing general notification (Android)...");
            // Genel bildirimler
            flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'default_channel_id',
                  'Genel Bildirimler',
                  importance: Importance.max,
                  priority: Priority.high,
                ),
              ),
            );
            print("📱 General notification shown (Android)!");
          }
        } else {
          print("📱 iOS: FCM otomatik gösteriyor, manuel show() çağrısı yok");
        }
      } else {
        print("📱 Notification is null!");
      }
    });

    // Arkaplan mesajları için handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Uygulama açıldığında bildirime tıklandıysa
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Bildirime tıklandı: ${message.notification?.title}');
      // Burada rozet sayfasına yönlendirme yapılabilir
    });
  } catch (e) {
    print('FCM setup hatası: $e');
  }
}

// Arkaplan mesaj handler'ı
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
    print("Arkaplan bildirimi: ${message.notification?.title}");
  } catch (e) {
    print("Background handler hatası: $e");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();
  timeago.setLocaleMessages('tr', timeago.TrMessages());

  await initFirebase();
  await FlutterFlowTheme.initialize();

  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    ),
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      print('📱 Notification tapped: ${response.payload}');
    },
  );

  // FCM sistemini başlat
  await setupFCM();

  // Varsayılan rozetleri başlat
  await BadgeInitializer.initializeDefaultBadges();

  // System user'ı oluştur (zaten varsa skip eder)
  await SystemUserInitializer.createSystemUser();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.entryPage});

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>()!;

  final Widget? entryPage;
}

class MyAppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch = routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches.map((e) => getRoute(e)).toList();

  late Stream<BaseAuthUser> userStream;

  final authUserSub = authenticatedUserStream.listen((_) {});

  Future<void> requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true, // Bildirim göster
      badge: true, // Uygulama ikonunda badge
      sound: true, // Ses çal
      provisional: false, // Sessiz bildirimler için (iOS 12+)
    );

    print('İzin durumu: ${settings.authorizationStatus}');
  }

  // Future<String> getAccessToken() async {
  //   final jsonString = await rootBundle.loadString(
  //       'assets/jsons/socialmedia-test-2bdde-firebase-adminsdk-fbsvc-165962c626.json');
  //   final jsonMap = json.decode(jsonString);
  //   final accountCredentials = ServiceAccountCredentials.fromJson(jsonMap);
  //   final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

  //   final client = await clientViaServiceAccount(accountCredentials, scopes);
  //   final accessToken = client.credentials.accessToken.data;
  //   client.close();

  //   return accessToken;
  // }

  // Future<void> sendFcmMessage() async {

  //   final response = await http.post(
  //     Uri.parse(
  //         'https://fcm.googleapis.com/v1/projects/socialmedia-test-2bdde/messages:send'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $accessToken',
  //     },
  //     body: jsonEncode({
  //       'message': {
  //         'token': token,
  //         'notification': {
  //           'title': 'Test Bildirim',
  //           'body': 'HTTP v1 API ile gönderildi!',
  //         },
  //       },
  //     }),
  //   );

  //   print('Bildirim: Response: ${response.statusCode}');
  //   print('Bildirim gönderildi: ${response.statusCode}');
  //   print('Bildirim: Yanıt gövdesi: ${response.body}');
  // }

  @override
  void initState() {
    super.initState();
    requestNotificationPermission();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier, widget.entryPage);
    userStream = sosyalMedyaFirebaseUserStream()
      ..listen((user) async {
        _appStateNotifier.update(user);

        // Update app version when user logs in or app starts
        if (user.loggedIn) {
          await _updateUserAppVersion(user.uid);
        }
      });
    jwtTokenStream.listen((_) {});
    Future.delayed(
      Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  /// Update user's app_version in Firestore if needed
  Future<void> _updateUserAppVersion(String? uid) async {
    if (uid == null || uid.isEmpty) return;

    try {
      final appVersion = await AppVersionUtil.getAppVersion();
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!userDoc.exists) return;

      final currentVersion = userDoc.data()?['app_version'] as String?;
      if (currentVersion == null || currentVersion != appVersion) {
        print('📱 Kullanıcı app_version güncelleniyor: $currentVersion -> $appVersion');
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'app_version': appVersion,
        });
      }
    } catch (e) {
      print('❌ App version güncelleme hatası: $e');
    }
  }

  @override
  void dispose() {
    authUserSub.cancel();

    super.dispose();
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Liseli Büyükelçiler Mezun Derneği',
      scrollBehavior: MyAppScrollBehavior(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.dragged)) {
              return Color(4293257195);
            }
            if (states.contains(WidgetState.hovered)) {
              return Color(4293257195);
            }
            return Color(4293257195);
          }),
        ),
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.dragged)) {
              return Color(4281414722);
            }
            if (states.contains(WidgetState.hovered)) {
              return Color(4281414722);
            }
            return Color(4281414722);
          }),
        ),
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

class NavBarPage extends StatefulWidget {
  NavBarPage({Key? key, this.initialPage, this.page}) : super(key: key);

  final String? initialPage;
  final Widget? page;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'main_Feed';
  late Widget? _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'main_Feed': MainFeedWidget(),
      'main_Chat': MainChatWidget(),
      'main_Event': EventView(),
      'main_Profile': MainProfileWidget(),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    return Scaffold(
      body: _currentPage ?? tabs[_currentPageName],
      bottomNavigationBar: Visibility(
        visible: responsiveVisibility(
          context: context,
          tabletLandscape: false,
          desktop: false,
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (i) => safeSetState(() {
            _currentPage = null;
            _currentPageName = tabs.keys.toList()[i];
          }),
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          selectedItemColor: FlutterFlowTheme.of(context).primary,
          unselectedItemColor: FlutterFlowTheme.of(context).secondaryText,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.ssid_chart_rounded,
                size: 24.0,
              ),
              label: '--',
              tooltip: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.forum_outlined,
                size: 24.0,
              ),
              label: '__',
              tooltip: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.event_outlined,
                size: 24.0,
              ),
              label: '__',
              tooltip: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle_outlined,
                size: 24.0,
              ),
              activeIcon: Icon(
                Icons.account_circle,
                size: 24.0,
              ),
              label: '__',
              tooltip: '',
            )
          ],
        ),
      ),
    );
  }
}
