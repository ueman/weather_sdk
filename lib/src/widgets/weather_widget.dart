import 'package:flutter/material.dart';

import 'package:weather_sdk/weather_sdk.dart';

/// A fully fledged weather forcase widget.
class WeatherWidget extends StatefulWidget {
  // ignore: public_member_api_docs
  const WeatherWidget({
    super.key,
    required this.controller,
  });

  // ignore: public_member_api_docs
  final WeatherForecastController controller;

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  final _longitude = TextEditingController(text: '4.9041');
  final _latitude = TextEditingController(text: '52.3676');
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(listenable: widget.controller, builder: _builder);
  }

  Widget _builder(BuildContext context, Widget? child) {
    final body = switch (widget.controller.state) {
      ControllerState.loading => Center(child: CircularProgressIndicator()),
      ControllerState.error =>
        Center(child: Text('An error occured, please try again later')),
      ControllerState.loaded => _weatherForecastLoadedWidget(),
    };
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Form(
          key: _formKey,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _latitude,
                    validator: _validator,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Latitude',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _longitude,
                    validator: _validator,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Longitude',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        SegmentedButton<TemperatureUnit>(
          segments: const <ButtonSegment<TemperatureUnit>>[
            ButtonSegment<TemperatureUnit>(
              value: TemperatureUnit.celsius,
              label: Text('Celsius'),
            ),
            ButtonSegment<TemperatureUnit>(
              value: TemperatureUnit.farenheit,
              label: Text('Fahrenheit'),
            ),
          ],
          multiSelectionEnabled: false,
          selected: <TemperatureUnit>{widget.controller.temperatueUnit},
          onSelectionChanged: (Set<TemperatureUnit> newSelection) {
            widget.controller.temperatueUnit = newSelection.first;
          },
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.controller.requestForecast(
                    latitude: _latitude.numberContent!,
                    longitude: _longitude.numberContent!,
                  );
                }
              },
              child: Text('Search'),
            ),
            ElevatedButton(
              onPressed: widget.controller.refresh,
              child: Text('Refresh'),
            ),
          ],
        ),
        Expanded(child: body),
      ],
    );
  }

  Widget _weatherForecastLoadedWidget() {
    final forecast = widget.controller.forecast;
    if (forecast == null || forecast.isEmpty) {
      return Center(child: Text('No forecast loaded'));
    }
    return WeatherForecastWidget(
      forecast: forecast,
      temperatureUnit: widget.controller.temperatueUnit,
    );
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter valid latitude/longitude';
    }
    if (double.tryParse(value) == null) {
      return 'The input is not a valid number';
    }
    return null;
  }
}

extension on TextEditingController {
  double? get numberContent => double.tryParse(text);
}
