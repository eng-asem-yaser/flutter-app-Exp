import 'package:flutter/material.dart';
import 'package:one/play_one.dart';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
void main() {
  runApp(const MyApp());
  MQTTClientWrapper s = MQTTClientWrapper();
  s.prepareMqttClient();

}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:PlayOne()
    );

  }
}