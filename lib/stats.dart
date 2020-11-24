import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:number_stepper/number_stepper.dart';
import 'package:oscilloscope/oscilloscope.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constanta.dart';

class Stats extends StatefulWidget {
  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
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
  double dataPaw = 0;
  double dataFlow = 0;
  double dataVolume = 0;
  String start = "Start";
  String fio = "0", cp = "0";
  String ip = "";

  @override
  initState() {
    super.initState();
    getIp();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _timer = Timer.periodic(Duration(milliseconds: 200), _generateTrace);
  }

  void getIp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ip = prefs.getString("ip");
    ip = "http://" + ip + ":8000";
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  _generateTrace(Timer t) async {
    //load data from internet
    final response = await http.get(ip);
    var data = response.body;
    var split = data.split("#");
    var paw = split[0];
    if (paw != "") {
      dataPaw = double.parse(paw);
    }

    var volume = split[2];
    if (volume != "") {
      dataVolume = double.parse(volume);
    }

    var flow = split[1];
    if (flow != "") {
      dataFlow = double.parse(flow);
    }

    fio = split[3];
    cp = split[4];

    setState(() {
      volumeData.add(dataVolume);
      pawData.add(dataPaw);
      flowData.add(dataFlow);
    });
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
        title: Text("Ventilator Monitoring"),
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
                          radius: 40.0,
                          child: Text(
                            dataPaw.toString(),
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
                        radius: 40.0,
                        child: Text(
                          dataFlow.toString(),
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
                        radius: 40.0,
                        child: Text(
                          dataVolume.toString(),
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
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset('assets/logo.png', scale: 10.0),
                      ],
                    ),
                  ),
                  _space(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text("FiO2"),
                          Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.topRight,
                            child: CircleAvatar(
                              radius: 25.0,
                              child: Text(
                                fio,
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text("CP"),
                          Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.topRight,
                            child: CircleAvatar(
                              radius: 25.0,
                              child: Text(
                                cp,
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Text("CP"),
                  Text("Ppeak"),
                  NumberStepper(
                    count: _ppeak,
                    size: 30,
                    //activeForegroundColor: Colors.purple,
                    activeBackgroundColor: Colors.red,
                    didChangeCount: (count) async {
                      await http.get(BASE_URL +
                          "?setting=ppeak&nilai=" +
                          count.toString());
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
                    didChangeCount: (count) async {
                      await http.get(
                          BASE_URL + "?setting=peep&nilai=" + count.toString());
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
                    didChangeCount: (count) async {
                      await http.get(
                          BASE_URL + "?setting=bpm&nilai=" + count.toString());
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
                    didChangeCount: (count) async {
                      await http.get(
                          BASE_URL + "?setting=er&nilai=" + count.toString());
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
                    didChangeCount: (count) async {
                      await http.get(BASE_URL +
                          "?setting=volmax&nilai=" +
                          count.toString());
                      setState(() {
                        _volmax = count;
                      });
                    },
                  ),
                  _space(),
                  FlatButton(
                    onPressed: () async {
                      int stateStart;
                      setState(() {
                        if (start == "Start") {
                          start = "Stop";
                          stateStart = 1;
                        } else {
                          start = "Start";
                          stateStart = 0;
                        }
                      });
                      await http.get(BASE_URL +
                          "?setting=start&nilai=" +
                          stateStart.toString());
                    },
                    color: Colors.red,
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Icon(
                          Icons.replay_outlined,
                          color: Colors.white,
                        ),
                        Text(
                          start,
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
