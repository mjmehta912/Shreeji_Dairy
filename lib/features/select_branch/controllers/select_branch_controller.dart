import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectBranchController extends GetxController {
  var isLoading = false.obs;
  final selectBranchFormKey = GlobalKey<FormState>();

  var selectedBranch = ''.obs;
  var branches = <String>[
    'Branch 1',
    'Branch 2',
    'Branch 3',
    'Branch 4',
    'Branch 5',
    'Branch 6',
  ].obs;

  void onBranchSelected(String branch) {
    selectedBranch.value = branch;
  }
}
