import 'package:flutter/material.dart';

import 'package:flutter_serial_communication/flutter_serial_communication.dart';
import 'package:flutter_serial_communication/models/device_info.dart';

class Rs323Serial2Page extends StatefulWidget {
  const Rs323Serial2Page({super.key});

  @override
  State<Rs323Serial2Page> createState() => _Rs323Serial2PageState();
}

class _Rs323Serial2PageState extends State<Rs323Serial2Page> {
  final _flutterSerialCommunicationPlugin = FlutterSerialCommunication();

  List<String> deviceList = [];

  Future getSerialList() async {
    List<DeviceInfo> availableDevices = await _flutterSerialCommunicationPlugin.getAvailableDevices();

    for (var element in availableDevices) {
      deviceList.add(element.toJson());
      print(element.toJson());
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
