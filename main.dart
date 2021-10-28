import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulacka',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Kalkulacka'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  // Create the initialization Future outside of `build`:
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum oper {
  ADD,
  SUB,
  MUL,
  DIV,
  NONE,
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  num _result = 0;
  var _input = '';
  String? _city;
  oper _oper = oper.NONE;
  bool weatherOn = true;
  static RemoteConfig? _remoteConfig;
  Future<http.Response>? httpWeather;
  final defaults = <String, dynamic>{"City": "Bratislava"};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      // isiel do pozadia
    }
    if (state == AppLifecycleState.resumed) {
      // prichadza do popredia
      if (_remoteConfig != null) {
        _remoteConfig!.activate();

        _city = _remoteConfig!.getString("City");
        httpWeather = http.get(Uri.parse(
            "https://api.openweathermap.org/data/2.5/weather?q=${_city},SK&appid=6eb6b05fcdc850818c6238aef85610be&units=metric"));

        _getWeather();
      }
    }
  }

  _initRemoteConfig() async {
    _remoteConfig = RemoteConfig.instance;
    await _remoteConfig!.setDefaults(defaults);
    await _remoteConfig!.fetch();

    await _remoteConfig!.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(minutes: 1)));

    _city = _remoteConfig!.getString("City");
    httpWeather = http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=${_city},SK&appid=6eb6b05fcdc850818c6238aef85610be&units=metric"));
  }

  Future<void> _fetchRemoteConfig() async {
    try {
      await _remoteConfig!.fetchAndActivate();

      print('Last fetch status: ' + _remoteConfig!.lastFetchStatus.toString());
      print('Last fetch time: ' + _remoteConfig!.lastFetchTime.toString());
      print('New City: ' + _remoteConfig!.getString("City").toString());

      _city = _remoteConfig!.getString("City");
      httpWeather = http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=${_city},SK&appid=6eb6b05fcdc850818c6238aef85610be&units=metric"));
    } catch (e) {
      print('Error ${e.toString()}');
    }
  }

  Future<void> _getWeather() async {
    try {
      http.Response? r = await httpWeather;
      String data = r!.body;

      Map<String, dynamic> dataMap = json.decode(data);
      Welcome pr = Welcome.fromJson(dataMap);

      setState(() {
        if (weatherOn)
          _input =
              'City: ${_city}\nTemp: ${pr.main!.temp} °C\nPressure: ${pr.main!.pressure} hPa\nHumidity: ${pr.main!.humidity} %';
      });
    } catch (e) {
      print('Error ${e.toString()}');
    }
  }

  void _num0() {
    setState(() {
      if (weatherOn) {
        _input = '';
        weatherOn = false;
      }
      _input += '0';
    });
  }

  void _num1() {
    setState(() {
      if (weatherOn) {
        _input = '';
        weatherOn = false;
      }
      _input += '1';
    });
  }

  void _num2() {
    setState(() {
      if (weatherOn) {
        _input = '';
        weatherOn = false;
      }
      _input += '2';
    });
  }

  void _num3() {
    setState(() {
      if (weatherOn) {
        _input = '';
        weatherOn = false;
      }
      _input += '3';
    });
  }

  void _num4() {
    setState(() {
      if (weatherOn) {
        _input = '';
        weatherOn = false;
      }
      _input += '4';
    });
  }

  void _num5() {
    setState(() {
      if (weatherOn) {
        _input = '';
        weatherOn = false;
      }
      _input += '5';
    });
  }

  void _num6() {
    setState(() {
      if (weatherOn) {
        _input = '';
        weatherOn = false;
      }
      _input += '6';
    });
  }

  void _num7() {
    setState(() {
      if (weatherOn) {
        _input = '';
        weatherOn = false;
      }
      _input += '7';
    });
  }

  void _num8() {
    setState(() {
      if (weatherOn) {
        _input = '';
        weatherOn = false;
      }
      _input += '8';
    });
  }

  void _num9() {
    setState(() {
      if (weatherOn) {
        _input = '';
        weatherOn = false;
      }
      _input += '9';
    });
  }

  void _add() {
    setState(() {
      _result = int.parse(_input);
      _input = '';
      _oper = oper.ADD;
    });
  }

  void _sub() {
    setState(() {
      _result = int.parse(_input);
      _input = '';
      _oper = oper.SUB;
    });
  }

  void _mul() {
    setState(() {
      _result = int.parse(_input);
      _input = '';
      _oper = oper.MUL;
    });
  }

  void _div() {
    setState(() {
      _result = int.parse(_input);
      _input = '';
      _oper = oper.DIV;
    });
  }

  void _equal() {
    setState(() {
      switch (_oper) {
        case oper.ADD:
          _result += int.parse(_input);
          break;
        case oper.SUB:
          _result -= int.parse(_input);
          break;
        case oper.MUL:
          _result *= int.parse(_input);
          break;
        case oper.DIV:
          _result /= int.parse(_input);
          break;
        case oper.NONE:
          break;
      }
      _input = _result.toString();
    });
  }

  void _clear() {
    setState(() {
      weatherOn = true;
      _result = 0;
      _input = '';
      _oper = oper.NONE;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Scaffold(
              appBar: AppBar(
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                title: Text(widget.title),
              ),
              body: Text(
                'Nepodarilo sa pripojit na Firebase',
                style: Theme.of(context).textTheme.headline4,
              ));
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          // init Remote config
          _initRemoteConfig();

          return Scaffold(
              appBar: AppBar(
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                title: Text(widget.title),
              ),
              body: Column(children: <Widget>[
                Expanded(
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //ROW 1
                        children: [
                      Text(
                        '$_input',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ])),
                Expanded(
                  child: Row(
                      //ROW 2
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: _num1,
                            child: Text("1",
                                style: new TextStyle(
                                  fontSize: 40.0,
                                  color: Colors.black,
                                ))),
                        TextButton(
                          onPressed: _num2,
                          child: Text("2",
                              style: new TextStyle(
                                fontSize: 40.0,
                                color: Colors.black,
                              )),
                        ),
                        TextButton(
                          onPressed: _num3,
                          child: Text("3",
                              style: new TextStyle(
                                fontSize: 40.0,
                                color: Colors.black,
                              )),
                        ),
                        TextButton(
                          onPressed: _add,
                          child: Text("+",
                              style: new TextStyle(
                                fontSize: 40.0,
                                color: Colors.black,
                              )),
                        ),
                      ]),
                ),
                Expanded(
                    child: Row(
                        //ROW 3
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                      TextButton(
                        onPressed: _num4,
                        child: Text("4",
                            style: new TextStyle(
                              fontSize: 40.0,
                              color: Colors.black,
                            )),
                      ),
                      TextButton(
                        onPressed: _num5,
                        child: Text("5",
                            style: new TextStyle(
                              fontSize: 40.0,
                              color: Colors.black,
                            )),
                      ),
                      TextButton(
                        onPressed: _num6,
                        child: Text("6",
                            style: new TextStyle(
                              fontSize: 40.0,
                              color: Colors.black,
                            )),
                      ),
                      TextButton(
                        onPressed: _sub,
                        child: Text("-",
                            style: new TextStyle(
                              fontSize: 40.0,
                              color: Colors.black,
                            )),
                      ),
                    ])),
                Expanded(
                    child: Row(
                        //ROW 3
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                      TextButton(
                        onPressed: _num7,
                        child: Text("7",
                            style: new TextStyle(
                              fontSize: 40.0,
                              color: Colors.black,
                            )),
                      ),
                      TextButton(
                        onPressed: _num8,
                        child: Text("8",
                            style: new TextStyle(
                              fontSize: 40.0,
                              color: Colors.black,
                            )),
                      ),
                      TextButton(
                        onPressed: _num9,
                        child: Text("9",
                            style: new TextStyle(
                              fontSize: 40.0,
                              color: Colors.black,
                            )),
                      ),
                      TextButton(
                        onPressed: _mul,
                        child: Text("*",
                            style: new TextStyle(
                              fontSize: 40.0,
                              color: Colors.black,
                            )),
                      ),
                    ])),
                Expanded(
                    child: Row(
                        //ROW 3
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                      TextButton(
                        onPressed: _clear,
                        child: Text("C",
                            style: new TextStyle(
                              fontSize: 40.0,
                              color: Colors.black,
                            )),
                      ),
                      TextButton(
                        onPressed: _num0,
                        child: Text("0",
                            style: new TextStyle(
                              fontSize: 40.0,
                              color: Colors.black,
                            )),
                      ),
                      TextButton(
                        onPressed: _equal,
                        child: Text("=",
                            style: new TextStyle(
                              fontSize: 40.0,
                              color: Colors.black,
                            )),
                      ),
                      TextButton(
                        onPressed: _div,
                        child: Text("/",
                            style: new TextStyle(
                              fontSize: 40.0,
                              color: Colors.black,
                            )),
                      ),
                      IconButton(
                        onPressed: () => _fetchRemoteConfig(),
                        icon: const Icon(Icons.refresh),
                      ),
                    ])),
              ]));
        }

        Timer.periodic(Duration(seconds: 5), (_) async {
          if (_remoteConfig != null) {
            _getWeather();
          }
        });

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}
