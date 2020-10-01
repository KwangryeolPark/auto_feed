import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

final setFeedURL =
    'https://us-central1-fir-api-test-project-e3d46.cloudfunctions.net/set_feed';
final setLEDURL =
    'https://us-central1-fir-api-test-project-e3d46.cloudfunctions.net/set_LED';
final setScheduleURL =
    'https://us-central1-fir-api-test-project-e3d46.cloudfunctions.net/set_schedule';
final getpHURL =
    'https://us-central1-fir-api-test-project-e3d46.cloudfunctions.net/get_pH';
final getTempURL =
    'https://us-central1-fir-api-test-project-e3d46.cloudfunctions.net/get_temp';

class ControllPage extends StatefulWidget {
  @override
  _ControllPage createState() => _ControllPage();
}

class _ControllPage extends State<ControllPage> {
  String temp = "0.0";
  String pH = "0.0";

  String dropdownValue = '빨강\t';

  TextEditingController textEditingController = new TextEditingController();
  TextEditingController textEditingController2 = new TextEditingController();

  getpH() async {
    String url = getpHURL;

    var res = await http.get(url);
    setState(() {
      pH = res.body;
      if(pH == "Error: could not handle the request") pH = "error";
      print("\t\t받아온 값: " + res.body);
    });
  }

