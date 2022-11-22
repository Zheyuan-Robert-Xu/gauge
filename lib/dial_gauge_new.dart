library pretty_Dial_new;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

///Class that holds the details of each segment on a CustomDial
class DialSegmentNew {
  final String segmentName;

  ///Name of the segment
  final double segmentSize;

  ///The size of the segment
  final Color segmentFirstColor;
  final Color segmentLastColor;

  ///The color of the segment

  DialSegmentNew(this.segmentName, this.segmentSize, this.segmentFirstColor,
      this.segmentLastColor);
}

class DialNeedleClipperNew extends CustomClipper<Path> {
  //Note that x,y coordinate system starts at the bottom right of the canvas
  //with x moving from right to left and y moving from bottm to top
  //Bottom right is 0,0 and top left is x,y
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.7);
    path.lineTo(1.05 * size.width * 0.5, size.height * 0.7);
    path.lineTo(size.width * 0.5, 0);
    path.lineTo(0.95 * size.width * 0.5, size.height * 0.7);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(DialNeedleClipperNew oldClipper) => false;
}

class DialTickerNew extends CustomClipper<Path> {
  //Note that x,y coordinate system starts at the bottom right of the canvas
  //with x moving from right to left and y moving from bottm to top
  //Bottom right is 0,0 and top left is x,y
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.24);
    path.lineTo(1.05 * size.width * 0.5, size.height * 0.24);
    path.lineTo(1.05 * size.width * 0.5, size.height * 0.1);
    path.lineTo(size.width * 0.5, size.height * 0.1);
    path.lineTo(size.width * 0.5, size.height * 0.24);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(DialTickerNew oldClipper) => false;
}

class ScaleTickerNew extends CustomClipper<Path> {
  //Note that x,y coordinate system starts at the bottom right of the canvas
  //with x moving from right to left and y moving from bottm to top
  //Bottom right is 0,0 and top left is x,y
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0.975 * size.width * 0.1, size.height * 0.875);
    path.lineTo(1.2 * size.width * 0.1, size.height * 0.875);
    path.lineTo(1.2 * size.width * 0.1, size.height * 0.91);
    path.lineTo(0.95 * size.width * 0.1, size.height * 0.91);
    path.lineTo(0.95 * size.width * 0.1, size.height * 0.875);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(ScaleTickerNew oldClipper) => false;
}

class ArcPainterNew extends CustomPainter {
  ArcPainterNew(
      {this.startAngle = 0,
      this.sweepAngle = 0,
      this.firstColor = Colors.grey,
      this.lastColor = Colors.grey});

  final double startAngle;

  final double sweepAngle;

  final Color firstColor;

  final Color lastColor;

  @override
  void paint(Canvas canvas, Size size) {
    // final rect = Rect.fromLTRB(size.width * 0.1, size.height * 0.1,
    //     size.width * 0.9, size.height * 0.9);

    final rect = Rect.fromCircle(
        center: size.bottomCenter(Offset.zero), radius: size.shortestSide);

    const useCenter = false;

    final paint = Paint()
      ..shader = ui.Gradient.linear(rect.centerLeft, rect.centerRight, [
        firstColor,
        lastColor,
        // firstColor,
        // secondColor
      ])
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.2;

    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}

class DialMarkerPainterNew extends CustomPainter {
  DialMarkerPainterNew(this.text, this.position, this.textStyle);

  final String text;
  final TextStyle textStyle;
  final Offset position;

  @override
  void paint(Canvas canvas, Size size) {
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    textPainter.paint(canvas, position);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}

///Customizable Dial widget for Flutter
class PrettyDialNew extends StatefulWidget {
  ///Size of the widget - This widget is rendered in a square shape
  final double dialsize;

  ///Supply the list of segments in the Dial.
  ///
  ///If nothing is supplied, the Dial will have one segment with a segment size of (Max Value - Min Value)
  ///painted in defaultSegmentColor
  ///
  ///Each segment is represented by a DialSegmentNew object that has a name, segment size and color
  final List<DialSegmentNew>? segments;

  ///Supply a min value for the Dial. Defaults to 0
  final double minValue;

  ///Supply a max value for the Dial. Defaults to 100
  final double maxValue;

