import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:ohlc/chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChartScreen();
  }
}