import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({Key? key}) : super(key: key);

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {

  double sheight(double per, BuildContext context) {
    double sh = MediaQuery.of(context).size.height;
    return sh * per / 100;
  }

  double swidth(double per, BuildContext context) {
    double sh = MediaQuery.of(context).size.width;
    return sh * per / 100;
  }
  int loading =0;
  late List<ChartSampleData> _chartData;
  late TrackballBehavior _trackballBehavior;


  bool _darkMode = true;
  bool _showAverage = false;
  var rng = Random();
  late List l=[];
  static List<dynamic> ohlc=[[0,54,60,50,52,0]];
  //  InteractiveChart requird minimum three array values , the another way is loading...
  // late List l=[List.generate(1, (_) => rng.nextInt(100))];
  List<ChartSampleData> getChartData() {
    return <ChartSampleData>[
      ChartSampleData(
          x: DateTime.now(),
          open: 54,
          high: 60,
          low: 50,
          close: 52),
    ];
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    genaratenum();
    _chartData = getChartData();
    _trackballBehavior = TrackballBehavior(
        enable: true, activationMode: ActivationMode.singleTap);
  }

  int tradeval=54;
  Color tradecolor=Colors.green;

  genaratenum(){
    int newtrade;
    setState(() {
      loading=1;
    });
    Timer.periodic(Duration(seconds: 1), (timer) {
      if(l.length>=60){
        // print(l.first);
        // print(l.last);
        // print(l.reduce((curr, next) => curr > next? curr: next));
        // print(l.reduce((curr, next) => curr < next? curr: next));

        // checking the values
        setState(() {
          ohlc.add([l.reduce((curr, next) => curr > next? curr: next),l.first,l.reduce((curr, next) => curr > next? curr: next),l.reduce((curr, next) => curr < next? curr: next),l.last,0]);
          _chartData.add(ChartSampleData(x: DateTime.now(),open:l.first,close:l.last,high:l.reduce((curr, next) => curr < next? curr: next),low:l.reduce((curr, next) => curr > next? curr: next)));
          loading=0;
        });
        // print(l[0].reduce(min));
        l=[];
        //min + Random().nextInt(max - min)
        newtrade=50+rng.nextInt(100-50);
        if(tradeval<newtrade){
          setState(() {
            tradecolor=Colors.green;
            tradeval=newtrade;
          });
        }else{
          setState(() {
            tradecolor=Colors.red;
            tradeval=newtrade;
          });
        }
        l.add(tradeval);
      }else{
        setState(() {
          loading=0;
        });
        newtrade=50+rng.nextInt(100-50);
        if(tradeval<newtrade){
          setState(() {
            tradecolor=Colors.green;
            tradeval=newtrade;
          });
        }else{
          setState(() {
            tradecolor=Colors.red;
            tradeval=newtrade;
          });
        }
        l.add(tradeval);
      }
       // l[0].add(List.generate(1, (_) => rng.nextInt(100)));
      // print(l.first);
      // print(l.last);
      // print(l.reduce(max));
      // print(l.reduce(min));
      // print(l);
      // print(ohlc);
    });


    // another method for creating random values
    // for (var i = 0; i < 10; i++) {
    //   print(rng.nextInt(100));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task chart',
      theme: ThemeData(
        brightness: _darkMode ? Brightness.dark : Brightness.light,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Task chart'),
          actions: [
            IconButton(
              icon: Icon(_darkMode ? Icons.dark_mode : Icons.light_mode),
              onPressed: () => setState(() => _darkMode = !_darkMode),
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            height: sheight(100, context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                loading==0?Container(
                  height: sheight(50, context),
                  width: swidth(95, context),
                  child: Column(
                    children: [
                      SfCartesianChart(
                        title: ChartTitle(text: '2023'),
                        trackballBehavior: _trackballBehavior,
                        series: <CandleSeries>[
                          CandleSeries<ChartSampleData, DateTime>(
                            trendlines:<Trendline>[
                              Trendline(
                                  type: TrendlineType.movingAverage,
                                  color: Colors.blue)
                            ],
                              dataSource: _chartData,
                              xValueMapper: (ChartSampleData sales, _) => sales.x,
                              lowValueMapper: (ChartSampleData sales, _) => sales.low,
                              highValueMapper: (ChartSampleData sales, _) => sales.high,
                              openValueMapper: (ChartSampleData sales, _) => sales.open,
                              closeValueMapper: (ChartSampleData sales, _) => sales.close),
                        ],
                        primaryXAxis: DateTimeAxis(
                            dateFormat: DateFormat.Hm(),
                            majorGridLines: MajorGridLines(width: 0)),
                        primaryYAxis: NumericAxis(
                            minimum: 40,
                            maximum: 100,
                            interval: 10,
                            numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Current Trade Amount : "),
                          Text(tradeval.toString(),style: TextStyle(color: tradecolor),),
                        ],
                      ),
                    ],
                  ),
                ):Container(
                  height: sheight(50, context),
                  width: swidth(95, context),
                  child: Center(child: Text('Loading'),),
                ),
                Column(
                  children: [
                    Container(
                      width: swidth(100, context),
                      height: sheight(6, context),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade300
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Open',style: TextStyle(color: Colors.black),),
                          Text('High',style: TextStyle(color: Colors.black),),
                          Text('Low',style: TextStyle(color: Colors.black),),
                          Text('Close',style: TextStyle(color: Colors.black),),
                        ],
                      ),
                    ),
                    Container(
                      height: sheight(30, context),
                      color: Colors.grey.shade300,
                      child: ListView.builder(
                        itemCount: ohlc.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            width: swidth(100, context),
                            height: sheight(6, context),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(ohlc[index][1].toString(),style: TextStyle(color: Colors.black),),
                                Text(ohlc[index][2].toString(),style: TextStyle(color: Colors.black),),
                                Text(ohlc[index][3].toString(),style: TextStyle(color: Colors.black),),
                                Text(ohlc[index][4].toString(),style: TextStyle(color: Colors.black),),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChartSampleData {
  ChartSampleData({
    this.x,
    this.open,
    this.close,
    this.low,
    this.high,
  });

  final DateTime? x;
  final num? open;
  final num? close;
  final num? low;
  final num? high;
}