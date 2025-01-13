import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/auth/splash/screens/splash_screen.dart';
import 'package:shreeji_dairy/utils/helpers/fcm_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyB3DOjpOOz-IO1h-uK3XTnUAem5nDojr1c',
        appId: '1:960139130236:android:1d8c8b4c19c988d8a3a0f9',
        messagingSenderId: '960139130236',
        projectId: 'mm-app-5d8be',
        storageBucket: 'mm-app-5d8be.firebasestorage.app',
      ),
    );

    await FCMHelper.initialize();
  }

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  ).then(
    (_) {
      runApp(
        const MyApp(),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