  /// value of interval between two markers
  final int interval;

  /// whether to show double for the value of interval
  final bool isTickerShowDouble;

  ///Current value of the Dial
  final double? currentValue;

  ///Current value decimal point places
  final int currentValueDecimalPlaces;

  ///Custom color for the needle on the Dial. Defaults to Colors.black
  final Color needleColor;

  ///Custom color for the needle on the Dial. Defaults to Colors.black
  final Color tickerColor;

  ///The default Segment color. Defaults to Colors.grey
  final Color defaultSegmentColor;

  ///The default Segment color. Defaults to Colors.grey
  final Color firstSegmentColor;

  ///The default Segment color. Defaults to Colors.grey
  final Color lastSegmentColor;

  ///Widget that is used to show the current value on the Dial. Defaults to show the current value as a Decimal with 1 digit
  ///If value must not be shown, supply Container()
  final Widget? valueWidget;

  ///Widget to show any other text for the Dial. Defaults to Container()
  final Widget? displayWidget;

  ///Specify if you want to display Min and Max value on the Dial widget
  final bool showMarkers;

  ///Custom styling for the Min marker. Defaults to black font with size 10
  final TextStyle startMarkerStyle;

  ///Custom styling for the Max marker. Defaults to black font with size 10
  final TextStyle endMarkerStyle;

  @override
  _PrettyDialNewState createState() => _PrettyDialNewState();

  const PrettyDialNew(
      {Key? key,
      this.dialsize = 200.0,
      this.segments,
      this.minValue = 0.0,
      this.maxValue = 100.0,
      this.interval = 10,
      this.isTickerShowDouble = false,
      this.currentValue,
      this.currentValueDecimalPlaces = 1,
      this.needleColor = Colors.black,
      this.tickerColor = Colors.orange,
      this.defaultSegmentColor = Colors.grey,
      this.firstSegmentColor = Colors.grey,
      this.lastSegmentColor = Colors.grey,
      this.valueWidget,
      this.displayWidget,
      this.showMarkers = true,
      this.startMarkerStyle =
          const TextStyle(fontSize: 15, color: Colors.black),
      this.endMarkerStyle = const TextStyle(fontSize: 15, color: Colors.black)})
      : super(key: key);
}

class _PrettyDialNewState extends State<PrettyDialNew> {
  //This method builds out multiple arcs that make up the Dial
  //using data supplied in the segments property
  List<Widget> buildDial(List<DialSegmentNew> segments) {
    List<CustomPaint> arcs = [];
    double cumulativeSegmentSize = 0.0;
    double dialSpread = widget.maxValue - widget.minValue;

    //Iterate through the segments collection in reverse order
    //First paint the arc with the last segment color, then paint multiple arcs in sequence until we reach the first segment

    //Because all these arcs will be painted inside of a Stack, it will overlay to represent the eventual Dial with
    //multiple segments
    segments.reversed.forEach((segment) {
      arcs.add(
        CustomPaint(
          size: Size(widget.dialsize, widget.dialsize / 2),
          painter: ArcPainterNew(
              startAngle: math.pi,
              sweepAngle:
                  ((dialSpread - cumulativeSegmentSize) / dialSpread) * math.pi,
              firstColor: segments.first.segmentFirstColor,
              lastColor: segments.last.segmentLastColor),
        ),
      );
      cumulativeSegmentSize = cumulativeSegmentSize + segment.segmentSize;
    });

    return arcs;
  }

