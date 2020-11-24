import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ventilator/stats.dart';

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
  @override
  initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  Future _showDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dIp = prefs.getString("ip");
    TextEditingController _ip =
        TextEditingController(text: dIp != null ? dIp : "");
    return await showDialog(
        context: context,
        //barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Alamat Server",
            ),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Form(
                    child: Column(children: [
                  TextFormField(
                    controller: _ip,
                    decoration: InputDecoration(
                      hintText: "Masukkan alamat IP",
                      labelText: "IP",
                    ),
                  )
                ])),
              );
            }),
            actions: [
              FlatButton(
                child: Text('Tutup'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Simpan'),
                onPressed: () async {
                  await prefs.setString("ip", _ip.text);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Ventilator Command Center"),
          actions: [
            IconButton(
              icon: Icon(Icons.settings_applications_outlined),
              onPressed: () {
                _showDialog();
              },
            )
          ],
        ),
        body: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 4,
          childAspectRatio: 16 / 4,
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.people,
                color: Colors.blue,
              ),
              title: Text("Billy Montolalu"),
              subtitle: Text("Kamar Mawar Bed 1"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Stats()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text("Kosong"),
              subtitle: Text("Kamar Mawar Bed 2"),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text("Kosong"),
              subtitle: Text("Kamar Mawar Bed 3"),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text("Kosong"),
              subtitle: Text("Kamar Mawar Bed 4"),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text("Kosong"),
              subtitle: Text("Kamar Mawar Bed 5"),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text("Kosong"),
              subtitle: Text("Kamar Mawar Bed 6"),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text("Kosong"),
              subtitle: Text("Kamar Mawar Bed 7"),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text("Kosong"),
              subtitle: Text("Kamar Mawar Bed 8"),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text("Kosong"),
              subtitle: Text("Kamar Mawar Bed 9"),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text("Kosong"),
              subtitle: Text("Kamar Mawar Bed 10"),
            ),
          ],
        ) /*RaisedButton(onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Stats()),
          );
        })*/
        );
  }
}
