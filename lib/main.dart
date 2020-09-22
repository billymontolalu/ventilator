import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oscilloscope/oscilloscope.dart';
import 'package:number_stepper/number_stepper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ventilator Command Center',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Ventilator Command Center'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<double> volumeData = List();
  List<double> flowData = List();
  List<double> pawData = List();
  double radians = 0.0;
  Timer _timer;
  int _ppeak = 18;
  int _peep = 10;
  int _bpm = 10;
  int _ratio = 2;
  int _volmax = 800;

  @override
  initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 200), _generateTrace);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  int _generateData(int min, int max) {
    Random rnd = new Random();
    return min + rnd.nextInt(max - min);
  }

  _generateTrace(Timer t) {
    //final _random = new Random();
    //int next(int min, int max) => min + _random.nextInt(max - min);
    // generate our  values
    //var sv = sin((radians * pi));
    //var cv = cos((radians * pi));

    // Add to the growing dataset
    setState(() {
      /*if (traceSine.length > 300) {
        traceSine.removeAt(0);
      }*/
      double dataVolume = _generateData(0, 1000).toDouble();
      volumeData.add(dataVolume);

      double dataPaw = _generateData(-20, 60).toDouble();
      pawData.add(dataPaw);

      double dataFlow = _generateData(-100, 100).toDouble();
      flowData.add(dataFlow);
    });

    // adjust to recyle the radian value ( as 0 = 2Pi RADS)
    //radians += 0.05;
    //if (radians >= 2.0) {
    //radians = 0.0;
    //}
  }

  Widget _space() {
    return SizedBox(
      height: 15.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    Oscilloscope flow = Oscilloscope(
      padding: 20.0,
      backgroundColor: Colors.black,
      traceColor: Colors.green,
      yAxisMax: 100.0,
      yAxisMin: -100.0,
      dataSet: flowData,
      showYAxis: true,
    );

    Oscilloscope paw = Oscilloscope(
      padding: 20.0,
      backgroundColor: Colors.black,
      traceColor: Colors.redAccent,
      yAxisMax: 60.0,
      yAxisMin: -20.0,
      dataSet: pawData,
      showYAxis: true,
    );

    // Create A Scope Display for Cosine
    Oscilloscope volume = Oscilloscope(
      showYAxis: true,
      padding: 20.0,
      backgroundColor: Colors.black,
      traceColor: Colors.yellow,
      yAxisMax: 1000.0,
      yAxisMin: 0.0,
      dataSet: volumeData,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Ventilator"),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Stack(children: [
                      paw,
                      Container(
                        padding: EdgeInsets.only(top: 5.0),
                        alignment: Alignment.topCenter,
                        child: Text(
                          "PAW",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          radius: 25.0,
                          child: Text(
                            "40",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      )
                    ])),
                Expanded(
                  flex: 1,
                  child: Stack(children: [
                    flow,
                    Container(
                        padding: EdgeInsets.only(top: 5.0),
                        alignment: Alignment.topCenter,
                        child: Text("Flow",
                            style: TextStyle(color: Colors.white))),
                    Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        radius: 25.0,
                        child: Text(
                          "50",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                  ]),
                ),
                Expanded(
                  flex: 1,
                  child: Stack(children: [
                    volume,
                    Container(
                        padding: EdgeInsets.only(top: 5.0),
                        alignment: Alignment.topCenter,
                        child: Text("Volume",
                            style: TextStyle(color: Colors.white))),
                    Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        radius: 25.0,
                        child: Text(
                          "500",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                  ]),
                ),
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Ppeak"),
                  NumberStepper(
                    count: _ppeak,
                    size: 30,
                    //activeForegroundColor: Colors.purple,
                    activeBackgroundColor: Colors.red,
                    didChangeCount: (count) {
                      setState(() {
                        _ppeak = count;
                      });
                    },
                  ),
                  _space(),
                  Text("PEEP"),
                  NumberStepper(
                    count: _peep,
                    size: 30,
                    //activeForegroundColor: Colors.purple,
                    activeBackgroundColor: Colors.red,
                    didChangeCount: (count) {
                      setState(() {
                        _peep = count;
                      });
                    },
                  ),
                  _space(),
                  Text("BPM"),
                  NumberStepper(
                    count: _bpm,
                    size: 30,
                    //activeForegroundColor: Colors.purple,
                    activeBackgroundColor: Colors.red,
                    didChangeCount: (count) {
                      setState(() {
                        _bpm = count;
                      });
                    },
                  ),
                  _space(),
                  Text("I/E Ratio 1"),
                  NumberStepper(
                    count: _ratio,
                    size: 30,
                    //activeForegroundColor: Colors.purple,
                    activeBackgroundColor: Colors.red,
                    didChangeCount: (count) {
                      setState(() {
                        _ratio = count;
                      });
                    },
                  ),
                  _space(),
                  Text("Maxvolume"),
                  NumberStepper(
                    count: _volmax,
                    size: 30,
                    //activeForegroundColor: Colors.purple,
                    activeBackgroundColor: Colors.red,
                    didChangeCount: (count) {
                      setState(() {
                        _volmax = count;
                      });
                    },
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
