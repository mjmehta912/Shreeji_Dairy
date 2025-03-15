import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/credit_note/credit_note_entry/screens/credit_note_entry_screen.dart';
import 'package:shreeji_dairy/features/credit_note/credit_notes/controllers/credit_notes_controller.dart';
import 'package:shreeji_dairy/features/credit_note/credit_notes/widgets/credit_notes_card.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';

class CreditNotesScreen extends StatefulWidget {
  const CreditNotesScreen({
    super.key,
    required this.pName,
    required this.pCode,
  });

  final String pName;
  final String pCode;

  @override
  State<CreditNotesScreen> createState() => _CreditNotesScreenState();
}

class _CreditNotesScreenState extends State<CreditNotesScreen> {
  final CreditNotesController _controller = Get.put(
    CreditNotesController(),
  );

  @override
  void initState() {
    super.initState();
    _controller.getAllCreditNotes(
      pCode: widget.pCode,
    );
    _controller.debounceSearchQuery(
      widget.pCode,
    );
  }

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
              subtitle: widget.pName,
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
                await _controller.getAllCreditNotes(
                  pCode: widget.pCode,
                );
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
                                style: TextStyles.kRegularFredoka(),
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
                                  pCode: widget.pCode,
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
                                  return CreditNotesCard(
                                    creditNote: creditNote,
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
                    pCode: widget.pCode,
                    pName: widget.pName,
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
        Obx(
          () => AppLoadingOverlay(
            isLoading: _controller.isLoading.value,
          ),
        ),
      ],
    );
  }
}
