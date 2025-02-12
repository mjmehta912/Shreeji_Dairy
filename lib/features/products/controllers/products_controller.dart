import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/auth/login/screens/login_screen.dart';
import 'package:shreeji_dairy/features/products/models/group_dm.dart';
import 'package:shreeji_dairy/features/products/models/product_dm.dart';
import 'package:shreeji_dairy/features/products/models/subgroup2_dm.dart';
import 'package:shreeji_dairy/features/products/models/subgroup_dm.dart';
import 'package:shreeji_dairy/features/products/repositories/products_repo.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';
import 'package:shreeji_dairy/utils/helpers/device_helper.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';
import 'package:shreeji_dairy/utils/helpers/version_info_service.dart';

class ProductsController extends GetxController {
  var isLoading = false.obs;

  var products = <ProductDm>[].obs;
  var searchController = TextEditingController();
  var cartCount = 0.obs;

  var groups = <GroupDm>[].obs;
  var selectedIgCodes = <String>{}.obs;
  var subGroups = <SubgroupDm>[].obs;
  var selectedIcCodes = <String>{}.obs;
  var subGroups2 = <Subgroup2Dm>[].obs;
  var selectedIpackgCodes = <String>{}.obs;

  Future<void> searchProduct({
    String searchText = '',
    String pCode = '',
  }) async {
    isLoading.value = true;
    String? version = await VersionService.getVersion();
    String? deviceId = await DeviceHelper().getDeviceId();

    if (deviceId == null) {
      showErrorSnackbar(
        'Login Failed',
        'Unable to fetch device ID.',
      );
      isLoading.value = false;
      return;
    }

    try {
      final fetchedProducts = await ProductsRepo.searchProduct(
        icCodes: selectedIcCodes.join(','),
        igCodes: selectedIgCodes.join(','),
        ipackgCodes: selectedIpackgCodes.join(','),
        searchText: searchText,
        pCode: pCode,
        deviceId: deviceId,
        version: version,
      );

      products.assignAll(fetchedProducts);
      calculateCartCount();
    } catch (e) {
      if (e is Map<String, dynamic>) {
        if (e['status'] == 403) {
          await SecureStorageHelper.clearAll();
          Get.offAll(() => LoginScreen());
          showErrorSnackbar(
            'Session Expired',
            e['message'] ?? 'Unauthorized access. Device ID is invalid.',
          );
        } else if (e['status'] == 402) {
          showDialog(
            context: Get.context!,
            barrierDismissible: false,
            // ignore: deprecated_member_use
            builder: (context) => WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: AlertDialog(
                title: Text(
                  e['message'],
                  style: TextStyles.kMediumFredoka(
                    fontSize: FontSizes.k18FontSize,
                    color: kColorTextPrimary,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: Text(
                      'Close App',
                      style: TextStyles.kMediumFredoka(
                        fontSize: FontSizes.k18FontSize,
                        color: kColorSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          showErrorSnackbar(
            'Error',
            e['message'] ?? 'An unknown error occurred.',
          );
        }
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

  Future<void> addOrUpdateCart({
    required String pCode,
    required String iCode,
    required int qty,
    required double rate,
  }) async {
    isLoading.value = true;

    try {
      var response = await ProductsRepo.addOrUpdateCart(
        pCode: pCode,
        iCode: iCode,
        qty: qty,
        rate: rate,
      );

      if (response != null && response.containsKey('message')) {}
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void calculateCartCount() {
    cartCount.value = products.fold<int>(
      0,
      (sum, product) =>
          sum + product.skus.where((sku) => sku.cartQty > 0).length,
    );
  }

  Future<void> getGroups() async {
    try {
      isLoading.value = true;

      final fetchedGroups = await ProductsRepo.getGroups();

      groups.assignAll(fetchedGroups);
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getSubGroups() async {
    try {
      isLoading.value = true;

      final fetchedSubGroups = await ProductsRepo.getSubGroups();

      subGroups.assignAll(fetchedSubGroups);
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getSubGroups2() async {
    try {
      isLoading.value = true;

      final fetchedSubGroups2 = await ProductsRepo.getSubGroups2();

      subGroups2.assignAll(fetchedSubGroups2);
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