  List<Widget> buildTicker(List<DialSegmentNew> segments) {
    List<Container> containers = [];
    double cumulativeSegmentSize = 0.0;

    //Iterate through the segments collection in reverse order
    //First paint the arc with the last segment color, then paint multiple arcs in sequence until we reach the first segment

    //Because all these arcs will be painted inside of a Stack, it will overlay to represent the eventual Dial with
    //multiple segments

    int numberOfTicker =
        ((widget.maxValue - widget.minValue) / widget.interval).floor();
    for (int i = 0; i < numberOfTicker; i++) {
      int indexOfSegment = 0;
      double currentCumulativeValue = 0;
      for (int segmentIndex = 0;
          segmentIndex < segments.length;
          segmentIndex++) {
        currentCumulativeValue += segments[segmentIndex].segmentSize;
        if (i * widget.interval >= currentCumulativeValue) {
          if (segmentIndex < segments.length - 1) {
            indexOfSegment = segmentIndex + 1;
          }
        }
      }
      containers.add(
        Container(
          height: widget.dialsize / 2,
          width: widget.dialsize,
          alignment: Alignment.center,
          child: Transform.rotate(
            origin: Offset(0, widget.dialsize / 4),
            angle: (math.pi * 3 / 2) +
                ((i * widget.interval) /
                    (widget.maxValue - widget.minValue) *
                    math.pi),
            child: ClipPath(
              clipper: DialTickerNew(),
              child: Container(
                width: widget.dialsize * 0.5,
                height: widget.dialsize,
                color: segments[indexOfSegment].segmentFirstColor,
              ),
            ),
          ),
        ),
      );
      cumulativeSegmentSize = cumulativeSegmentSize + widget.interval;
    }

    // add the last ticker
    containers.add(
      Container(
        height: widget.dialsize / 2,
        width: widget.dialsize,
        alignment: Alignment.center,
        child: Transform.rotate(
          origin: Offset(0, widget.dialsize / 4),
          angle: (math.pi * 3 / 2) + math.pi * 0.99,
          child: ClipPath(
            clipper: DialTickerNew(),
            child: Container(
              width: widget.dialsize * 0.5,
              height: widget.dialsize,
              color: segments[segments.length - 1].segmentLastColor,
            ),
          ),
        ),
      ),
    );

    return containers;
  }

  List<Widget> buildScalerTicker(double minValue, double maxValue) {
    List<Widget> containers = [];

    for (double i = minValue; i <= maxValue; i += widget.interval) {
      containers.add(CustomPaint(
          size: Size(widget.dialsize, widget.dialsize),
          painter: DialMarkerPainterNew(
              widget.isTickerShowDouble ? i.toString() : i.toInt().toString(),
              Offset(
                  widget.dialsize *
                      (0.48 -
                          0.65 *
                              math.cos(math.pi /
                                  ((widget.maxValue - widget.minValue) /
                                      widget.interval) *
                                  (i - widget.minValue) /
                                  widget.interval)),
                  widget.dialsize *
                      (0.48 -
                          0.65 *
                              math.sin(math.pi /
                                  ((widget.maxValue - widget.minValue) /
                                      widget.interval) *
                                  (i - widget.minValue) /
                                  widget.interval))),
              TextStyle(
                  color: Colors.black, fontSize: widget.dialsize * 0.03))));
    }
    if ((widget.maxValue - widget.minValue) % widget.interval != 0) {
      containers.add(CustomPaint(
          size: Size(widget.dialsize, widget.dialsize),
          painter: DialMarkerPainterNew(
              widget.isTickerShowDouble
                  ? widget.maxValue.toString()
                  : widget.maxValue.toInt().toString(),
              Offset(widget.dialsize * 0.825, widget.dialsize * 0.475),
              TextStyle(
                  color: Colors.black, fontSize: widget.dialsize * 0.03))));
    }

    return containers;
  }

  List<Widget> buildScalerMarker(double minValue, double maxValue) {
    List<Widget> containers = [];

    for (double i = minValue; i <= maxValue; i += widget.interval) {
      containers.add(CustomPaint(
          size: Size(widget.dialsize, widget.dialsize),
          painter: DialMarkerPainterNew(
              widget.isTickerShowDouble ? i.toString() : i.toInt().toString(),
              Offset(
                  widget.dialsize *
                      (0.48 -
                          0.65 *
                              math.cos(math.pi /
                                  ((widget.maxValue - widget.minValue) /
                                      widget.interval) *
                                  (i - widget.minValue) /
                                  widget.interval)),
                  widget.dialsize *
                      (0.48 -
                          0.65 *
                              math.sin(math.pi /
                                  ((widget.maxValue - widget.minValue) /
                                      widget.interval) *
                                  (i - widget.minValue) /
                                  widget.interval))),
              TextStyle(
                  color: Colors.black, fontSize: widget.dialsize * 0.03))));
    }
    if ((widget.maxValue - widget.minValue) % widget.interval != 0) {
      containers.add(CustomPaint(
          size: Size(widget.dialsize, widget.dialsize),
          painter: DialMarkerPainterNew(
              widget.isTickerShowDouble
                  ? widget.maxValue.toString()
                  : widget.maxValue.toInt().toString(),
              Offset(widget.dialsize * 0.825, widget.dialsize * 0.475),
              TextStyle(
                  color: Colors.black, fontSize: widget.dialsize * 0.03))));
    }

    return containers;
  }

