import 'package:get/get.dart';
import 'package:shreeji_dairy/features/select_customer/models/customer_dm.dart';
import 'package:shreeji_dairy/features/user_authorization/authorize_user/repositories/authorize_user_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class AuthorizeUserController extends GetxController {
  var isLoading = false.obs;

  var userTypes = {
    0: 'Supervisor',
    1: 'Branch Manager',
    2: 'Salesman',
    3: 'Franchise Owner',
    4: 'Customer',
  }.obs;

  var selectedUserType = Rxn<int>();
  var customers = <CustomerDm>[].obs;
  var customerNames = <String>[].obs;

  void onUserTypeChanged(String selectedValue) {
    final selectedIndex = userTypes.values.toList().indexOf(selectedValue);

    selectedUserType.value = selectedIndex == -1 ? null : selectedIndex;

    getCustomers();
  }

  Future<void> getCustomers() async {
    try {
      isLoading.value = true;

      final fetchedCustomers = await AuthorizeUserRepo.getCustomers();

      customers.assignAll(fetchedCustomers);
      customerNames.assignAll(
        fetchedCustomers
            .map(
              (customer) => customer.pName,
            )
            .toList(),
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
}
