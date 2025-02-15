import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/credit_note/credit_note_details/controllers/credit_note_details_controller.dart';
import 'package:shreeji_dairy/features/credit_note/credit_note_details/widgets/credit_note_details_card.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';

class CreditNoteDetailsScreen extends StatefulWidget {
  const CreditNoteDetailsScreen({
    super.key,
    required this.invNo,
  });

  final String invNo;

  @override
  State<CreditNoteDetailsScreen> createState() =>
      _CreditNoteDetailsScreenState();
}

class _CreditNoteDetailsScreenState extends State<CreditNoteDetailsScreen> {
  final CreditNoteDetailsController _controller = Get.put(
    CreditNoteDetailsController(),
  );

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  void _initialize() async {
    await _controller.getCreditNoteDetails(
      invNo: widget.invNo,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: kColorWhite,
          appBar: AppAppbar(
            title: 'Credit Note Details',
            subtitle: widget.invNo,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios,
                size: 25,
                color: kColorTextPrimary,
              ),
            ),
          ),
          body: Padding(
            padding: AppPaddings.p10,
            child: Column(
              children: [
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      shrinkWrap: true,
                      itemCount: _controller.creditNoteDetails.length,
                      itemBuilder: (context, index) {
                        final detail = _controller.creditNoteDetails[index];
                        return CreditNoteDetailsCard(
                          detail: detail,
                        );
                      },
                    ),
                  ),
                ),
                AppSpaces.v10,
              ],
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
