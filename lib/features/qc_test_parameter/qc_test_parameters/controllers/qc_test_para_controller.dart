import 'package:get/get.dart';
import 'package:shreeji_dairy/features/qc_test_parameter/qc_test_parameters/models/group_wise_qc_test_para_dm.dart';
import 'package:shreeji_dairy/features/qc_test_parameter/qc_test_parameters/models/item_wise_qc_test_para_dm.dart';
import 'package:shreeji_dairy/features/qc_test_parameter/qc_test_parameters/repos/qc_test_para_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class QcTestParaController extends GetxController {
  var isLoading = false.obs;

  var groupwiseQcTestingParameters = <GroupWiseQcTestParaDm>[].obs;
  var itemwiseQcTestingParameters = <ItemWiseQcTestParaDm>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await getGroupwiseQcTestingParameters();
    await getItemwiseQcTestingParameters();
  }

  Future<void> getGroupwiseQcTestingParameters() async {
    try {
      isLoading.value = true;

      final fetchedGroupwiseQcTestingParameters =
          await QcTestParaRepo.getGroupwiseQcTestingParameters();

      groupwiseQcTestingParameters
          .assignAll(fetchedGroupwiseQcTestingParameters);
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getItemwiseQcTestingParameters() async {
    try {
      isLoading.value = true;

      final fetchedItemwiseQcTestingParameters =
          await QcTestParaRepo.getItemwiseQcTestingParameters();

      itemwiseQcTestingParameters.assignAll(fetchedItemwiseQcTestingParameters);
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
