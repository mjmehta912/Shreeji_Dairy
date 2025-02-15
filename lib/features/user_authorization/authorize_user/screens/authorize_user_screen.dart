import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/user_authorization/authorize_user/controllers/authorize_user_controller.dart';
import 'package:shreeji_dairy/features/user_authorization/authorize_user/widgets/user_detail_card.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_dropdown.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';

class AuthorizeUserScreen extends StatelessWidget {
  AuthorizeUserScreen({
    super.key,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.business,
    required this.mobileNo,
  });

  final int userId;
  final String firstName;
  final String lastName;
  final String business;
  final String mobileNo;

  final AuthorizeUserController _controller = Get.put(
    AuthorizeUserController(),
  );

  void showCustomersSheet() {
    final RxSet<String> tempSelectedPCodes =
        _controller.selectedPCodes.toSet().obs;
    final RxSet<String> tempSelectedPNames =
        _controller.selectedPNames.toSet().obs;

    _controller.filteredCustomers.assignAll(_controller.customers);
    final TextEditingController searchController = TextEditingController();

    Get.bottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: kColorWhite,
        ),
        padding: AppPaddings.p16,
        constraints: BoxConstraints(
          maxHeight: 0.75.screenHeight,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Customers',
              style: TextStyles.kRegularFredoka(
                fontSize: FontSizes.k20FontSize,
                color: kColorTextPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpaces.v10,
            AppTextFormField(
              controller: searchController,
              hintText: 'Search',
              onChanged: (value) {
                _controller.filterCustomers(value);
              },
            ),
            AppSpaces.v10,
            Expanded(
              child: Obx(
                () => ListView(
                  shrinkWrap: true,
                  children: _controller.filteredCustomers.map(
                    (customer) {
                      return CheckboxListTile(
                        title: Text(
                          customer.pName,
                          style: TextStyles.kRegularFredoka(
                            fontSize: FontSizes.k16FontSize,
                            color: kColorTextPrimary,
                          ),
                        ),
                        contentPadding: EdgeInsets.zero,
                        value: tempSelectedPCodes.contains(customer.pCode),
                        activeColor: kColorSecondary,
                        onChanged: (isSelected) {
                          if (isSelected == true) {
                            tempSelectedPCodes.add(customer.pCode);
                            tempSelectedPNames.add(customer.pName);
                          } else {
                            tempSelectedPCodes.remove(customer.pCode);
                            tempSelectedPNames.remove(customer.pName);
                          }
                        },
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
            AppSpaces.v10,
            AppButton(
              buttonWidth: 0.5.screenWidth,
              buttonHeight: 40,
              buttonColor: kColorPrimary,
              titleColor: kColorTextPrimary,
              onPressed: () {
                _controller.selectedPCodes
                  ..clear()
                  ..addAll(tempSelectedPCodes);

                _controller.selectedPNames
                  ..clear()
                  ..addAll(tempSelectedPNames);

                Get.back();
              },
              title: 'Select',
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void showSelectedCustomersDialog() {
    final selectedPNames = _controller.selectedPNames.toList();

    if (selectedPNames.isEmpty) {
      showErrorSnackbar('No Customers', 'No customers are selected.');
      return;
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          height: 0.5.screenHeight,
          width: 0.8.screenWidth,
          padding: AppPaddings.p16,
          child: Column(
            children: [
              Text(
                'Selected Customers',
                style: TextStyles.kRegularFredoka(
                  fontSize: FontSizes.k20FontSize,
                  color: kColorTextPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppSpaces.v10,
              Expanded(
                child: ListView.builder(
                  itemCount: selectedPNames.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: AppPaddings.pv4,
                      child: Text(
                        selectedPNames[index],
                        style: TextStyles.kRegularFredoka(
                          fontSize: FontSizes.k16FontSize,
                          color: kColorTextPrimary,
                        ),
                      ),
                    );
                  },
                ),
              ),
              AppSpaces.v10,
              AppButton(
                buttonWidth: 0.3.screenWidth,
                buttonColor: kColorPrimary,
                titleColor: kColorTextPrimary,
                buttonHeight: 45,
                onPressed: () {
                  Get.back();
                },
                title: 'OK',
              ),
            ],
          ),
        ),
      ),
      useSafeArea: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: kColorWhite,
            appBar: AppAppbar(
              title: 'Authorise User',
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
              padding: AppPaddings.p12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  UserDetailCard(
                    firstName: firstName,
                    lastName: lastName,
                    business: business,
                    mobileNo: mobileNo,
                  ),
                  AppSpaces.v10,
                  AppDropdown(
                    items: _controller.userTypes.values.toList(),
                    hintText: 'User Type',
                    showSearchBox: false,
                    onChanged: (selectedValue) {
                      _controller.onUserTypeChanged(selectedValue!);
                    },
                  ),
                  Obx(
                    () => Visibility(
                      visible: _controller.selectedUserType.value == 4,
                      child: Column(
                        children: [
                          AppSpaces.v10,
                          GestureDetector(
                            onTap: () {
                              showCustomersSheet();
                            },
                            onLongPress: () {
                              showSelectedCustomersDialog();
                            },
                            child: SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: Card(
                                margin: EdgeInsets.all(0),
                                color: kColorLightGrey,
                                child: Padding(
                                  padding: AppPaddings.combined(
                                    horizontal: 16.appWidth,
                                    vertical: 8.appHeight,
                                  ),
                                  child: _controller.selectedPNames.isEmpty
                                      ? Text(
                                          'Select Customers',
                                          style: TextStyles.kLightFredoka(
                                            fontSize: FontSizes.k16FontSize,
                                            color: kColorGrey,
                                          ).copyWith(
                                            height: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          maxLines: 1,
                                        )
                                      : Text(
                                          _controller.selectedPNames.join(', '),
                                          style: TextStyles.kRegularFredoka(
                                            fontSize: FontSizes.k16FontSize,
                                            color: kColorTextPrimary,
                                          ).copyWith(
                                            height: 1,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: _controller.selectedUserType.value == 2,
                      child: Column(
                        children: [
                          AppSpaces.v10,
                          AppDropdown(
                            items: _controller.salesmanNames,
                            hintText: 'Select Salesman',
                            onChanged: (value) {
                              _controller.onSalesmanSelected(value!);
                            },
                            selectedItem:
                                _controller.selectedSalesman.value.isNotEmpty
                                    ? _controller.selectedSalesman.value
                                    : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: _controller.selectedUserType.value == 1 ||
                          _controller.selectedUserType.value == 3,
                      child: Column(
                        children: [
                          AppSpaces.v10,
                          AppDropdown(
                            items: _controller.customerNames,
                            hintText: 'Select Store',
                            onChanged: (value) {
                              _controller.onStoreSelected(value!);
                            },
                            selectedItem:
                                _controller.selectedStorePName.value.isNotEmpty
                                    ? _controller.selectedStorePName.value
                                    : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppSpaces.v20,
                  AppButton(
                    buttonWidth: 0.5.screenWidth,
                    buttonHeight: 45,
                    buttonColor: kColorPrimary,
                    title: 'Authorise',
                    titleColor: kColorTextPrimary,
                    onPressed: () {
                      _controller.authorizeUser(
                        userId: userId,
                      );
                    },
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
