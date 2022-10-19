import 'package:flutter/material.dart';
import 'package:pretty_gauge/pretty_gauge.dart';
import 'package:pretty_gauge/dial_gauge.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('CustomGauge example app'),
          ),
          body: Container(
              color: Colors.grey[200],
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(children: <Widget>[
                      PrettyGauge(
                        gaugeSize: 200,
                        segments: [
                          GaugeSegment('Low', 20, Colors.red),
                          GaugeSegment('Medium', 40, Colors.orange),
                          GaugeSegment('High', 40, Colors.green),
                        ],
                        currentValue: 60,
                        displayWidget: const Text('Fuel in tank',
                            style: TextStyle(fontSize: 12)),
                      ),
                      PrettyGauge(
                        gaugeSize: 200,
                        segments: [
                          GaugeSegment('Critically Low', 10, Colors.red),
                          GaugeSegment('Low', 20, Colors.orange),
                          GaugeSegment('Medium', 20, Colors.yellow),
                          GaugeSegment('High', 50, Colors.green),
                        ],
                        currentValue: 45,
                        needleColor: Colors.red,
                        showMarkers: false,
                        displayWidget: const Text('Fuel in tank',
                            style: TextStyle(fontSize: 12)),
                      ),
                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: PrettyDial(
                            minValue: 0,
                            maxValue: 150,
                            dialsize: 500,
                            segments: [
                              DialSegment('Good', 80, Colors.green),
                              DialSegment('High', 70, Colors.red),
                            ],
                            currentValue: 120,
                            showMarkers: true,
                            displayWidget: const Text('Speed',
                                style: TextStyle(fontSize: 12)),
                          ),
                        ),
                      ],
                    )
                  ])),
        ));
  }
}
