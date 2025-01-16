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
  final Map<String, TextEditingController> productControllers = {};

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

      for (var category in storeProducts) {
        for (var product in category.products) {
          productControllers[product.icode] = TextEditingController(
            text: product.cartQty == 0 ? '' : product.cartQty.toString(),
          );
        }
      }
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addOrUpdateCart({
    required String iCode,
  }) async {
    // Retrieve the quantity entered in the TextEditingController
    final qty = int.tryParse(productControllers[iCode]?.text ?? '0') ?? 0;
    final product = storeProducts
        .expand((category) => category.products)
        .firstWhere((product) => product.icode == iCode);
    final rate = product.rate;

    String? storePcode = await SecureStorageHelper.read(
      'storePCode',
    );

    isLoading.value = true;

    try {
      var response = await StoreOrderRepo.addOrUpdateCart(
        pCode: storePcode!,
        iCode: iCode,
        qty: qty,
        rate: rate,
      );

      if (response != null && response.containsKey('message')) {
        fetchStoreProducts(
          searchText: searchController.text,
        );
      }
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
