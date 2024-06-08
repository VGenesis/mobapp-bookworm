import 'package:bookworm/models/bookModel.dart';
import 'package:bookworm/models/readableBookModel.dart';
import 'package:bookworm/utility/colors.dart';
import 'package:flutter/material.dart';

class BookPage extends StatefulWidget {
  final BookModel book;
  const BookPage({
      required this.book,
      super.key
      });

  @override State<BookPage> createState() => _BookPageState();
}

enum BookLoadStatus{ idle, started, finished, failed }

class _BookPageState extends State<BookPage> {
  late ReadableBookModel? bookModel;
  var loadStatus = BookLoadStatus.idle;

  int pageCount = 0;
  int currentPage = 0;

  Size screenSize = const Size(0, 0);
  ThemeData theme = lightTheme;

  void loadBook() async{
    setState(() {
      loadStatus = BookLoadStatus.started;
    });

    bookModel = await ReadableBookModel.fromBookModel(widget.book);

    setState(() {
      loadStatus = (bookModel != null)
      ? BookLoadStatus.finished
      : BookLoadStatus.failed;
    });
  }

  Widget generateBody(BuildContext context){
    switch(loadStatus){
      case BookLoadStatus.idle:
        return const Center();
      case BookLoadStatus.started:
        return Center(
            child: Text(
              "Loading...",
              style: theme.textTheme.titleSmall
              )
            );
      case BookLoadStatus.finished:
        return bookModel!.build();
      case BookLoadStatus.failed:
        return Center(
            child: Text(
              "Could not load book.",
              style: theme.textTheme.titleSmall
              )
            );
    }
  }

  @override void initState(){
    super.initState();
    loadBook();
  }

  @override Widget build(BuildContext context) {
    BookModel book = widget.book;
    return Scaffold(
        appBar: AppBar(
          title: Text(book.bookName),
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: Colors.black87
          ),

        body: Container(
          color: Colors.black,
          child: generateBody(context),
        ),

        );
  }
}
