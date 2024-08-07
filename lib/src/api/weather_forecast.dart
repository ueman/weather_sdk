// I added some doc comments for the sake of the example.
// Typically, I would document these classes more thouroughly.
// ignore_for_file: public_member_api_docs

/// Contains the forecast for the next 5 days in 3 hour steps
///
/// Typically not used outside of this package.
class WeatherForecast {
  WeatherForecast(this.forecast);

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      (json['list'] as List<dynamic>?)
              ?.cast<Map<String, dynamic>>()
              .map((x) => WeatherDataPoint.fromJson(x))
              .toList() ??
          [],
    );
  }

  /// Contains the forecast for the next 5 days in 3 hour steps
  final List<WeatherDataPoint> forecast;
}

/// Weather data point for a specific point in time
class WeatherDataPoint {
  factory WeatherDataPoint.fromJson(Map<String, dynamic> json) {
    return WeatherDataPoint(
      weather: (json['weather'] as List<dynamic>?)
              ?.cast<Map<String, dynamic>>()
              .map((x) => WeatherDescription.fromJson(x))
              .toList() ??
          [],
      main: json['main'] == null
          ? null
          : Main.fromJson(json['main'] as Map<String, dynamic>),
      time: DateTime.fromMillisecondsSinceEpoch(
        (json['dt'] as int) * 1000,
        isUtc: true,
      ),
      timezone: json['timezone'] as int?,
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  WeatherDataPoint({
    required this.weather,
    required this.main,
    required this.time,
    required this.timezone,
    required this.id,
    required this.name,
  });

  final List<WeatherDescription> weather;
  final Main? main;
  final DateTime time;
  final int? timezone;
  final int? id;
  final String? name;
}

class Main {
  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
      temp: json['temp'] as double?,
      feelsLike: json['feels_like'] as num?,
      tempMin: json['temp_min'] as double?,
      tempMax: json['temp_max'] as double?,
      pressure: json['pressure'] as int?,
      humidity: json['humidity'] as int?,
      seaLevel: json['sea_level'] as int?,
      grndLevel: json['grnd_level'] as int?,
    );
  }
  Main({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.seaLevel,
    required this.grndLevel,
  });

  /// Temperature in the unit with which the request was made.
  /// Either Celsius, Fahrenheit or Kelvin
  final double? temp;

  /// A value of how the temperature feels
  final num? feelsLike;

  final double? tempMin;
  final double? tempMax;
  final int? pressure;
  final int? humidity;
  final int? seaLevel;
  final int? grndLevel;
}

class WeatherDescription {
  factory WeatherDescription.fromJson(Map<String, dynamic> json) {
    return WeatherDescription(
      id: json['id'] as int?,
      title: json['main'] as String?,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
    );
  }
  WeatherDescription({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });

  /// The ID of the given weather condition
  final int? id;

  /// The brief description of the weather condition
  final String? title;

  /// A description that's a tad more details than [title]
  final String? description;

  /// Icon ID to be used in a URL for open weather map
  final String? icon;
}
