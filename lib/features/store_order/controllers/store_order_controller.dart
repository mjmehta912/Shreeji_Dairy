import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/products/models/group_dm.dart';
import 'package:shreeji_dairy/features/products/models/subgroup2_dm.dart';
import 'package:shreeji_dairy/features/products/models/subgroup_dm.dart';
import 'package:shreeji_dairy/features/store_order/models/store_product_dm.dart';
import 'package:shreeji_dairy/features/store_order/repositories/store_order_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';
import 'package:shreeji_dairy/utils/helpers/secure_storage_helper.dart';

class StoreOrderController extends GetxController {
  var isLoading = false.obs;

  var storeProducts = <StoreCategoryDm>[].obs;
  var suggestedProducts = true.obs;
  var searchController = TextEditingController();
  final Map<String, TextEditingController> productControllers = {};
  var groups = <GroupDm>[].obs;
  var selectedIgCodes = <String>{}.obs;
  var groupSearchController = TextEditingController();
  var subGroups = <SubgroupDm>[].obs;
  var selectedIcCodes = <String>{}.obs;
  var subGroupSearchController = TextEditingController();
  var subGroups2 = <Subgroup2Dm>[].obs;
  var selectedIpackgCodes = <String>{}.obs;
  var subGroup2SearchController = TextEditingController();

  var isCartFilterActive = false.obs;
  var isPackingItem = false.obs;

  Future<void> fetchStoreProducts({
    String searchText = '',
  }) async {
    isLoading.value = true;

    String? storePcode = await SecureStorageHelper.read(
      'storePCode',
    );

    try {
      final fetchedProducts = await StoreOrderRepo.storeProducts(
        icCodes: selectedIcCodes.join(','),
        igCodes: selectedIgCodes.join(','),
        ipackgCodes: selectedIpackgCodes.join(','),
        searchText: searchText,
        pCode: storePcode!,
        packingItem: isPackingItem.value,
        suggestion: suggestedProducts.value,
      );

      if (isCartFilterActive.value) {
        final filteredProducts = fetchedProducts
            .map(
              (category) {
                final filteredCategoryProducts =
                    category.products.where((p) => p.cartQty > 0).toList();
                if (filteredCategoryProducts.isNotEmpty) {
                  return StoreCategoryDm(
                    icname: category.icname,
                    products: filteredCategoryProducts,
                  );
                }
                return null;
              },
            )
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
    );
  }

  void showPackingItem() {
    isPackingItem.value = !isPackingItem.value;

    fetchStoreProducts(
      searchText: searchController.text,
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

  Future<void> getGroups({
    required String cCode,
  }) async {
    try {
      isLoading.value = true;

      final fetchedGroups = await StoreOrderRepo.getGroups(
        cCode: cCode,
      );

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

  Future<void> getSubGroups({
    required String cCode,
  }) async {
    try {
      isLoading.value = true;

      final fetchedSubGroups = await StoreOrderRepo.getSubGroups(
        igCodes: selectedIgCodes.join(','),
        cCode: cCode,
      );

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

  Future<void> getSubGroups2({
    required String cCode,
  }) async {
    try {
      isLoading.value = true;

      final fetchedSubGroups2 = await StoreOrderRepo.getSubGroups2(
        igCodes: selectedIgCodes.join(','),
        icCodes: selectedIcCodes.join(','),
        cCode: cCode,
      );

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
