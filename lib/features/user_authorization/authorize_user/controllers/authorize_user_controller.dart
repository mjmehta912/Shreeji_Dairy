import 'package:get/get.dart';
import 'package:shreeji_dairy/features/auth/select_customer/models/customer_dm.dart';
import 'package:shreeji_dairy/features/user_authorization/authorize_user/models/salesman_dm.dart';
import 'package:shreeji_dairy/features/user_authorization/authorize_user/repositories/authorize_user_repo.dart';
import 'package:shreeji_dairy/features/user_authorization/unauthorized_users/controllers/unauthorized_users_controller.dart';
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
  var filteredCustomers = <CustomerDm>[].obs;
  var customerNames = <String>[].obs;
  var filteredCustomerNames = <String>[].obs;

  var selectedPNames = <String>{}.obs;
  var selectedPCodes = <String>{}.obs;

  var salesmen = <SalesmanDm>[].obs;
  var salesmanNames = <String>[].obs;
  var selectedSalesman = ''.obs;
  var selectedSalesmanCode = ''.obs;

  var selectedStorePCode = ''.obs;
  var selectedStorePName = ''.obs;

  void onUserTypeChanged(String selectedValue) {
    final selectedIndex = userTypes.values.toList().indexOf(selectedValue);

    selectedUserType.value = selectedIndex == -1 ? null : selectedIndex;

    selectedPCodes.clear();
    selectedPNames.clear();
    selectedSalesman.value = '';
    selectedSalesmanCode.value = '';
    selectedStorePCode.value = '';
    selectedStorePName.value = '';

    if (selectedUserType.value == 1 ||
        selectedUserType.value == 3 ||
        selectedUserType.value == 4) {
      getCustomers();
    }

    if (selectedUserType.value == 2) {
      getSalesmen();
    }
  }

  Future<void> getCustomers() async {
    try {
      isLoading.value = true;

      final fetchedCustomers = await AuthorizeUserRepo.getCustomers();

      customers.assignAll(fetchedCustomers);
      filteredCustomers.assignAll(fetchedCustomers);
      customerNames.assignAll(
        fetchedCustomers
            .map(
              (customer) => customer.pName,
            )
            .toList(),
      );

      filteredCustomerNames.assignAll(
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

  void filterCustomers(String query) {
    if (query.isEmpty) {
      filteredCustomers.assignAll(customers);
    } else {
      filteredCustomers.assignAll(
        customers.where(
          (cust) {
            return cust.pName.toLowerCase().contains(query.toLowerCase());
          },
        ).toList(),
      );
    }
  }

  Future<void> getSalesmen() async {
    try {
      isLoading.value = true;

      final fetchedSalesmen = await AuthorizeUserRepo.getSalesmen();

      salesmen.assignAll(fetchedSalesmen);
      salesmanNames.assignAll(
        fetchedSalesmen
            .map(
              (se) => se.seName,
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

  void onSalesmanSelected(String salesman) {
    selectedSalesman.value = salesman;

    var salesMenObj = salesmen.firstWhere(
      (se) => se.seName == salesman,
    );

    selectedSalesmanCode.value = salesMenObj.seCode;
  }

  void onStoreSelected(String store) {
    selectedStorePName.value = store;

    var storeObj = customers.firstWhere(
      (st) => st.pName == store,
    );

    selectedStorePCode.value = storeObj.pCode;
  }

  final UnauthorizedUsersController unauthorizedUsersController =
      Get.find<UnauthorizedUsersController>();

  Future<void> authorizeUser({
    required int userId,
  }) async {
    isLoading.value = true;

    try {
      var response = await AuthorizeUserRepo.authorizeUser(
        userId: userId,
        userType: selectedUserType.value!,
        pCodes: selectedPCodes.isEmpty ? '' : selectedPCodes.join(','),
        seCode: selectedSalesmanCode.value.isEmpty
            ? ''
            : selectedSalesmanCode.value,
        storePCode:
            selectedStorePCode.value.isEmpty ? '' : selectedStorePCode.value,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];
        await unauthorizedUsersController.getUnauthorizedUsers();
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
          e['message'],
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
