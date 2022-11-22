import 'package:flutter/material.dart';
import 'package:pretty_gauge/pretty_gauge.dart';
import 'package:pretty_gauge/dial_gauge_new.dart';

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
                          child: PrettyDialNew(
                            minValue: 0,
                            maxValue: 120,
                            isTickerShowDouble: false,
                            interval: 10,
                            dialsize: 500,
                            firstSegmentColor:
                                Color.fromARGB(255, 159, 230, 73),
                            lastSegmentColor: Color.fromARGB(255, 230, 73, 73),
                            segments: [
                              // currently manually set the value of color in segments
                              DialSegmentNew(
                                  'Extremely Low',
                                  20,
                                  Color.fromARGB(255, 159, 230, 73),
                                  Color.fromARGB(255, 170, 203, 73)),
                              DialSegmentNew(
                                  'Low',
                                  30,
                                  Color.fromARGB(255, 170, 203, 73),
                                  Color.fromARGB(255, 188, 164, 73)),
                              DialSegmentNew(
                                  'Good',
                                  30,
                                  Color.fromARGB(255, 188, 164, 73),
                                  Color.fromARGB(255, 206, 125, 73)),
                              DialSegmentNew(
                                  'High',
                                  40,
                                  Color.fromARGB(255, 206, 125, 73),
                                  Color.fromARGB(255, 230, 73, 73)),
                            ],
                            currentValue: 10,
                            showMarkers: true,
                            displayWidget: const Text('Current Speed',
                                style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    )
                  ])),
        ));
  }
}
