# Weather SDK

## Features

Display a weather forecast for the upcoming 5 days!

## Getting started

## Usage with UI

First, instantiate a `WeatherForecastController` with your API key.

```dart
final _controller = WeatherForecastController(apiKey: '75ab5e7e2f15d1599da672c4a6bc4a87');
// Or, optionally, enable caching by using the CachingClient
final _controller = WeatherForecastController(apiKey: '75ab5e7e2f15d1599da672c4a6bc4a87', client: CachingClient(maxAge: Duration(minutes: 10)));
```

Next, add the `WeatherWidget` to your widget tree:

```dart
Scaffold(
  appBar: AppBar(
    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    title: Text(widget.title),
  ),
  body: WeatherWidget(controller: _controller),
);
```

## Usage without UI

First, instantiate the `WeatherApi` class with your API key.

```dart
final _api = WeatherApi('75ab5e7e2f15d1599da672c4a6bc4a87');
// Or, optionally, enable caching by using the CachingClient
final _api = WeatherApi('75ab5e7e2f15d1599da672c4a6bc4a87', client: CachingClient(maxAge: Duration(minutes: 10)));
```

Next, request a weather forecast:

```dart
final forecast = await _api.getWeatherForecastForCoordinates(
  lat: 52.3676,
  lng: 4.9041,
  unit = TemperatureUnit.celsius, // optional, defaults to Celsius
);
```