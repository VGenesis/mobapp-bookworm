import 'package:bookworm/models/bookModel.dart';
import 'package:bookworm/models/readableBookModel.dart';
import 'package:flutter/material.dart';

class BookPage extends StatefulWidget {
    final BookModel book;
    const BookPage({
        required this.book,
        super.key
    });

    @override State<BookPage> createState() => _BookPageState();
}

enum BookLoadStatus{
    LOAD_IDLE,
    LOAD_STARTED,
    LOAD_COMPLETE,
    LOAD_FAILED
}

class _BookPageState extends State<BookPage> {
    late ReadableBookModel? bookModel;
    var loadStatus = BookLoadStatus.LOAD_IDLE;

    void loadBook() async{
        setState(() {
            loadStatus = BookLoadStatus.LOAD_STARTED;
        });
        print("Started loading");
        bookModel = await ReadableBookModel.fromBookModel(widget.book);
        print("Finished loading");
        setState(() {
            loadStatus = (bookModel != null)
                ? BookLoadStatus.LOAD_COMPLETE
                : BookLoadStatus.LOAD_FAILED;
        });
        print((bookModel != null)
            ? "Load successful"
            : "Failed to load book"
        );
    }

    Widget generateBody(){
        switch(loadStatus){
            case BookLoadStatus.LOAD_IDLE:
                return const Center();
            case BookLoadStatus.LOAD_STARTED:
                return const Center(
                    child: Text(
                        "Loading",
                        style: TextStyle(
                            color: Colors.white
                        )
                    )
                );
            case BookLoadStatus.LOAD_COMPLETE:
                return bookModel!.build();
            case BookLoadStatus.LOAD_FAILED:
                return const Center(
                    child: Text(
                        "Could not load book",
                        style: TextStyle(
                            color: Colors.white
                        )
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
                child: generateBody(),
            ),
        );
    }
}
