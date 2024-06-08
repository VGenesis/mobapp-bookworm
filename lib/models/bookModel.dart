import 'package:bookworm/pages/bookpage.dart';
import 'package:bookworm/utility/searchAPI.dart';
import 'package:flutter/material.dart';

class BookModel{
  final String bookName;
  final String bookURL;
  final String authorName;
  final String authorURL;
  final String ebookAccess;
  final int publishYear;
  final String? coverEditionKey;

  static const double cardWidth = 200;
  static const double cardHeight = 300;

  String oclc = "", isbn = "";
  static const String imgUnavailable = "lib/assets/img-not-found.jpg";

  bool imgAvailable = true;
  String imgSrc = imgUnavailable;
  Image image = Image.asset(imgUnavailable);

  BookModel({
      required this.bookName,
      required this.bookURL,
      required this.authorName,
      required this.authorURL,
      required this.ebookAccess,
      required this.publishYear,
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
        authorName:     (json.containsKey("author_name")) ? json["author_name"][0] as String : "Unknown",
        authorURL:      (json.containsKey("author_key")) ? json["author_key"][0] as String : "Unknown",
        ebookAccess:    (json.containsKey("ebook_access")) ? json["ebook_access"] as String : "no_ebook",
        publishYear:    (json.containsKey("first_publish_key")) ? json["first_publish_year"] as int : 1900,
        coverEditionKey:(json.containsKey("cover_edition_key")) ? json["cover_edition_key"] : "",
        ); 
      book.oclc = (json["oclc"] != null) ? json["oclc"][0] : "";
      book.isbn = (json["isbn"] != null) ? json["isbn"][0] : "";
      book.fetchCoverImage("L");
      return book;
    } on Exception {
      return null;
    }
  }

  void fetchCoverImage(String size) async{
    if(isbn.isEmpty && oclc.isEmpty) return;

    if(imgAvailable) {
      try{
        SearchAPI api = SearchAPI();
        var imageBytes = await api.fetchCover("isbn", isbn);
        if(api.statusCode == 200){
          image = (imageBytes.length < 100)
            ? Image.asset(
                imgUnavailable,
                fit: BoxFit.contain
                ) : Image.memory(
                  imageBytes,
                  fit: BoxFit.contain
                  );
        }else {
          image = Image.asset(
              imgUnavailable,
              fit: BoxFit.contain
              );
        }
      } on SearchAPIException catch(_){
        image = Image.asset(imgUnavailable);
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
              builder: (context) => BookPage(book: this)
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
