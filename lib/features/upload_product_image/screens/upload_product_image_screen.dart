import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/constants/image_constants.dart';
import 'package:shreeji_dairy/features/upload_product_image/controllers/upload_product_image_controller.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_dropdown.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';

class UploadProductImageScreen extends StatelessWidget {
  UploadProductImageScreen({
    super.key,
  });

  final UploadProductImageController _controller = Get.put(
    UploadProductImageController(),
  );

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      _controller.selectedImage.value = File(pickedFile.path);
    }
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
              title: 'Upload Product Image',
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
              padding: AppPaddings.p14,
              child: Column(
                children: [
                  Obx(
                    () => AppDropdown(
                      items: _controller.itemNames,
                      hintText: 'Item',
                      onChanged: (value) {
                        _controller.onItemSelected(value!);
                      },
                      selectedItem: _controller.selectedIName.value.isNotEmpty
                          ? _controller.selectedIName.value
                          : null,
                    ),
                  ),
                  AppSpaces.v10,
                  Obx(
                    () {
                      if (_controller.selectedImage.value == null) {
                        return GestureDetector(
                          onTap: pickImage,
                          child: Container(
                            height: 0.2.screenHeight,
                            width: 0.75.screenHeight,
                            decoration: BoxDecoration(
                              color: kColorLightGrey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CustomPaint(
                                  size: Size(
                                    double.infinity,
                                    double.infinity,
                                  ),
                                  painter: DashedBorderPainter(),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      kIconUploadProductImage,
                                      height: 30,
                                      width: 30,
                                      colorFilter: ColorFilter.mode(
                                        kColorSecondary,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    AppSpaces.h10,
                                    Text(
                                      'Upload Product Image',
                                      style: TextStyles.kRegularFredoka(
                                        color: kColorSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Image.file(
                          _controller.selectedImage.value!,
                          fit: BoxFit.cover,
                        );
                      }
                    },
                  ),
                ],
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

class DashedBorderPainter extends CustomPainter {
  final double dashWidth = 10.0;
  final double dashSpace = 5.0;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = kColorSecondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final Path path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    _drawDashedBorder(canvas, path, paint);
  }

  void _drawDashedBorder(Canvas canvas, Path path, Paint paint) {
    double totalLength = 0.0;
    PathMetrics pathMetrics = path.computeMetrics();
    for (PathMetric pathMetric in pathMetrics) {
      while (totalLength < pathMetric.length) {
        final double start = totalLength;
        final double end = totalLength + dashWidth;
        canvas.drawPath(
          pathMetric.extractPath(
              start, end > pathMetric.length ? pathMetric.length : end),
          paint,
        );
        totalLength = end + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
