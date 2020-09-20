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
  List<double> traceSine = List();
  List<double> traceCosine = List();
  double radians = 0.0;
  Timer _timer;
  int _counter = 5;
  int _ppeak = 18;
  int _pplat = 16;
  int _peep = 10;
  int _bpm = 10;
  int _ratio = 2;
  int _volmax = 800;

  @override
  initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 60), _generateTrace);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  _generateTrace(Timer t) {
    // generate our  values
    var sv = sin((radians * pi));
    var cv = cos((radians * pi));

    // Add to the growing dataset
    setState(() {
      traceSine.add(sv);
      traceCosine.add(cv);
    });

    // adjust to recyle the radian value ( as 0 = 2Pi RADS)
    radians += 0.05;
    if (radians >= 2.0) {
      radians = 0.0;
    }
  }

  Widget _space() {
    return SizedBox(
      height: 15.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    Oscilloscope scopeOne = Oscilloscope(
      padding: 20.0,
      backgroundColor: Colors.black,
      traceColor: Colors.green,
      yAxisMax: 1.0,
      yAxisMin: -1.0,
      dataSet: traceSine,
      showYAxis: true,
    );

    // Create A Scope Display for Cosine
    Oscilloscope scopeTwo = Oscilloscope(
      showYAxis: true,
      padding: 20.0,
      backgroundColor: Colors.black,
      traceColor: Colors.yellow,
      yAxisMax: 1.0,
      yAxisMin: -1.0,
      dataSet: traceCosine,
    );

    Oscilloscope scopeThree = Oscilloscope(
      showYAxis: true,
      padding: 20.0,
      backgroundColor: Colors.black,
      traceColor: Colors.blue,
      yAxisMax: 1.0,
      yAxisMin: -1.0,
      dataSet: traceCosine,
    );

    // Generate the Scaffold
    return Scaffold(
      appBar: AppBar(
        title: Text("Ventilator"),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: <Widget>[
                Container(
                  height: 20,
                  child: Text("PAW"),
                ),
                Expanded(flex: 1, child: scopeOne),
                Container(
                  height: 20,
                  child: Text("Flow"),
                ),
                Expanded(
                  flex: 1,
                  child: scopeTwo,
                ),
                Container(
                  height: 20,
                  child: Text("Volume"),
                ),
                Expanded(
                  flex: 1,
                  child: scopeThree,
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
