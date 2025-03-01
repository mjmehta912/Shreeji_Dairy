import 'package:get/get.dart';
import 'package:shreeji_dairy/features/qc_test_parameter/add_group_wise_test_para/repos/add_group_wise_test_para_repo.dart';
import 'package:shreeji_dairy/features/qc_test_parameter/add_item_wise_test_para/models/item_for_test_para_dm.dart';
import 'package:shreeji_dairy/features/qc_test_parameter/add_item_wise_test_para/repos/add_item_wise_test_para_repo.dart';
import 'package:shreeji_dairy/features/qc_test_parameter/qc_test_parameters/controllers/qc_test_para_controller.dart';
import 'package:shreeji_dairy/features/testing_parmeter/testing_parameters/models/testing_parameter_dm.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class AddItemWiseTestParaController extends GetxController {
  var isLoading = false.obs;

  var items = <ItemForTestParaDm>[].obs;
  var itemNames = <String>[].obs;
  var selectedItem = ''.obs;
  var selectedItemCode = ''.obs;

  var testingParameters = <TestingParameterDm>[].obs;
  var testingParameterNames = <String>[].obs;
  var selectedTestingParameter = ''.obs;
  var selectedTestingParameterCode = ''.obs;

  var addedData = <Map<String, String>>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await getItems();
    await getTestingParameters();
  }

  Future<void> getItems() async {
    try {
      isLoading.value = true;

      final fetchedItems = await AddItemWiseTestParaRepo.getItems();

      items.assignAll(fetchedItems);
      itemNames.assignAll(
        fetchedItems.map(
          (item) => item.iName,
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

  void onItemSelected(String? itemName) {
    selectedItem.value = itemName!;

    final selectedItemObj = items.firstWhere(
      (item) => item.iName == itemName,
    );

    selectedItemCode.value = selectedItemObj.iCode;
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
    if (selectedItemCode.value.isNotEmpty &&
        selectedTestingParameterCode.value.isNotEmpty) {
      addedData.add(
        {
          "TPCODE": selectedTestingParameterCode.value,
          "ICODE": selectedItemCode.value,
          "TPNAME": selectedTestingParameter.value,
          "INAME": selectedItem.value,
        },
      );

      selectedItem.value = '';
      selectedItemCode.value = '';
      selectedTestingParameter.value = '';
      selectedTestingParameterCode.value = '';

      print(addedData);
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

  Future<void> addItemwiseQcTestPara() async {
    isLoading.value = true;

    try {
      // Extract only TPCODE and ICCODE
      List<Map<String, String>> requestData = addedData
          .map(
            (item) => {
              "TPCODE": item["TPCODE"] ?? "",
              "ICODE": item["ICODE"] ?? "",
            },
          )
          .toList();

      var response = await AddItemWiseTestParaRepo.addItemwiseQcTestPara(
        data: requestData,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];
        qcTestParaController.getItemwiseQcTestingParameters();
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
