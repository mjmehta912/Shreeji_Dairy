import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/credit_note_status/controllers/credit_note_status_controller.dart';
import 'package:shreeji_dairy/features/credit_note_status/widgets/credit_note_status_card.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';

class CreditNoteStatusScreen extends StatefulWidget {
  const CreditNoteStatusScreen({
    super.key,
    required this.pCode,
    required this.pName,
  });

  final String pCode;
  final String pName;

  @override
  State<CreditNoteStatusScreen> createState() => _CreditNoteStatusScreenState();
}

class _CreditNoteStatusScreenState extends State<CreditNoteStatusScreen> {
  final CreditNoteStatusController _controller = Get.put(
    CreditNoteStatusController(),
  );

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    await _controller.getItemsForApproval(
      pCode: widget.pCode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          child: Scaffold(
            backgroundColor: kColorWhite,
            appBar: AppAppbar(
              title: 'Credit Note Status',
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
            body: Padding(
              padding: AppPaddings.p12,
              child: Obx(
                () {
                  return ListView.builder(
                    itemCount: _controller.itemsForApproval.length,
                    itemBuilder: (context, index) {
                      final item = _controller.itemsForApproval[index];

                      return CreditNoteStatusCard(
                        item: item,
                      );
                    },
                  );
                },
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
