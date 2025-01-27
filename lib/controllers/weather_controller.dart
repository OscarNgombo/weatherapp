import 'dart:math';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WeatherController extends GetxController {
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var weatherMain = ''.obs;
  var weatherDescription = ''.obs;
  var temperature = 0.0.obs;
  var humidity = 0.obs;
  var windSpeed = 0.0.obs;
  var cityName = ''.obs;
  var errorMessage = ''.obs;
  var isLoading = false.obs;
  var iconID = ''.obs;
  var hourlyWeather = <Map<String, dynamic>>[].obs;
  var dayWeather = <Map<String, dynamic>>[].obs;
  var lastUpdated = ''.obs;

  final apiKey = 'YOUR_API_KEY';

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    loadWeatherData();
    loadHourlyWeatherData();
    loadForecastData();
  }

  void getCurrentLocation() async {
    isLoading.value = true;
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      errorMessage.value = 'Location services are disabled.';
      isLoading.value = false;
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        errorMessage.value = 'Location permissions are denied';
        isLoading.value = false;
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      errorMessage.value =
          'Location permissions are permanently denied, we cannot request permissions.';
      isLoading.value = false;
      return;
    }

    // When we reach here, permissions are granted and we can continue
    Position position = await Geolocator.getCurrentPosition();
    latitude.value = position.latitude;
    longitude.value = position.longitude;

    fetchWeather();
    fetchForecast();
    fetch3HourForecast();
  }

  void setCoordinates(double lat, double lon) {
    latitude.value = lat;
    longitude.value = lon;
    fetchWeather();
    fetchForecast();
    fetch3HourForecast();
  }

  void fetchWeather() async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=${latitude.value}&lon=${longitude.value}&appid=$apiKey&units=metric';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        weatherMain.value = data['weather'][0]['main'];
        weatherDescription.value = data['weather'][0]['description'];
        temperature.value = (data['main']['temp'] as num).toDouble();
        humidity.value = data['main']['humidity'];
        windSpeed.value = (data['wind']['speed'] as num).toDouble();
        cityName.value = data['name'];
        iconID.value = data['weather'][0]['icon'];
        lastUpdated.value =
            DateFormat('MMMM dd, yyyy HH:mm').format(DateTime.now());
        saveWeatherData();
        isLoading.value = false;
      } else {
        errorMessage.value = 'Failed to load weather data';
        isLoading.value = false;
      }
    } catch (e) {
      errorMessage.value = 'Connection failed: $e';
      isLoading.value = false;
    }
  }

  void fetchForecast() async {
    final url =
        'https://api.openweathermap.org/data/2.5/forecast?lat=${latitude.value}&lon=${longitude.value}&appid=$apiKey&units=metric';
    try {
      final response = await http.get(Uri.parse(url));
      String today = DateFormat('EEEE').format(DateTime.now());

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        dayWeather.clear();

        Map<String, Map<String, dynamic>> dailyData = {};

        for (var entry in data['list']) {
          DateTime dateTime = DateTime.parse(entry['dt_txt']);
          String day = DateFormat('EEEE').format(dateTime);

          if (day != today) {
            if (!dailyData.containsKey(day)) {
              dailyData[day] = {
                'dt_txt': entry['dt_txt'],
                'tempMax': entry['main']['temp_max'].toDouble(),
                'tempMin': entry['main']['temp_min'].toDouble(),
                'icon': entry['weather'][0]['icon'],
              };
            } else {
              dailyData[day]?['tempMax'] = max<double>(
                  dailyData[day]?['tempMax'],
                  entry['main']['temp_max'].toDouble());
              dailyData[day]?['tempMin'] = min<double>(
                  dailyData[day]?['tempMin'],
                  entry['main']['temp_min'].toDouble());

              dailyData[day]?['icon'] = entry['weather'][0]['icon'];
            }
          }
        }
        dayWeather.addAll(dailyData.values.toList());
        saveHourlyWeatherData();
      } else {
        errorMessage.value = 'Failed to load hourly weather data';
      }
    } catch (e) {
      errorMessage.value = 'Connection failed: $e';
      isLoading.value = false;
    }
  }

  void fetch3HourForecast() async {
    final url =
        'https://api.openweathermap.org/data/2.5/forecast?lat=${latitude.value}&lon=${longitude.value}&appid=$apiKey&units=metric';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        hourlyWeather.clear();

        Map<String, List<Map<String, dynamic>>> dailyForecasts = {};

        for (var entry in data['list']) {
          DateTime dateTime = DateTime.parse(entry['dt_txt']);
          String day = DateFormat('EEEE').format(dateTime);

          if (!dailyForecasts.containsKey(day)) {
            dailyForecasts[day] = [];
          }

          dailyForecasts[day]!.add({
            'dt_txt': entry['dt_txt'],
            'temp': entry['main']['temp'].toDouble(),
            'icon': entry['weather'][0]['icon'],
            'description': entry['weather'][0]['description'],
          });
        }
        List<Map<String, dynamic>> forecastList = [];
        dailyForecasts.forEach((day, forecasts) {
          forecastList.add({
            'day': day,
            'forecasts': forecasts,
          });
        });

        hourlyWeather.value = forecastList;
        saveForecastData();
      } else {
        errorMessage.value = 'Failed to load 3-hour forecast data';
      }
    } catch (e) {
      errorMessage.value = 'Connection failed: $e';
      isLoading.value = false;
    }
  }

  void saveWeatherData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('weatherMain', weatherMain.value);
    prefs.setString('weatherDescription', weatherDescription.value);
    prefs.setDouble('temperature', temperature.value);
    prefs.setInt('humidity', humidity.value);
    prefs.setDouble('windSpeed', windSpeed.value);
    prefs.setString('cityName', cityName.value);
    prefs.setString('iconID', iconID.value);
    prefs.setString('lastUpdated', lastUpdated.value);
  }

  void loadWeatherData() async {
    final prefs = await SharedPreferences.getInstance();
    weatherMain.value = prefs.getString('weatherMain') ?? '';
    weatherDescription.value = prefs.getString('weatherDescription') ?? '';
    temperature.value = prefs.getDouble('temperature') ?? 0.0;
    humidity.value = prefs.getInt('humidity') ?? 0;
    windSpeed.value = prefs.getDouble('windSpeed') ?? 0.0;
    cityName.value = prefs.getString('cityName') ?? '';
    iconID.value = prefs.getString('iconID') ?? '';
    lastUpdated.value = prefs.getString('lastUpdated') ?? '';
  }

  void saveHourlyWeatherData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('hourlyWeather', json.encode(hourlyWeather));
  }

  void loadHourlyWeatherData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? hourlyWeatherString = prefs.getString('hourlyWeather');
    if (hourlyWeatherString != null) {
      hourlyWeather.value =
          List<Map<String, dynamic>>.from(json.decode(hourlyWeatherString));
    }
  }

  void saveForecastData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('hourlyWeather', json.encode(hourlyWeather));
  }

  void loadForecastData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? hourlyWeatherString = prefs.getString('hourlyWeather');
    if (hourlyWeatherString != null) {
      hourlyWeather.value =
          List<Map<String, dynamic>>.from(json.decode(hourlyWeatherString));
    }
  }
}
