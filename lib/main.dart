import 'dart:async';
import 'dart:io';

import 'package:auto_feed/controll.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChangeOption>(
        create: (_) => ChangeOption(),
        child: MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: MyHomePage()));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool connectionFlag = false;

  StreamController<String> _progress = StreamController<String>.broadcast();

  initProgress() async {
    await Future<void>.delayed(Duration(seconds: 2));
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile)
      _progress.sink.add('Connected');
    else if (connectivityResult == ConnectivityResult.wifi)
      _progress.sink.add('Connected');
    else
      _progress.sink.add('Not connected');
    await Future<void>.delayed(Duration(seconds: 5));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _progress.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
                child: RaisedButton(
              onPressed: () async {
                initProgress();
                showDialog(
                    barrierDismissible: connectionFlag,
                    context: context,
                    builder: (alertContext) {
                      return AlertDialog(
                          title: new Text("접속 확인 중"),
                          actions: [
                            StreamBuilder(
                              stream: _progress.stream,
                              builder: (context, snapshot) {
                                if (snapshot.hasError)
                                  return Container();
                                else {
                                  Widget widget = Container();
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.active:
                                      switch (snapshot.data) {
                                        case 'Connected':
                                          widget = FlatButton(
                                              child: Text("다음"),
                                              onPressed: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ControllPage())));
                                          break;

                                        case 'Not connected':
                                          widget = FlatButton(
                                              child: Text('닫기'),
                                              onPressed: () =>
                                                  Navigator.pop(alertContext));
                                          break;
                                      }
                                      break;
                                  }
                                  return widget;
                                }
                              },
                            )
                          ],
                          content: StreamBuilder(
                              stream: _progress.stream,
                              builder: (context, snapshot) {
                                if (snapshot.hasError)
                                  return new Text("에러가 발생했습니다.");
                                else {
                                  Widget widget;
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      widget = Center(
                                          child: new SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: CircularProgressIndicator(),
                                      ));
                                      break;

                                    case ConnectionState.active:
                                      switch (snapshot.data) {
                                        case 'Connected':
                                          widget = new Text("인터넷에 연결되어 있습니다.");
                                          break;

                                        case 'Not connected':
                                          widget = new Text("인터넷에 연결해주세요.");
                                          break;
                                      }
                                      break;
                                  }
                                  return Container(
                                      width: 200, height: 50, child: widget);
                                }
                              }));
                    });
              },
              child: new Text("아두이노에 연결합니다.", style: TextStyle(fontSize: 22)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(color: Colors.blue)),
              textColor: Colors.blue,
              color: Colors.white,
            ))));
  }
}

showInternetConnectivityAlert(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: new Text("인터넷에 연결해야합니다."),
          content: new Text("이 어플을 이용할 때 인터넷이 필요합니다."),
          actions: [
            new FlatButton(onPressed: () => exit(0), child: new Text("닫기"))
          ],
        );
      });
}