  List<Widget> buildLegends(List<DialSegmentNew> segments) {
    List<Widget> widgets = [];
    segments.asMap().forEach((index, segment) {
      widgets.add(
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  segment.segmentFirstColor,
                  segment.segmentLastColor,
                ],
              )),
              height: widget.dialsize * 0.03,
              width: widget.dialsize * 0.07,
              // color: segment.segmentColor,
            ),
            SizedBox(
              width: widget.dialsize * 0.02,
            ),
            Text(
              segment.segmentName,
              style: TextStyle(fontSize: widget.dialsize * 0.03),
            )
          ],
        ),
      );
      widgets.add(SizedBox(
        height: widget.dialsize * 0.01,
      ));
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    List<DialSegmentNew>? _segments = widget.segments;
    double? _currentValue = widget.currentValue;
    int _currentValueDecimalPlaces = widget.currentValueDecimalPlaces;

    if (widget.currentValue! < widget.minValue) {
      _currentValue = widget.minValue;
    }
    if (widget.currentValue! > widget.maxValue) {
      _currentValue = widget.maxValue;
    }
    // Make sure the decimal place if supplied meets Darts bounds (0-20)
    if (_currentValueDecimalPlaces < 0) {
      _currentValueDecimalPlaces = 0;
    }
    if (_currentValueDecimalPlaces > 20) {
      _currentValueDecimalPlaces = 20;
    }

    //If segments is supplied, validate that the sum of all segment sizes = (maxValue - minValue)
    if (_segments != null) {
      double totalSegmentSize = 0;
      _segments.forEach((segment) {
        totalSegmentSize = totalSegmentSize + segment.segmentSize;
      });
      if (totalSegmentSize != (widget.maxValue - widget.minValue)) {
        throw Exception('Total segment size must equal (Max Size - Min Size)');
      }
    } else {
      //If no segments are supplied, default to one segment with default color
      _segments = [
        DialSegmentNew('', (widget.maxValue - widget.minValue),
            widget.defaultSegmentColor, widget.defaultSegmentColor)
      ];
    }

    return Row(
      children: [
        SizedBox(
          height: widget.dialsize * 0.55,
          width: widget.dialsize,
          child: Stack(
            children: <Widget>[
              ...buildTicker(_segments),
              ...buildDial(_segments),
              Container(
                height: widget.dialsize / 2,
                width: widget.dialsize,
                alignment: Alignment.center,
                child: Transform.rotate(
                  origin: Offset(0, widget.dialsize / 4),
                  angle: (math.pi * 3 / 2) +
                      ((_currentValue! - widget.minValue) /
                          (widget.maxValue - widget.minValue) *
                          math.pi),
                  child: ClipPath(
                    clipper: DialNeedleClipperNew(),
                    child: Container(
                      width: widget.dialsize * 0.75,
                      height: widget.dialsize,
                      color: widget.needleColor,
                    ),
                  ),
                ),
              ),
              Container(
                height: widget.dialsize,
                width: widget.dialsize,
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: widget.dialsize * 0.44,
                    ),
                    widget.displayWidget ?? Container(),
                    widget.valueWidget ??
                        Text(
                            '${_currentValue.toStringAsFixed(_currentValueDecimalPlaces)}',
                            style: TextStyle(fontSize: widget.dialsize * 0.04)),
                  ],
                ),
              ),
              ...buildScalerMarker(widget.minValue, widget.maxValue),
            ],
          ),
        ),
        SizedBox(
          width: widget.dialsize / 4,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [...buildLegends(_segments)],
        ),
      ],
    );
  }
}
