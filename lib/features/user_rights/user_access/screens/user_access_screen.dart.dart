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
    _controller.getUserAccess(
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
                      ],
                    ),
                  ),
                  AppSpaces.v10,
                  Visibility(
                    visible: widget.appAccess,
                    child: Obx(
                      () => ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _controller.menuAccess.length,
                        itemBuilder: (context, index) {
                          final menuAccess = _controller.menuAccess[index];
                          return ListTile(
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
                                  },
                                );
                              },
                            ),
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
