import 'dart:core';
import 'dart:convert';
import 'package:http/http.dart' as http;

List<String> sortingTypes = ["", "new"];
enum Sorting{
    SORT_POPULAR(0, ""),
    SORT_NEW(1, "new");

    final int id;
    final String type;

    const Sorting(this.id, this.type);

    int get toInt => id;
}

class SearchAPIException implements Exception{
    final String message;
    final int statusCode;

    SearchAPIException({
        required this.message,
        required this.statusCode
    });
}

class SearchAPI{
    final String domain = "openlibrary.org";
    final String query = "search.json";
    Map<String, dynamic> defparams = {
        "limit": "10",
        "sort": ""
    };

    int statusCode = 200;
    SearchAPI();

    void addParams(Map<String, dynamic> params){
        params.addAll(params);
    }

    void setSorting(Sorting sort){
        if(sort.type != "") defparams.addAll({"sort": sort.type});
    }

    Future<String> fetch(Map<String, dynamic> params) async{
        print("Here");
        params.addAll(defparams);
        print(params);
        Uri uri = Uri.https(domain, query, params);
        print(uri);
        var response = await http.get(uri);

        statusCode = response.statusCode;
        return response.body;
    }

    Future<Map<String, dynamic>> fetchJSON(Map<String, dynamic> params) async{
        try{
            var response = await fetch(params);
            return json.decode(response);
        } catch(e){
            throw SearchAPIException(message: "Failed to fetch data", statusCode: statusCode);
        }
    }
}
