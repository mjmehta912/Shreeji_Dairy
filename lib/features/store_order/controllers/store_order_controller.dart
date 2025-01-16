import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/store_order/models/store_product_dm.dart';
import 'package:shreeji_dairy/features/store_order/repositories/store_order_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class StoreOrderController extends GetxController {
  var isLoading = false.obs;

  var storeProducts = <StoreCategoryDm>[].obs;
  var searchController = TextEditingController();

  Future<void> fetchStoreProducts({
    String icCodes = '',
    String igCodes = '',
    String ipackgCodes = '',
    String searchText = '',
  }) async {
    isLoading.value = true;

    String? storePcode = await SecureStorageHelper.read(
      'storePCode',
    );

    try {
      final fetchedProducts = await StoreOrderRepo.storeProducts(
        icCodes: icCodes,
        igCodes: igCodes,
        ipackgCodes: ipackgCodes,
        searchText: searchText,
        pCode: storePcode!,
      );

      storeProducts.assignAll(fetchedProducts);
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
