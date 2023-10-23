import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../controllers/localnotification_controller.dart';
import '../../controllers/logincontroller.dart';
import '../../controllers/notificationcontroller.dart';
import '../../controllers/ordercontroller.dart';
import '../../controllers/profilecontroller.dart';
import '../../statics/appcolors.dart';

import 'package:badges/badges.dart' as badges;

import '../../widgets/components/ordercomponent.dart';
import '../../widgets/components/storecomponent.dart';
import 'notifications.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  var storeItems;
  final ProfileController profileController = Get.find();
  final NotificationController notificationController = Get.find();
  final OrderController orderController = Get.find();
  final LoginController loginController = Get.find();
  final storage = GetStorage();
  late String uToken = "";

  late Timer _timer;

  @override
  void initState() {
    if (storage.read("token") != null) {
      uToken = storage.read("token");
    }
    scheduleTimers();
    super.initState();
  }

  void scheduleTimers() {
    profileController.getMyProfile(uToken);
    orderController.getAllOrders(uToken);
    orderController.getAllPendingOrders(uToken);
    orderController.getAllProcessingOrders(uToken);
    orderController.getAllPickedUpOrders(uToken);
    orderController.getAllDeliveredOrders(uToken);
    notificationController.getAllTriggeredNotifications(uToken);
    notificationController.getAllUnReadNotifications(uToken);
    notificationController.getAllNotifications(uToken);
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      profileController.getMyProfile(uToken);
      orderController.getAllOrders(uToken);
      orderController.getAllPendingOrders(uToken);
      orderController.getAllProcessingOrders(uToken);
      orderController.getAllPickedUpOrders(uToken);
      orderController.getAllDeliveredOrders(uToken);
      notificationController.getAllTriggeredNotifications(uToken);
      notificationController.getAllUnReadNotifications(uToken);
      notificationController.getAllNotifications(uToken);
      for (var i in notificationController.triggered) {
        LocalNotificationController().showNotifications(
          title: i['notification_title'],
          body: i['notification_message'],
        );
      }
    });

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      for (var e in notificationController.triggered) {
        notificationController.unTriggerNotifications(e["id"], uToken);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(profileController.username,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        actions: [
          IconButton(
            onPressed: () {
              loginController.logoutUser(uToken);
            },
            icon:
                const Icon(FontAwesomeIcons.signOut, color: defaultTextColor2),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => const OrderComponent());
                  },
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: SizedBox(
                        height: 150,
                        width: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.shopping_bag, size: 50),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text("Orders",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 10,
                            ),
                            GetBuilder<OrderController>(builder: (controller) {
                              return Text(
                                  "(${controller.pendingOrders.length})",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold));
                            })
                          ],
                        ),
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const Notifications());
                  },
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: SizedBox(
                        height: 150,
                        width: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.notifications, size: 50),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text("Notifications",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 10,
                            ),
                            GetBuilder<NotificationController>(
                                builder: (controller) {
                              return Text("(${controller.notRead.length})",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold));
                            })
                          ],
                        ),
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
