import 'package:get/get.dart';
import 'package:qurocare_test/models/product_model.dart';
import 'package:qurocare_test/services/api_services.dart';

class ProductController extends GetxController {
  // Observable state variables
  final products = <Product>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Convenience getters
  bool get hasError => errorMessage.value.isNotEmpty;
  bool get isLoaded => !isLoading.value && !hasError && products.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    fetchProducts(); // Auto-fetch when controller is initialized
  }

  /// Fetches products from the API and updates observables.
  Future<void> fetchProducts() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await ApiService.fetchProducts();
      products.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }
}