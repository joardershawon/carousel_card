import 'package:flutter/material.dart';

class MockData {
  final String? title;
  final String? image;
  final String? description;
  MockData({
    @required this.title,
    @required this.image,
    @required this.description,
  });
  static List<MockData> mockList = [
    MockData(title: 'Strawberry', image: 'strawberry.jpg', description: ''),
    MockData(title: 'Cherry', image: 'cherry.jpg', description: ''),
    MockData(title: 'Pine-Apple', image: 'pineapple.jpg', description: ''),
    MockData(title: 'Orange', image: 'orange.jpg', description: ''),
    MockData(title: 'Avocado', image: 'avocado.jpg', description: ''),
  ];
}
