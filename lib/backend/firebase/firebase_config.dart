import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyBaMG-INyfbM1NtSdMJLfIr_gW_w0GJMI8',
        appId: '1:707312703311:android:0fa7a526e4121ee74a173a',
        messagingSenderId: '707312703311',
        projectId: 'liseli-buyukelciler-db',
        storageBucket: 'liseli-buyukelciler-db.firebasestorage.app',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
}
