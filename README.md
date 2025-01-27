# WeatherApp

A Flutter project that provides weather information and forecasts for different cities. The app allows users to add favorite cities and view weather data for those cities.

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Android Studio](https://developer.android.com/studio) or [Visual Studio Code](https://code.visualstudio.com/) with Flutter and Dart plugins
- An API key from [OpenWeatherMap](https://openweathermap.org/api)

### Installation

1. Clone the repository:

   ```sh
   git clone https://github.com/yourusername/weatherapp.git
   cd weatherapp
   ```
2. Install dependencies:
   ```sh
      flutter pub get
   ``` 
3. Add your OpenWeatherMap API key:

Open weather_controller.dart
Replace 'YOUR_API_KEY' with your actual API key

### Running the App
1. Connect your device or start an emulator.
2. Run the app:
   ```sh
      flutter run
   ```
### Approach
The app uses the GetX package for state management and dependency injection. It fetches weather data from the OpenWeatherMap API and displays it in a user-friendly interface. Users can add cities to their favorites and view weather data for those cities.

## Features
- Fetch current weather data and 3-hour forecasts
- Add and manage favorite cities
- Display weather data for favorite cities
- Offline storage of weather data using SharedPreferences
- Responsive design for different screen sizes

## Challenges Faced and Solutions Implemented
1. Handling API Requests and Errors
   
   **Challenge:** Ensuring reliable API requests and handling errors gracefully.

   **Solution:** Wrapped API requests in try-catch blocks to handle exceptions and display error messages to the user. Used observables to manage loading states and error messages.

2. Offline Storage

   **Challenge:** Storing weather data locally to provide offline access.
   
   **Solution:** Used SharedPreferences to save and load weather data. Implemented methods to save and load data for current weather and 3-hour forecasts.

3. Responsive Design

   **Challenge:** Ensuring the app works well on different screen sizes.
   
   **Solution:** Used flexible and adaptive layouts with widgets like Expanded, Flexible, MediaQuery, and LayoutBuilder. Adjusted heights and widths dynamically based on available space.

4. Managing Favorite Cities

   **Challenge:** Allowing users to add and manage favorite cities.
   
   **Solution:** Implemented a FavoriteCitiesController to manage the list of favorite cities. Used GetX for state management and dependency injection.

## Resources
- [Flutter Documentation](https://flutter.dev/docs)
- [GetX Documentation](https://pub.dev/packages/get)
- [OpenWeatherMap API](https://openweathermap.org/api)

## Gallery
![Screenshot_20250127_093157](https://github.com/user-attachments/assets/664d4053-82f6-4684-9a89-a98c07cc1d33)
![Screenshot_20250127_015158](https://github.com/user-attachments/assets/fcb2b407-6dd7-4b12-a80c-30b53f15a856)
![Screenshot_20250127_015138](https://github.com/user-attachments/assets/ad039406-90e9-4f33-8bdc-ab793eb6db87)

For help getting started with Flutter development, view the online documentation, which offers tutorials, samples, guidance on mobile development, and a full API reference.
