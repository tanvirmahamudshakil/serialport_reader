import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_serial_communication/flutter_serial_communication.dart';
import 'package:flutter_serial_communication/models/device_info.dart';

class RS323SerialPage extends StatefulWidget {
  const RS323SerialPage({super.key});

  @override
  State<RS323SerialPage> createState() => _RS323SerialPageState();
}

class _RS323SerialPageState extends State<RS323SerialPage> {
  final _flutterSerialCommunicationPlugin = FlutterSerialCommunication();
  List<DeviceInfo> listDevice = [];
  DeviceInfo? selectDevice;

  Future getSerialDevice() async {
    listDevice = await _flutterSerialCommunicationPlugin.getAvailableDevices();
    print("list device ${listDevice.length}");
    setState(() {});
  }

  void disconnectSerial() async {
    await _flutterSerialCommunicationPlugin.disconnect();
  }

  void serialPortLisitiner() {
    EventChannel eventChannel = _flutterSerialCommunicationPlugin.getSerialMessageListener();
    eventChannel.receiveBroadcastStream().listen((event) {
      debugPrint("Received From Native:  $event");
    });
  }

  void deviceConnectStatus() {
    EventChannel eventChannel = _flutterSerialCommunicationPlugin.getDeviceConnectionListener();
    eventChannel.receiveBroadcastStream().listen((event) {
      debugPrint("Received From Native:  $event");
    });
  }

  Future connectDevice() async {
    // DeviceInfo from getAvailableDevices()
    int baudRate = 0; // Your device's baud rate
    if (selectDevice != null) {
      bool isConnectionSuccess = await _flutterSerialCommunicationPlugin.connect(selectDevice!, baudRate);

      print("connect device ${isConnectionSuccess}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("RS323 Serial Port")),
      body: Column(
        children: [
          MaterialButton(
              color: Colors.green,
              onPressed: () {
                getSerialDevice();
              },
              child: Text("Get Serial Port")),
          DropdownButton<DeviceInfo>(
            items: listDevice.map((DeviceInfo device) {
              return DropdownMenuItem<DeviceInfo>(
                value: device,
                child: Text(device.deviceName),
              );
            }).toList(),
            onChanged: (DeviceInfo? device) {
              setState(() {
                selectDevice = device;
              });
            },
            hint: Text('Select Device'),
          ),
          MaterialButton(
              color: Colors.green,
              onPressed: () {
                connectDevice();
              },
              child: Text("Connect Serial Port")),
          MaterialButton(
              color: Colors.green,
              onPressed: () {
                serialPortLisitiner();
              },
              child: Text("Listiner  Connect Serial Port")),
          MaterialButton(
              color: Colors.green,
              onPressed: () {
                deviceConnectStatus();
              },
              child: Text("deviceConnectStatus")),
          MaterialButton(
              color: Colors.green,
              onPressed: () {
                disconnectSerial();
              },
              child: Text("disconnect")),
        ],
      ),
    );
  }
}
