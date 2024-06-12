import 'dart:convert';
import 'dart:io';

import 'package:bookworm/models/bookModel.dart';
import 'package:path_provider/path_provider.dart';

class LikedBooks{
  static List<BookModel> likedBooks = [];

  static void addBook(BookModel model){
    likedBooks.add(model);
  }

  static bool contains(BookModel model){
    return likedBooks.contains(model);
  }

  static int count(){
    return likedBooks.length;
  }

  static BookModel get(int index){
    return likedBooks[index];
  }

  static void removeBook(BookModel model){
    likedBooks.remove(model);
  }

  static Future<void> saveBooks() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/likedBooks.json');

    if(!await file.exists()){
      await file.create();
    }

    try{
      List<Map<String, dynamic>> bookList = [];
      for(BookModel bookModel in likedBooks){
        bookList.add(bookModel.toJSON());
      }
      String json = jsonEncode(bookList);
      await file.writeAsString(json);
      print("Saved $json");
    } on Exception catch(e) {
      print(e);
    }
  }

  static Future<void> loadBooks() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/likedBooks.json');
    
    try{
      String json = await file.readAsString();
      print("Loaded $json");
      final List<dynamic> books = jsonDecode(json);
      for(Map<String, dynamic> book in books){
        BookModel? bookModel = BookModel.fromJSON(book);
        if(bookModel != null){
          likedBooks.add(bookModel);
        }
      }
    } on IOException {
      return;
    }
  }
}

