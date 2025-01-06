
import 'dart:convert';

import 'package:display_sdk_flutter/USBserial/usb_serial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class SerialPortPage extends StatefulWidget {
  const SerialPortPage({super.key});

  @override
  State<SerialPortPage> createState() => _SerialPortPageState();
}

class _SerialPortPageState extends State<SerialPortPage> {
  TextEditingController commandController = TextEditingController();

  List<UsbDevice> serialPortList = [];


  void getAllPort() async {
    serialPortList = await UsbSerial.listDevices();
    setState(() {});
  }

  UsbDevice? selectPort;
  UsbPort? port;

  String receiveAmount = "";

  bool portConnected = false;


  void connectPort() async {

    port = await selectPort?.create();
    portConnected = await port?.open() ?? false;
    if ( !portConnected ) {
      setState(() {});
      return;
    }

    await port?.setDTR(true);
    await port?.setRTS(true);

    port?.setPortParameters(9600, UsbPort.DATABITS_8,
        UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);
    setState(() {

    });
    // print first result and close port.
    port?.inputStream?.listen((Uint8List event) {
      var data = String.fromCharCodes(event);
      print(data);
      receiveAmount = data;
      setState(() {

      });
      if(!data.contains("0.000")) {


      }


    });


  }

  void sendCommand(String command) async {
    await port?.write(Uint8List.fromList(utf8.encode(command)));
  }


  @override
  void initState() {
    getAllPort();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Serial Port")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Receive: ${receiveAmount}"),
          ),

          serialList(),
          MaterialButton(
              color: Colors.indigo,
              onPressed: portConnected ? null : () {
                connectPort();
              },child: Text(portConnected ? "Connected" : "Connect",style: TextStyle(color: Colors.white),)),
          command()
        ],
      ),
    );
  }


  Widget serialList() {
    return Row(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Serial Port"
                ),
                items: List.generate(serialPortList.length, (index) {
                  var d = serialPortList[index];
                  return DropdownMenuItem(value: d, child: Text(d.deviceName ?? ""));
                }), onChanged: (value){
              if(port != null) {
                port?.close();
                setState(() {
                  portConnected = false;
                });
              }
              selectPort = value;
              setState(() {});
            }),
          ),
        ),

        IconButton(onPressed: () {
          getAllPort();
        }, icon: Icon(Icons.refresh))
      ],
    );
  }



  Widget command() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(

            controller: commandController,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Send Command"
            ),
          ),
        ),
        MaterialButton(
            color: Colors.indigo,
            onPressed: () {
              sendCommand(commandController.text);
            },child: Text("Send",style: TextStyle(color: Colors.white),))
      ],
    );
  }


}
