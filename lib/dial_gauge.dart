library pretty_Dial;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

///Class that holds the details of each segment on a CustomDial
class DialSegment {
  final String segmentName;

  ///Name of the segment
  final double segmentSize;

  ///The size of the segment
  final Color segmentColor;

  ///The color of the segment

  DialSegment(this.segmentName, this.segmentSize, this.segmentColor);
}

class DialNeedleClipper extends CustomClipper<Path> {
  //Note that x,y coordinate system starts at the bottom right of the canvas
  //with x moving from right to left and y moving from bottm to top
  //Bottom right is 0,0 and top left is x,y
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.62);
    path.lineTo(1.05 * size.width * 0.5, size.height * 0.62);
    path.lineTo(size.width * 0.5, size.height * 0.95);
    path.lineTo(0.95 * size.width * 0.5, size.height * 0.62);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(DialNeedleClipper oldClipper) => false;
}

class ScaleClipper extends CustomClipper<Path> {
  //Note that x,y coordinate system starts at the bottom right of the canvas
  //with x moving from right to left and y moving from bottm to top
  //Bottom right is 0,0 and top left is x,y
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.78);
    path.lineTo(1.05 * size.width * 0.5, size.height * 0.78);
    path.lineTo(1.05 * size.width * 0.5, size.height);
    path.lineTo(0.95 * size.width * 0.5, size.height);
    path.lineTo(0.95 * size.width * 0.5, size.height * 0.78);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(ScaleClipper oldClipper) => false;
}

class ArcPainter extends CustomPainter {
  ArcPainter(
      {this.startAngle = 0, this.sweepAngle = 0, this.color = Colors.grey});

  final double startAngle;

  final double sweepAngle;

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(size.width * 0.1, size.height * 0.1,
        size.width * 0.9, size.height * 0.9);

    const useCenter = false;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.2;

    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}

class DialMarkerPainter extends CustomPainter {
  DialMarkerPainter(this.text, this.position, this.textStyle);

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
class PrettyDial extends StatefulWidget {
  ///Size of the widget - This widget is rendered in a square shape
  final double dialsize;

  ///Supply the list of segments in the Dial.
  ///
  ///If nothing is supplied, the Dial will have one segment with a segment size of (Max Value - Min Value)
  ///painted in defaultSegmentColor
  ///
  ///Each segment is represented by a DialSegment object that has a name, segment size and color
  final List<DialSegment>? segments;

  ///Supply a min value for the Dial. Defaults to 0
  final double minValue;

  ///Supply a max value for the Dial. Defaults to 100
  final double maxValue;

  ///Current value of the Dial
  final double? currentValue;

  ///Current value decimal point places
  final int currentValueDecimalPlaces;

  ///Custom color for the needle on the Dial. Defaults to Colors.black
  final Color needleColor;

  ///The default Segment color. Defaults to Colors.grey
  final Color defaultSegmentColor;

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
  _PrettyDialState createState() => _PrettyDialState();

