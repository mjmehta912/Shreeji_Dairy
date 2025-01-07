import 'package:get/get.dart';
import 'package:shreeji_dairy/features/auth/login/screens/login_screen.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;

  var firstName = ''.obs;
  var lastName = ''.obs;
  var userType = ''.obs;
  var mobileNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    try {
      firstName.value =
          await SecureStorageHelper.read('firstName') ?? 'Unknown';
      lastName.value = await SecureStorageHelper.read('lastName') ?? 'User';
      userType.value = await SecureStorageHelper.read('userType') ?? 'guest';
      mobileNumber.value = await SecureStorageHelper.read('mobileNo') ?? '';
    } catch (e) {
      showErrorSnackbar(
        'Failed to Load User Info',
        'There was an issue loading your profile data. Please try again.',
      );
    }
  }

  Future<void> logoutUser() async {
    isLoading.value = true;
    try {
      await SecureStorageHelper.clearAll();

      Get.offAll(() => LoginScreen());

      showSuccessSnackbar(
        'Logged Out',
        'You have been successfully logged out.',
      );
    } catch (e) {
      showErrorSnackbar(
        'Logout Failed',
        'Something went wrong. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
