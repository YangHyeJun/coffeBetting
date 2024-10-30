import 'package:coffee/paint.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiTouchScreen(),
    );
  }
}

class MultiTouchScreen extends StatefulWidget{
  @override
  _MultiTouchScreenState createState() => _MultiTouchScreenState();
}

class _MultiTouchScreenState extends State<MultiTouchScreen> with SingleTickerProviderStateMixin {
  Map<int, Offset> touchPoints = {};
  Timer? holdTimer;
  Offset? expandingPoint;
  Color expandingColor = Colors.transparent;
  late AnimationController _controller;
  late Animation<double> _animation;
  final List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.black,
    Colors.purple,
    Colors.grey,
  ];

  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  void _startHoldTimer() {
    holdTimer?.cancel();
    holdTimer = Timer(const Duration(seconds: 3), () {
      if (touchPoints.isNotEmpty) {
        setState(() {
          final randomPointer = touchPoints.keys.elementAt(random.nextInt(touchPoints.length));
          expandingPoint = touchPoints[randomPointer];
          expandingColor = colors[randomPointer % colors.length];
          _controller.forward(from: 0.0);
        });
      }
    });
  }

  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      touchPoints[event.pointer] = event.localPosition;
    });
    _startHoldTimer();
  }

  void _onPointerMove(PointerMoveEvent event) {
    setState(() {
      touchPoints[event.pointer] = event.localPosition;
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      touchPoints.remove(event.pointer);
      holdTimer?.cancel();
      expandingPoint = null;
      _controller.reset();

      if (touchPoints.isNotEmpty) {
        _startHoldTimer();
      }
    });
  }

  @override
  void dispose() {
    holdTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      child: Container(
        color: Colors.white,
        child: CustomPaint(
          painter: TouchPointsPainter(
            touchPoints: touchPoints,
            expandingPoint: expandingPoint,
            expandingColor: expandingColor,
            animationValue: _animation.value,
            colors: colors,
          ),
          child: SizedBox.expand(),
        ),
      ),
    );
  }
}