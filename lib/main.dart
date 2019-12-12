import 'package:flutter/material.dart';
import 'package:reddit_google_search/Globals.dart';
import 'package:reddit_google_search/Result.dart';
import 'package:reddit_google_search/ThemeSwitcher.dart';
import 'package:reddit_google_search/duckduckgo_search.dart';
import 'package:reddit_google_search/settings.dart';
import 'google_search.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
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
  DDGSearch duckduckgoSearch = new DDGSearch();
  ThemeSwitcher themeSwitcher = new ThemeSwitcher();
  CustomColors customColors = new CustomColors(); 

  TextEditingController _searchTermController;
  ScrollController _listViewController;

  bool _test = false;

  @override
  void initState(){
    _searchTermController = TextEditingController();
    _listViewController = ScrollController();
    super.initState();
  }

  @override
  // Clean up the controller when the widget is disposed.
  void dispose() {
    _searchTermController.dispose();
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

  //Listen for the scroll events on the ListView list
  void _scrollListener() async{
    switch(Globals.searchEngine){
      case SearchEngine.google:
        // TODO: Handle this case.
        break;
      case SearchEngine.ddg:
        //If the user has scrolled about 75% of the list's length then load the next set of results
        if(_listViewController.offset > _listViewController.position.maxScrollExtent * 0.75 && !_test){
          _test = true;
          results.addAll(await duckduckgoSearch.searchNextPage());
          setState((){});
          _test = false;
          print("Added more posts!");
        }
        break;
    }
  }
  
  //Get called user searches for a term and returns the results to the listview
  void _handleRequest() async{
    Globals.loading = true;
    results.clear();
    switch(Globals.searchEngine){
      case SearchEngine.google:
        results = await googleSearch.search(_searchTermController.text); 
        break;
      case SearchEngine.ddg:
        results = await duckduckgoSearch.search(_searchTermController.text);
        break;
    }
    setState(() { });
    _listViewController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),

      ),
      body:
        Column(children: <Widget>[ 
              TextField(
                controller: _searchTermController,
                textAlignVertical: TextAlignVertical.bottom,
                onSubmitted: (done) => _handleRequest(),
                decoration: new InputDecoration.collapsed(
                  hintText: "Search"
                ),
                style: new TextStyle(
                  fontSize: 20.0,
                  height: 2.0,

                ),
                textAlign: TextAlign.center,
              ),
            Expanded(
              child:
                new ModalProgressHUD(
                  child:ListView.builder(
                    controller: _listViewController,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: results.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        //color: themeSwitcher.cardTheme,
                        child:ListTile(
                          title:Text(results[index].title),
                          onTap: () => _launchURL(results[index].url),
                        )
                      );
                    }),
                  inAsyncCall: Globals.loading,
                  color: ThemeSwitcher.hexToColor("#303030"),
              )
              ),
            ]
          ),         
        
        //backgroundColor: themeSwitcher.backgroundTheme,
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Settings(),));
                  },
                )
              ],
            ),
        ),
    );
  }
}
