/// Used to request temperatures in a given.
enum TemperatureUnit {
  /// Temperature unit used in most of the world.
  /// https://en.wikipedia.org/wiki/Celsius
  celsius('°C'),

  /// Temperature unit used in the USA, Cayman Islands and Liberia
  /// https://en.wikipedia.org/wiki/Fahrenheit
  farenheit('°F'),

  /// https://en.wikipedia.org/wiki/Kelvin
  kelvin('°K');

  const TemperatureUnit(this.sign);

  /// The sign by which the unit is represented.
  final String sign;
}
