import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/image_constants.dart';

class ProductsController extends GetxController {
  var isLoading = false.obs;

  final List<String> imagePaths = [
    kImageAd1,
    kImageAd2,
    kImageAd3,
  ];

  var searchController = TextEditingController();
  final filterOptions = [
    'Sort By',
    'Category',
    'Group',
    'Sub Group',
  ].obs;

  final selectedFilters = <String>[].obs;

  final Map<String, List<String>> filterSubOptions = {
    'Sort By': [
      'Price Low to High',
      'Price High to Low',
      'Newest First',
      'Newest Last',
      'Alphabetically A-Z',
      'Alphabetically Z-A',
    ],
    'Category': [
      'Dairy',
      'Bakery',
      'Sweets',
      'Namkeen',
    ],
    'Group': [
      'Group A',
      'Group B',
      'Group C',
    ],
    'Sub Group': ['Sub A', 'Sub B', 'Sub C'],
    'Semi Finished': ['Option 1', 'Option 2', 'Option 3'],
  };

  final Map<String, String> selectedSubOptions = {}.obs as Map<String, String>;

  List<String> get reorderedFilterOptions {
    final selected = selectedFilters.toList();
    final unselected = filterOptions
        .where(
          (filter) => !selected.contains(filter),
        )
        .toList();
    return [...selected, ...unselected];
  }

  void toggleFilter(String filter) {
    if (selectedFilters.contains(filter)) {
      selectedFilters.remove(filter);
    } else {
      selectedFilters.add(filter);
    }
  }

  void selectSubOption(String filter, String subOption) {
    selectedSubOptions[filter] = subOption;
  }
}
