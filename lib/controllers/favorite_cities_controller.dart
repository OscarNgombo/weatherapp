import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/city_model.dart';

class FavoriteCitiesController extends GetxController {
  var favoriteCities = <String>[].obs;
  var cities = <City>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadFavoriteCities();
    loadCityData();
  }

  void loadFavoriteCities() async {
    final prefs = await SharedPreferences.getInstance();
    favoriteCities.value = prefs.getStringList('favoriteCities') ?? [];
  }

  void addFavoriteCity(String city) async {
    favoriteCities.add(city);
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favoriteCities', favoriteCities);
  }

  void loadCityData() async {
    final String response = await rootBundle.loadString('assets/other/cities/city.json');
    final data = await json.decode(response) as List;
    cities.value = data.map((city) => City.fromJson(city)).toList();
  }
}