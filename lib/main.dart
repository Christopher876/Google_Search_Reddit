import 'dart:math';

import 'package:flutter/material.dart';
import 'package:reddit_google_search/Globals.dart';
import 'package:reddit_google_search/Result.dart';
import 'google_search.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Google Reddit Search'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  var random = Random.secure();
  String sample = "";
  List<Result> results = new List(); 

  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

  final searchTermController = TextEditingController();

  void _setSample(){
    setState(() {
      sample = "Congrats the number is now below 0!";
    });
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter+=random.nextInt(100);
      if(_counter >= 200){
        _counter = -20;
        _setSample();
      }
      else
        sample = ""; 
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    searchTermController.dispose();
    super.dispose();
  }

  _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

  void _handleRequest() async{
    results = await search(searchTermController.text);     
    setState(() {
      print("WORK!");
      print(results[0].title); 
    });
  }

  void _updatePlease(int index){
    setState(() {
      entries.insert(index, 'Planet');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:
        Column(children: <Widget>[ 
          Row(children: <Widget>[
            new Container(
              width:340,
              height:30,
              child:
                TextField(
                  controller: searchTermController,
                  textAlignVertical: TextAlignVertical.bottom,
                ),
            ),
            FlatButton(
              child: Text("Go"),
              onPressed: () => _handleRequest(),
            ), 
            ],),

          new Expanded(child:ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: results.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child:ListTile(
                  title:Text(results[index].title),
                  onTap: () => _launchURL(results[index].url),
                )
              );
            })
          )]
        )
    );
  }
}
