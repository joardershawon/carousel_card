import 'dart:math';

import 'package:flutter/foundation.dart';
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
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      bottom: 30,
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
                                Transform(
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, .001)
                                    ..translate(0.0, 0.0),
                                  child: Opacity(
                                    opacity: opacity < .9 ? 0.0 : opacity,
                                    child: Text(
                                      'Your Balance is : $counter BDT',
                                      key: UniqueKey(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
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
      ),
    );
  }
}
