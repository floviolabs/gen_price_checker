import 'package:gen_price_checker/pages/dashboard_page.dart';
import 'package:gen_price_checker/pages/found_page.dart';
import 'package:gen_price_checker/pages/not_found_page.dart';
import 'package:gen_price_checker/pages/waiting_configuration_page.dart';

import 'package:get/get.dart';

class Routes {
  // Dashboard Page
  static const String dashboardPage = "/dashboard";
  static String getDashboardPage() => dashboardPage;

  static const String foundPage = "/found";
  static String getFoundPage(String id) => '$foundPage?id=$id';

  static const String notFoundPage = "/not-found";
  static String getNotFoundPage() => notFoundPage;

  static const String waitingConfigurationPage = "/waiting-configuration";
  static String getWaitingConfigurationPage() => waitingConfigurationPage;

  static List<GetPage> routes = [
    GetPage(name: dashboardPage, page: () => const DashboardPage()),
    GetPage(
        name: foundPage,
        page: () {
          var id = Get.parameters['id'];
          return FoundPage(id: id!);
        }),
    GetPage(name: notFoundPage, page: () => const NotFoundPage()),
    GetPage(
        name: waitingConfigurationPage,
        page: () => const WaitingConfigurationPage()),
  ];
}
