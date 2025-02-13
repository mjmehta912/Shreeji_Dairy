import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shreeji_dairy/features/credit_note/credit_note_entry/models/all_item_dm.dart';
import 'package:shreeji_dairy/features/credit_note/credit_note_entry/repos/credit_note_entry_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class CreditNoteEntryController extends GetxController {
  var isLoading = false.obs;
  var items = <AllItemDm>[].obs;
  var skus = <ItemSkuDm>[].obs;
  var itemNames = <String>[].obs;
  var skuPacks = <String>[].obs;
  var selectedItem = Rxn<AllItemDm>();
  var selectedSkuIcode = ''.obs;
  var selectedPack = ''.obs;
  var qtyController = TextEditingController();
  var invNoController = TextEditingController();

  var selectedImage = Rx<File?>(null);

  var addedItems = <Map<String, dynamic>>[].obs;
  var remarkController = TextEditingController();

  final picker = ImagePicker();

  Future<void> pickImage() async {
    PermissionStatus status = await Permission.photos.request();

    if (status.isGranted) {
      try {
        final pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
        );
        if (pickedFile != null) {
          selectedImage.value = File(pickedFile.path);
        }
      } catch (e) {
        // print('Error picking image: $e');
      }
    } else {
      showErrorSnackbar(
        'Error',
        'Permission to access photos was denied',
      );
    }
  }

  void addItemToList({
    required String itemName,
    required String skuPack,
    required String skuICode,
    required String qty,
    required String invNo,
  }) {
    addedItems.add({
      'itemName': itemName,
      'skuPack': skuPack,
      'skuICode': skuICode,
      'qty': qty,
      'invNo': invNo,
      'image': selectedImage.value, // Store the image file
    });
  }

  void clearForm() {
    selectedItem.value = null;
    selectedPack.value = '';
    selectedSkuIcode.value = '';
    qtyController.clear();
    invNoController.clear();
    selectedImage.value = null;
  }

  Future<void> getAllItems() async {
    isLoading.value = true;

    try {
      final fetchedItems = await CreditNoteEntryRepo.getAllItems(
        icCodes: '',
        igCodes: '',
        ipackgCodes: '',
        searchText: '',
      );

      items.assignAll(fetchedItems);

      itemNames.assignAll(fetchedItems.map((item) => item.printName).toList());

      skus.clear();
      skuPacks.clear();
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

  void onItemSelected(AllItemDm selected) {
    selectedItem.value = selected;

    skus.assignAll(selected.skus);

    skuPacks.assignAll(
      selected.skus.map((sku) => sku.pack).toSet().toList(),
    );
  }

  void onSkuSelected(ItemSkuDm selectedSku) {
    selectedSkuIcode.value = selectedSku.skuIcode;
    selectedPack.value = selectedSku.pack;
  }
}
