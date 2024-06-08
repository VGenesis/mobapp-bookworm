import 'package:flutter/material.dart';

import 'package:bookworm/utility/colors.dart';
import 'package:bookworm/utility/searchAPI.dart';
import 'package:bookworm/models/bookModel.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
    State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
    {"sort": "popular"},
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
    print(params);
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
    for(int i = 0; i < categories.length; i++){
      List<BookModel> categoryBooks = await fetchBooks(categoryParams[i]);
      if(categoryBooks != []){
        books.update(categories[i].toLowerCase(), (value) => categoryBooks);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadCategories());
  }

  @override 
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        var categoryBooks = books[categories[index].toLowerCase()]!;
        return ListTile(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(12.0)
                ),
                child: Text(
                  categories[index],
                  style: theme.textTheme.titleSmall
                )
              ),
              Row(
                children: [
                   ListView.builder(
                    itemBuilder: (context, index) => const Placeholder()
                //    scrollDirection: Axis.horizontal,
                //    itemCount: categoryBooks.length,
                //    itemBuilder: (context, index) {
                //      var book = categoryBooks[index];
                //      return ListTile(
                //        title: book.build(context)
                //      );
                //    }
                  )
                ],
              )
            ],
          )
        );
      }
    );
  }
}

