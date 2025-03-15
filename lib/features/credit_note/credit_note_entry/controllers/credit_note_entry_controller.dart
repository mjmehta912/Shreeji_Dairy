import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shreeji_dairy/features/credit_note/credit_note_entry/models/all_item_dm.dart';
import 'package:shreeji_dairy/features/credit_note/credit_note_entry/models/credit_note_reason_dm.dart';
import 'package:shreeji_dairy/features/credit_note/credit_note_entry/models/item_party_wise_inv_no_dm.dart';
import 'package:shreeji_dairy/features/credit_note/credit_note_entry/repos/credit_note_entry_repo.dart';
import 'package:shreeji_dairy/features/credit_note/credit_notes/controllers/credit_notes_controller.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class CreditNoteEntryController extends GetxController {
  var isLoading = false.obs;
  var creditNoteEntryFormKey = GlobalKey<FormState>();

  var items = <AllItemDm>[].obs;
  var skus = <ItemSkuDm>[].obs;
  var itemNames = <String>[].obs;
  var skuPacks = <String>[].obs;
  var selectedItem = Rxn<AllItemDm>();
  var selectedSkuIcode = ''.obs;
  var selectedPack = ''.obs;
  var qtyController = TextEditingController();
  var expiryDateController = TextEditingController();
  var invNos = <ItemPartyWiseInvNoDm>[].obs;
  var invNoNos = <String>[].obs;
  var selectedInvNo = ''.obs;
  var reasons = <CreditNoteReasonDm>[].obs;
  var reasonNames = <String>[].obs;
  var selectedReason = ''.obs;
  var selectedReasonCode = ''.obs;
  var reasonController = TextEditingController();
  var selectedImage = Rx<File?>(null);

  var addedItems = <Map<String, dynamic>>[].obs;
  var remarkController = TextEditingController();

  void addItemToList({
    required String itemName,
    required String skuPack,
    required String skuICode,
    required String qty,
    required String expiryDate,
    required String invNo,
  }) {
    int serialNo = addedItems.length + 1;

    addedItems.add(
      {
        'serialNo': serialNo,
        'itemName': itemName,
        'skuPack': skuPack,
        'skuICode': skuICode,
        'qty': qty,
        'expDate': DateFormat('yyyy-MM-dd')
            .format(DateFormat('dd-MM-yyyy').parse(expiryDate)),
        'invNo': invNo,
        'reason': selectedReason.value == 'OTHER'
            ? reasonController.text
            : selectedReason.value,
        'image': selectedImage.value,
      },
    );
  }

  void deleteItem(int serialNo) {
    addedItems.removeWhere(
      (item) => item['serialNo'] == serialNo,
    );

    for (int i = 0; i < addedItems.length; i++) {
      addedItems[i]['serialNo'] = i + 1;
    }
  }

  void clearForm() {
    selectedItem.value = null;
    selectedPack.value = '';
    selectedSkuIcode.value = '';
    qtyController.clear();
    expiryDateController.clear();
    invNos.clear();
    invNoNos.clear();
    selectedInvNo.value = '';
    selectedReason.value = '';
    selectedReasonCode.value = '';
    reasonController.clear();
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

      itemNames.assignAll(
        fetchedItems
            .map(
              (item) => item.printName,
            )
            .toList(),
      );

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
    selectedPack.value = '';
    selectedSkuIcode.value = '';
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

  Future<void> getInvNos({
    required String pCode,
    required String iCode,
  }) async {
    try {
      isLoading.value = true;

      final fetchedInvNos = await CreditNoteEntryRepo.getInvNos(
        pCode: pCode,
        iCode: iCode,
      );

      invNos.assignAll(fetchedInvNos);
      invNoNos.assignAll(
        fetchedInvNos
            .map(
              (invno) => invno.invNo,
            )
            .toList(),
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

  void onInvNoSelected(String invNo) {
    selectedInvNo.value = invNo;
  }

  Future<void> getReasons() async {
    try {
      isLoading.value = true;

      final fetchedReasons = await CreditNoteEntryRepo.getReasons();

      reasons.assignAll(fetchedReasons);
      reasonNames.assignAll(
        fetchedReasons
            .map(
              (reason) => reason.rName,
            )
            .toList(),
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

  void onReasonSelected(String? reasonName) {
    selectedReason.value = reasonName!;
    final selectedReasonObj = reasons.firstWhere(
      (reason) => reason.rName == reasonName,
    );

    selectedReasonCode.value = selectedReasonObj.rCode;
  }

  final CreditNotesController creditNotesController =
      Get.find<CreditNotesController>();

  Future<void> saveCreditNote({
    required String pCode,
  }) async {
    isLoading.value = true;

    try {
      List<Map<String, dynamic>> details = addedItems.map(
        (item) {
          return {
            'SRNO': item['serialNo'].toString(),
            'ICODE': item['skuICode'],
            'QTY': item['qty'],
            'ExpDate': item['expDate'],
            'INVNO': item['invNo'],
            'Reason': item['reason'],
            'Image': item['image'],
          };
        },
      ).toList();

      var response = await CreditNoteEntryRepo.saveCreditNote(
        pcode: pCode,
        remark: remarkController.text,
        details: details,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];
        creditNotesController.getAllCreditNotes(
          pCode: pCode,
        );
        Get.back();
        showSuccessSnackbar(
          'Success',
          message,
        );
        addedItems.clear();
        remarkController.clear();
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
