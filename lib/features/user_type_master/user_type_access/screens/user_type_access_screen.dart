import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/user_type_master/user_type_access/controllers/user_type_access_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_date_picker_field.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';

// ignore: must_be_immutable
class UserTypeAccessScreen extends StatefulWidget {
  UserTypeAccessScreen({
    super.key,
    required this.userDesignation,
    required this.userType,
    required this.appAccess,
  });

  final String userDesignation;
  final int userType;
  bool appAccess;

  @override
  State<UserTypeAccessScreen> createState() => _UserTypeAccessScreenState();
}

class _UserTypeAccessScreenState extends State<UserTypeAccessScreen> {
  final UserTypeAccessController _controller = Get.put(
    UserTypeAccessController(),
  );

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    await _controller.getUserTypeAccess(
      userType: widget.userType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: kColorWhite,
          appBar: AppAppbar(
            title: widget.userDesignation,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios,
                size: 25,
                color: kColorTextPrimary,
              ),
            ),
          ),
          body: Padding(
            padding: AppPaddings.combined(
              horizontal: 15.appWidth,
              vertical: 10.appHeight,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AppCard1(
                    child: Padding(
                      padding: AppPaddings.p10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'App Access',
                                style: TextStyles.kMediumFredoka(
                                  color: kColorTextPrimary,
                                ),
                              ),
                              Text(
                                'Allow all ${widget.userDesignation} to access app',
                                style: TextStyles.kRegularFredoka(
                                  color: kColorTextPrimary,
                                  fontSize: FontSizes.k16FontSize,
                                ),
                              )
                            ],
                          ),
                          Switch(
                            value: widget.appAccess,
                            activeColor: kColorWhite,
                            inactiveThumbColor: kColorWhite,
                            inactiveTrackColor: kColorGrey,
                            activeTrackColor: kColorSecondary,
                            onChanged: (value) async {
                              await _controller.setUserTypeAppAccess(
                                userType: widget.userType,
                                appAccess: value,
                              );
                              setState(
                                () {
                                  widget.appAccess = value;
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppSpaces.v10,
                  Visibility(
                    visible: widget.appAccess,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ledger Start',
                              style: TextStyles.kMediumFredoka(
                                fontSize: FontSizes.k18FontSize,
                                color: kColorTextPrimary,
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 0.45.screenWidth,
                                  child: AppDatePickerTextFormField(
                                    dateController:
                                        _controller.ledgerStartDateController,
                                    hintText: 'Ledger Start',
                                    onChanged: (value) {
                                      _controller.setUserTypeLedger(
                                        userType: widget.userType,
                                      );
                                    },
                                  ),
                                ),
                                AppSpaces.h10,
                                InkWell(
                                  onTap: () {
                                    _controller.ledgerStartDateController
                                        .clear();

                                    _controller.setUserTypeLedger(
                                      userType: widget.userType,
                                    );
                                  },
                                  child: Icon(
                                    Icons.clear,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        AppSpaces.v10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ledger End',
                              style: TextStyles.kMediumFredoka(
                                fontSize: FontSizes.k18FontSize,
                                color: kColorTextPrimary,
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 0.45.screenWidth,
                                  child: AppDatePickerTextFormField(
                                    dateController:
                                        _controller.ledgerEndDateController,
                                    hintText: 'Ledger End',
                                    onChanged: (value) {
                                      _controller.setUserTypeLedger(
                                        userType: widget.userType,
                                      );
                                    },
                                  ),
                                ),
                                AppSpaces.h10,
                                InkWell(
                                  onTap: () {
                                    _controller.ledgerEndDateController.clear();

                                    _controller.setUserTypeLedger(
                                      userType: widget.userType,
                                    );
                                  },
                                  child: Icon(
                                    Icons.clear,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        AppSpaces.v10,
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Products",
                                style: TextStyles.kMediumFredoka(
                                  fontSize: FontSizes.k18FontSize,
                                  color: kColorTextPrimary,
                                ),
                              ),
                              Obx(
                                () => Text(
                                  _controller.ledgerDate.value.productDtl,
                                  style: TextStyles.kRegularFredoka(
                                    fontSize: FontSizes.k16FontSize,
                                    color: kColorGrey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          trailing: Obx(
                            () => Switch(
                              value: _controller.ledgerDate.value.product,
                              activeColor: kColorWhite,
                              inactiveThumbColor: kColorWhite,
                              inactiveTrackColor: kColorGrey,
                              activeTrackColor: kColorSecondary,
                              onChanged: (value) async {
                                _controller.setUserTypeLedger(
                                  userType: widget.userType,
                                  product: value,
                                );
                                setState(
                                  () {
                                    _controller.ledgerDate.value.product =
                                        value;
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          leading: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Invoices",
                                style: TextStyles.kMediumFredoka(
                                  fontSize: FontSizes.k18FontSize,
                                  color: kColorTextPrimary,
                                ),
                              ),
                              Obx(
                                () => Text(
                                  _controller.ledgerDate.value.invoiceDtl,
                                  style: TextStyles.kRegularFredoka(
                                    fontSize: FontSizes.k16FontSize,
                                    color: kColorGrey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          trailing: Obx(
                            () => Switch(
                              value: _controller.ledgerDate.value.invoice,
                              activeColor: kColorWhite,
                              inactiveThumbColor: kColorWhite,
                              inactiveTrackColor: kColorGrey,
                              activeTrackColor: kColorSecondary,
                              onChanged: (value) async {
                                _controller.setUserTypeLedger(
                                  userType: widget.userType,
                                  invoice: value,
                                );
                                setState(
                                  () {
                                    _controller.ledgerDate.value.invoice =
                                        value;
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ledger",
                                style: TextStyles.kMediumFredoka(
                                  fontSize: FontSizes.k18FontSize,
                                  color: kColorTextPrimary,
                                ),
                              ),
                              Obx(
                                () => Text(
                                  _controller.ledgerDate.value.ledgerDtl,
                                  style: TextStyles.kRegularFredoka(
                                    fontSize: FontSizes.k16FontSize,
                                    color: kColorGrey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          trailing: Obx(
                            () => Switch(
                              value: _controller.ledgerDate.value.ledger,
                              activeColor: kColorWhite,
                              inactiveThumbColor: kColorWhite,
                              inactiveTrackColor: kColorGrey,
                              activeTrackColor: kColorSecondary,
                              onChanged: (value) async {
                                _controller.setUserTypeLedger(
                                  userType: widget.userType,
                                  ledger: value,
                                );

                                setState(
                                  () {
                                    _controller.ledgerDate.value.ledger = value;
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: widget.appAccess,
                    child: Obx(
                      () => ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _controller.menuAccess.length,
                        itemBuilder: (context, index) {
                          final menuAccess = _controller.menuAccess[index];

                          return Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.all(0),
                                leading: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      menuAccess.menuName,
                                      style: TextStyles.kMediumFredoka(
                                        fontSize: FontSizes.k18FontSize,
                                        color: kColorTextPrimary,
                                      ),
                                    ),
                                    if (menuAccess.subMenu.isEmpty)
                                      Text(
                                        menuAccess.menuDtl,
                                        style: TextStyles.kRegularFredoka(
                                          fontSize: FontSizes.k16FontSize,
                                          color: kColorGrey,
                                        ),
                                      ),
                                  ],
                                ),
                                trailing: Switch(
                                  value: menuAccess.access,
                                  activeColor: kColorWhite,
                                  inactiveThumbColor: kColorWhite,
                                  inactiveTrackColor: kColorGrey,
                                  activeTrackColor: kColorSecondary,
                                  onChanged: (value) async {
                                    await _controller.setUserTypeMenuAccess(
                                      userType: widget.userType,
                                      menuId: menuAccess.menuId,
                                      menuAccess: value,
                                    );
                                    setState(
                                      () {
                                        menuAccess.access = value;

                                        if (!value) {
                                          for (var subMenu
                                              in menuAccess.subMenu) {
                                            subMenu.subMenuAccess = false;
                                          }
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: Column(
                                  children: menuAccess.subMenu.map(
                                    (subMenu) {
                                      return ListTile(
                                        contentPadding: EdgeInsets.all(0),
                                        leading: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              subMenu.subMenuName,
                                              style: TextStyles.kRegularFredoka(
                                                fontSize: FontSizes.k18FontSize,
                                                color: kColorTextPrimary,
                                              ),
                                            ),
                                            Text(subMenu.subMenuDtl,
                                                style:
                                                    TextStyles.kRegularFredoka(
                                                  fontSize:
                                                      FontSizes.k16FontSize,
                                                  color: kColorGrey,
                                                )),
                                          ],
                                        ),
                                        trailing: Switch(
                                          value: subMenu.subMenuAccess,
                                          activeColor: kColorWhite,
                                          inactiveThumbColor: kColorWhite,
                                          inactiveTrackColor: kColorGrey,
                                          activeTrackColor: kColorSecondary,
                                          onChanged: (value) async {
                                            await _controller
                                                .setUserTypeMenuAccess(
                                              userType: widget.userType,
                                              menuId: menuAccess.menuId,
                                              subMenuId: subMenu.subMenuId,
                                              menuAccess: value,
                                            );
                                            setState(
                                              () {
                                                subMenu.subMenuAccess = value;
                                              },
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
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
}
