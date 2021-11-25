import 'package:calculator/message.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

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

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  AccessToken? fbAccessToken;
  String? fbAuthorPicture;
  String? fbAuthorName;
  String? fbAuthorId;

  List<num> nums = [];
  List<String> opers = [];

  var input = '';
  var message = '';
  num? result;
  bool holdResult = false;
  bool waitForInput = false;

  String? city;
  bool weatherOn = true;
  Future<http.Response>? httpWeather;

  static RemoteConfig? _remoteConfig;
  final defaults = <String, dynamic>{"City": "Bratislava"};

  void saveMessage(Message msg) {
    final _dbRef = FirebaseDatabase.instance.reference().child("calculator");
    _dbRef.push().set(msg.toJson());
  }

  void initListener() {
    final DatabaseReference _dbRef =
        FirebaseDatabase.instance.reference().child("calculator");
    _dbRef
        .orderByChild('datetime')
        .limitToLast(10)
        .onChildAdded
        .listen((event) {
      var msg = Message.fromSnapshot(event.snapshot);

      // prejdi pouzivane operandy a upozorni usera
      var mean = 0.0;
      msg.nums.forEach((element) {
        mean += element;
      });
      mean /= msg.nums.length;

      if (mean <= 10) {
        setState(() {
          message = "Please don't use a calculator for numbers to 10 !!!";
        });
      } else {
        setState(() {
          message = "You're clever.";
        });
      }
    });
  }

  void getFacebook() async {
    // over spravnost prihlasenia
    if (fbAccessToken != null) {
      final userData =
          await FacebookAuth.instance.getUserData(fields: "id,name,picture");

      fbAuthorName = userData["name"];
      fbAuthorId = userData["id"];
      setState(() {
        fbAuthorPicture = userData["picture"]["data"]["url"];
        message = "Welcome, $fbAuthorName!";
      });
    }
  }

  void initFacebook() async {
    if (fbAccessToken == null) {
      final LoginResult result = await FacebookAuth.instance
          .login(); // by default we request the email and the public profile
      if (result.status == LoginStatus.success) {
        fbAccessToken = result.accessToken;

        getFacebook();
      } else {
        setState(() {
          message =
              "Cannot connect to Facebook API: ${result.status}, ${result.message}";
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addObserver(this);

    initListener();
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

        city = _remoteConfig!.getString("City");
        httpWeather = http.get(Uri.parse(
            "https://api.openweathermap.org/data/2.5/weather?q=$city,SK&appid=6eb6b05fcdc850818c6238aef85610be&units=metric"));

        getWeather();
        getFacebook();
      }
    }
  }

  initRemoteConfig() async {
    if (_remoteConfig == null) {
      _remoteConfig = RemoteConfig.instance;
      await _remoteConfig!.setDefaults(defaults);
      await _remoteConfig!.fetch();

      await _remoteConfig!.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 5),
          minimumFetchInterval: const Duration(hours: 12)));

      city = _remoteConfig!.getString("City");
      httpWeather = http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$city,SK&appid=6eb6b05fcdc850818c6238aef85610be&units=metric"));

      await getWeather();
    }
  }

  Future<void> getWeather() async {
    try {
      http.Response? r = await httpWeather;
      String data = r!.body;

      Map<String, dynamic> dataMap = json.decode(data);
      Welcome pr = Welcome.fromJson(dataMap);

      setState(() {
        input =
            'City: $city\nTemp: ${pr.main!.temp} °C\nPressure: ${pr.main!.pressure} hPa\nHumidity: ${pr.main!.humidity} %';
      });
    } catch (e) {
      setState(() {
        input = "Cannot read weather !";
      });
    }
  }

  void _num0() {
    setState(() {
      if (weatherOn || holdResult) {
        input = '';
        weatherOn = false;
        holdResult = false;
      }
      input += '0';
      waitForInput = false;
    });
  }

  void _num1() {
    setState(() {
      if (weatherOn || holdResult) {
        input = '';
        weatherOn = false;
        holdResult = false;
      }
      input += '1';
      waitForInput = false;
    });
  }

  void _num2() {
    setState(() {
      if (weatherOn || holdResult) {
        input = '';
        weatherOn = false;
        holdResult = false;
      }
      input += '2';
      waitForInput = false;
    });
  }

  void _num3() {
    setState(() {
      if (weatherOn || holdResult) {
        input = '';
        weatherOn = false;
        holdResult = false;
      }
      input += '3';
      waitForInput = false;
    });
  }

  void _num4() {
    setState(() {
      if (weatherOn || holdResult) {
        input = '';
        weatherOn = false;
        holdResult = false;
      }
      input += '4';
      waitForInput = false;
    });
  }

  void _num5() {
    setState(() {
      if (weatherOn || holdResult) {
        input = '';
        weatherOn = false;
        holdResult = false;
      }
      input += '5';
      waitForInput = false;
    });
  }

  void _num6() {
    setState(() {
      if (weatherOn || holdResult) {
        input = '';
        weatherOn = false;
        holdResult = false;
      }
      input += '6';
      waitForInput = false;
    });
  }

  void _num7() {
    setState(() {
      if (weatherOn || holdResult) {
        input = '';
        weatherOn = false;
        holdResult = false;
      }
      input += '7';
      waitForInput = false;
    });
  }

  void _num8() {
    setState(() {
      if (weatherOn || holdResult) {
        input = '';
        weatherOn = false;
        holdResult = false;
      }
      input += '8';
      waitForInput = false;
    });
  }

  void _num9() {
    setState(() {
      if (weatherOn || holdResult) {
        input = '';
        weatherOn = false;
        holdResult = false;
      }
      input += '9';
      waitForInput = false;
    });
  }

  void process(String oper) {
    switch (oper) {
      case "+":
        result = result! + nums.last;
        break;
      case "-":
        result = result! - nums.last;
        break;
      case "*":
        result = result! * nums.last;
        break;
      case "/":
        result = result! / nums.last;
        break;
      default:
        break;
    }

    setState(() {
      input = result.toString();
    });
  }

  void _add() {
    if (waitForInput == false) {
      nums.add(num.parse(input));
      print("input: $input\tresult: $result\toper: $opers\tlast_num: $nums");

      if (result == null) {
        result = nums.last;
      } else {
        process(opers.last);
      }

      opers.add("+");
      holdResult = true;
      waitForInput = true;
    } else {
      opers.removeAt(opers.length - 1);
      opers.add("+");
    }
  }

  void _sub() {
    if (waitForInput == false) {
      nums.add(num.parse(input));
      print("input: $input\tresult: $result\toper: $opers\tlast_num: $nums");

      if (result == null) {
        result = nums.last;
      } else {
        process(opers.last);
      }

      opers.add("-");
      holdResult = true;
      waitForInput = true;
    } else // change operand
    {
      opers.removeAt(opers.length - 1);
      opers.add("-");
    }
  }

  void _mul() {
    if (waitForInput == false) {
      nums.add(num.parse(input));
      print("input: $input\tresult: $result\toper: $opers\tlast_num: $nums");

      if (result == null) {
        result = nums.last;
      } else {
        process(opers.last);
      }

      opers.add("*");
      holdResult = true;
      waitForInput = true;
    } else // change operand
    {
      opers.removeAt(opers.length - 1);
      opers.add("*");
    }
  }

  void _div() {
    if (waitForInput == false) {
      nums.add(num.parse(input));
      print(
          "input: $input\tresult: $result\toper: ${opers}\tlast_num: ${nums}");

      if (result == null) {
        result = nums.last;
      } else {
        process(opers.last);
      }

      opers.add("/");
      holdResult = true;
      waitForInput = true;
    } else // change operand
    {
      opers.removeAt(opers.length - 1);
      opers.add("/");
    }
  }

  void _equal() {
    if (!weatherOn) {
      nums.add(num.parse(input));

      if (result != null) {
        process(opers.last);
      }

      saveMessage(Message(
          nums, opers, result, DateTime.now(), fbAuthorId, fbAuthorName));
    }
  }

  void _clear() {
    setState(() {
      weatherOn = true;
      result = null;
      input = '';
      nums.clear();
      opers.clear();
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
          initRemoteConfig();
          initFacebook();

          Timer.periodic(const Duration(minutes: 5), (_) async {
            if (_remoteConfig != null && weatherOn) {
              getWeather();
            }
          });

          return Scaffold(
              appBar: AppBar(
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                title: Text(widget.title),
              ),
              body: Column(children: <Widget>[
                Container(
                    margin: const EdgeInsets.all(15),
                    child: Text(input, style: const TextStyle(fontSize: 25))),
                Row(children: [
                  if (fbAuthorPicture != null) Image.network(fbAuthorPicture!),
                  Container(
                      margin: const EdgeInsets.all(15),
                      child:
                          Text(message, style: const TextStyle(fontSize: 15))),
                ]),
                Expanded(
                  child: Row(
                      //ROW 3
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: _num1,
                            child: const Text("1",
                                style: TextStyle(
                                  fontSize: 40.0,
                                  color: Colors.black,
                                ))),
                        TextButton(
                          onPressed: _num2,
                          child: const Text("2",
                              style: TextStyle(
                                fontSize: 40.0,
                                color: Colors.black,
                              )),
                        ),
                        TextButton(
                          onPressed: _num3,
                          child: const Text("3",
                              style: TextStyle(
                                fontSize: 40.0,
                                color: Colors.black,
                              )),
                        ),
                        TextButton(
                          onPressed: _add,
                          child: const Text("+",
                              style: TextStyle(
                                fontSize: 40.0,
                                color: Colors.black,
                              )),
                        ),
                      ]),
                ),
                Expanded(
                    child: Row(
                        //ROW 4
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                      TextButton(
                        onPressed: _num4,
                        child: const Text("4",
                            style: TextStyle(
                              fontSize: 40.0,
                              color: Colors.black,
                            )),
                      ),
                      TextButton(
                        onPressed: _num5,
                        child: const Text("5",
                            style: TextStyle(
                              fontSize: 40.0,
                              color: Colors.black,
                            )),
                      ),
                      TextButton(
                        onPressed: _num6,
                        child: const Text("6",
                            style: TextStyle(
                              fontSize: 40.0,
                              color: Colors.black,
                            )),
                      ),
                      TextButton(
                        onPressed: _sub,
                        child: const Text("-",
                            style: TextStyle(
                              fontSize: 40.0,
                              color: Colors.black,
                            )),
                      ),
                    ])),
                Expanded(
                    child: Row(
                        //ROW 5
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                      TextButton(
                        onPressed: _num7,
                        child: const Text("7",
                            style: TextStyle(
                              fontSize: 40.0,
                              color: Colors.black,
                            )),
                      ),
                      TextButton(
                        onPressed: _num8,
                        child: const Text("8",
                            style: TextStyle(
                              fontSize: 40.0,
                              color: Colors.black,
                            )),
                      ),
                      TextButton(
                        onPressed: _num9,
                        child: const Text("9",
                            style: TextStyle(
                              fontSize: 40.0,
                              color: Colors.black,
                            )),
                      ),
                      TextButton(
                        onPressed: _mul,
                        child: const Text("*",
                            style: TextStyle(
                              fontSize: 40.0,
                              color: Colors.black,
                            )),
                      ),
                    ])),
                Expanded(
                    child: Row(
                        //ROW 6
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                      TextButton(
                        onPressed: _clear,
                        child: const Text("C",
                            style: TextStyle(
                              fontSize: 40.0,
                              color: Colors.black,
                            )),
                      ),
                      TextButton(
                        onPressed: _num0,
                        child: const Text("0",
                            style: TextStyle(
                              fontSize: 40.0,
                              color: Colors.black,
                            )),
                      ),
                      TextButton(
                        onPressed: _equal,
                        child: const Text("=",
                            style: TextStyle(
                              fontSize: 40.0,
                              color: Colors.black,
                            )),
                      ),
                      TextButton(
                        onPressed: _div,
                        child: const Text("/",
                            style: TextStyle(
                              fontSize: 40.0,
                              color: Colors.black,
                            )),
                      ),
                      IconButton(
                        onPressed: () => {
                          setState(() => {
                                if (input.isNotEmpty)
                                  {input = input.substring(0, input.length - 1)}
                              })
                        },
                        icon: const Icon(Icons.backspace),
                      ),
                    ])),
              ]));
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const CircularProgressIndicator();
      },
    );
  }
}
