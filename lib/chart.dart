import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:interactive_chart/interactive_chart.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    genaratenum();
  }
  var rng = Random();
  late List l=[];
  static List<dynamic> ohlc=[[0,54,60,50,52,0],[0,50,55,50,50,0],[0,77,77,52,61,0],[0,53,70,59,68,0],[0,54,60,50,52,0],[0,50,55,50,50,0],[0,77,77,52,61,0],[0,53,70,59,68,0],];
  //  InteractiveChart requird minimum three array values , the another way is loading...
  // late List l=[List.generate(1, (_) => rng.nextInt(100))];
  genaratenum(){
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
          ohlc.add([0,l.first,l.reduce((curr, next) => curr > next? curr: next),l.reduce((curr, next) => curr < next? curr: next),l.last,0]);
          loading=0;
        });
        // print(l[0].reduce(min));
        l=[];
        //min + Random().nextInt(max - min)
        l.add(50+rng.nextInt(100-50));
      }else{
        setState(() {
          loading=0;
        });
        l.add(50+rng.nextInt(100-50));
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

  static List<CandleData> get candles => ohlc
      .map((row) => CandleData(
    timestamp: row[0] * 1000,
    open: row[1]?.toDouble(),
    high: row[2]?.toDouble(),
    low: row[3]?.toDouble(),
    close: row[4]?.toDouble(),
    volume: row[5]?.toDouble(),
  ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task chart'),
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
                child: InteractiveChart(
                  candles: candles,
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
                        Text('Open'),
                        Text('High'),
                        Text('Low'),
                        Text('Close'),
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
                              Text(ohlc[index][1].toString()),
                              Text(ohlc[index][2].toString()),
                              Text(ohlc[index][3].toString()),
                              Text(ohlc[index][4].toString()),
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
    );
  }
}
