import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:one/mqtt.dart';
String x='';
bool g = false;
String m='';
class PlayOne extends StatefulWidget {
  @override
  State<PlayOne> createState() => _PlayOneState();
}

class _PlayOneState extends State<PlayOne> {
  bool isSwitched = true;
  bool ic = false;
  String? _now;
  Timer? _everySecond;
  MQTTClientWrapper s = MQTTClientWrapper();

  @override
  void initState() {
    super.initState();

    // sets first value
    _now = DateTime.now().second.toString();

    // defines a timer
    _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
    //  s._1publishMessage('r', 'EXP');

      //print(ic);
      setState(() {


        ic = g;

        _now = DateTime.now().second.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 30.0,
        backgroundColor: Colors.blueGrey[900],
        toolbarHeight: 60.0,
        leading: Icon(
          Icons.wifi_tethering,
        ),
        title: Center(
          child: Text(
            'EXPERT HOUSE',
          ),
        ),
        actions: [
          IconButton(
              onPressed: onpress,
              icon: Icon(
                Icons.menu,
              )),
        ],
      ),
      body: Container(
         width: double.infinity,
         height: double.infinity,
                //color: Colors.blueGrey[900],
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          /*stops: [
                0.1,
                0.7,
                0.9,
              ],*/
          colors: [
            Color.fromRGBO(11, 25, 51, 1.0),
            Color.fromRGBO(2, 87, 122, 1.0),
            Color.fromRGBO(1, 48, 63, 1.0),
          ],
        )),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                   'Demo App',
                   style: TextStyle(
                     fontSize: 20.0,
                     color: Colors.white,

                   ),

                 ),
            ),
               Expanded(child:
                Image.asset(
                  "images/jk.png",
                  height: 300.0,
                  width: 300.0,
                ),
        ),

               Expanded(
                 child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      ic
                          ? Image.asset(
                              "images/light.gif",
                              height: 60.0,
                              width: 60.0,
                            )
                          : Image.asset(
                              "images/off.gif",
                              height: 60.0,
                              width: 60.0,
                            ),
                      Text(
                        '   Lamp',
                        style: TextStyle(
                          fontSize: 50.0,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        width: 60.0,
                        height: 60.0,
                        child: Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                                var x = isSwitched ? 'O' : 'F';
                                //s._connectClient();
                                s._publishMessage(x, 'EXP');

                                // ic=(g=='0');
                              });
                            }),
                      ),

                    ]),
               ),


                             /*Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               crossAxisAlignment: CrossAxisAlignment.center,
                               children: [
                                 Text(
                                    'Lamp',
                                    style: TextStyle(
                                      fontSize: 40.0,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              Switch(
                                  value: isSwitched,
                                  onChanged: (value) {
                                    setState(() {
                                      isSwitched = value;
                                      var x = isSwitched ? '1' : '0';
                                      //s._connectClient();
                                      s._publishMessage(x, 'hajar1');

                                      // ic=(g=='0');
                                    });
                                  }),

                    ]),*/





            /*Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                  15.0, 10.0, 0.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(onPressed: om,
                    icon: Icon(
                      Icons.air,
                      color: Colors.white,
                      size: 50.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        15.0, 10.0, 0.0, 0.0),
                    child: Text('   AC',
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                  ),
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  void om() {
    ic = (g == '0');
  }

  void onpress() {}
}




enum MqttCurrentConnectionState {
  IDLE,
  CONNECTING,
  CONNECTED,
  DISCONNECTED,
  ERROR_WHEN_CONNECTING
}

enum MqttSubscriptionState { IDLE, SUBSCRIBED }

class MQTTClientWrapper {
  MqttServerClient? client;

  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;

  // using async tasks, so the connection won't hinder the code flow
  void prepareMqttClient() async {
    _setupMqttClient();
    await _connectClient();
    _subscribeToTopic('EXP');
    _publishMessage('hiiiiiii', 'EXP');
  }

  // waiting for the connection, if an error occurs, print it and disconnect
  Future<void> _connectClient() async {
    try {
      print('client connecting....');
      connectionState = MqttCurrentConnectionState.CONNECTING;
      await client?.connect('flutter', '12345678');
    } on Exception catch (e) {
      print('client exception - $e');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client?.disconnect();
    }

    // when connected, print a confirmation, else print an error
    if (client?.connectionStatus.state == MqttConnectionState.connected) {
      connectionState = MqttCurrentConnectionState.CONNECTED;
      print('client connected');
    } else {
      print(
          'ERROR client connection failed - disconnecting, status is ${client?.connectionStatus}');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client?.disconnect();
    }
  }

  void _setupMqttClient() {
    client = MqttServerClient.withPort(
        '25390565c2c345cf8ee57bf432c84aed.s2.eu.hivemq.cloud', 'NBVHB', 8883);
    // the next 2 lines are necessary to connect with tls, which is used by HiveMQ Cloud
    client?.secure = true;
    client?.securityContext = SecurityContext.defaultContext;
    client?.keepAlivePeriod = 20;
    client?.onDisconnected = _onDisconnected;
    client?.onConnected = _onConnected;
    client?.onSubscribed = _onSubscribed;
  }

  void _subscribeToTopic(String topicName) {
    // print('Subscribing to the $topicName topic');
    client?.subscribe(topicName, MqttQos.atMostOnce);

    // print the message when it is received
    client?.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
      final payload =
      MqttPublishPayload.bytesToStringAsString(message.payload.message);

      // print('Received message:$payload from topic: ${c[0].topic}>');
      //print('YOU GOT A NEW MESSAGE:');
      print(payload);
      m=payload;
      if (payload=='1'){
        g=true;
      }
      else if (payload=='0'){
      g = false;
    }});}

  void _publishMessage(String message, String topic) async {
    _setupMqttClient();
    await _connectClient();
    _subscribeToTopic('EXP');
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    print('Publishing message "$message" to topic $topic');
    client?.publishMessage(topic, MqttQos.exactlyOnce, builder.payload);
  }

  void _1publishMessage(String message, String topic) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    print('Publishing message "$message" to topic $topic');
    client?.publishMessage(topic, MqttQos.exactlyOnce, builder.payload);
  }

  // callbacks for different events
  void _onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic');
    subscriptionState = MqttSubscriptionState.SUBSCRIBED;
  }

  void _onDisconnected() {
    print('OnDisconnected client callback - Client disconnection');
    connectionState = MqttCurrentConnectionState.DISCONNECTED;
  }

  void _onConnected() {
    connectionState = MqttCurrentConnectionState.CONNECTED;
    print('OnConnected client callback - Client connection was sucessful');
  }
}
