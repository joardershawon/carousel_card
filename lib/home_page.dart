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
  int counter = 0;
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
    if (animationController.isAnimating) {
      return;
    } else {
      if (animationController.isCompleted) {
        animationController.reverse();
      } else {
        counter++;
        animationController.forward();
        Future.delayed(const Duration(seconds: 2)).then((value) {
          animationController.reverse();
        });
      }
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
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 10,
            child: SizedBox(
              height: size.height / (2.2 * pi),
              width: size.width / (.33 * pi),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    bottom: 10,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, .001)
                        ..translate(0.0, -scale / 3)
                        ..scale(1 - gg),
                      child: Opacity(
                        opacity: (1 - opacity * 2).clamp(0.0, 1.0),
                        child: const Text(
                          'Check Your Balance',
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    width: scale + boxSize - 10,
                    height: 70,
                    child: Material(
                      color: Colors.amber[50],
                      elevation: 5,
                      borderRadius: BorderRadius.circular(40),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: InkWell(
                        splashColor: Colors.amber,
                        onTap: () {
                          animationReset();
                        },
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..translate((scale * (gg * .58)), 0.0)
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
                              Transform(
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, .001)
                                  ..translate(0.0, 0.0),
                                child: Opacity(
                                  opacity: opacity < .95 ? 0.0 : opacity,
                                  child: Text(
                                    'Your Balance is : $counter BDT',
                                    key: UniqueKey(),
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      shadows: [
                                        Shadow(
                                          color: Colors.white,
                                          blurRadius: 10,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
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
          ),
        ],
      ),
    );
  }
}
