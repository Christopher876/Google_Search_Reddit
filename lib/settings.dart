import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reddit_google_search/Globals.dart';

class Settings extends StatefulWidget{
  SettingsPage createState()=>SettingsPage();
}
class SettingsPage extends State<Settings>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body:
        Column(
          children: <Widget>[
            Text("Search Engine:",
            style: TextStyle(fontSize: 16,),
            ),
            new Row(
              children:<Widget>[
                new Radio(
                value: SearchEngine.ddg,
                groupValue: Globals.searchEngine,
                onChanged: (SearchEngine value){
                   setState(() { Globals.searchEngine = value; });
                },
              ),
                Text("DuckDuckGo")
              ]
            ),
            new Row(
              children:<Widget>[
                new Radio(
                value: SearchEngine.google,
                groupValue: Globals.searchEngine,
                onChanged: (SearchEngine value){
                   setState(() { Globals.searchEngine = value; });
                },
              ),
                Text("Google")
              ]
            ),
          ],
        )
        
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }
  
}