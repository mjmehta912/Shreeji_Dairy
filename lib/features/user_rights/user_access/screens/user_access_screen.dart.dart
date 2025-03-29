import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/user_rights/user_access/controllers/user_access_controller.dart';
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
class UserAccessScreen extends StatefulWidget {
  UserAccessScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.userId,
    required this.appAccess,
  });

  final String firstName;
  final String lastName;
  final int userId;
  bool appAccess;

  @override
  State<UserAccessScreen> createState() => _UserAccessScreenState();
}

class _UserAccessScreenState extends State<UserAccessScreen> {
  final UserAccessController _controller = Get.put(
    UserAccessController(),
  );

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    await _controller.getUserAccess(
      userId: widget.userId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: kColorWhite,
          appBar: AppAppbar(
            title: '${widget.firstName} ${widget.lastName}',
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
                                'Allow user to access app',
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
                              await _controller.setAppAccess(
                                userId: widget.userId,
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
                                      _controller.setLedger(
                                        userId: widget.userId,
                                      );
                                    },
                                  ),
                                ),
                                AppSpaces.h10,
                                InkWell(
                                  onTap: () {
                                    _controller.ledgerStartDateController
                                        .clear();

                                    _controller.setLedger(
                                      userId: widget.userId,
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
                                      _controller.setLedger(
                                        userId: widget.userId,
                                      );
                                    },
                                  ),
                                ),
                                AppSpaces.h10,
                                InkWell(
                                  onTap: () {
                                    _controller.ledgerEndDateController.clear();

                                    _controller.setLedger(
                                      userId: widget.userId,
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
                          leading: Text(
                            "Products",
                            style: TextStyles.kMediumFredoka(
                              fontSize: FontSizes.k18FontSize,
                              color: kColorTextPrimary,
                            ),
                          ),
                          trailing: Obx(
                            () => Switch(
                              value: _controller.ledgerDate.value.product,
                              activeColor: kColorWhite,
                              inactiveThumbColor: kColorWhite,
                              inactiveTrackColor: kColorGrey,
                              activeTrackColor: kColorSecondary,
                              onChanged: (value) async {
                                _controller.setLedger(
                                  userId: widget.userId,
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
                          leading: Text(
                            "Invoices",
                            style: TextStyles.kMediumFredoka(
                              fontSize: FontSizes.k18FontSize,
                              color: kColorTextPrimary,
                            ),
                          ),
                          trailing: Obx(
                            () => Switch(
                              value: _controller.ledgerDate.value.invoice,
                              activeColor: kColorWhite,
                              inactiveThumbColor: kColorWhite,
                              inactiveTrackColor: kColorGrey,
                              activeTrackColor: kColorSecondary,
                              onChanged: (value) async {
                                _controller.setLedger(
                                  userId: widget.userId,
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
                          leading: Text(
                            "Ledger",
                            style: TextStyles.kMediumFredoka(
                              fontSize: FontSizes.k18FontSize,
                              color: kColorTextPrimary,
                            ),
                          ),
                          trailing: Obx(
                            () => Switch(
                              value: _controller.ledgerDate.value.ledger,
                              activeColor: kColorWhite,
                              inactiveThumbColor: kColorWhite,
                              inactiveTrackColor: kColorGrey,
                              activeTrackColor: kColorSecondary,
                              onChanged: (value) async {
                                _controller.setLedger(
                                  userId: widget.userId,
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
                                leading: Text(
                                  menuAccess.menuName,
                                  style: TextStyles.kMediumFredoka(
                                    fontSize: FontSizes.k18FontSize,
                                    color: kColorTextPrimary,
                                  ),
                                ),
                                trailing: Switch(
                                  value: menuAccess.access,
                                  activeColor: kColorWhite,
                                  inactiveThumbColor: kColorWhite,
                                  inactiveTrackColor: kColorGrey,
                                  activeTrackColor: kColorSecondary,
                                  onChanged: (value) async {
                                    await _controller.setMenuAccess(
                                      userId: widget.userId,
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
                              if (menuAccess.access &&
                                  menuAccess.subMenu.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Column(
                                    children: menuAccess.subMenu.map(
                                      (subMenu) {
                                        return ListTile(
                                          contentPadding: EdgeInsets.all(0),
                                          leading: Text(
                                            subMenu.subMenuName,
                                            style: TextStyles.kRegularFredoka(
                                              fontSize: FontSizes.k18FontSize,
                                              color: kColorTextPrimary,
                                            ),
                                          ),
                                          trailing: Switch(
                                            value: subMenu.subMenuAccess,
                                            activeColor: kColorWhite,
                                            inactiveThumbColor: kColorWhite,
                                            inactiveTrackColor: kColorGrey,
                                            activeTrackColor: kColorSecondary,
                                            onChanged: menuAccess.access
                                                ? (value) async {
                                                    await _controller
                                                        .setMenuAccess(
                                                      userId: widget.userId,
                                                      menuId: menuAccess.menuId,
                                                      subMenuId:
                                                          subMenu.subMenuId,
                                                      menuAccess: value,
                                                    );
                                                    setState(
                                                      () {
                                                        subMenu.subMenuAccess =
                                                            value;
                                                      },
                                                    );
                                                  }
                                                : null,
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
