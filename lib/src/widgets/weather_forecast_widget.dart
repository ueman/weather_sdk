import 'package:flutter/material.dart';
import 'package:weather_sdk/weather_sdk.dart';

/// Shows a list of [WeatherDataPointWidget]s. This is typically used to
/// show how the weather changes throughout a specific day.
/// Used by the [WeatherWidget]
class WeatherForecastWidget extends StatelessWidget {
  /// Instantiates an instance of this widget.
  ///
  /// Setting the [temperatureUnit] doesn't actually converts the temperature
  /// data from [forecast], it just controls the unit indicator shown to the
  /// user.
  const WeatherForecastWidget({
    super.key,
    required this.forecast,
    required this.temperatureUnit,
  });

  /// The data that's visualized by this widget
  final List<WeatherDataPoint> forecast;

  /// The unit for the temperature in which the temperature is displayed in
  /// this widget.
  final TemperatureUnit temperatureUnit;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      itemCount: forecast.length,
      itemBuilder: (context, index) {
        final dataPoint = forecast[index];
        return WeatherDataPointWidget(
          weatherDataPoint: dataPoint,
          temperatureUnit: temperatureUnit,
        );
      },
    );
  }
}
