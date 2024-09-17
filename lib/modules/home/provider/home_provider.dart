import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practical_1/api/api_end_points.dart';
import 'package:flutter_practical_1/api/api_service.dart';
import 'package:flutter_practical_1/modules/home/model/brand_model.dart';
import 'package:flutter_practical_1/modules/home/model/category_model.dart';
import 'package:flutter_practical_1/modules/home/model/product_model.dart';

class HomeProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Products> allProductList = [];
  List<Products> filterProductModel = [];
  List<BrandModel> brandList = [];
  List<CategoryModel> categoryList = [];

  HomeProvider() {
    getProfileData();
  }

  getProfileData() async {
    isLoading = true;
    notifyListeners();

    final response = await ApiService().getRequest(
      APIEndPoints.productAPI,
    );

    if (response.statusCode == 200) {
      var allProductModel = ProductModel.fromJson(response.data);
      allProductList.addAll(allProductModel.products ?? []);
      filterProductModel = allProductModel.products ?? [];

      getBrandList();
      getCategory();
      isLoading = false;
      notifyListeners();
    } else {
      isLoading = false;
      notifyListeners();
    }
  }

  getBrandList() {
    brandList.clear();
    for (var data in allProductList) {
      if (!brandList.any((e) => e.name == data.brand)) {
        brandList.add(BrandModel(name: data.brand ?? "", isSelected: false));
      }
    }

    brandList.removeWhere((element) => element.name == "");
  }

  getCategory() {
    categoryList.clear();
    for (var data in allProductList) {
      if (!categoryList.any((e) => e.name == data.category)) {
        categoryList
            .add(CategoryModel(name: data.category ?? "", isSelected: false));
      }
    }
  }

  void filterList() {
    filterProductModel.clear();
    List<String> selectedBrands = [];
    List<String> selectedCategory = [];

    // Collect selected brands
    for (var data in brandList) {
      if (data.isSelected) {
        selectedBrands.add(data.name);
      }
    }

    // Collect selected categories
    for (var data in categoryList) {
      if (data.isSelected) {
        selectedCategory.add(data.name);
      }
    }

    // Start with the full product list
    List<Products> filteredProducts = allProductList;

    // Filter by brands if any brand is selected
    if (selectedBrands.isNotEmpty) {
      filteredProducts = filteredProducts
          .where((product) => selectedBrands.contains(product.brand))
          .toList();
    }

    // Further filter by category if any category is selected
    if (selectedCategory.isNotEmpty) {
      filteredProducts = filteredProducts
          .where((product) => selectedCategory.contains(product.category))
          .toList();
    }

    // Update the filterProductModel with the filtered result
    filterProductModel.addAll(filteredProducts);

    // Notify listeners for UI updates
    notifyListeners();
  }
}
