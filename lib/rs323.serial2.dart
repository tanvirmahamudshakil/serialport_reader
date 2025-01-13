import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class Rs323Serial2Page extends StatefulWidget {
  const Rs323Serial2Page({super.key});

  @override
  State<Rs323Serial2Page> createState() => _Rs323Serial2PageState();
}

class _Rs323Serial2PageState extends State<Rs323Serial2Page> {
  Future getSerialList() async {
    final devices = SerialPort.availablePorts;
    ;
    for (var element in devices) {
      print(element);
    }
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
              getSerialList();
            },
            child: Text("Serial Get"),
          )
        ],
      ),
    );
  }
}
