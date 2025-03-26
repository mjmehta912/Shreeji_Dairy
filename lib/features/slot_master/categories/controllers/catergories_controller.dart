import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/slot_master/categories/models/customer_category_dm.dart';
import 'package:shreeji_dairy/features/slot_master/categories/repos/categories_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class CatergoriesController extends GetxController {
  var isLoading = false.obs;

  var categories = <CustomerCategoryDm>[].obs;
  var filteredCategories = <CustomerCategoryDm>[].obs;
  var searchController = TextEditingController();

  @override
  void onInit() async {
    super.onInit();
    await getCategories();
  }

  Future<void> getCategories() async {
    try {
      isLoading.value = true;

      final fetchedCategories = await CategoriesRepo.getCategories();

      categories.assignAll(fetchedCategories);
      filteredCategories.assignAll(fetchedCategories);
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void searchCategories(String query) {
    if (query.isEmpty) {
      filteredCategories.assignAll(categories);
    } else {
      filteredCategories.assignAll(
        categories.where(
          (category) =>
              category.cName.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }
}
