import 'dart:math';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  );

  late Animation<double> translateX = Tween<double>(
    begin: 10.0,
    end: 140,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.0,
        0.7,
        curve: Curves.ease,
      ),
    ),
  );

  late Animation<double> opacity1 = Tween<double>(
    begin: 1,
    end: 0,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.0,
        0.7,
        curve: Curves.ease,
      ),
    ),
  );
  late Animation<double> opacity2 = Tween<double>(
    begin: 0,
    end: 1,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.70,
        1.00,
        curve: Curves.ease,
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(
          const Duration(milliseconds: 1000),
          () => _controller.reverse(),
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[200],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlidingAnimatedBox(
                controller: _controller,
                translateX: translateX,
                opacity1: opacity1,
                opacity2: opacity2,
                height: 40,
                width: 200,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SlidingAnimatedBox extends StatelessWidget {
  const SlidingAnimatedBox({
    Key? key,
    required AnimationController controller,
    required this.translateX,
    required this.opacity1,
    required this.opacity2,
    required this.height,
    required this.width,
  })  : _controller = controller,
        super(key: key);

  final AnimationController _controller;
  final Animation<double> translateX;
  final Animation<double> opacity1;
  final Animation<double> opacity2;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    double radius = height * .8;

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // print(translateX.value);
          print(radius);
          return Stack(
            children: [
              Positioned(
                top: radius * .12,
                left: translateX.value,
                child: GestureDetector(
                  onTap: () {
                    _controller.forward();
                  },
                  child: Container(
                    height: radius,
                    width: radius,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: radius * (height / 120),
                left: 80,
                child: AnimatedOpacity(
                  duration: const Duration(microseconds: 100),
                  opacity: opacity1.value,
                  child: const Text(
                    "Show",
                    // style: Styles.alertSubTitle,
                  ),
                ),
              ),
              Positioned(
                top: radius * (height / 120),
                left: 80,
                child: AnimatedOpacity(
                  duration: const Duration(microseconds: 100),
                  opacity: opacity2.value,
                  child: const Text(
                    "1Tk",
                    // style: Styles.alertSubTitle,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
