import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/features/login/screens/login_screen.dart';
import 'package:shreeji_dairy/features/onboarding/controllers/onboarding_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/app_paddings.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({
    super.key,
  });

  final OnboardingController _controller = Get.put(
    OnboardingController(),
  );
  final PageController pageController = PageController();

  final Duration _animationDuration = const Duration(
    milliseconds: 500,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: _controller.images.length,
            onPageChanged: (pageIndex) {
              _controller.currentPage.value = pageIndex;
            },
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    _controller.images[index],
                    fit: BoxFit.cover,
                  ),
                  Container(
                    color: kColorBlackWithOpacity,
                  ),
                ],
              );
            },
          ),
          Padding(
            padding: AppPaddings.ph20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 0.075.screenHeight,
                ),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _controller.images.length,
                      (index) => AnimatedContainer(
                        duration: _animationDuration,
                        curve: Curves.easeInOut,
                        margin: AppPaddings.ph4,
                        height: 5,
                        width: _controller.currentPage.value == index
                            ? 0.25.screenWidth
                            : 0.125.screenWidth,
                        decoration: BoxDecoration(
                          color: _controller.currentPage.value == index
                              ? Colors.white
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.6.screenHeight,
                ),
                Obx(
                  () => AnimatedSwitcher(
                    duration: _animationDuration,
                    child: Text(
                      _controller.descriptions[_controller.currentPage.value],
                      key: ValueKey<int>(_controller.currentPage.value),
                      style: TextStyles.kLightFredoka(
                        fontSize: FontSizes.k36FontSize,
                        color: kColorWhite,
                      ).copyWith(
                        height: 1.25,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.05.screenHeight,
                ),
                Obx(
                  () => AnimatedSwitcher(
                    duration: _animationDuration,
                    child: _controller.currentPage.value ==
                            _controller.images.length - 1
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              AppButton(
                                key: const ValueKey('Start_Button'),
                                buttonWidth: 0.5.screenWidth,
                                title: 'Let\'s Start',
                                onPressed: () {
                                  Get.offAll(
                                    () => LoginScreen(),
                                    transition: Transition.fadeIn,
                                    duration: _animationDuration,
                                  );
                                },
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
