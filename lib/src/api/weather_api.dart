import 'dart:convert';

import 'package:http/http.dart';
import 'package:weather_sdk/src/api/exceptions.dart';
import 'package:weather_sdk/src/api/temperature_unit.dart';
import 'package:weather_sdk/src/api/weather_forecast.dart';

/// Retrieves a weather forecast for a given location.
class WeatherApi {
  /// Instantiates an instance of this class.
  ///
  /// Pass a custom [client] for testing or to use `cupertino_http` or `cronet_http`
  WeatherApi(this._apiKey, {Client? client})
      : assert(_apiKey.isNotEmpty),
        _client = client ?? Client();

  /// This builds a special faster decoder on newer Dart versions.
  static final _utf8JsonDecoder = const Utf8Decoder().fuse(const JsonDecoder());

  final Client _client;
  final String _apiKey;

  /// Retrieves the weather forecast for the given location.
  /// Returns a forecast for at max 5 days.
  ///
  /// [lat] is the latitude of the location.
  /// [lng] is the longitude of the location.
  ///
  /// [unit] configures the temperature unit of the response.
  /// Defaults to [TemperatureUnit.celsius] due to it being used in most parts
  /// of the world.
  Future<List<WeatherDataPoint>> getWeatherForecastForCoordinates({
    required double lat,
    required double lng,
    TemperatureUnit unit = TemperatureUnit.celsius,
  }) async {
    final result = await _client.get(_latLngUrlBuilder(lat, lng, unit));
    result.throwOnProblem();

    final json =
        _utf8JsonDecoder.convert(result.bodyBytes) as Map<String, dynamic>;
    return WeatherForecast.fromJson(json).forecast;
  }

  Uri _latLngUrlBuilder(double lat, double lng, TemperatureUnit unit) {
    return Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lng&units=${unit.name}&appid=$_apiKey',
    );
  }
}

extension on TemperatureUnit {
  String get name {
    return switch (this) {
      TemperatureUnit.celsius => 'metric',
      TemperatureUnit.farenheit => 'imperial',
      TemperatureUnit.kelvin => 'standard',
    };
  }
}

extension on Response {
  /// Exemplary error handling. In production code there should be more checks
  /// for 404s, rate limiting and other issues that may arise in the API.
  void throwOnProblem() {
    if (statusCode >= 500 && statusCode < 600) {
      throw ServerErrorException();
    }
    if (statusCode == 401) {
      throw ApiKeyException();
    }
  }
}
