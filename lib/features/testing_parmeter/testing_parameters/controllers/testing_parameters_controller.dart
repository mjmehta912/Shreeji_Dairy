import 'package:get/get.dart';
import 'package:shreeji_dairy/features/testing_parmeter/testing_parameters/models/testing_parameter_dm.dart';
import 'package:shreeji_dairy/features/testing_parmeter/testing_parameters/repos/testing_parameters_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class TestingParametersController extends GetxController {
  var isLoading = false.obs;

  var testingParameters = <TestingParameterDm>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await getTestingParameters();
  }

  Future<void> getTestingParameters() async {
    try {
      isLoading.value = true;

      final fetchedTestingParameters =
          await TestingParametersRepo.getTestingParameters();

      testingParameters.assignAll(fetchedTestingParameters);
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
