import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weatherapp/widgets/add_city_dialog.dart';
import '../controllers/favorite_cities_controller.dart';

class FavoriteCitiesView extends StatelessWidget {
  const FavoriteCitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteCitiesController favoriteCitiesController = Get.put(FavoriteCitiesController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Other Cities'),
      ),
      body: Center(
        child: Obx(() {
          if (favoriteCitiesController.favoriteCities.isEmpty) {
            return const Text('No selected cities.');
          } else {
            return ListView.builder(
              itemCount: favoriteCitiesController.favoriteCities.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(favoriteCitiesController.favoriteCities[index]),
                );
              },
            );
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(AddCityDialog());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
