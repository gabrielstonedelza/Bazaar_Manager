import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../statics/appcolors.dart';

class StoreItemsController extends GetxController {
  bool isLoading = true;
  late List storeItems = [];
  late List storeItemRatings = [];
  late List storeItemRemarks = [];
  late List exclusiveItems = [];
  late List promotionItems = [];
  late List otherItems = [];
  late List allDrinks = [];
  late List allWater = [];

  late List customersRemarks = [];
  late List customersRatings = [];
  late String name = "";
  late String size = "";
  late String oldPrice = "";
  late String newPrice = "";
  late String retailPrice = "";
  late String wholesalePrice = "";
  late String itemPic = "";
  late String description = "";

  Future<void> getAllStoreItems(String token) async {
    try {
      isLoading = true;

      const profileLink = "https://f-bazaar.com/store_api/items/";
      var link = Uri.parse(profileLink);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $token"
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        storeItems.assignAll(jsonData);
        for (var i in storeItems) {
          if (i['exclusive']) {
            if (!exclusiveItems.contains(i)) {
              exclusiveItems.add(i);
            }
          }
          if (i['promotion']) {
            if (!promotionItems.contains(i)) {
              promotionItems.add(i);
            }
          }
          if (!i['promotion'] && !i['exclusive']) {
            if (!otherItems.contains(i)) {
              otherItems.add(i);
            }
          }
          if (i['category'] == "Water") {
            if (!allWater.contains(i)) {
              allWater.add(i);
            }
          }
          if (i['category'] == "Drinks") {
            if (!allDrinks.contains(i)) {
              allDrinks.add(i);
            }
          }
        }
        update();
      } else {
        if (kDebugMode) {
          print(response.body);
        }
      }
    } catch (e) {
      // Get.snackbar("Sorry","something happened or please check your internet connection",snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> getItem(String token, String id) async {
    final profileLink = "https://f-bazaar.com/store_api/items/$id/detail/";
    var link = Uri.parse(profileLink);
    http.Response response = await http.get(link, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $token"
    });
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      name = jsonData['name'];
      size = jsonData['size'];
      oldPrice = jsonData['old_price'];
      newPrice = jsonData['new_price'];
      retailPrice = jsonData['retail_price'];
      wholesalePrice = jsonData['wholesale_price'];
      itemPic = jsonData['get_item_pic'];
      description = jsonData['description'];
      update();
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getItemRemarks(String token, String id) async {
    final profileLink = "https://f-bazaar.com/store_api/item/$id/remarks/";
    var link = Uri.parse(profileLink);
    http.Response response = await http.get(link, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $token"
    });
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      customersRemarks = jsonData;
      update();
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getItemRatings(String token, String id) async {
    final profileLink = "https://f-bazaar.com/store_api/item/$id/ratings/";
    var link = Uri.parse(profileLink);
    http.Response response = await http.get(link, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $token"
    });
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      customersRatings = jsonData;
      update();
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> addToReviews(
      String token, String id, String remarkController) async {
    final loginUrl = "https://f-bazaar.com/store_api/add_remarks/$id/";
    final myLink = Uri.parse(loginUrl);
    final response = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $token"
    }, body: {
      "remark": remarkController
    });

    if (response.statusCode == 201) {
      getItem(token, id);
      update();
      Get.snackbar("Success!", "your review was added",
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: warning,
          colorText: defaultTextColor1);
    } else {
      Get.snackbar("Sorry 😢", "something went wrong",
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: warning,
          colorText: defaultTextColor1);
    }
  }
}
