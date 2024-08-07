import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:weather_sdk/src/api/temperature_unit.dart';
import 'package:weather_sdk/src/api/weather_api.dart';
import 'package:weather_sdk/src/api/weather_forecast.dart';
import 'package:weather_sdk/src/widgets/weather_widget.dart';

/// This is the main class to control the [WeatherWidget]. It allows you to
/// search for locations, set the unit in which the temperature is displayed,
/// refresh the current forecast and more.
class WeatherForecastController extends ChangeNotifier {
  /// Instantiates the controller.
  ///
  /// Grab the [apiKey] from [https://openweathermap.org/api](OpenWeatherMap).
  ///
  /// Setting a [client] is useful for testing, or when using other client
  /// implementations like `cupertino_http`.
  WeatherForecastController({required String apiKey, Client? client})
      : _api = WeatherApi(apiKey, client: client);

  final WeatherApi _api;

  /// The weather forecast. May be null if no forecast has been made, or no
  /// forecast could be found for the requested location.
  List<WeatherDataPoint>? forecast;

  /// The current state of the [WeatherForecastController].
  ControllerState state = ControllerState.loaded;

  late TemperatureUnit _unit = TemperatureUnit.celsius;

  /// The currently selected temperature unit.
  TemperatureUnit get temperatueUnit => _unit;
  set temperatueUnit(TemperatureUnit newUnit) {
    _unit = newUnit;
    refresh();
  }

  double? _latitude;
  double? _longitude;
  DateTime? _day;

  /// Request the forecast for a given location ([latitude], [longitude]) and
  /// [day]. [day] defaults to tomorrow.
  Future<void> requestForecast({
    required double latitude,
    required double longitude,
    DateTime? day,
  }) async {
    day ??= DateTime.now().add(Duration(days: 1));
    state = ControllerState.loading;
    notifyListeners();

    _latitude = latitude;
    _longitude = longitude;
    _day = day;

    try {
      final result = await _api.getWeatherForecastForCoordinates(
        lat: latitude,
        lng: longitude,
        unit: _unit,
      );
      forecast = result.where((it) => _isSameDay(it.time, day!)).toList();

      state = ControllerState.loaded;
      notifyListeners();
    } catch (e, s) {
      FlutterError.presentError(
        FlutterErrorDetails(exception: e, stack: s, library: 'weather_sdk'),
      );
      state = ControllerState.error;
      notifyListeners();
    }
  }

  /// Refreshes the previous forecast request.
  /// If no forecast request has been made, it's a noop.
  Future<void> refresh() async {
    if (_latitude == null) {
      return;
    }
    await requestForecast(
      latitude: _latitude!,
      longitude: _longitude!,
      day: _day,
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.day == b.day && a.year == b.year && a.month == b.month;
  }
}

/// State of the [WeatherForecastController]
enum ControllerState {
  // The documentation lint is ignored, because there's honestly nothing to
  // add to the name.
  // ignore: public_member_api_docs
  loading,

  /// Indicates that an error happened. This can have various reasons;
  /// - no internet connection
  /// - invalid API key
  /// - invalid HTTP response
  error,

  /// This state indicates that the controller has finished loading.
  /// This does not mean, however, that there's guaranteed to be data.
  /// Sometimes, there's no data available for a given location.
  loaded,
}
