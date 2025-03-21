import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/credit_note/credit_notes/models/credit_note_dm.dart';
import 'package:shreeji_dairy/features/credit_note/credit_notes/repos/credit_notes_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class CreditNotesController extends GetxController {
  var isLoading = true.obs;
  var isLoadingMore = false.obs;
  var hasMoreData = true.obs;
  var isFetchingData = false;

  var searchController = TextEditingController();
  var searchQuery = ''.obs;
  var creditNotes = <CreditNoteDm>[].obs;

  var currentPage = 1;
  var pageSize = 10;

  void debounceSearchQuery(
    String pCode,
  ) {
    debounce(
      searchQuery,
      (_) => getAllCreditNotes(
        pCode: pCode,
      ),
      time: const Duration(
        milliseconds: 300,
      ),
    );
  }

  Future<void> getAllCreditNotes({
    bool loadMore = false,
    required String pCode,
  }) async {
    if (loadMore && !hasMoreData.value) {
      return;
    }
    if (isFetchingData) return;

    try {
      isFetchingData = true;

      if (!loadMore) {
        isLoading.value = true;
        currentPage = 1;
        creditNotes.clear();
      } else {
        isLoadingMore.value = true;
      }

      var fetchedCreditNotes = await CreditNotesRepo.getAllCreditNotes(
        pageNumber: currentPage,
        pageSize: pageSize,
        searchText: searchQuery.value,
        pCode: pCode,
      );

      if (fetchedCreditNotes.isNotEmpty) {
        creditNotes.addAll(fetchedCreditNotes);
        currentPage++;
      } else {
        hasMoreData(false);
      }
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
      isFetchingData = false;
    }
  }
}
