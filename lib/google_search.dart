import 'package:http/http.dart' as http;
import 'package:beautifulsoup/beautifulsoup.dart';
import 'package:reddit_google_search/Globals.dart';
import 'package:reddit_google_search/Result.dart';

class GoogleSearch{

  List<Result> _parseResults(http.Response response){
    Beautifulsoup soup = Beautifulsoup(response.body);
    var entries = soup.find_all("div").map((e) => e.getElementsByClassName("kCrYT")).toList();
    for (var entry in entries) {
      try{
        if(entry.length == 2){
          for(int i = 0; i < entry.length;i++){
            String title = entry[i].getElementsByTagName("a")[0].getElementsByClassName("BNeawe vvjwJb AP7Wnd")[0].innerHtml;
            String url = entry[i].getElementsByTagName("a")[0].attributes["href"].replaceFirst("/url?q=", "");

            if(Globals.results.length != 0){
              if(title != Globals.results[Globals.results.length - 1].title){
                //Replace the last part of the string so that reddit will not point to a specific comment that may or may not exist
                if(url.contains("&sa"))
                  url = url.substring(0,url.indexOf("&sa"));
                Globals.results.add(new Result(title,url));
              }
            }else{
              Globals.results.add(new Result(title,url));
            }
          }
        }
        else{
          continue;
        }
      }catch (e){

      }
    
    }
    /*
    for (var result in Globals.results) {
      print(result.title);
      print(result.url);
      print("-------------------------------");
    }*/
  return Globals.results;
}

  Future<List<Result>> search(String term) async {
    final response =
        await http.get('https://www.google.com/search?q=reddit%3A'+term);
    if (response.statusCode == 200) {
      //Get the first page
      _parseResults(response);

    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }

    final response2 = await http.get('https://www.google.com/search?q=reddit%3A'+term+"&start=10");
    if (response2.statusCode == 200) {
      //Get the first page
      _parseResults(response2);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }

    Globals.loading = false;
    return Globals.results;
  }
}