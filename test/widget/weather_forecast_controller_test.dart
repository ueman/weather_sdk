import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

import 'package:weather_sdk/weather_sdk.dart';
import 'package:http/testing.dart';

void main() {
  test('Controller successfully loads data', () async {
    final controller = WeatherForecastController(
      apiKey: 'test-api-key',
      client: alwaysSucceedingClient,
    );

    await expectLater(
      controller.requestForecast(
        latitude: 1,
        longitude: 1,
        day: DateTime(1970, 1, 1),
      ),
      completes,
    );

    expect(controller.state, ControllerState.loaded);
    expect(controller.forecast, isNotEmpty);
  });

  test('refresh successfully reloads data', () async {
    final controller = WeatherForecastController(
      apiKey: 'test-api-key',
      client: alwaysSucceedingClient,
    );

    await expectLater(
      controller.requestForecast(
        latitude: 1,
        longitude: 1,
        day: DateTime(1970, 1, 1),
      ),
      completes,
    );

    await expectLater(
      controller.refresh(),
      completes,
    );

    expect(controller.state, ControllerState.loaded);
    expect(controller.forecast, isNotEmpty);
  });

  test('Controller gracefully fails', () async {
    final controller = WeatherForecastController(
      apiKey: 'test-api-key',
      client: alwaysFailingClient,
    );

    await expectLater(
      controller.requestForecast(latitude: 1, longitude: 1),
      completes,
    );

    expect(controller.state, ControllerState.error);
    expect(controller.forecast, isNull);
  });
}

final alwaysFailingClient = MockClient((_) async {
  return Response('', 401);
});

final alwaysSucceedingClient = MockClient(_mock);

Future<Response> _mock(Request request) async {
  return Response(jsonEncode(goecodingResponse), 200);
}

Map<String, dynamic> get goecodingResponse => {
      'list': [
        {
          'coord': {'lon': -0.13, 'lat': 51.51},
          'weather': [
            {
              'id': 300,
              'main': 'Drizzle',
              'description': 'light intensity drizzle',
              'icon': '09d',
            }
          ],
          'base': 'stations',
          'main': {
            'temp': 280.32,
            'pressure': 1012,
            'humidity': 81,
            'temp_min': 279.15,
            'temp_max': 281.15,
          },
          'visibility': 10000,
          'wind': {'speed': 4.1, 'deg': 80},
          'clouds': {'all': 90},
          'dt': DateTime(1970, 1, 1).millisecond ~/ 1000,
          'sys': {
            'type': 1,
            'id': 5091,
            'message': 0.0103,
            'country': 'USA',
            'sunrise': 1485762037,
            'sunset': 1485794875,
          },
          'id': 2643743,
          'name': 'Boulder',
          'cod': 200,
        }
      ],
    };
