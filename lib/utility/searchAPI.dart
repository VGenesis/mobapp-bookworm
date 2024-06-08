import 'dart:core';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

List<String> sortingTypes = ["", "new"];

class SearchAPIException implements Exception{
  final String message;
  final int statusCode;

  SearchAPIException({
    required this.message,
    required this.statusCode
  });
}

class SearchAPI{
  static const String domain = "openlibrary.org";
  static const String coverDomain = "covers.openlibrary.org";
  static const String archiveDomain = "archive.org/details";

  static const String searchQuery = "search.json";
  static const String bookQuery = "book";

  String generateReaderSuffix(String mode, String view){
    return "mode/$mode?/ref=ol&view=$view";
  }

  Map<String, dynamic> defparams = {
    "limit": "10",
    "sort": ""
  };

  int statusCode = 200;
  SearchAPI();


  Future<String> fetch(String query, Map<String, dynamic> params) async{
    Uri uri = Uri.https(domain, query, params);
    print(uri);
    var response = await http.get(uri);

    statusCode = response.statusCode;
    return response.body;
  }

  Future<Map<String, dynamic>> fetchBook(Map<String, dynamic> queryParams) async{
    try{
      var params = defparams;
      params.addAll(queryParams);
      var response = await fetch(searchQuery, params);
      return json.decode(response);
    } catch(e) {
      throw SearchAPIException(
        message: "Failed to fetch data",
        statusCode: statusCode
      );
    }
  }

  Future<Uint8List> fetchCover(String type, String id) async{
    try{
      String query = "b/$type/$id-L.jpg";
      Uri uri = Uri.https(coverDomain, query);

      var response = await http.get(uri);
      statusCode = response.statusCode;
      return response.bodyBytes;
    } on Exception catch(_) {
      throw SearchAPIException(message: "Failed to fetch cover", statusCode: statusCode);
    }
  }

  Future<Map<String, dynamic>> fetchReaderData(String editionKey) async{
    try{
      String query = "book/$editionKey.json";
      var response = await fetch(query, {});
      return json.decode(response);
    } catch(e) {
      throw SearchAPIException(
        message: "Failed to fetch reader data",
        statusCode: statusCode
      );
    }
  }
}

