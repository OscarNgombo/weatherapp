import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weatherapp/controllers/favorite_cities_controller.dart';
import 'package:weatherapp/controllers/weather_controller.dart';
import 'package:weatherapp/widgets/add_city_dialog.dart';

class FavoriteCitiesView extends StatelessWidget {
  const FavoriteCitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteCitiesController favoriteCitiesController =
        Get.put(FavoriteCitiesController());
    final WeatherController weatherController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Favorite Cities'),
      ),
      body: Center(
        child: Obx(() {
          if (favoriteCitiesController.favoriteCities.isEmpty) {
            return const Text('No selected cities.');
          } else {
            return ListView.builder(
              itemCount: favoriteCitiesController.favoriteCities.length,
              itemBuilder: (context, index) {
                final city = favoriteCitiesController.favoriteCities[index];
                return ListTile(
                  title: Text(city),
                  trailing: IconButton(
                    icon: Icon(
                      favoriteCitiesController.isFavorite(city)
                          ? Icons.star
                          : Icons.star_border,
                      color: favoriteCitiesController.isFavorite(city)
                          ? Colors.amber
                          : null,
                    ),
                    onPressed: () {
                      favoriteCitiesController.toggleFavoriteStatus(city);
                    },
                  ),
                  onTap: () {
                    final selectedCity = favoriteCitiesController.cities
                        .firstWhere((c) => c.name == city);
                    weatherController.setCoordinates(
                        selectedCity.lat, selectedCity.lon);
                    Get.back();
                  },
                );
              },
            );
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.bottomSheet(
            AddCityDialog(),
            isScrollControlled: true,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
