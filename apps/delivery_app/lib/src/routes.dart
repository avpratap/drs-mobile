abstract final class Routes {
  static const splash = '/';
  static const login = '/login';
  static const today = '/today';
  static const map = '/today/map';
  static String stop(int id) => '/today/stop/$id';
  static String deliver(int id) => '/today/stop/$id/deliver';
}
