import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/constants/image_constants.dart';
import 'package:shreeji_dairy/features/auth/reset_password/screens/reset_password_screen.dart';
import 'package:shreeji_dairy/features/profile/controllers/profile_controller.dart';
import 'package:shreeji_dairy/features/select_customer/screens/select_customer_screen.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({
    super.key,
    required this.pCode,
    required this.pName,
  });

  final String pCode;
  final String pName;

  final ProfileController _controller = Get.put(
    ProfileController(),
  );

  List<Map<String, dynamic>> get services {
    List<Map<String, dynamic>> availableServices = [];

    if (_controller.userType.value == '0' ||
        _controller.userType.value == '1') {
      availableServices.add(
        {
          "icon": kIconResetPassword,
          "title": 'Change Customer',
        },
      );
    }

    availableServices.addAll([
      {"icon": kIconResetPassword, "title": 'Reset Password'},
      {"icon": kIconOrderStatus, "title": 'Order Status'},
      {"icon": kIconUploadProductImage, "title": 'Upload Product Image'},
      {"icon": kIconUserManagement, "title": 'User Management'},
      {"icon": kIconUserAuthorisation, "title": 'User Authorisation'},
      {"icon": kIconCreditNoteEntry, "title": 'Credit Note Entry'},
      {"icon": kIconCreditNoteStatus, "title": 'Credit Note Status'},
      {"icon": kIconCreditNoteApproval, "title": 'Credit Note Approval'},
      {"icon": kIconLedgerFilled, "title": 'Outstandings'},
    ]);

    return availableServices;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                AppSpaces.v16,
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.25,
                    ),
                    itemCount: services.length,
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
                    _controller.logoutUser();
                  },
                ),
                AppSpaces.v60,
                AppSpaces.v10,
              ],
            ),
          ),
        ),
        Obx(
          () => AppLoadingOverlay(
            isLoading: _controller.isLoading.value,
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () {
            String fullName =
                '${_controller.firstName.value} ${_controller.lastName.value}';

            return Text(
              'Welcome, $fullName!',
              style: TextStyles.kRegularFredoka(
                fontSize: FontSizes.k30FontSize,
                color: kColorSecondary,
              ),
              textAlign: TextAlign.left,
            );
          },
        ),
      ],
    );
  }

  void _onServiceTap(int index) {
    switch (index) {
      case 0:
        Get.offAll(
          () => SelectCustomerScreen(),
        );
        break;
      case 1:
        Get.to(
          () => ResetPasswordScreen(
            mobileNumber: _controller.mobileNumber.value,
          ),
        );
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
      case 5:
        break;
      case 6:
        break;
      case 7:
        break;
      case 8:
        break;
      case 9:
        break;
      default:
        break;
    }
  }

  String _getIconForService(int index) {
    var service = services[index];
    return service['icon'] ?? kIconHome;
  }

  String _getTitleForService(int index) {
    var service = services[index];
    return service['title'] ?? 'Service';
  }

  Widget _buildServiceCard({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [kColorWhite, kColorSecondary],
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
          padding: AppPaddings.ph10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                height: 30,
                colorFilter: ColorFilter.mode(
                  kColorSecondary,
                  BlendMode.srcIn,
                ),
              ),
              AppSpaces.v4,
              Text(
                title,
                style: TextStyles.kRegularFredoka(
                  fontSize: FontSizes.k18FontSize,
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
