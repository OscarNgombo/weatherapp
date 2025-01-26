import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

IconData weatherIcon(String iconCode) {
  switch (iconCode) {
    case '01d':
      return WeatherIcons.day_sunny; // Clear Day
    case '01n':
      return WeatherIcons.night_clear; // Clear Night
    case '02d':
      return WeatherIcons.day_cloudy; // Few Clouds Day
    case '02n':
      return WeatherIcons.night_cloudy; // Few Clouds Night
    case '03d':
      return WeatherIcons.day_cloudy_gusts;
    case '03n':
      return WeatherIcons.night_cloudy_gusts; // Scattered Clouds
    case '04d':
      return WeatherIcons.day_cloudy_high;
    case '04n':
      return WeatherIcons.night_cloudy_high; // Broken Clouds
    case '09d':
      return WeatherIcons.day_showers; // Shower Rain
    case '09n':
      return WeatherIcons.night_showers; // Shower Rain
    case '10d':
      return WeatherIcons.day_rain; // Rain
    case '10n':
      return WeatherIcons.night_rain; // Rain Night
    case '11d':
      return WeatherIcons.day_thunderstorm; // Thunderstorm
    case '11n':
      return WeatherIcons.night_thunderstorm; // Thunderstorm
    case '13d':
      return WeatherIcons.day_snow; // Snow
    case '13n':
      return WeatherIcons.night_snow; // Snow
    case '50d':
      return WeatherIcons.day_fog; // Mist
    case '50n':
      return WeatherIcons.night_fog; // Mist
    default:
      return Icons.error; // Default Icon
  }
}
