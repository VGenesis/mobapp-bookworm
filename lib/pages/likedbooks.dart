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

    await file.writeAsString("hello");
  }

  static Future<String> loadBooks() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/likedBooks.json');
    
    try{
      var json = await file.readAsString();
      return json;
    } on IOException {
      return "";
    }
  }
}

