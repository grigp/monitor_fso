import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../assets/colors/colors.dart';

const double LeftBorder = 38;
const double RightBorder = 1;
const double TopBorder = 5;
const double BottomBorder = 5;

class OscillBlock {
  double chan0;
  double chan1;
  double chan2;

  /// Отсчет данных для осцилографа
  OscillBlock({
    required this.chan0,
    required this.chan1,
    required this.chan2,
  });
}

List<OscillBlock> _data = [];
int pos = LeftBorder.toInt();
int shift = 0;

class Oscilloscope extends CustomPainter {
  Oscilloscope(this.values, this.min, this.max) {
    _data.addAll(values);
    shift += values.length;
    values.clear();
  }

  late List<OscillBlock> values;
  late double min;
  late double max;
  final Paint _paintFrame = Paint()
    ..color = Colors.black87
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  final Paint _paintAxis = Paint()
    ..color = Colors.black45
    ..strokeWidth = 1;
  final Paint _paintGrid = Paint()
    ..color = Colors.black12
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;
  final Paint _paintMarker = Paint()
    ..color = Colors.red
    ..strokeWidth = 1;
  final Paint _paintGraph = Paint()
    ..color = tealDarkColor
    ..strokeWidth = 1;

  /// Выводит текст
  void drawText(Canvas canvas, Size size, String text, double x, double y,
      Color color, double fontSize) {
    var textStyle = TextStyle(
      color: color,
      fontSize: fontSize,
    );
    var textSpan = TextSpan(
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
    final offset = Offset(x, y);
    textPainter.paint(canvas, offset);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Рамка
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), _paintFrame);

    double zoneHeight = size.height / 3;
    canvas.drawLine(
        Offset(0, zoneHeight), Offset(size.width, zoneHeight), _paintFrame);
    canvas.drawLine(Offset(0, zoneHeight * 2),
        Offset(size.width, zoneHeight * 2), _paintFrame);
    canvas.drawLine(const Offset(LeftBorder, 0),
        Offset(LeftBorder, size.height), _paintAxis);

    drawText(canvas, size, 'AX', 4, zoneHeight / 2 - 11, Colors.black, 22);
    drawText(canvas, size, 'AY', 4, zoneHeight / 2 * 3 - 11, Colors.black, 22);
    drawText(canvas, size, 'AZ', 4, zoneHeight / 2 * 5 - 11, Colors.black, 22);

    for (int i = 0; i < size.width; i += 50) {
      canvas.drawLine(Offset(LeftBorder + i, 0),
          Offset(LeftBorder + i, size.height), _paintGrid);
    }

    /// Оси
    canvas.drawLine(Offset(LeftBorder, TopBorder + zoneHeight / 2),
        Offset(size.width - RightBorder, TopBorder + zoneHeight / 2), _paintAxis);
    canvas.drawLine(Offset(LeftBorder, TopBorder + zoneHeight / 2 * 3),
        Offset(size.width - RightBorder, TopBorder + zoneHeight / 2 * 3), _paintAxis);
    canvas.drawLine(Offset(LeftBorder, TopBorder + zoneHeight / 2 * 5),
        Offset(size.width - RightBorder, TopBorder + zoneHeight / 2 * 5), _paintAxis);

    var length = size.width - RightBorder - LeftBorder;

    /// Коррекция длины массива
    if (_data.length > length) {
      _data.removeRange(0, (_data.length - length).toInt());
    }

    /// Начальная точка построения
    pos += shift;
    if (pos > size.width - RightBorder) {
      pos = LeftBorder.toInt();
    }
    shift = 0;

    int l = _data.length;

    double prop =
        (zoneHeight - BottomBorder - TopBorder) / (max - min).toDouble();
    double x = pos.toDouble();
    for (int i = _data.length - 1; i > 0; --i) {
      var p1 = Offset(x,
          zoneHeight - BottomBorder - (_data[i].chan0 - min).toDouble() * prop);
      var p2 = Offset(
          x - 1,
          zoneHeight -
              BottomBorder -
              (_data[i - 1].chan0 - min).toDouble() * prop);
      canvas.drawLine(p1, p2, _paintGraph);

      p1 = Offset(
          x,
          zoneHeight * 2 -
              BottomBorder -
              (_data[i].chan1 - min).toDouble() * prop);
      p2 = Offset(
          x - 1,
          zoneHeight * 2 -
              BottomBorder -
              (_data[i - 1].chan1 - min).toDouble() * prop);
      canvas.drawLine(p1, p2, _paintGraph);

      p1 = Offset(
          x,
          size.height -
              BottomBorder -
              (_data[i].chan2 - min).toDouble() * prop);
      p2 = Offset(
          x - 1,
          size.height -
              BottomBorder -
              (_data[i - 1].chan2 - min).toDouble() * prop);
      canvas.drawLine(p1, p2, _paintGraph);

      x -= 1;
      if (x <= LeftBorder) {
        x = size.width - RightBorder;
      }
    }

    /// Маркер
    canvas.drawLine(Offset(pos.toDouble(), TopBorder),
        Offset(pos.toDouble(), size.height - BottomBorder), _paintMarker);
  } // paint

  @override
  bool shouldRepaint(Oscilloscope oldDelegate) => false;
}
