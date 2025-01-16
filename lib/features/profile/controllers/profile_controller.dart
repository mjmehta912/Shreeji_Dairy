import 'package:get/get.dart';
import 'package:shreeji_dairy/features/auth/login/screens/login_screen.dart';
import 'package:shreeji_dairy/features/profile/repositories/profile_repo.dart';
import 'package:shreeji_dairy/features/user_rights/user_access/models/user_access_dm.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;

  var firstName = ''.obs;
  var lastName = ''.obs;
  var userType = ''.obs;
  var mobileNumber = ''.obs;
  var menuAccess = <MenuAccessDm>[].obs;

  String getDynamicGreeting(String userType) {
    switch (userType) {
      case '0':
        return 'Hello, Visionary Leader!';
      case '1':
        return 'Greetings, Branch Chief!';
      case '2':
        return 'Welcome, Sales Pro!';
      case '3':
        return 'Hi, Business Partner!';
      case '4':
        return 'Hello, Valued Guest!';
      default:
        return 'Welcome, Esteemed User!';
    }
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

  Future<void> getUserAccess() async {
    isLoading.value = true;
    String? userId = await SecureStorageHelper.read(
      'userId',
    );

    try {
      final fetchedUserAccess = await ProfileRepo.getUserAccess(
        userId: int.parse(userId!),
      );

      menuAccess.assignAll(
        fetchedUserAccess.menuAccess,
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
