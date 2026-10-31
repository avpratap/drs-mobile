abstract final class Routes {
  static const splash = '/splash';
  static const signIn = '/sign-in';
  static const home = '/home';
  static const shop = '/shop';
  static const subscriptions = '/subscriptions';
  static const account = '/account';

  // Full-screen flows above the tab shell.
  static const cart = '/cart';
  static const checkout = '/cart/checkout';
  static const payOrder = '/pay';
  static const newAddress = '/addresses/new';
  static const editAddress = '/addresses/edit';
  static String product(int id) => '/product/$id';
  static String productReviews(int id) => '/product/$id/reviews';
  static String writeReview(int id) => '/product/$id/review';

  // Inside tabs (keep the navigation bar).
  static const subscribeBrowse = '/subscriptions/add';
  static String subscribeProduct(int id) => '/subscriptions/add/$id';
  static const orders = '/account/orders';
  static String order(int id) => '/account/orders/$id';
  static const wallet = '/account/wallet';
  static const addresses = '/account/addresses';
  static const profile = '/account/profile';
  static const notificationPrefs = '/account/notifications';
}
