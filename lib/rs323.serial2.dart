import 'package:flutter/material.dart';

import 'package:serialport_plus/serialport_plus.dart';

class Rs323Serial2Page extends StatefulWidget {
  const Rs323Serial2Page({super.key});

  @override
  State<Rs323Serial2Page> createState() => _Rs323Serial2PageState();
}

class _Rs323Serial2PageState extends State<Rs323Serial2Page> {
  final _serialportFlutterPlugin = SerialportPlus();

  List<String> deviceList = [];

  Future getSerialList() async {
    var devices = (await _serialportFlutterPlugin.getAllDevicesPath());

    for (var element in devices!) {
      print(element);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Seriqal 2"),
      ),
      body: Column(
        children: [
          MaterialButton(
            onPressed: () {
              deviceList.clear();
              setState(() {});
              getSerialList();
            },
            child: Text("Serial Get"),
          )
        ],
      ),
    );
  }
}