  getTemp() async {
    String url = getTempURL;

    var res = await http.get(url);
    setState(() {
      temp = res.body;
      if(temp == "Error: could not handle the request") temp = "error";
      print("\t\t받아온 값: " + res.body);
    });
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (t) async {
      print("Asdasd");
      getpH();
      getTemp();
    });
  }

  @override
  Widget build(BuildContext context) {
    final option = Provider.of<ChangeOption>(context);
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Color.fromARGB(255, 213, 232, 210),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: new Text("   어항 상태 현황(온도, pH)",
                            textAlign: TextAlign.left),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: new Center(
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(flex: 1, child: Container()),
                              Expanded(
                                  flex: 3,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: Image.asset(
                                                'assets/images/hygrometer.png')),
                                        Text('\n수온')
                                      ])),
                              Expanded(
                                  flex: 2, child: Text('\t\t\t' + temp + 'C')),
                              Expanded(flex: 1, child: Container()),
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: Image.asset(
                                                'assets/images/cup.png')),
                                        Text('\npH 농도')
                                      ])),
                              Expanded(
                                  flex: 2, child: Center(child: Text('' + pH))),
                              Expanded(flex: 1, child: Container())
                              //Hygrometer icon icon by Icons8
                            ],
                          ),
                        )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: Color.fromARGB(255, 213, 232, 210),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: new Text("   어항 관리 (수온, 먹이주기, LED제어)",
                              textAlign: TextAlign.left),
                        )),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Color.fromARGB(255, 255, 242, 205),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          option.set(1);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("수온"),
                            SizedBox(
                                width: 50,
                                height: 50,
                                child: Image.asset('assets/images/fish.png')),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          option.set(2);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("먹이급여"),
                            SizedBox(
                                width: 50,
                                height: 50,
                                child: Image.asset('assets/images/fish.png')),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          option.set(3);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("LED"),
                            SizedBox(
                                width: 50,
                                height: 50,
                                child: Image.asset('assets/images/light.png')),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Center(child: showOption()),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                          "All icons from ICONS8 (Sport Drink Cup. Hygrometer. Whole Fish. Light.)"),
                    )
                  ],
                ),
                color: Color.fromARGB(255, 217, 232, 251),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showOption() {
    String data = '';

    Widget widget = Container();
    final option = Provider.of<ChangeOption>(context);

    switch (option.get()) {
      case 1:
        widget = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 1, child: Container()),
            Expanded(
              flex: 3,
              child: Text("희망 온도: ", textAlign: TextAlign.center),
            ),
            Expanded(flex: 1, child: Container()),
            Expanded(
              flex: 3,
              child: TextField(
                controller: textEditingController,
                keyboardType: TextInputType.number,
              ),
            ),
            Expanded(flex: 1, child: Container()),
            Expanded(
                flex: 3,
                child: Container(
                    width: 40,
                    color: Color.fromARGB(255, 240, 209, 207),
                    child: SizedBox(
                        width: 40,
                        height: 50,
                        child: FlatButton(
                          child: new Text("설정"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                              side: BorderSide(
                                  color: Color.fromARGB(255, 178, 132, 143))),
                          textColor: Colors.black,
                        )))),
            Expanded(flex: 1, child: Container()),
          ],
        );
        break;

      case 2:
        widget = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 1, child: Container()),
            Expanded(
              flex: 3,
              child: Text("먹이급여 시각: ", textAlign: TextAlign.center),
            ),
            Expanded(flex: 1, child: Container()),
            Expanded(
              flex: 4,
              child: TextField(
                controller: textEditingController2,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: new InputDecoration(hintText: '0 ~ 23h'),
              ),
            ),
            Expanded(flex: 1, child: Container()),
            Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        color: Color.fromARGB(255, 240, 209, 207),
                        child: SizedBox(
                            width: 100,
                            height: 40,
                            child: FlatButton(
                              child: new Text("설 정"),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                  side: BorderSide(
                                      color:
                                          Color.fromARGB(255, 178, 132, 143))),
                              textColor: Colors.black,
                              onPressed: () async {
                                print("\t\t입력한 데이터: " +
                                    textEditingController2.text);
                                data = textEditingController2.text;
                                int dataInteger = int.tryParse(data) ?? 50;
                                data = dataInteger.toString();
                                if (dataInteger < 0 || dataInteger > 23)
                                  data = "50";
                                if (dataInteger < 10) data = "0" + data;
                                print("\t\t보낸 시각: " + data);

                                String url = setScheduleURL + "?data=" + data;

                                var res = await http.get(url);
                                setState(() {
                                  print("\t\t받아온 값: " + res.body);
                                });
                              },
                            ))),
                    Container(height: 20),
                    Container(
                        color: Color.fromARGB(255, 255, 242, 205),
                        child: SizedBox(
                            width: 100,
                            height: 40,
                            child: FlatButton(
                              child: new Text("수동 급여"),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                  side: BorderSide(
                                    color: Color.fromARGB(255, 195, 182, 145),
                                  )),
                              textColor: Colors.black,
                              onPressed: () async {
                                String url = setFeedURL + "?data=" + "true";

                                var res = await http.get(url);
                                setState(() {
                                  print("\t\t받아온 값: " + res.body);
                                });
                              },
                            )))
                  ],
                )),
            Expanded(flex: 1, child: Container()),
          ],
        );
        break;

      case 3:
        Map<String, Color> textColor = {
          '빨강\t': Colors.red,
          '초록\t': Colors.green,
          '파랑\t': Colors.blue
        };
        widget = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 1, child: Container()),
            Expanded(
              flex: 3,
              child: Text("LED ", textAlign: TextAlign.center),
            ),
            Expanded(flex: 1, child: Container()),
            Expanded(
                flex: 4,
                child: Center(
                    child: DropdownButton<String>(
                        value: dropdownValue,
                        style: TextStyle(color: Colors.red),
                        icon: Icon(Icons.color_lens),
                        onChanged: (value) {
                          setState(() {
                            dropdownValue = value;
                          });
                        },
                        items: <String>['빨강\t', '초록\t', '파랑\t']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: TextStyle(color: textColor[value]),
                                  textAlign: TextAlign.center));
                        }).toList()))),
            Expanded(flex: 1, child: Container()),
            Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        color: Color.fromARGB(255, 240, 209, 207),
                        child: SizedBox(
                            width: 100,
                            height: 40,
                            child: FlatButton(
                              child: new Text("설 정"),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                  side: BorderSide(
                                      color:
                                          Color.fromARGB(255, 178, 132, 143))),
                              textColor: Colors.black,
                              onPressed: () async {
                                Map<String, String> led = {
                                  '빨강\t': "150:000:000",
                                  '초록\t': "000:150:000",
                                  '파랑\t': "000:000:150"
                                };
                                String url =
                                    setLEDURL + "?data=" + led[dropdownValue];

                                var res = await http.get(url);
                                setState(() {
                                  print("\t\t받아온 값: " + res.body);
                                });
                              },
                            ))),
                    Container(height: 20),
                    Container(
                        color: Color.fromARGB(255, 255, 242, 205),
                        child: SizedBox(
                            width: 100,
                            height: 40,
                            child: FlatButton(
                              child: new Text("ON/OFF"),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                  side: BorderSide(
                                    color: Color.fromARGB(255, 195, 182, 145),
                                  )),
                              textColor: Colors.black,
                              onPressed: () async {
                                String url =
                                    setLEDURL + "?data=" + "000:000:000";

                                var res = await http.get(url);
                                setState(() {
                                  print("\t\t받아온 값: " + res.body);
                                });
                              },
                            )))
                  ],
                )),
            Expanded(flex: 1, child: Container()),
          ],
        );
    }
    return widget;
  }
}

class ChangeOption with ChangeNotifier {
  int _option = 0;

  void set(int option) {
    _option = option;
    notifyListeners();
  }

  int get() {
    return _option;
  }
}
