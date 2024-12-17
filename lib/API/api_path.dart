class APIPath {
  // Base URL
  static const String baseUrl =
      'http://10.0.2.2:8000'; // Replace with your actual base URL

  //login
  static String login() => '$baseUrl/customer/login';
  //signup
  static String signup() => '$baseUrl/customer/signup';
  //profile
  static String profile(String customerId) =>
      '$baseUrl/customer/profile?customer_id=$customerId';

  // Endpoints for Products
  static String getAllProducts() => '$baseUrl/products/';
  static String getProductById(String productId) =>
      '$baseUrl/products/$productId';
  static String getProductsByCategory(String categoryName) =>
      '$baseUrl/products/category/$categoryName';
  static String createProduct() => '$baseUrl/products';
  static String updateProduct(String productId) =>
      '$baseUrl/products/$productId';
  static String deleteProduct(String productId) =>
      '$baseUrl/products/$productId';

  // Endpoints for Cart
  static String addToCart(String customerId, String productId) =>
      '$baseUrl/cart/add?customer_id=$customerId&product_id=$productId';
  static String updateCart() => '$baseUrl/cart/update';
  static String viewCart() => '$baseUrl/cart/';
  static String viewAllCarts() => '$baseUrl/cart/all';

  // Other related endpoints (if any)
  static String getCategories() => '$baseUrl/category';
  static String searchProducts(String query) =>
      '$baseUrl/products/search?query=$query';

  // Endpoints for Reviews
  static String addReview() => '$baseUrl/products/addreview';
  static String getReviews() => '$baseUrl/products/getreviews';
  static String deleteReview() => '$baseUrl/products/deleteReview';

  // Endpoints for Wishlist
  static String addToWishlist() => '$baseUrl/products/addwishlist';
  static String removeFromWishlist() => '$baseUrl/products/removewishlist';

  //Endpoints for Order
  static String placeOrder() => '$baseUrl/orders/place';

  //Endpoints for Address
  static String getAddress(String customerId) =>
      '$baseUrl/customer/address/get?customer_id=$customerId';
}
