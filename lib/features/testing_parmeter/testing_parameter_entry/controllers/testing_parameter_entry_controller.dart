import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/testing_parmeter/testing_parameter_entry/repos/testing_parameter_entry_repo.dart';
import 'package:shreeji_dairy/features/testing_parmeter/testing_parameters/controllers/testing_parameters_controller.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class TestingParameterEntryController extends GetxController {
  var isLoading = false.obs;
  final testingParameterEntryFormKey = GlobalKey<FormState>();

  var testParaController = TextEditingController();
  var testResultController = TextEditingController();

  var options = <Map<String, String>>[].obs;

  void addOption(String option) {
    if (option.isNotEmpty) {
      options.add({"TestResult": option});
      testResultController.clear();
    }
  }

  void removeOption(int index) {
    options.removeAt(index);
  }

  final TestingParametersController testingParametersController =
      Get.find<TestingParametersController>();

  Future<void> addtestingParameter() async {
    isLoading.value = true;

    try {
      var response = await TestingParameterEntryRepo.addTestingParameter(
        testPara: testParaController.text,
        options: options,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];
        testingParametersController.getTestingParameters();
        Get.back();
        showSuccessSnackbar(
          'Success',
          message,
        );
      }
    } catch (e) {
      if (e is Map<String, dynamic>) {
        showErrorSnackbar(
          'Error',
          e['message'] ?? 'An unknown error occurred.',
        );
      } else {
        showErrorSnackbar(
          'Error',
          e.toString(),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
