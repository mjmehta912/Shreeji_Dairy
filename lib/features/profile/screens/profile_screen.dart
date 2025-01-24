import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/constants/image_constants.dart';
import 'package:shreeji_dairy/features/auth/reset_password/screens/reset_password_screen.dart';
import 'package:shreeji_dairy/features/outstandings/screens/outstandings_screen.dart';
import 'package:shreeji_dairy/features/profile/controllers/profile_controller.dart';
import 'package:shreeji_dairy/features/auth/select_customer/screens/select_customer_branch_screen.dart';
import 'package:shreeji_dairy/features/store_order/screens/store_order_screen.dart';
import 'package:shreeji_dairy/features/user_authorization/unauthorized_users/screens/unauthorized_users_screen.dart';
import 'package:shreeji_dairy/features/user_management/all_users/screens/all_users_screen.dart';
import 'package:shreeji_dairy/features/user_rights/users/screens/users_screen.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.pCode,
    required this.pName,
    required this.branchCode,
  });

  final String pCode;
  final String pName;
  final String branchCode;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _controller = Get.put(
    ProfileController(),
  );

  Map<String, Map<String, dynamic>> get menuConfig {
    return {
      "Change Customer": {
        "icon": kIconChangeCustomer,
        "action": () {
          Get.offAll(
            () => SelectCustomerBranchScreen(),
          );
        },
      },
      "Reset Password": {
        "icon": kIconResetPassword,
        "action": () {
          Get.to(
            () => ResetPasswordScreen(
              mobileNumber: _controller.mobileNumber.value,
            ),
          );
        },
      },
      "Order Status": {
        "icon": kIconOrderStatus,
        "action": () {},
      },
      "View Outstanding": {
        "icon": kIconViewOutstandings,
        "action": () {
          Get.to(
            () => OutstandingsScreen(
              pCode: widget.pCode,
              pName: widget.pName,
              branchCode: widget.branchCode,
            ),
          );
        },
      },
      "Upload Product Image": {
        "icon": kIconUploadProductImage,
        "action": () {},
      },
      "User Management": {
        "icon": kIconUserManagement,
        "action": () {
          Get.to(
            () => AllUsersScreen(),
          );
        },
      },
      "User Authorisation": {
        "icon": kIconUserAuthorisation,
        "action": () {
          Get.to(
            () => UnauthorizedUsersScreen(),
          );
        },
      },
      "User Rights": {
        "icon": kIconUserRights,
        "action": () {
          Get.to(
            () => UsersScreen(),
          );
        },
      },
      "Credit Note Entry": {
        "icon": kIconCreditNoteEntry,
        "action": () {},
      },
      "Credit Note Status": {
        "icon": kIconCreditNoteStatus,
        "action": () {},
      },
      "Credit Note Approval": {
        "icon": kIconCreditNoteApproval,
        "action": () {},
      },
      "Store Order": {
        "icon": kIconStoreOrder,
        "action": () async {
          final storePCode = await SecureStorageHelper.read('storePCode');
          if (storePCode == null || storePCode.isEmpty) {
            Get.dialog(
              AlertDialog(
                title: Text(
                  'Store Not Registered',
                  style: TextStyles.kMediumFredoka(
                    fontSize: FontSizes.k20FontSize,
                    color: kColorTextPrimary,
                  ),
                ),
                content: Text(
                  'Your store is not registered. Please contact support or register your store to proceed.',
                  style: TextStyles.kRegularFredoka(
                    fontSize: FontSizes.k16FontSize,
                    color: kColorTextPrimary,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      'OK',
                      style: TextStyles.kRegularFredoka(
                        fontSize: FontSizes.k16FontSize,
                        color: kColorSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            Get.to(
              () => StoreOrderScreen(),
            );
          }
        },
      },
    };
  }

  String? getIconPath(String menuName) {
    return menuConfig[menuName]?["icon"];
  }

  VoidCallback? getAction(String menuName) {
    return menuConfig[menuName]?["action"];
  }

  @override
  void initState() {
    super.initState();
    _controller.loadUserInfo();
    _controller.getUserAccess();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: kColorWhite,
          appBar: AppAppbar(
            title: 'Services',
            actions: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _controller.logoutUser();
                    },
                    child: Text(
                      'Logout',
                      style: TextStyles.kRegularFredoka(
                        fontSize: FontSizes.k16FontSize,
                        color: kColorTextPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _controller.logoutUser();
                    },
                    icon: Icon(
                      Icons.logout,
                      color: kColorTextPrimary,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Padding(
            padding: AppPaddings.p12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeText(),
                AppSpaces.v16,
                Obx(
                  () {
                    if (_controller.isLoading.value) {
                      return const SizedBox.shrink();
                    }

                    if (_controller.menuAccess
                            .where(
                              (item) => item.access == true,
                            )
                            .isEmpty &&
                        !_controller.isLoading.value) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            'Services not available',
                            style: TextStyles.kMediumFredoka(
                              color: kColorTextPrimary,
                            ),
                          ),
                        ),
                      );
                    }
                    return Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: _controller.menuAccess
                            .where(
                              (item) => item.access == true,
                            )
                            .length,
                        itemBuilder: (context, index) {
                          final menuItem = _controller.menuAccess
                              .where(
                                (item) => item.access == true,
                              )
                              .toList()[index];

                          return _buildServiceCard(
                            icon: getIconPath(menuItem.menuName) ?? '',
                            title: menuItem.menuName,
                            onTap: getAction(menuItem.menuName) ?? () {},
                          );
                        },
                      ),
                    );
                  },
                ),
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
            return RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        '${_controller.getDynamicGreeting(_controller.userType.value)} \n',
                    style: TextStyles.kLightFredoka(
                      color: kColorTextPrimary,
                    ),
                  ),
                  TextSpan(
                    text:
                        '${_controller.firstName.value} ${_controller.lastName.value}',
                    style: TextStyles.kRegularFredoka(
                      fontSize: FontSizes.k30FontSize,
                      color: kColorSecondary,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.left,
            );
          },
        ),
      ],
    );
  }

  Widget _buildServiceCard({
    required String icon,
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
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: AppPaddings.ph8,
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
