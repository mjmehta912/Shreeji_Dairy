import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/credit_note_approval/qc_approval/controllers/qc_approval_action_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';

class QcApprovalActionScreen extends StatefulWidget {
  const QcApprovalActionScreen({
    super.key,
    required this.id,
    required this.iCode,
  });

  final int id;
  final String iCode;

  @override
  State<QcApprovalActionScreen> createState() => _QcApprovalActionScreenState();
}

class _QcApprovalActionScreenState extends State<QcApprovalActionScreen> {
  final QcApprovalActionController _controller =
      Get.put(QcApprovalActionController());

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    await _controller.getQcParaForApproval(iCode: widget.iCode);
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
              title: 'QC Approval',
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
              padding: AppPaddings.p10,
              child: Column(
                children: [
                  Obx(
                    () {
                      if (_controller.qcParaForApproval.isEmpty &&
                          _controller.isLoading.value) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              'No questions need to be answered',
                              style: TextStyles.kRegularFredoka(),
                            ),
                          ),
                        );
                      }

                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _controller.qcParaForApproval.length,
                          itemBuilder: (context, index) {
                            final qcPara = _controller.qcParaForApproval[index];
                            return AppCard1(
                              child: Padding(
                                padding: AppPaddings.p10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      qcPara.testPara,
                                      style: TextStyles.kMediumFredoka(),
                                    ),
                                    ...qcPara.testResult.map(
                                      (testResult) {
                                        return Obx(
                                          () {
                                            return RadioListTile<String>(
                                              contentPadding: EdgeInsets.zero,
                                              dense: true,
                                              title: Text(
                                                testResult.testResult,
                                                style:
                                                    TextStyles.kRegularFredoka(
                                                  fontSize:
                                                      FontSizes.k16FontSize,
                                                ),
                                              ),
                                              value: testResult.testResult,
                                              groupValue: _controller
                                                  .selectedResults
                                                  .firstWhere(
                                                (result) =>
                                                    result['TPCODE'] ==
                                                    qcPara.tpcode,
                                                orElse: () => {},
                                              )['TestResult'],
                                              onChanged: (value) {
                                                _controller.selectTestResult(
                                                  qcPara.tpcode,
                                                  value!,
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  AppSpaces.v10,
                  AppTextFormField(
                    controller: _controller.remarkController,
                    hintText: 'Remark',
                  ),
                  AppSpaces.v10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppButton(
                        buttonWidth: 0.35.screenWidth,
                        buttonHeight: 35,
                        buttonColor: kColorRed,
                        titleSize: FontSizes.k16FontSize,
                        title: 'Reject',
                        onPressed: () async {
                          if (_controller.qcParaForApproval.length !=
                              _controller.selectedResults.length) {
                            showErrorSnackbar(
                              'Oops!',
                              'Please answer all the questions',
                            );
                          } else {
                            await _controller.approveQc(
                              id: widget.id,
                              qc: false,
                            );
                          }
                        },
                      ),
                      AppButton(
                        buttonWidth: 0.35.screenWidth,
                        buttonHeight: 35,
                        buttonColor: kColorSecondary,
                        titleSize: FontSizes.k16FontSize,
                        title: 'Approve',
                        onPressed: () async {
                          if (_controller.qcParaForApproval.length !=
                              _controller.selectedResults.length) {
                            showErrorSnackbar(
                              'Oops!',
                              'Please answer all the questions',
                            );
                          } else {
                            await _controller.approveQc(
                              id: widget.id,
                              qc: true,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  AppSpaces.v20,
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
