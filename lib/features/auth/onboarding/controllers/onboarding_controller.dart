import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/image_constants.dart';

class OnboardingController extends GetxController {
  RxInt currentPage = 0.obs;

  final List<String> images = [
    kImageShrikhand,
    kImageBaklava,
    kImageHalwa,
  ];

  final List<String> descriptions = [
    'Serving \nfresh delicacies \nsince 1982.',
    'Savour the \nTurkish delicacy \nBaklava.',
    'Experience the \nauthentic Bombay \nIce Halwa.',
  ];

  void nextPage(int totalPages) {
    if (currentPage.value < totalPages - 1) {
      currentPage.value++;
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
  }
}
