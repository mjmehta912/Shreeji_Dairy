import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/credit_note/credit_note_details/screens/credit_note_details_screen.dart';
import 'package:shreeji_dairy/features/credit_note/credit_note_entry/screens/credit_note_entry_screen.dart';
import 'package:shreeji_dairy/features/credit_note/credit_notes/controllers/credit_notes_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';

class CreditNotesScreen extends StatelessWidget {
  CreditNotesScreen({
    super.key,
    required this.pName,
    required this.pCode,
  });

  final String pName;
  final String pCode;

  final CreditNotesController _controller = Get.put(
    CreditNotesController(),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: kColorWhite,
            appBar: AppAppbar(
              title: 'Credit Notes',
              subtitle: pName,
              leading: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 25,
                  color: kColorTextPrimary,
                ),
              ),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                await _controller.getAllCreditNotes();
              },
              child: Padding(
                padding: AppPaddings.p10,
                child: Column(
                  children: [
                    AppTextFormField(
                      controller: _controller.searchController,
                      hintText: 'Search Credit Note',
                      onChanged: (query) {
                        _controller.searchQuery.value = query;
                      },
                    ),
                    AppSpaces.v14,
                    Obx(
                      () {
                        if (_controller.creditNotes.isEmpty &&
                            !_controller.isLoading.value) {
                          return Expanded(
                            child: Center(
                              child: Text(
                                'No credit notes found.',
                                style: TextStyles.kMediumFredoka(),
                              ),
                            ),
                          );
                        }
                        return Expanded(
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (scrollNotification) {
                              if (scrollNotification is ScrollEndNotification &&
                                  scrollNotification.metrics.extentAfter == 0) {
                                _controller.getAllCreditNotes(
                                  loadMore: true,
                                );
                              }
                              return false;
                            },
                            child: Obx(
                              () => ListView.builder(
                                itemCount: _controller.creditNotes.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == _controller.creditNotes.length) {
                                    return _controller.isLoadingMore.value
                                        ? Padding(
                                            padding: AppPaddings.p16,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                color: kColorSecondary,
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink();
                                  }
                                  final creditNote =
                                      _controller.creditNotes[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Get.to(
                                        () => CreditNoteDetailsScreen(
                                          invNo: creditNote.invNo,
                                        ),
                                      );
                                    },
                                    child: AppCard1(
                                      child: Padding(
                                        padding: AppPaddings.p10,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Inv No.',
                                                  style:
                                                      TextStyles.kLightFredoka(
                                                    fontSize:
                                                        FontSizes.k16FontSize,
                                                  ),
                                                ),
                                                AppSpaces.h10,
                                                Text(
                                                  creditNote.invNo,
                                                  style:
                                                      TextStyles.kMediumFredoka(
                                                    fontSize:
                                                        FontSizes.k16FontSize,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Party Name',
                                                  style:
                                                      TextStyles.kLightFredoka(
                                                    fontSize:
                                                        FontSizes.k16FontSize,
                                                  ),
                                                ),
                                                AppSpaces.h10,
                                                Text(
                                                  creditNote.pName,
                                                  style:
                                                      TextStyles.kMediumFredoka(
                                                    fontSize:
                                                        FontSizes.k16FontSize,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Remark',
                                                  style:
                                                      TextStyles.kLightFredoka(
                                                    fontSize:
                                                        FontSizes.k16FontSize,
                                                  ),
                                                ),
                                                AppSpaces.h10,
                                                Text(
                                                  creditNote.remark,
                                                  style:
                                                      TextStyles.kMediumFredoka(
                                                    fontSize:
                                                        FontSizes.k16FontSize,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Get.to(
                  () => CreditNoteEntryScreen(
                    pCode: pCode,
                    pName: pName,
                  ),
                );
              },
              elevation: 5,
              shape: const CircleBorder(),
              backgroundColor: kColorPrimary,
              child: const Icon(
                Icons.add,
                size: 30,
                color: kColorTextPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
