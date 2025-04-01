import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/products/models/group_dm.dart';
import 'package:shreeji_dairy/features/store_order/models/store_product_dm.dart';
import 'package:shreeji_dairy/features/store_order/repositories/store_order_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class StoreOrderController extends GetxController {
  var isLoading = false.obs;

  var storeProducts = <StoreCategoryDm>[].obs;
  var searchController = TextEditingController();
  final Map<String, TextEditingController> productControllers = {};
  var groups = <GroupDm>[].obs;
  var selectedIgCode = ''.obs;

  var isCartFilterActive = false.obs;

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

      if (isCartFilterActive.value) {
        final filteredProducts = fetchedProducts
            .map((category) {
              final filteredCategoryProducts =
                  category.products.where((p) => p.cartQty > 0).toList();
              if (filteredCategoryProducts.isNotEmpty) {
                return StoreCategoryDm(
                  icname: category.icname,
                  products: filteredCategoryProducts,
                );
              }
              return null;
            })
            .whereType<StoreCategoryDm>()
            .toList();

        storeProducts.assignAll(filteredProducts);
      } else {
        storeProducts.assignAll(fetchedProducts);
      }

      for (var category in storeProducts) {
        for (var product in category.products) {
          productControllers[product.icode] = TextEditingController(
            text: product.cartQty == 0.0
                ? ''
                : product.cartQty.toInt().toString(),
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

  void toggleCartFilter() {
    isCartFilterActive.value = !isCartFilterActive.value;

    fetchStoreProducts(
      searchText: searchController.text,
      igCodes: selectedIgCode.value,
    );
  }

  Future<void> addOrUpdateCart({
    required String iCode,
    required String oldIcode,
  }) async {
    final qty = int.tryParse(productControllers[iCode]?.text ?? '0') ?? 0;
    final product =
        storeProducts.expand((category) => category.products).firstWhere(
              (product) => product.icode == iCode,
            );
    final rate = product.rate;

    String? storePcode = await SecureStorageHelper.read(
      'storePCode',
    );

    isLoading.value = true;

    try {
      var response = await StoreOrderRepo.addOrUpdateCart(
        pCode: storePcode!,
        iCode: iCode,
        oldIcode: oldIcode,
        qty: qty.toDouble(),
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

  Future<void> getGroups() async {
    try {
      isLoading.value = true;

      final fetchedGroups = await StoreOrderRepo.getGroups();

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
}
