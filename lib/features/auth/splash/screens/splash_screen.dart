import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/constants/image_constants.dart';
import 'package:shreeji_dairy/features/auth/login/screens/login_screen.dart';
import 'package:shreeji_dairy/features/select_customer/screens/select_customer_screen.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(kVideoSplash)
      ..initialize().then(
        (_) {
          setState(() {});
          _controller.play();

          Future.delayed(
            const Duration(seconds: 3),
            () async {
              if (_controller.value.isInitialized) {
                _controller.pause();
              }

              String? token = await SecureStorageHelper.read('token');

              Future.delayed(
                const Duration(seconds: 1),
                () {
                  if (token != null && token.isNotEmpty) {
                    Get.offAll(
                      () => SelectCustomerScreen(),
                    );
                  } else {
                    Get.offAll(
                      () => LoginScreen(),
                    );
                  }
                },
              );
            },
          );
        },
      );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorWhite,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const SizedBox(),
      ),
    );
  }
}
