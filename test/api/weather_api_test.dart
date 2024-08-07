import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

import 'package:weather_sdk/weather_sdk.dart';
import 'package:http/testing.dart';

void main() {
  test('getWeatherForecastForCoordinates returns a weather forecast', () async {
    final mockClient = MockClient(_mock);

    final api = WeatherApi('test-api-key', client: mockClient);

    final forecast = await api.getWeatherForecastForCoordinates(lat: 1, lng: 1);

    expect(forecast.first.weather.first.title, 'Rain');
  });

  test('getWeatherForecast throws for 401 response', () async {
    final mockClient = MockClient((request) async {
      return Response('', 401);
    });

    final api = WeatherApi('expired-api-key', client: mockClient);

    await expectLater(
      api.getWeatherForecastForCoordinates(lat: 1, lng: 1),
      throwsA(isA<ApiKeyException>()),
    );
  });
}

Future<Response> _mock(Request request) async {
  final latLngUri = Uri.parse(
    'https://api.openweathermap.org/data/2.5/forecast?lat=1.0&lon=1.0&units=metric&appid=test-api-key',
  );
  if (request.url == latLngUri) {
    return Response(jsonEncode(coordsFakeResponse), 200);
  }
  return Response('', 404);
}

final coordsFakeResponse = {
  'list': [
    {
      'coord': {'lon': 1.0, 'lat': 1.0},
      'weather': [
        {
          'id': 501,
          'main': 'Rain',
          'description': 'moderate rain',
          'icon': '10d',
        },
      ],
      'base': 'stations',
      'main': {
        'temp': 298.48,
        'feels_like': 298.74,
        'temp_min': 297.56,
        'temp_max': 300.05,
        'pressure': 1015,
        'humidity': 64,
        'sea_level': 1015,
        'grnd_level': 933,
      },
      'visibility': 10000,
      'wind': {'speed': 0.62, 'deg': 349, 'gust': 1.18},
      'rain': {'1h': 3.16},
      'clouds': {'all': 100},
      'dt': 1661870592,
      'sys': {
        'type': 2,
        'id': 2075663,
        'country': 'IT',
        'sunrise': 1661834187,
        'sunset': 1661882248,
      },
      'timezone': 7200,
      'id': 3163858,
      'name': 'Boulder',
      'cod': 200,
    }
  ],
};
