import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weatherapp/controllers/weather_controller.dart';
import 'package:weatherapp/views/favorite_cities_view.dart';
import 'package:weatherapp/widgets/icon.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final WeatherController weatherController = Get.put(WeatherController());
    final String formattedDate =
        DateFormat('MMMM dd, yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text(
                  weatherController.cityName.value,
                  style: Theme.of(context).textTheme.titleLarge,
                )),
            SizedBox(
              height: 5.0,
            ),
            Text(
              formattedDate,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add,
                size: 30.0, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () {
              Get.to(() => const FavoriteCitiesView());
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (weatherController.cityName.isEmpty) {
            return Center(child: const CircularProgressIndicator());
          } else if (weatherController.errorMessage.isNotEmpty) {
            return Text(
              weatherController.errorMessage.value,
              style: Theme.of(context).textTheme.bodyLarge,
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Weather Section
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Row(
                        children: [
                          Text(
                            '${weatherController.temperature.value}°C',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          Spacer(),
                          BoxedIcon(weatherIcon(weatherController.iconID.value),
                              size: 50.0,
                              color: Theme.of(context).colorScheme.primary),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Spacer(),
                        Obx(
                          () => Text(
                            weatherController.weatherDescription.value,
                            style: TextStyle(
                              fontFamily: 'ChakraPetch',
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 20.0,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.0),

                Card(
                  elevation: 10.0,
                  child: SizedBox(
                    height: 150,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Humidity',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Text(
                                  '${weatherController.humidity.value}%',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Wind Speed',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Text(
                                  '${weatherController.windSpeed.value} m/s',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Weather',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Text(
                                  weatherController.weatherMain.value,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Timeline for the current day
                SizedBox(height: 20.0),
                Text(
                  "Forecasts for the current day",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'ChakraPetch',
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
                SizedBox(height: 10.0),
                Obx(() {
                  final todayForecasts = weatherController.hourlyWeather
                      .firstWhereOrNull((forecast) =>
                          forecast['day'] ==
                          DateFormat('EEEE').format(DateTime.now()));

                  if (todayForecasts != null) {
                    final forecasts = todayForecasts['forecasts'];
                    return SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: forecasts!.length,
                        itemBuilder: (context, index) {
                          final forecast = forecasts[index];
                          final temp = forecast['temp'];
                          final icon = forecast['icon'];

                          final hour = DateTime.parse(forecast['dt_txt']).hour;

                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  BoxedIcon(
                                    TimeIcon.fromHour(hour),
                                    size: 36.0,
                                    color: Colors.black,
                                  ),
                                  Text('$temp°C'),
                                  BoxedIcon(
                                    weatherIcon(icon),
                                    size: 24.0,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(child: const CircularProgressIndicator());
                  }
                }),
                // Weekly Forecast Section
                SizedBox(height: 20.0),
                Text(
                  'Other 5 days Forecast',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'ChakraPetch',
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
                SizedBox(height: 10.0),
                Expanded(child: Obx(() {
                  if (weatherController.dayWeather.isEmpty) {
                    return Center(child: const CircularProgressIndicator());
                  } else if (weatherController.errorMessage.isNotEmpty) {
                    return Text(
                      weatherController.errorMessage.value,
                      style: Theme.of(context).textTheme.bodyLarge,
                    );
                  } else {
                    return ListView.builder(
                        itemCount: weatherController.dayWeather.length,
                        itemBuilder: (context, index) {
                          final dayData = weatherController.dayWeather[index];
                          final time = DateFormat('EEEE')
                              .format(DateTime.parse(dayData['dt_txt']));
                          final tempMax = dayData['tempMax'];
                          final tempMin = dayData['tempMin'];
                          final icon = dayData['icon'];
                          return Card(
                            borderOnForeground: true,
                            child: ListTile(
                              title: Text(time,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              trailing: Wrap(
                                alignment: WrapAlignment.end,
                                children: [
                                  Text('$tempMin°C'),
                                  Container(
                                    width: 20,
                                    height: 3,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    padding: EdgeInsets.only(top: 4),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context).colorScheme.primary,
                                          Theme.of(context)
                                              .colorScheme
                                              .secondary
                                        ],
                                      ),
                                    ),
                                  ),
                                  Text('$tempMax°C'),
                                  const SizedBox(width: 8),
                                  BoxedIcon(
                                    weatherIcon(icon),
                                    size: 20.0,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }
                })),
                Obx(() => Text(
                      'Last updated: ${weatherController.lastUpdated.value}',
                      style: Theme.of(context).textTheme.bodySmall,
                    )),
              ],
            );
          }
        }),
      ),
    );
  }
}
