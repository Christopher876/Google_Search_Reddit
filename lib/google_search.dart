import 'package:http/http.dart' as http;
import 'package:beautifulsoup/beautifulsoup.dart';
import 'package:reddit_google_search/Result.dart';

List<Result> _parseResults(http.Response response){
  List<Result> results; 
  Beautifulsoup soup = Beautifulsoup(response.body);
  var entries = soup.find_all("div").map((e) => e.getElementsByClassName("kCrYT")).toList();
  print("Entries=" + entries.length.toString());
  for (var entry in entries) {
    try{
      if(entry.length == 2){
        print("Entry number = " + entry.length.toString());
        for(int i = 0; i < entry.length;i++){
          //title = entry.a.find("div",{"class":"BNeawe vvjwJb AP7Wnd"}).get_text()

          print(entry[i].getElementsByTagName("a")[0].getElementsByClassName("BNeawe vvjwJb AP7Wnd")[0].innerHtml);
          print(entry[i].getElementsByTagName("a")[0].attributes["href"].replaceFirst("/url?q=", ""));
        }
        print("----------------------------");
      }
      else{
        continue;
      }
    }catch (e){

    }
    
  }
}

Future<http.Response> search() async {
  final response =
      await http.get('https://www.google.com/search?q=reddit%3Apixel+4');
  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON.
    _parseResults(response);

  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}

Future<void> testSearch() async{
  var test = await search();
  print(test.body);
}