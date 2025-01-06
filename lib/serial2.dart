import 'package:display_sdk_flutter/USBserial/usb_serial.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';



class SerialPortReader extends StatefulWidget {
  @override
  _SerialPortReaderState createState() => _SerialPortReaderState();
}

class _SerialPortReaderState extends State<SerialPortReader> {
  UsbPort? _port;
  List<UsbDevice> _devices = [];
  String _serialData = '';

  TextEditingController commandController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getPorts();
  }

  Future<void> _getPorts() async {
    List<UsbDevice> devices = await UsbSerial.listDevices();
    setState(() {
      _devices = devices;
    });
  }

  Future<void> _connectToDevice(UsbDevice device) async {
    UsbPort? port = await device.create();
    bool openResult = await (port?.open()) ?? false;
    if (!openResult) {
      print("Failed to open port");
      return;
    }

    await port?.setDTR(true);
    await port?.setRTS(true);
    await port?.setPortParameters(9600, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

    port?.inputStream?.listen((Uint8List event) {
      setState(() {
        var data = String.fromCharCodes(event);
        print(data);
       if(!data.contains("0.000")){
         _serialData = String.fromCharCodes(event);
       }
      });
    });

    setState(() {
      _port = port;
    });
  }

  @override
  void dispose() {
    _port?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Serial Port Reader'),
      ),
      body: Column(
        children: [
          DropdownButton<UsbDevice>(
            items: _devices.map((UsbDevice device) {
              return DropdownMenuItem<UsbDevice>(
                value: device,
                child: Text(device.deviceName),
              );
            }).toList(),
            onChanged: (UsbDevice? device) {
              if (device != null) {
                _connectToDevice(device);
              }
            },
            hint: Text('Select Device'),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Text(_serialData),
            ),
          ),
        ],
      ),
    );
  }
}
