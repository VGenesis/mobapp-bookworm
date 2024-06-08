import 'package:flutter/material.dart';

import 'package:bookworm/utility/colors.dart';
import 'package:bookworm/utility/searchAPI.dart';
import 'package:bookworm/models/bookModel.dart';

enum HomepageLoadState{ loading, finished, failed }

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
    State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  HomepageLoadState state = HomepageLoadState.loading;
  bool sortSwitchValue = false;

  ThemeData theme = lightTheme;

  final List<String> categories = [
    "Popular",
    "New",
    "Action",
    "Drama",
    "Sci-fi",
    "Thriller",
    "Horror",
    "Psychology",
    "Science",
  ];

  static const defparams = {"title": "a", "ebook_access": "public", "limit": "5"};
  final List<Map<String, String>> categoryParams = [
    {},
    {"sort": "new"},
    {"subject": "action"},
    {"subject": "drama"},
    {"subject": "science fiction"},
    {"subject": "thriller"},
    {"subject": "horror"},
    {"subject": "psychology"},
    {"subject": "science"},
  ];

  Map<String, List<BookModel>> books = {
    "popular" : [],
    "new" : [],
    "action" : [],
    "drama" : [],
    "sci-fi" : [],
    "thriller" : [],
    "horror" : [],
    "psychology" : [],
    "science" : [],
  };

  Future<List<BookModel>> fetchBooks(Map<String, dynamic> params) async {
    var api = SearchAPI();
    params.addEntries(defparams.entries);
    var responseJson = await api.fetchBook(params);

    try{
      List<BookModel> bookList = [];
      if(mounted) {
        setState(() {
          for(var book in responseJson["docs"]){
            BookModel? model = BookModel.fromJSON(book);
            if(model != null) {
              bookList.add(model);
            }
          }
        });
      }
      return bookList;
    } on SearchAPIException {
      return [];
    }
  }

  void loadCategories() async {
    setState(() {
      state = HomepageLoadState.loading;
        print("Loading");
    });
    try{
      for(int i = 0; i < categories.length; i++){
        List<BookModel> categoryBooks = await fetchBooks(categoryParams[i]);
        // if(categoryBooks != []){
        //   books.update(categories[i].toLowerCase(), (value) => categoryBooks);
        // }
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
        return Center(
          child: Text(
            "Loading...",
            style: theme.textTheme.displaySmall
          )
        );
      case HomepageLoadState.finished:
        return const Placeholder();
      case HomepageLoadState.failed:
        return Center(
          child: Text(
            "Failed to load page.",
            style: theme.textTheme.displaySmall
          )
        );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadCategories());
    // print(books.toString());
  }

  @override 
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return generatePage();
    // return ListView.builder(
    //   itemCount: categories.length,
    //   itemBuilder: (context, index) {
    //     var categoryBooks = books[categories[index].toLowerCase()]!;
    //     // print(categoryBooks.length);
    //     return ListTile(
    //       title: Column(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Container(
    //             width: double.infinity,
    //             padding: const EdgeInsets.all(8.0),
    //             decoration: BoxDecoration(
    //               color: theme.colorScheme.primary,
    //               borderRadius: BorderRadius.circular(12.0)
    //             ),
    //             child: Text(
    //               categories[index],
    //               style: theme.textTheme.titleSmall
    //             )
    //           ),

    //           Row(
    //             children: [
    //               Expanded(
    //                 child: SizedBox(
    //                   height: 200,
    //                   child: ListView.builder(
    //                     scrollDirection: Axis.horizontal,
    //                     itemCount: categoryBooks.length,
    //                     itemBuilder: (context, index) {
    //                       var book = categoryBooks[index];
    //                       return book.build(context);
    //                     }
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           )
    //         ],
    //       )
    //     );
    //   }
    // );
  }
}

