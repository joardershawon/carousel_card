import 'dart:math';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  Duration duration = const Duration(milliseconds: 700);
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: duration,
      vsync: this,
    );

    final curvedAnim = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeInBack,
    );

    animation = Tween<double>(begin: 0, end: 2 * pi).animate(curvedAnim)
      ..addListener(
        () {
          setState(() {});
        },
      );
    // animationController.forward();
  }

  void animationReset() {
    if (animationController.isCompleted) {
      animationController.reverse();
    } else {
      animationController.forward();
      Future.delayed(const Duration(seconds: 5)).then((value) {
        animationController.reverse();
      });
    }
  }

  @override
  void dispose() {
    print('dismissed');
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final gg = animationController.value;
    final scale = gg * (size.width * .2) * pi;
    final boxSize = scale.clamp(80, 120.0);
    final opacity = (gg).clamp(0.0, 1.0);
    // print(boxSize);
    print(gg);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 50,
              left: 10,
              width: scale + boxSize,
              height: 80,
              child: Material(
                // shape: CircleBorder(),
                color: Colors.white,
                elevation: 5,
                borderRadius: BorderRadius.circular(40),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: InkWell(
                  onTap: () {
                    animationReset();
                  },
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform(
                          alignment: Alignment.centerLeft,
                          transform: Matrix4.identity()
                            ..translate((scale * (gg * .8)), 0.0)
                            ..rotateY(gg * 3),
                          child: const Text(
                            '🪙',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 55,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: opacity < .9 ? 0.0 : opacity,
                          child: Text(
                            'Your Balance is : 1M',
                            key: UniqueKey(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
