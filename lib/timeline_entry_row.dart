import 'package:flutter/material.dart';
import 'package:gramola_timeline/model/timeline_entry.dart';
import 'package:meta/meta.dart';

class LinePainter extends CustomPainter {
  LinePainter({
    @required this.color,
    @required this.backgroundColor,
  }) : super();

  /// The color in the background of the circle
  final Color backgroundColor;

  /// The foreground color used to indicate progress
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = new Paint()
      ..color = backgroundColor
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      size.topCenter(new Offset(0.0, 2.0)),
      size.bottomCenter(new Offset(0.0, -2.0)),
      linePaint);
    
    Paint fillPaint = new Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(size.center(Offset.zero), 8.0, fillPaint);
  }

  @override
  bool shouldRepaint(LinePainter other) {
    return color != other.color ||
      backgroundColor != other.backgroundColor;
  }
}

class TimelineEntryRow extends StatelessWidget {
  final String _imagesBaseUrl;
  final TimelineEntry _entry;

  TimelineEntryRow(this._imagesBaseUrl, this._entry);

  Widget _buildTimeColumn(BuildContext context) {
    return new Container(
      width: 30.0,
      //color: Colors.lightBlue,
      child: new Center(
        child: new Text(
          _entry.time,
          style: new TextStyle(
            fontSize: 9.0,
            fontWeight: FontWeight.normal,
          ),
        ),
      )
    );
  }

  Widget _buildLineColumn(BuildContext context) {
    return new Container(
      width: 40.0,
      //color: Colors.lightGreen,
      child: new CustomPaint(
        painter: new LinePainter(
          color: Colors.deepPurple, 
          backgroundColor:  Colors.deepPurpleAccent)
      )
    );
  }

  Widget _buildTextColumn(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        new Container(
          padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
          child: new Text(
            _entry.title,
            style: new TextStyle(
              //color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        new Text(
          _entry.description,
          style: new TextStyle(
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return new Container(
      height: 100.0,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
      //color: Colors.amber,
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTimeColumn(context),
          _buildLineColumn(context),
          new Expanded(child: _buildTextColumn(context))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCardContent(context);
  }
}