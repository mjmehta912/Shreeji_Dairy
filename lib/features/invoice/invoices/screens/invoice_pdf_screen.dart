import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';

class InvoicePdfScreen extends StatelessWidget {
  final Uint8List pdfBytes;
  final String title;

  const InvoicePdfScreen({
    super.key,
    required this.pdfBytes,
    required this.title,
  });

  Future<void> _sharePdf() async {
    try {
      final tempDir = await getTemporaryDirectory();

      final sanitizedTitle = title.replaceAll(RegExp(r'[^\w\s]+'), '_');
      final fileName = '$sanitizedTitle.pdf';

      final file = File('${tempDir.path}/$fileName');

      await file.writeAsBytes(pdfBytes);

      await Share.shareXFiles(
        [
          XFile(file.path),
        ],
        text: 'Here is a PDF file: $title',
      );
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar(
        title: title,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios,
            size: 25,
            color: kColorTextPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.share,
              size: 25,
              color: kColorTextPrimary,
            ),
            onPressed: _sharePdf,
          ),
        ],
      ),
      body: PDFView(
        backgroundColor: kColorLightGrey,
        pdfData: pdfBytes,
        enableSwipe: true,
        autoSpacing: false,
        pageFling: false,
        fitPolicy: FitPolicy.BOTH,
      ),
    );
  }
}
