import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/login/screens/login_screen.dart';
import 'package:shreeji_dairy/features/password_management/reset_password/screens/reset_password_screen.dart';
import 'package:shreeji_dairy/features/profile/controllers/profile_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({
    super.key,
  });

  final ProfileController _controller = Get.put(
    ProfileController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorWhite,
      appBar: AppAppbar(
        title: 'Services',
      ),
      body: Padding(
        padding: AppPaddings.p12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeText(),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                ),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return _buildServiceCard(
                    icon: _getIconForService(index),
                    title: _getTitleForService(index),
                    onTap: () => _onServiceTap(index),
                  );
                },
              ),
            ),
            AppButton(
              buttonHeight: 45,
              title: 'Log Out',
              onPressed: () {
                Get.offAll(
                  () => LoginScreen(),
                  transition: Transition.fadeIn,
                  duration: Duration(
                    milliseconds: 500,
                  ),
                );
              },
            ),
            AppSpaces.v60,
            AppSpaces.v10,
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Text(
      'Welcome, User!',
      style: TextStyles.kRegularFredoka(
        fontSize: FontSizes.k30FontSize,
        color: kColorSecondary,
      ),
      textAlign: TextAlign.left,
    );
  }

  void _onServiceTap(int index) {
    switch (index) {
      case 0:
        () {};
        break;
      case 1:
        Get.to(
          () => ResetPasswordScreen(),
          transition: Transition.fadeIn,
          duration: Duration(
            milliseconds: 500,
          ),
        );
        break;
      case 2:
        () {};
        break;
      case 3:
        () {};
        break;
      case 4:
        () {};
        break;
      case 5:
        () {};
        break;
      case 6:
        () {};
        break;
      case 7:
        () {};
        break;
      default:
        () {};
        break;
    }
  }

  IconData _getIconForService(int index) {
    switch (index) {
      case 0:
        return Icons.shopping_bag;
      case 1:
        return Icons.lock_reset;
      case 2:
        return Icons.cloud_upload;
      case 3:
        return Icons.group;
      case 4:
        return Icons.security;
      case 5:
        return Icons.note_add;
      case 6:
        return Icons.history;
      case 7:
        return Icons.fact_check;
      default:
        return Icons.help;
    }
  }

  String _getTitleForService(int index) {
    switch (index) {
      case 0:
        return 'Order Status';
      case 1:
        return 'Reset Password';
      case 2:
        return 'Upload Product Image';
      case 3:
        return 'User Management';
      case 4:
        return 'User Authorisation';
      case 5:
        return 'Credit Note Entry';
      case 6:
        return 'Credit Note Status';
      case 7:
        return 'Credit Note Approval';
      default:
        return 'Service';
    }
  }

  Widget _buildServiceCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            kColorWhite,
            kColorSecondary,
          ],
          radius: 10,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: kColorSecondary,
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: AppPaddings.p14,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30,
                color: kColorSecondary,
              ),
              AppSpaces.v4,
              Text(
                title,
                style: TextStyles.kRegularFredoka(
                  fontSize: FontSizes.k16FontSize,
                  color: kColorTextPrimary,
                ).copyWith(
                  height: 1.25,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
