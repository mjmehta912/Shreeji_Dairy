import 'package:get/get.dart';
import 'package:shreeji_dairy/features/bottom_nav/repos/bottom_nav_repo.dart';
import 'package:shreeji_dairy/features/user_rights/user_access/models/user_access_dm.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class BottomNavController extends GetxController {
  var isLoading = false.obs;

  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  var menuAccess = <MenuAccessDm>[].obs;
  var ledgerDate = LedgerDateDm(
    ledgerStart: '',
    ledgerEnd: '',
    product: false,
    ledger: false,
    invoice: false,
  ).obs;

  Future<void> getUserAccess() async {
    isLoading.value = true;
    String? userId = await SecureStorageHelper.read(
      'userId',
    );
    try {
      final fetchedUserAccess = await BottomNavRepo.getUserAccess(
        userId: int.parse(userId!),
      );

      menuAccess.assignAll(fetchedUserAccess.menuAccess);
      ledgerDate.value = fetchedUserAccess.ledgerDate;
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
