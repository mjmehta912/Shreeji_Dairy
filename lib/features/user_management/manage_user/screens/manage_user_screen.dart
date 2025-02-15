import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/user_management/manage_user/controllers/manage_user_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/formatters/text_input_formatters.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_dropdown.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';

class ManageUserScreen extends StatefulWidget {
  const ManageUserScreen({
    super.key,
    required this.isEdit,
    this.firstName,
    this.lastName,
    this.mobileNo,
    this.userId,
    this.isAppAccess,
    this.userType,
    this.seCode,
    this.storePCode,
    this.pCodes,
  });

  final bool isEdit;
  final String? firstName;
  final String? lastName;
  final String? mobileNo;
  final int? userId;
  final bool? isAppAccess;
  final int? userType;
  final String? seCode;
  final String? storePCode;
  final String? pCodes;

  @override
  State<ManageUserScreen> createState() => _ManageUserScreenState();
}

class _ManageUserScreenState extends State<ManageUserScreen> {
  final ManageUserController _controller = Get.put(
    ManageUserController(),
  );

  @override
  void initState() {
    super.initState();
    _controller.setupValidationListeners();
    initialize();
  }

  void initialize() async {
    if (widget.isEdit) {
      _controller.firstNameController.text = widget.firstName!;
      _controller.lastNameController.text = widget.lastName!;
      _controller.mobileNoController.text = widget.mobileNo!;
      _controller.appAccess.value = widget.isAppAccess!;
      _controller.selectedUserType.value = widget.userType!;

      if (widget.userType == 2) {
        await _controller.getSalesmen();

        if (widget.seCode != null && widget.seCode!.isNotEmpty) {
          _controller.selectedSalesmanCode.value = widget.seCode!;
          _controller.selectedSalesman.value = _controller.salesmen
              .firstWhere((se) => se.seCode == widget.seCode!)
              .seName;
        }
      }

      if (widget.userType == 1 || widget.userType == 3) {
        await _controller.getCustomers();

        if (widget.storePCode != null && widget.storePCode!.isNotEmpty) {
          _controller.selectedStorePCode.value = widget.storePCode!;
          _controller.selectedStorePName.value = _controller.customers
              .firstWhere((cust) => cust.pCode == widget.storePCode!)
              .pName;
        }
      }

      if (widget.userType == 4) {
        await _controller.getCustomers();

        if (widget.pCodes != null && widget.pCodes!.isNotEmpty) {
          _controller.selectedPCodes.addAll(
            widget.pCodes!.split(',').map((pcode) => pcode.trim()),
          );
        }

        for (var customer in _controller.customers) {
          if (_controller.selectedPCodes.contains(customer.pCode)) {
            _controller.selectedPNames.add(customer.pName);
          }
        }
      }
    }
  }

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
      showErrorSnackbar(
        'No Customers',
        'No customers are selected.',
      );
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
              title: 'Manage User',
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 25,
                  color: kColorTextPrimary,
                ),
              ),
            ),
            body: Padding(
              padding: AppPaddings.p12,
              child: SingleChildScrollView(
                child: Form(
                  key: _controller.manageUserFormKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 0.45.screenWidth,
                            child: AppTextFormField(
                              controller: _controller.firstNameController,
                              hintText: 'First Name',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your first name';
                                }
                                return null;
                              },
                              inputFormatters: [
                                TitleCaseTextInputFormatter(),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 0.45.screenWidth,
                            child: AppTextFormField(
                              controller: _controller.lastNameController,
                              hintText: 'Last Name',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              },
                              inputFormatters: [
                                TitleCaseTextInputFormatter(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      AppSpaces.v10,
                      AppTextFormField(
                        controller: _controller.mobileNoController,
                        hintText: 'Mobile Number',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your mobile number';
                          }
                          if (value.length != 10) {
                            return 'Please enter a 10-digit mobile number';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          MobileNumberInputFormatter(),
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                      AppSpaces.v10,
                      Obx(
                        () => AppTextFormField(
                          controller: _controller.passwordController,
                          hintText: 'Password',
                          isObscure: _controller.obscuredText.value,
                          suffixIcon: IconButton(
                            onPressed: () {
                              _controller.togglePasswordVisibility();
                            },
                            icon: Icon(
                              _controller.obscuredText.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      AppSpaces.v10,
                      AppDropdown(
                        items: _controller.userTypes.values.toList(),
                        hintText: 'User Type',
                        showSearchBox: false,
                        onChanged: (selectedValue) {
                          _controller.onUserTypeChanged(selectedValue!);
                        },
                        selectedItem: _controller.selectedUserType.value != null
                            ? _controller.userTypes.entries
                                .firstWhere(
                                  (ut) =>
                                      ut.key ==
                                      _controller.selectedUserType.value,
                                )
                                .value
                            : null,
                        validatorText: 'Please select a user type.',
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
                                              _controller.selectedPNames
                                                  .join(', '),
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
                                selectedItem: _controller
                                        .selectedSalesman.value.isNotEmpty
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
                                selectedItem: _controller
                                        .selectedStorePName.value.isNotEmpty
                                    ? _controller.selectedStorePName.value
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                      AppSpaces.v10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'App Access',
                            style: TextStyles.kRegularFredoka(
                              color: kColorTextPrimary,
                            ),
                          ),
                          Obx(
                            () => Switch(
                              value: _controller.appAccess.value,
                              activeColor: kColorWhite,
                              inactiveThumbColor: kColorWhite,
                              inactiveTrackColor: kColorGrey,
                              activeTrackColor: kColorSecondary,
                              onChanged: (value) async {
                                _controller.appAccess.value = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      AppSpaces.v30,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppButton(
                            buttonColor: kColorPrimary,
                            buttonWidth: 0.5.screenWidth,
                            title: 'Save',
                            titleColor: kColorTextPrimary,
                            onPressed: () {
                              _controller.hasAttemptedSubmit.value = true;
                              if (_controller.manageUserFormKey.currentState!
                                  .validate()) {
                                _controller.manageUser(
                                  userId: widget.isEdit ? widget.userId! : 0,
                                );
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
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
