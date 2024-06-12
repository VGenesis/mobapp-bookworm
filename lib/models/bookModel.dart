import 'dart:convert';

import 'package:bookworm/pages/bookreader.dart';
import 'package:bookworm/utility/searchAPI.dart';
import 'package:flutter/material.dart';

class BookModel{
  final String bookName;
  final String bookURL;
  final String summary;
  final String authorName;
  final String authorURL;
  final String ebookAccess;
  final String? coverEditionKey;
  final String oclc;
  final String isbn;

  static const double cardWidth = 200;
  static const double cardHeight = 300;

  static const String imgUnavailable = "lib/assets/img-not-found.png";

  bool imgAvailable = true;
  String imgSrc = imgUnavailable;
  Image image = Image.asset(imgUnavailable);
  bool hasImage = false;

  BookModel({
    required this.bookName,
    required this.bookURL,
    required this.summary,
    required this.authorName,
    required this.authorURL,
    required this.ebookAccess,
    required this.oclc,
    required this.isbn,
    this.coverEditionKey
  });

  String getBookUrl(){
    return "openlibrary.org/works/$bookURL";
  }

  static BookModel? fromJSON(Map<String, dynamic> json){
    try{
      var book = BookModel(
        bookName:       json["title"] as String,
        bookURL:        (json.containsKey("key")) ? json["key"] as String : "",
        summary:        (json.containsKey("first_sentence")) ? json["first_sentence"][0] as String : "No summary found",
        authorName:     (json.containsKey("author_name")) ? json["author_name"][0] as String : "Unknown",
        authorURL:      (json.containsKey("author_key")) ? json["author_key"][0] as String : "Unknown",
        ebookAccess:    (json.containsKey("ebook_access")) ? json["ebook_access"] as String : "no_ebook",
        coverEditionKey:(json.containsKey("cover_edition_key")) ? json["cover_edition_key"] : "",
        oclc: json.containsKey("oclc")? ["oclc"][0] : "",
        isbn: json.containsKey("isbn")? ["isbn"][0] : "",
        ); 

      book.fetchCoverImage();
      return book;
    } on Exception {
      return null;
    }
  }

  Map<String, dynamic> toJSON(){
    return {
      "title": bookName,
      "key": bookURL,
      "first_sentence": summary,
      "author_name": authorName,
      "author_key": authorURL,
      "ebook_access": ebookAccess,
      "cover_edition_key": coverEditionKey,
      "oclc": jsonEncode([oclc]),
      "isbn": jsonEncode([isbn])
    };
  }

  void fetchCoverImage() async{
    if(isbn.isEmpty && oclc.isEmpty) return;

    if(imgAvailable) {
      try{
        SearchAPI api = SearchAPI();
        var imageBytes = await api.fetchCover("isbn", isbn);
        if(api.statusCode == 200){
          if(imageBytes.length < 100){
            image = Image.asset(imgUnavailable, fit: BoxFit.contain);
          } else {
            image = Image.memory(imageBytes, fit: BoxFit.contain);
            hasImage = true;
          }
        }
      } on SearchAPIException catch(_){
        return;
      }
    }
  }

  Widget build(BuildContext context){
    ThemeData theme = Theme.of(context);
    return ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookReader(book: this)
            )
          );
        },
        tileColor: theme.colorScheme.primary,
         hoverColor: theme.colorScheme.primary,
        title: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(12)
          ),
          child: Column(
            children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                image,
                Text(
                  bookName,
                  style: theme.textTheme.titleMedium
                  ),
                Text(
                  authorName,
                  style: theme.textTheme.titleSmall
                  ),
                ]
              ),
            )
          ],
        )
      ),
    );
  }
}
