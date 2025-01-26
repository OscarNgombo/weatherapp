import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorite_cities_controller.dart';

class AddCityDialog extends StatelessWidget {
  const AddCityDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteCitiesController favoriteCitiesController = Get.find();
    final TextEditingController searchController = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Search city',
            ),
            onChanged: (value) {
              favoriteCitiesController.filterCities(value);
            },
          ),
          const SizedBox(height: 10),
          Obx(() {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: favoriteCitiesController.filteredCities.isEmpty
                  ? const Center(
                      child: Text('No cities found'),
                    )
                  : Scrollbar(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: favoriteCitiesController.filteredCities.length,
                        itemBuilder: (context, index) {
                          final city = favoriteCitiesController.filteredCities[index];
                          return ListTile(
                            title: Text(city.name, style: Theme.of(context).textTheme.titleMedium),
                            onTap: () {
                              favoriteCitiesController.addFavoriteCity(city.name);
                              Get.back();
                            },
                          );
                        },
                      ),
                    ),
            );
          }),
        ],
      ),
    );
  }
}
