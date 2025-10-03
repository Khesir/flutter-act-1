import '../entities/product.dart';

class GetProducts {
  Future<List<Product>> call() async {
    // fake async data
    await Future.delayed(Duration(milliseconds: 500));
    return [Product("1", "Laptop", 999.99), Product("2", "Phone", 499.99)];
  }
}
