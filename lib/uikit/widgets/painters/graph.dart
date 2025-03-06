import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../repositories/defines.dart';

const double LeftBorder = 38;
const double RightBorder = 3;
const double TopBorder = 5;
const double BottomBorder = 5;

class Graph extends CustomPainter {
  Graph(this.values, this.freq) {}

  late List<DataBlock> values;
  late int freq;
  late double min = -100;
  late double max = 100;
  final Paint _paintFrame = Paint()
    ..color = Colors.black87
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  final Paint _paintAxis = Paint()
    ..color = Colors.black87
    ..strokeWidth = 1;
  final Paint _paintGridSlim = Paint()
    ..color = Colors.black38
    ..style = PaintingStyle.stroke;
  final Paint _paintGridThik = Paint()
    ..color = Colors.black54
    ..style = PaintingStyle.stroke;
  final Paint _paintGraph = Paint()
    ..color = Colors.blue.shade900
    ..strokeWidth = 1;

  Paragraph createText(String text) {
    final builder = ParagraphBuilder(ParagraphStyle(fontSize: 12));
    builder.addText(text);
    return builder.build();
  }

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
//    print('------------ $text : ${textPainter.width}');
    textPainter.paint(canvas, offset);
  }

  @override
  void paint(Canvas canvas, Size size) {
    min = 100000;
    max = -100000;
    for (int i = 0; i < values.length - 1; ++i) {
      if (values[i].ax < min) {
        min = values[i].ax;
      }
      if (values[i].ax > max) {
        max = values[i].ax;
      }
      if (values[i].ay < min) {
        min = values[i].ay;
      }
      if (values[i].ay > max) {
        max = values[i].ay;
      }
      if (values[i].az < min) {
        min = values[i].az;
      }
      if (values[i].az > max) {
        max = values[i].az;
      }
    }

    /// Рамка
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), _paintFrame);

    double zoneHeight = size.height / 3;
    canvas.drawLine(
        Offset(0, zoneHeight), Offset(size.width, zoneHeight), _paintFrame);
    canvas.drawLine(Offset(0, zoneHeight * 2),
        Offset(size.width, zoneHeight * 2), _paintFrame);
    canvas.drawLine(const Offset(LeftBorder, 0),
        Offset(LeftBorder, size.height), _paintAxis);

    /// Подписи осей
    drawText(canvas, size, 'AX', 4, zoneHeight / 2 - 11, Colors.black, 22);
    drawText(canvas, size, 'AY', 4, zoneHeight / 2 * 3 - 11, Colors.black, 22);
    drawText(canvas, size, 'AZ', 4, zoneHeight / 2 * 5 - 11, Colors.black, 22);

    /// Оси
    canvas.drawLine(
        Offset(LeftBorder, TopBorder + zoneHeight / 2),
        Offset(size.width - RightBorder, TopBorder + zoneHeight / 2),
        _paintAxis);
    canvas.drawLine(
        Offset(LeftBorder, TopBorder + zoneHeight / 2 * 3),
        Offset(size.width - RightBorder, TopBorder + zoneHeight / 2 * 3),
        _paintAxis);
    canvas.drawLine(
        Offset(LeftBorder, TopBorder + zoneHeight / 2 * 5),
        Offset(size.width - RightBorder, TopBorder + zoneHeight / 2 * 5),
        _paintAxis);

    double prop =
        (zoneHeight - BottomBorder - TopBorder) / (max - min).toDouble();
    double step =
        (size.width - LeftBorder - RightBorder) / values.length.toDouble();

    for (int i = 0; i < values.length - 1; ++i) {
      double x1 = LeftBorder + i * step;
      double x2 = LeftBorder + (i + 1) * step;

      var p1 = Offset(x1,
          zoneHeight - BottomBorder - (values[i].ax - min).toDouble() * prop);
      var p2 = Offset(
          x2,
          zoneHeight -
              BottomBorder -
              (values[i + 1].ax - min).toDouble() * prop);
      canvas.drawLine(p1, p2, _paintGraph);

      p1 = Offset(
          x1,
          zoneHeight * 2 -
              BottomBorder -
              (values[i].ay - min).toDouble() * prop);
      p2 = Offset(
          x2,
          zoneHeight * 2 -
              BottomBorder -
              (values[i + 1].ay - min).toDouble() * prop);
      canvas.drawLine(p1, p2, _paintGraph);

      p1 = Offset(x1,
          size.height - BottomBorder - (values[i].az - min).toDouble() * prop);
      p2 = Offset(
          x2,
          size.height -
              BottomBorder -
              (values[i + 1].az - min).toDouble() * prop);
      canvas.drawLine(p1, p2, _paintGraph);

      if ((i + 1) % freq == 0) {
        var v = (i + 1) ~/ freq;
        p1 = Offset(x2, TopBorder);
        p2 = Offset(x2, size.height - BottomBorder);
        canvas.drawLine(p1, p2, _paintGridSlim);

        if (values.length <= 20 * freq) {
          drawText(
              canvas, size, v.toString(), x2 + 2, TopBorder, Colors.black, 10);
        } else {
          if (v % 5 == 0) {
            canvas.drawLine(p1, p2, _paintGridThik);
            drawText(
                canvas, size, v.toString(), x2 + 2, TopBorder, Colors.black, 10);
          }
        }
      }
    }
  } // paint

  @override
  bool shouldRepaint(Graph oldDelegate) => false;
}
