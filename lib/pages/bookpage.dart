import 'package:bookworm/pages/bookreader.dart';
import 'package:bookworm/pages/likedbooks.dart';
import 'package:bookworm/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../models/bookModel.dart';

class BookPage extends StatefulWidget {
  final BookModel book;
  const BookPage ({
    super.key,
    required this.book
  });

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  ThemeData theme = lightTheme;

  bool liked = false;

  void initState(){
    super.initState();
    liked = LikedBooks.contains(widget.book);
  }

  void toggleLiked(){
    setState(() {
      liked = !liked;
      if(liked == true) {
        LikedBooks.addBook(widget.book);
      } else {
        LikedBooks.removeBook(widget.book);
      }
      print(LikedBooks.likedBooks.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Container(
        color: theme.colorScheme.onPrimary,
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0)
                  ),
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: widget.book.image
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.book.bookName,
                                    style: theme.textTheme.titleMedium
                                  ),
                                  Text(
                                    "by ${widget.book.authorName}",
                                    style: theme.textTheme.titleSmall
                                  )
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => BookReader(book: widget.book)
                                    )
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.onPrimary,
                                    borderRadius: BorderRadius.circular(12.0)
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.play_arrow,
                                        color: theme.colorScheme.primary,
                                      ),
                                      Text(
                                        "Read",
                                        style: TextStyle(
                                          fontSize: theme.textTheme.displaySmall!.fontSize,
                                          color: theme.colorScheme.primary
                                        )
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ),
              Container(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 12),
                        Icon(
                          Icons.circle,
                          size: 10,
                          color: theme.colorScheme.primary,
                        ),
                        Text(
                          " SUMMARY",
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(8.0)
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(6.0)
                        ),
                        child: Text(
                          widget.book.summary,
                          style: theme.textTheme.displaySmall
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: toggleLiked,
        child: Icon((liked) 
          ? Icons.favorite
          : Icons.favorite_outline
        )
      ),
    );
  }
}
