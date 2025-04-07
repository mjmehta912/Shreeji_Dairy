import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/constants/image_constants.dart';
import 'package:shreeji_dairy/features/auth/reset_password/screens/reset_password_screen.dart';
import 'package:shreeji_dairy/features/credit_note/credit_notes/screens/credit_notes_screen.dart';
import 'package:shreeji_dairy/features/credit_note_approval/credit_note_approval_menu/screens/credit_note_approval_menu_screen.dart';
import 'package:shreeji_dairy/features/credit_note_status/screens/credit_note_status_screen.dart';
import 'package:shreeji_dairy/features/notification_master/noifications/screens/notifications_screen.dart';
import 'package:shreeji_dairy/features/order_authorisation/orders/screens/orders_screen.dart';
import 'package:shreeji_dairy/features/order_status/screens/order_status_screen.dart';
import 'package:shreeji_dairy/features/outstandings/screens/outstandings_screen.dart';
import 'package:shreeji_dairy/features/profile/controllers/profile_controller.dart';
import 'package:shreeji_dairy/features/auth/select_customer/screens/select_customer_branch_screen.dart';
import 'package:shreeji_dairy/features/qc_test_parameter/qc_test_parameters/screens/qc_test_para_screen.dart';
import 'package:shreeji_dairy/features/reasons/screens/reasons_screen.dart';
import 'package:shreeji_dairy/features/slot_master/categories/screens/categories_screen.dart';
import 'package:shreeji_dairy/features/store_order/screens/store_order_screen.dart';
import 'package:shreeji_dairy/features/testing_parmeter/testing_parameters/screens/testing_parameters_screen.dart';
import 'package:shreeji_dairy/features/upload_product_image/screens/upload_product_image_screen.dart';
import 'package:shreeji_dairy/features/user_authorization/unauthorized_users/screens/unauthorized_users_screen.dart';
import 'package:shreeji_dairy/features/user_management/all_users/screens/all_users_screen.dart';
import 'package:shreeji_dairy/features/user_rights/users/screens/users_screen.dart';
import 'package:shreeji_dairy/features/user_type_master/user_types/screens/user_types_screen.dart';
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
    required this.cCode,
    required this.deliDateOption,
  });

  final String pCode;
  final String pName;
  final String cCode;
  final String deliDateOption;
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
        "action": () {
          Get.to(
            () => OrderStatusScreen(
              pCode: widget.pCode,
              pName: widget.pName,
            ),
          );
        },
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
        "action": () {
          Get.to(
            () => UploadProductImageScreen(),
          );
        },
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
        "action": () {
          Get.to(
            () => CreditNotesScreen(
              pCode: widget.pCode,
              pName: widget.pName,
            ),
          );
        },
      },
      "Credit Note Status": {
        "icon": kIconCreditStatus,
        "action": () {
          Get.to(
            () => CreditNoteStatusScreen(
              pCode: widget.pCode,
              pName: widget.pName,
            ),
          );
        },
      },
      "Credit Note Approval": {
        "icon": kIconCreditNoteApproval,
        "action": () {
          final creditNoteMenu = _controller.menuAccess.firstWhereOrNull(
            (menu) => menu.menuName == "Credit Note Approval",
          );

          if (creditNoteMenu != null) {
            Get.to(
              () => CreditNoteApprovalMenuScreen(
                subMenus: creditNoteMenu.subMenu,
              ),
            );
          } else {
            Get.snackbar(
              "Access Denied",
              "You don't have access to Credit Note Approval",
            );
          }
        },
      },
      "Store Order": {
        "icon": kIconStoreOrder,
        "action": () async {
          final storePCode = await SecureStorageHelper.read('storePCode');
          if (storePCode == null || storePCode.isEmpty) {
            Get.dialog(
              AlertDialog(
                backgroundColor: kColorWhite,
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
              () => StoreOrderScreen(
                pCode: widget.pCode,
                pName: widget.pName,
                cCode: widget.cCode,
                branchCode: widget.branchCode,
                deliDateOption: widget.deliDateOption,
              ),
            );
          }
        },
      },
      "Testing Parameter": {
        "icon": kIconTestingParameter,
        "action": () {
          Get.to(
            () => TestingParametersScreen(),
          );
        },
      },
      "QC Test Para": {
        "icon": kIconQcTest,
        "action": () {
          Get.to(
            () => QcTestParaScreen(),
          );
        },
      },
      "Reason Master": {
        "icon": kIconReason,
        "action": () {
          Get.to(
            () => ReasonsScreen(),
          );
        },
      },
      "Notification Master": {
        "icon": kIconNotification,
        "action": () {
          Get.to(
            () => NotificationsScreen(),
          );
        },
      },
      "Order Authorization": {
        "icon": kIconOrderAuthorization,
        "action": () {
          Get.to(
            () => OrdersScreen(
              pCode: widget.pCode,
              pName: widget.pName,
            ),
          );
        },
      },
      "Slot Master": {
        "icon": kIconSlotMaster,
        "action": () {
          Get.to(
            () => CategoriesScreen(),
          );
        },
      },
      "Usertype Master": {
        "icon": kIconUserTypeMaster,
        "action": () {
          Get.to(
            () => UserTypesScreen(),
          );
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
    _initialize();
  }

  void _initialize() async {
    await _controller.checkVersion();
    _controller.loadUserInfo();
    await _controller.getUserAccess();
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
                AppSpaces.v10,
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
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
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
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     RichText(
                //       text: TextSpan(
                //         style: TextStyles.kRegularFredoka(
                //           fontSize: FontSizes.k14FontSize,
                //           color: kColorTextPrimary,
                //         ),
                //         children: [
                //           TextSpan(
                //             text: "Developed by ",
                //           ),
                //           TextSpan(
                //             text: "Jinee Infotech",
                //             style: TextStyles.kRegularFredoka(
                //               fontSize: FontSizes.k14FontSize,
                //               color: kColorSecondary,
                //             ).copyWith(
                //               decoration: TextDecoration.underline,
                //               decorationColor: kColorSecondary,
                //             ),
                //             recognizer: TapGestureRecognizer()
                //               ..onTap = () async {
                //                 final Uri url = Uri.parse(
                //                   "https://jinee.in/Default.aspx",
                //                 );
                //                 if (await canLaunchUrl(url)) {
                //                   await launchUrl(
                //                     url,
                //                     mode: LaunchMode.externalApplication,
                //                   );
                //                 }
                //               },
                //           ),
                //           TextSpan(text: "  |  "),
                //           WidgetSpan(
                //             child: FutureBuilder<String>(
                //               future: VersionService.getVersion(),
                //               builder: (context, snapshot) {
                //                 if (snapshot.connectionState ==
                //                     ConnectionState.waiting) {
                //                   return Text(
                //                     "v...",
                //                     style: TextStyles.kRegularFredoka(
                //                       fontSize: FontSizes.k14FontSize,
                //                       color: kColorBlack,
                //                     ),
                //                   );
                //                 } else if (snapshot.hasError) {
                //                   return Text(
                //                     "vError",
                //                     style: TextStyles.kRegularFredoka(
                //                       fontSize: FontSizes.k14FontSize,
                //                       color: kColorRed,
                //                     ),
                //                   );
                //                 } else {
                //                   return Text(
                //                     "v${snapshot.data}",
                //                     style: TextStyles.kRegularFredoka(
                //                       fontSize: FontSizes.k14FontSize,
                //                       color: kColorBlack,
                //                     ),
                //                   );
                //                 }
                //               },
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                // AppSpaces.v60,
                // AppSpaces.v20,
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Card(
        elevation: 3,
        color: kColorWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: AppPaddings.p10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                height: 25,
                colorFilter: ColorFilter.mode(
                  kColorSecondary,
                  BlendMode.srcIn,
                ),
              ),
              AppSpaces.v4,
              Text(
                title,
                style: TextStyles.kRegularFredoka(
                  fontSize: FontSizes.k12FontSize,
                  color: kColorTextPrimary,
                ).copyWith(
                  height: 1.25,
                ),
                maxLines: 3,
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
