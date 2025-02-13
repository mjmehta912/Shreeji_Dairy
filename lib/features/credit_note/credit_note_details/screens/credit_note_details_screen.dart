import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/credit_note/credit_note_details/controllers/credit_note_details_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_card1.dart';
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

  void _showImagePreview(String imageUrl) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl.startsWith('http') ? imageUrl : 'http://$imageUrl',
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: -12.5,
              right: -12.5,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kColorBlackWithOpacity,
                  ),
                  padding: AppPaddings.p6,
                  child: Icon(
                    Icons.close,
                    color: kColorWhite,
                    size: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
                        return AppCard1(
                          child: Padding(
                            padding: AppPaddings.p12,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: GestureDetector(
                                    onTap: () {
                                      _showImagePreview(
                                        detail.imagePath,
                                      );
                                    },
                                    child: Image.network(
                                      detail.imagePath.startsWith('http')
                                          ? detail.imagePath
                                          : 'http://${detail.imagePath}',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                AppSpaces.h10,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        detail.iName,
                                        style: TextStyles.kMediumFredoka(
                                          fontSize: FontSizes.k18FontSize,
                                        ),
                                      ),
                                      Text(
                                        'Qty : ${detail.qty}',
                                        style: TextStyles.kRegularFredoka(
                                          fontSize: FontSizes.k18FontSize,
                                        ),
                                      ),
                                      Text(
                                        'Status : ${detail.statusText}',
                                        style: TextStyles.kRegularFredoka(
                                          fontSize: FontSizes.k18FontSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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
