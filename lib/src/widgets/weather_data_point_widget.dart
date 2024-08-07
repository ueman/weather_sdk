import 'package:flutter/material.dart';
import 'package:weather_sdk/weather_sdk.dart';

/// Displays the given data point based on the given [WeatherDataPoint].
class WeatherDataPointWidget extends StatelessWidget {
  /// Displays the forecast based on the given [WeatherDataPoint].
  const WeatherDataPointWidget({
    super.key,
    required this.weatherDataPoint,
    required this.temperatureUnit,
  });

  /// The data that's visualized by this widget
  final WeatherDataPoint weatherDataPoint;

  /// The unit for the temperature in which the temperature is displayed in
  /// this widget.
  final TemperatureUnit temperatureUnit;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: _WeatherIcon(
              weatherId: weatherDataPoint.weather.first.id!,
            ),
            title: Text(
              '${weatherDataPoint.weather.first.title}: ${weatherDataPoint.weather.first.description}',
            ),
            subtitle: Text(
              'Temperature: ${weatherDataPoint.main!.temp}${temperatureUnit.sign}\n'
              'Time: ${weatherDataPoint.time}',
            ),
          ),
        ],
      ),
    );
  }
}

class _WeatherIcon extends StatelessWidget {
  const _WeatherIcon({required this.weatherId});

  final int weatherId;

  @override
  Widget build(BuildContext context) {
    /// See https://openweathermap.org/weather-conditions#Weather-Condition-Codes-2

    final style = TextStyle(fontSize: 40);

    if (weatherId >= 200 && weatherId < 300) {
      return Text('⛈️', style: style);
    }
    if (weatherId >= 300 && weatherId < 400) {
      return Text('🌧️', style: style);
    }
    if (weatherId >= 500 && weatherId < 600) {
      return Text('🌧️', style: style);
    }
    if (weatherId >= 600 && weatherId < 700) {
      return Text('🌨️');
    }
    if (weatherId >= 700 && weatherId < 800) {
      return Text('🌫️', style: style);
    }
    if (weatherId == 800) {
      return Text('☀️', style: style);
    }
    if (weatherId == 801) {
      return Text('🌤️', style: style);
    }
    if (weatherId == 802) {
      return Text('⛅️', style: style);
    }
    if (weatherId == 803) {
      return Text('☁️', style: style);
    }
    if (weatherId == 804) {
      return Text('☁️☁️', style: style);
    }

    return Text('❓', style: style);
  }
}
