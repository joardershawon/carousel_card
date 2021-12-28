import 'package:carousel_card/mock_data.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;
  late PageController pageController;
  Duration duration = const Duration(milliseconds: 500);

  double initialPage = 0;
  double heightFactor = .8;
  double widthFactor = .9;
  double viewFraction = 1.0;

  void pageListener() {
    setState(() {
      initialPage = pageController.page!;
    });
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: duration,
    )..addListener(() {});
    pageController = PageController(
      initialPage: initialPage.toInt(),
      viewportFraction: .5,
    )..addListener(pageListener);
  }

  @override
  void dispose() {
    super.dispose();
    animationController.removeListener(pageListener);
    animationController.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var items = MockData.mockList;
    var item;
    var result = 1.0;

    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            FractionallySizedBox(
              heightFactor: .2,
              widthFactor: .9,
              child: Container(
                color: Colors.teal,
                child: Column(
                  children: [
                    Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, .001)
                        ..translate(25, 0.0),
                      child: Text(
                        items[initialPage.toInt()].title.toString(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            PageView.builder(
              scrollDirection: Axis.vertical,
              controller: pageController,
              itemCount: items.length,
              itemBuilder: (context, index) {
                viewFraction = pageController.viewportFraction;
                item = items[index];
                result = (index - initialPage - 1) + 1;
                final value = .05 * result * (initialPage + 1.25) * 5 + 1;
                final opacity = value.clamp(0.0, 1.0);
                print(value);

                return Transform(
                  alignment: Alignment.bottomCenter,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, .001)
                    ..translate(0.0, size.height / 2.5 * (1 - value).abs())
                    ..scale(value * opacity),
                  child: Opacity(
                    opacity: opacity,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          pageController.animateToPage(
                            index,
                            duration: duration,
                            curve: Curves.easeInOut,
                          );
                        });
                      },
                      child: FractionallySizedBox(
                        heightFactor: heightFactor,
                        widthFactor: widthFactor,
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(20),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/${item.image}'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
