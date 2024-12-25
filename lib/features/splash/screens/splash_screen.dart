import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/constants/image_constants.dart';
import 'package:shreeji_dairy/features/onboarding/screens/onboarding_screen.dart';
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
          setState(
            () {},
          );
          _controller.play();

          Future.delayed(
            const Duration(
              seconds: 3,
            ),
            () {
              if (_controller.value.isInitialized) {
                _controller.pause();
              }

              Future.delayed(
                const Duration(
                  seconds: 1,
                ),
                () {
                  Get.offAll(
                    () => OnboardingScreen(),
                    transition: Transition.fadeIn,
                    duration: const Duration(
                      milliseconds: 500,
                    ),
                  );
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
