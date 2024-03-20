import 'package:flutter/material.dart';

class BookModel{
    final String bookName;
    final String bookURL;
    final String authorName;
    final String authorURL;
    final String ebookAccess;
    final int publishYear;
    //final double rating;

    static const String imgUnavailable = "lib/assets/img-not-found.jpg";
    static const double cardWidth = 300;
    static const double cardHeight = 400;

    BookModel({
        required this.bookName,
        required this.bookURL,
        required this.authorName,
        required this.authorURL,
        required this.ebookAccess,
        required this.publishYear,
        //required this.rating
    });

    String getBookUrl(){
        return "openlibrary.org/works/$bookURL";
    }

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
        return Card(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Stack(
                        children: <Widget>[
                            Image.asset(imgUnavailable),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                        bookName,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color:  Colors.white.computeLuminance() > 0.5 
                                                    ? Colors.black : Colors.white,
                                        )
                                    ),
                                    Text(
                                        authorName,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color:  Colors.white.computeLuminance() > 0.5 
                                                    ? Colors.black : Colors.white,
                                        )
                                    ),
                                ],
                            )
                        ],
                    ),
                ),
            )
        );
    }
}
