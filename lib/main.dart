// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Platform Dependency',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _platform = '';
  String _deviceModel = '';

  @override
  void initState() {
    super.initState();
    _initPlatformState();
    _getDeviceModel();
  }

  Future<void> _initPlatformState() async {
    try {
      if (Platform.isAndroid) {
        setState(() {
          _platform = 'Android';
        });
      } else if (Platform.isIOS) {
        setState(() {
          _platform = 'iOS';
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _getDeviceModel() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        String model = await _getPlatformModel();
        setState(() {
          _deviceModel = model;
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<String> _getPlatformModel() async {
    if (Platform.isAndroid) {
      const platform = MethodChannel('samples.flutter.dev/device');
      String model = await platform.invokeMethod('getDeviceModel');
      return model;
    } else if (Platform.isIOS) {
      return 'iOS Device';
    } else {
      return 'Unknown Platform';
    }
  }

  void _showPlatformDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text('iOS Dialog'),
                content: Text('This is an iOS specific dialog.'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Close', style: TextStyle(color: Colors.amber)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            : AlertDialog(
                title: Text('Android Dialog'),
                content: Text('This is an Android specific dialog.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Close', style: TextStyle(color: Colors.amber)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Platform Dependency'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Platform: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '$_platform',
                  style: TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Device Model: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '$_deviceModel',
                  style: TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.amber),
              ),
              onPressed: _showPlatformDialog,
              child: Text('Show Platform Specific Dialog', style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
      ),
    );
  }
}
