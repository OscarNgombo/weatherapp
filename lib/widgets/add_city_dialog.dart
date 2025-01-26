import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:weatherapp/controllers/favorite_cities_controller.dart';
import 'package:weatherapp/models/city_model.dart';

class AddCityDialog extends StatelessWidget {
  const AddCityDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteCitiesController favoriteCitiesController = Get.find();

    return AlertDialog(
      title: const Text('Add City'),
      content: TypeAheadField<City>(
        suggestionsCallback: (search) => favoriteCitiesController.cities
            .where((city) => city.name.toLowerCase().contains(search.toLowerCase()))
            .toList(),
        builder: (context, controller, focusNode) {
          return TextField(
            controller: controller,
            focusNode: focusNode,
            decoration: const InputDecoration(
              hintText: 'Search city',
            ),
          );
        },
        itemBuilder: (context, City city) {
          return ListTile(
            title: Text(city.name),
          );
        }, onSelected: (city) {          
          favoriteCitiesController.addFavoriteCity(city.name);
          Get.back();
        },
      ),
    );
  }
}
