import 'dart:math';

import 'package:flutter/material.dart';
import 'package:reddit_google_search/Globals.dart';
import 'package:reddit_google_search/Result.dart';
import 'package:reddit_google_search/ThemeSwitcher.dart';
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
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Result> results = new List();
  GoogleSearch googleSearch = new GoogleSearch();
  ThemeSwitcher themeSwitcher = new ThemeSwitcher();
  CustomColors customColors = new CustomColors(); 

  final searchTermController = TextEditingController();

  @override
  // Clean up the controller when the widget is disposed.
  void dispose() {
    searchTermController.dispose();
    super.dispose();
  }

  //Launch the reddit post attached to the result that was returned
  _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
  
  //Get called user searches for a term and returns the results to the listview
  void _handleRequest() async{
    results = await googleSearch.search(searchTermController.text);     
    setState(() { 
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
                color: themeSwitcher.cardTheme,
                child:ListTile(
                  title:Text(results[index].title),
                  onTap: () => _launchURL(results[index].url),
                )
              );
            })
          )]
        ),
        backgroundColor: themeSwitcher.backgroundTheme,
        drawer: Drawer(
          child: 
            ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text("Placeholder Text"),
                  decoration: BoxDecoration(
                    color: themeSwitcher.drawerHeaderTheme),
                ),
                ListTile(
                  title: Text("Settings"),
                  onTap: (){
                    Navigator.pop(context);
                  },
                )
              ],
            ),
        ),
    );
  }
}
