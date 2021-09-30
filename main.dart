import 'package:flutter/material.dart';

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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum oper {
  ADD,
  SUB,
  MUL,
  DIV,
  NONE,
}

class _MyHomePageState extends State<MyHomePage> {
  num _result = 0;
  var _input = '';
  oper _oper = oper.NONE;

  void _num0() {
    setState(() {
      _input += '0';
    });
  }

  void _num1() {
    setState(() {
      _input += '1';
    });
  }

  void _num2() {
    setState(() {
      _input += '2';
    });
  }

  void _num3() {
    setState(() {
      _input += '3';
    });
  }

  void _num4() {
    setState(() {
      _input += '4';
    });
  }

  void _num5() {
    setState(() {
      _input += '5';
    });
  }

  void _num6() {
    setState(() {
      _input += '6';
    });
  }

  void _num7() {
    setState(() {
      _input += '7';
    });
  }

  void _num8() {
    setState(() {
      _input += '8';
    });
  }

  void _num9() {
    setState(() {
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
      }
      _input = _result.toString();
    });
  }

  void _clear() {
    setState(() {
      _result = 0;
      _input = '';
      _oper = oper.NONE;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: //Center(
            Column(children: <Widget>[
          Expanded(
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //ROW 1
                  children: [
                Text(
                  '$_input',
                  style: Theme.of(context).textTheme.headline4,
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
                )
              ])),
        ]));
  }
}
