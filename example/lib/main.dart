import 'package:flutter/material.dart';
import 'package:pretty_gauge/pretty_gauge.dart';
import 'package:pretty_gauge/dial_gauge.dart';
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
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Container(
                    //       child: PrettyDial(
                    //         minValue: 0,
                    //         maxValue: 150,
                    //         dialsize: 500,
                    //         segments: [
                    //           DialSegment('Good', 40, Colors.green),
                    //           DialSegment('Good', 30, Colors.blue),
                    //           DialSegment('High', 80, Colors.red),
                    //         ],
                    //         currentValue: 90,
                    //         showMarkers: true,
                    //         displayWidget: const Text('Current Speed',
                    //             style: TextStyle(fontSize: 16)),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: PrettyDialNew(
                            minValue: 0,
                            maxValue: 120,
                            interval: 19,
                            dialsize: 500,
                            segments: [
                              DialSegmentNew('Extremely Low', 20, Colors.green),
                              DialSegmentNew('Low', 40, Colors.blue),
                              DialSegmentNew('Good', 30, Colors.orange),
                              DialSegmentNew('High', 30, Colors.red),
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
