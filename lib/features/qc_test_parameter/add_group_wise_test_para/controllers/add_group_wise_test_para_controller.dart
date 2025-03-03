import 'package:get/get.dart';
import 'package:shreeji_dairy/features/products/models/subgroup_dm.dart';
import 'package:shreeji_dairy/features/qc_test_parameter/add_group_wise_test_para/repos/add_group_wise_test_para_repo.dart';
import 'package:shreeji_dairy/features/qc_test_parameter/qc_test_parameters/controllers/qc_test_para_controller.dart';
import 'package:shreeji_dairy/features/testing_parmeter/testing_parameters/models/testing_parameter_dm.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class AddGroupWiseTestParaController extends GetxController {
  var isLoading = false.obs;

  var subGroups = <SubgroupDm>[].obs;
  var subGroupNames = <String>[].obs;
  var selectedSubGroup = ''.obs;
  var selectedSubGroupCode = ''.obs;

  var testingParameters = <TestingParameterDm>[].obs;
  var testingParameterNames = <String>[].obs;
  var selectedTestingParameter = ''.obs;
  var selectedTestingParameterCode = ''.obs;

  var addedData = <Map<String, String>>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await getSubGroups();
    await getTestingParameters();
  }

  Future<void> getSubGroups() async {
    try {
      isLoading.value = true;

      final fetchedSubGroups = await AddGroupWiseTestParaRepo.getSubGroups(
        igCodes: '',
      );

      subGroups.assignAll(fetchedSubGroups);
      subGroupNames.assignAll(
        fetchedSubGroups.map(
          (sg) => sg.icName,
        ),
      );
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onSubGroupSelected(String? subGroup) {
    selectedSubGroup.value = subGroup!;

    final selectedSubGroupObj = subGroups.firstWhere(
      (sg) => sg.icName == subGroup,
    );

    selectedSubGroupCode.value = selectedSubGroupObj.icCode;
  }

  Future<void> getTestingParameters() async {
    try {
      isLoading.value = true;

      final fetchedTestingParameters =
          await AddGroupWiseTestParaRepo.getTestingParameters();

      testingParameters.assignAll(fetchedTestingParameters);
      testingParameterNames.assignAll(
        fetchedTestingParameters.map(
          (tp) => tp.testPara,
        ),
      );
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onTestingParameterSelected(String? testingParameter) {
    selectedTestingParameter.value = testingParameter!;

    final selectedTestingParameterObj = testingParameters.firstWhere(
      (tp) => tp.testPara == testingParameter,
    );

    selectedTestingParameterCode.value = selectedTestingParameterObj.tpcode;
  }

  void addData() {
    if (selectedSubGroupCode.value.isNotEmpty &&
        selectedTestingParameterCode.value.isNotEmpty) {
      addedData.add(
        {
          "TPCODE": selectedTestingParameterCode.value,
          "ICCODE": selectedSubGroupCode.value,
          "TPNAME": selectedTestingParameter.value,
          "ICNAME": selectedSubGroup.value,
        },
      );

      selectedSubGroup.value = '';
      selectedSubGroupCode.value = '';
      selectedTestingParameter.value = '';
      selectedTestingParameterCode.value = '';
    } else {
      showErrorSnackbar(
        'Error',
        'Please select both Group and Testing Parameter',
      );
    }
  }

  void deleteData(int index) {
    if (index >= 0 && index < addedData.length) {
      addedData.removeAt(index);
    }
  }

  final QcTestParaController qcTestParaController =
      Get.find<QcTestParaController>();

  Future<void> addGroupwiseQcTestPara() async {
    isLoading.value = true;

    try {
      // Extract only TPCODE and ICCODE
      List<Map<String, String>> requestData = addedData
          .map(
            (item) => {
              "TPCODE": item["TPCODE"] ?? "",
              "ICCODE": item["ICCODE"] ?? "",
            },
          )
          .toList();

      var response = await AddGroupWiseTestParaRepo.addGroupwiseQcTestPara(
        data: requestData,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];
        qcTestParaController.getGroupwiseQcTestingParameters();
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
