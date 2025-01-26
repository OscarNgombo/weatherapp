
import 'package:flutter_test/flutter_test.dart';
import 'package:weatherapp/controllers/weather_controller.dart';

void main() {
  group('My class test', () {
    test('Test 1', () {
      // Sample data
      List<Map<String, dynamic>> data = [
        {'date': '2025-01-26 18:00:00.000', 'tempMax': 27.5, 'tempMin': 27.4},
        {'date': '2025-01-26 21:00:00.000', 'tempMax': 27.5, 'tempMin': 27.5},
        {'date': '2025-01-27 00:00:00.000', 'tempMax': 26.8, 'tempMin': 26.8},
        {'date': '2025-01-27 03:00:00.000', 'tempMax': 26.8, 'tempMin': 26.8},
        {'date': '2025-01-27 06:00:00.000', 'tempMax': 26.8, 'tempMin': 26.8},
        {'date': '2025-01-27 09:00:00.000', 'tempMax': 26.9, 'tempMin': 26.9},
        {'date': '2025-01-27 12:00:00.000', 'tempMax': 27.2, 'tempMin': 27.2},
        {'date': '2025-01-27 15:00:00.000', 'tempMax': 27.3, 'tempMin': 27.3},
        {'date': '2025-01-27 18:00:00.000', 'tempMax': 27.5, 'tempMin': 27.5},
        {'date': '2025-01-27 21:00:00.000', 'tempMax': 27.6, 'tempMin': 27.6},
        {'date': '2025-01-28 00:00:00.000', 'tempMax': 27.5, 'tempMin': 27.5},
      ];
WeatherController weatherController = WeatherController();
weatherController.fetchHourlyWeather();
    });
  });
}
