import 'package:fbazaar_wholesale_manager/screens/splashscreen.dart';
import 'package:fbazaar_wholesale_manager/statics/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/localnotification_controller.dart';
import 'controllers/logincontroller.dart';
import 'controllers/notificationcontroller.dart';
import 'controllers/ordercontroller.dart';
import 'controllers/profilecontroller.dart';
import 'controllers/storelistcontroller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await GetStorage.init();
  Get.put(LoginController());
  Get.put(ProfileController());
  Get.put(OrderController());
  Get.put(StoreItemsController());
  Get.put(NotificationController());
  LocalNotificationController().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.leftToRightWithFade,
      theme: ThemeData(
          primaryColor: primaryYellow,
          appBarTheme: const AppBarTheme(
              elevation: 0,
              backgroundColor: defaultTextColor1,
              titleTextStyle: TextStyle(
                  color: defaultTextColor2, fontWeight: FontWeight.bold))),
      home: const SplashScreen(),
    );
  }
}
