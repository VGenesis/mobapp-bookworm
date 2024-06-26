import 'dart:isolate';

import 'package:bookworm/models/bookModel.dart';
import 'package:bookworm/pages/bookpage.dart';
import 'package:bookworm/utility/colors.dart';
import 'package:bookworm/utility/searchAPI.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum HomepageLoadState{ loading, finished, failed }

class LoadArgs {
  final SendPort sendPort;
  final Map<String, String> params;

  LoadArgs({
    required this.sendPort,
    required this.params
  });
}

void fetchBooks(LoadArgs args) async {
  SendPort sendPort = args.sendPort;
  var params = args.params;
  try{
    var api = SearchAPI();
    var responseJson = await api.fetchBook(params);
    sendPort.send(responseJson["docs"]);
  } on SearchAPIException {
    sendPort.send([]);
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
    State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  HomepageLoadState state = HomepageLoadState.loading;
  bool sortSwitchValue = false;

  final List<String> categories = [
    "Popular",
    "New",
    "Action",
    "Drama",
    "Sci-fi",
    "Thriller",
    "Romance",
    "Horror",
    "Psychology",
  ];

  static const defparams = {"q": "0", "ebook_access": "public", "limit": "10"};
  final List<Map<String, String>> categoryParams = [
    {},
    {"sort": "new"},
    {"subject": "action"},
    {"subject": "drama"},
    {"subject": "science fiction"},
    {"subject": "thriller"},
    {"subject": "romance"},
    {"subject": "horror"},
    {"subject": "psychology"},
  ];

  static Map<String, List<BookModel>> books = {
    "popular" : [],
    "new" : [],
    "action" : [],
    "drama" : [],
    "sci-fi" : [],
    "thriller" : [],
    "romance" : [],
    "horror" : [],
    "psychology" : [],
    "science" : [],
  };

  void loadCategory(int i) async{
    final receivePort = ReceivePort();
    Map<String, String> params = {};
    params.addEntries(defparams.entries);
    params.addEntries(categoryParams[i].entries);
    final LoadArgs args = LoadArgs(
      sendPort : receivePort.sendPort,
      params: params
    );
    final iso = await Isolate.spawn(fetchBooks, args);
    receivePort.listen((message) {
      for(var data in message){
        BookModel? book = BookModel.fromJSON(data);
        if(book != null) {
          if(mounted){
            setState((){
              books[categories[i].toLowerCase()]!.add(book);
            });
          }
        }
      }
      receivePort.close();
      iso.kill();
    });
  }

  void loadCategories() async {
    setState(() {
      state = HomepageLoadState.loading;
        print("Loading");
    });
    try{
      for(int i = 0; i < categories.length; i++){
        if(books[categories[i].toLowerCase()]!.isEmpty){
          loadCategory(i);
        }
      }
    } on SearchAPIException {
      setState(() {
        state = HomepageLoadState.failed;
        print("Failed");
      });
      return;
    }
    setState(() {
      state = HomepageLoadState.finished;
        print("Done");
    });
  }

  Widget generatePage(){
    switch(state){
      case HomepageLoadState.loading:
        return Consumer<PageTheme>(
          builder: (context, currentTheme, child) => Center(
            child: Text(
              "Loading...",
              style: currentTheme.theme.textTheme.displaySmall
            )
          ),
        );
      case HomepageLoadState.finished:
        return ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            var categoryBooks = books[categories[index].toLowerCase()]!;
            return Consumer<PageTheme>(
              builder: (context, currentTheme, child) => ListTile(
                title: Container(
                  decoration: BoxDecoration(
                    color: currentTheme.theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12.0)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: currentTheme.theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(12.0)
                        ),
                        child: Text(
                          categories[index],
                          style: currentTheme.theme.textTheme.titleSmall
                        )
                      ),
                  
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categoryBooks.length,
                                  itemBuilder: (context, index) {
                                    BookModel book = categoryBooks[index];
                                    return GestureDetector(
                                      onTapUp: (details){
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: 
                                            (context) => BookPage(book: book)
                                          )
                                        );
                                      },
                                      child: Container(
                                        height: 200,
                                        constraints: const BoxConstraints(maxWidth: 150),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(12.0),
                                            child: (book.hasImage)
                                              ? book.image
                                              : Stack(
                                                alignment: Alignment.center,
                                                  children: [
                                                    book.image,
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Text(
                                                            book.authorName,
                                                            maxLines: 2,
                                                            textAlign: TextAlign.center,
                                                            style: currentTheme.theme.textTheme.displaySmall,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Text(
                                                            book.bookName,
                                                            maxLines: 2,
                                                            textAlign: TextAlign.center,
                                                            style: currentTheme.theme.textTheme.displaySmall,
                                                          ),
                                                        )
                                                      ]
                                                    )
                                                  ],
                                                ),
                                          )
                                          ),
                                      ),
                                    );
                                  }
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ),
            );
          }
        );
      case HomepageLoadState.failed:
        return Center(
          child: Consumer<PageTheme>(
            builder: (context, currentTheme, child) => Text(
              "Failed to load page.",
              style: currentTheme.theme.textTheme.displaySmall
            ),
          )
        );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadCategories());
  }

  @override 
  Widget build(BuildContext context) {
    return generatePage();
  }
}

