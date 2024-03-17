import 'package:flutter/material.dart';

class BookModel{
    final String bookName;
    final String bookURL;
    final String authorName;
    final String authorURL;
    final String ebookAccess;
    final int publishYear;
    //final double rating;

    BookModel({
        required this.bookName,
        required this.bookURL,
        required this.authorName,
        required this.authorURL,
        required this.ebookAccess,
        required this.publishYear,
        //required this.rating
    });

    static BookModel? fromJSON(json){
        try{
            return BookModel(
                    bookName:       json["title"] as String,
                    bookURL:        json["key"] as String,
                    authorName:     json["author_name"][0] as String,
                    authorURL:      json["author_key"][0] as String,
                    ebookAccess:    json["ebook_access"] as String,
                    publishYear:    (json["first_publish_year"] != null)
                                        ? json["first_publish_year"] as int
                                        : 1900
                    ); 
        } on Exception {
            return null;
        }
    }

    Widget buildList(){
        return ListTile(
            title: Text(bookName),
            subtitle: Text(authorName),
        );
    }

    Widget buildGrid(){
        return GridTile(
            child: Container(
              child: Column(
                  children:[
                      Text(bookName),
                      Text(authorName),
                  ]
              ),
            )
        );
    }
}