  const PrettyDial(
      {Key? key,
      this.dialsize = 200,
      this.segments,
      this.minValue = 0,
      this.maxValue = 100.0,
      this.currentValue,
      this.currentValueDecimalPlaces = 1,
      this.needleColor = Colors.black,
      this.defaultSegmentColor = Colors.grey,
      this.valueWidget,
      this.displayWidget,
      this.showMarkers = true,
      this.startMarkerStyle =
          const TextStyle(fontSize: 10, color: Colors.black),
      this.endMarkerStyle = const TextStyle(fontSize: 10, color: Colors.black)})
      : super(key: key);
}

class _PrettyDialState extends State<PrettyDial> {
  //This method builds out multiple arcs that make up the Dial
  //using data supplied in the segments property
  List<Widget> buildDial(List<DialSegment> segments) {
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
          size: Size(widget.dialsize, widget.dialsize),
          painter: ArcPainter(
              startAngle: math.pi,
              sweepAngle:
                  ((dialSpread - cumulativeSegmentSize) / dialSpread) * math.pi,
              color: segment.segmentColor),
        ),
      );
      cumulativeSegmentSize = cumulativeSegmentSize + segment.segmentSize;
    });

    return arcs;
  }

  List<Widget> buildMarker(List<DialSegment> segments) {
    List<Container> containers = [];
    double cumulativeSegmentSize = 0.0;
    double dialSpread = widget.maxValue - widget.minValue;

    //Iterate through the segments collection in reverse order
    //First paint the arc with the last segment color, then paint multiple arcs in sequence until we reach the first segment

    //Because all these arcs will be painted inside of a Stack, it will overlay to represent the eventual Dial with
    //multiple segments
    segments.asMap().forEach((key, value) {
      print(key);
      containers.add(
        Container(
          height: widget.dialsize * 1.1,
          width: widget.dialsize,
          alignment: Alignment.center,
          child: Transform.rotate(
            angle: (math.pi / 4),
            child: ClipPath(
              clipper: ScaleClipper(),
              child: Container(
                width: widget.dialsize * 0.25,
                height: widget.dialsize * 1.1,
                color: Colors.orange,
              ),
            ),
          ),
        ),
      );
      cumulativeSegmentSize = cumulativeSegmentSize + value.segmentSize;
    });

    return containers;
  }

  List<Widget> buildScaleMarker(List<DialSegment> segments) {
    List<CustomPaint> arcs = [];
    double cumulativeSegmentSize = 0.0;
    double dialSpread = widget.maxValue - widget.minValue;

    //Iterate through the segments collection in reverse order
    //First paint the arc with the last segment color, then paint multiple arcs in sequence until we reach the first segment

    //Because all these arcs will be painted inside of a Stack, it will overlay to represent the eventual Dial with
    //multiple segments
    // segments.asMap().entries.map((entry) {
    //   int idx = entry.key;
    //   DialSegment segment = entry.value;

    // });
    segments.reversed.forEach((segment) {
      arcs.add(
        CustomPaint(
          size: Size(widget.dialsize, widget.dialsize),
          painter: ArcPainter(
              startAngle: math.pi,
              sweepAngle:
                  ((dialSpread - cumulativeSegmentSize) / dialSpread) * math.pi,
              color: segment.segmentColor),
        ),
      );
      cumulativeSegmentSize = cumulativeSegmentSize + segment.segmentSize;
    });

    return arcs;
  }

  @override
  Widget build(BuildContext context) {
    List<DialSegment>? _segments = widget.segments;
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
        DialSegment(
            '', (widget.maxValue - widget.minValue), widget.defaultSegmentColor)
      ];
    }

    return SizedBox(
      height: widget.dialsize,
      width: widget.dialsize * 1.1,
      child: Stack(
        children: <Widget>[
          ...buildDial(_segments),
          ...buildMarker(_segments),
          widget.showMarkers
              ? CustomPaint(
                  size: Size(widget.dialsize, widget.dialsize),
                  painter: DialMarkerPainter(
                      widget.minValue.toString(),
                      Offset(widget.dialsize * 0.23, widget.dialsize * 0.49),
                      widget.startMarkerStyle))
              : Container(),
          widget.showMarkers
              ? CustomPaint(
                  size: Size(widget.dialsize, widget.dialsize),
                  painter: DialMarkerPainter(
                      widget.maxValue.toString(),
                      Offset(widget.dialsize * 0.73, widget.dialsize * 0.49),
                      widget.endMarkerStyle))
              : Container(),
          // marker bar for minimal value
          Container(
            height: widget.dialsize * 1.1,
            width: widget.dialsize,
            alignment: Alignment.center,
            child: Transform.rotate(
              angle: (math.pi / 2),
              child: ClipPath(
                clipper: ScaleClipper(),
                child: Container(
                  width: widget.dialsize * 0.25,
                  height: widget.dialsize * 1.1,
                  color: Colors.orange,
                ),
              ),
            ),
          ),

          // marker bar for max value
          Container(
            height: widget.dialsize * 1.1,
            width: widget.dialsize,
            alignment: Alignment.center,
            child: Transform.rotate(
              angle: (3 * math.pi / 2),
              child: ClipPath(
                clipper: ScaleClipper(),
                child: Container(
                  width: widget.dialsize * 0.25,
                  height: widget.dialsize * 1.1,
                  color: Colors.orange,
                ),
              ),
            ),
          ),
          Container(
            height: widget.dialsize,
            width: widget.dialsize,
            alignment: Alignment.center,
            child: Transform.rotate(
              angle: (math.pi / 2) +
                  ((_currentValue! - widget.minValue) /
                      (widget.maxValue - widget.minValue) *
                      math.pi),
              child: ClipPath(
                clipper: DialNeedleClipper(),
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
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                widget.displayWidget ?? Container(),
                widget.valueWidget ??
                    Text(
                        '${_currentValue.toStringAsFixed(_currentValueDecimalPlaces)}',
                        style: const TextStyle(fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
