import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/credit_note/credit_note_entry/models/all_item_dm.dart';
import 'package:shreeji_dairy/features/upload_product_image/repos/upload_product_image_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class UploadProductImageController extends GetxController {
  var isLoading = false.obs;

  final imageUploadFormKey = GlobalKey<FormState>();

  var selectedImage = Rx<File?>(null);

  var items = <AllItemDm>[].obs;
  var itemNames = <String>[].obs;
  var selectedIName = ''.obs;
  var selectedICode = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    getAllItems();
  }

  Future<void> getAllItems() async {
    isLoading.value = true;

    try {
      final fetchedItems = await UploadProductImageRepo.getAllItems(
        icCodes: '',
        igCodes: '',
        ipackgCodes: '',
        searchText: '',
      );

      items.assignAll(fetchedItems);

      itemNames.assignAll(
        fetchedItems
            .map(
              (item) => item.printName,
            )
            .toList(),
      );
    } catch (e) {
      if (e is Map<String, dynamic>) {
        showErrorSnackbar(
          'Error',
          e['message'] ?? 'An unknown error occurred.',
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

  void onItemSelected(String itemName) {
    selectedIName.value = itemName;

    final selectedItemObj = items.firstWhere(
      (item) => item.printName == itemName,
    );

    selectedICode.value = selectedItemObj.icode;

    print(selectedIName.value);
    print(selectedICode.value);
  }

  Future<void> uploadProductImage() async {
    isLoading.value = true;

    try {
      var response = await UploadProductImageRepo.uploadProductImage(
        iCode: selectedICode.value,
        imageFile: selectedImage.value!,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];

        // Get.back();
        selectedICode.value = '';
        selectedIName.value = '';
        selectedImage.value = null;
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
