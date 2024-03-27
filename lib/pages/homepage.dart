import 'package:flutter/material.dart';

import 'package:bookworm/utility/searchAPI.dart';
import 'package:bookworm/models/bookModel.dart';

class Homepage extends StatefulWidget {
    const Homepage({super.key});

    @override
        State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
    Sorting sort = Sorting.SORT_POPULAR;
    bool sortSwitchValue = false;

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

    static const defparams = {"title": "a", "ebook_access": "public", "limit": "10"};
    final List<dynamic> categoryParams = [
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

    final List<List<BookModel>> books = [];

    Future<void> fetchBooks(Map<String, dynamic> params, List<BookModel> list) async {
        var api = SearchAPI();
        api.addParams(defparams);
        api.addParams(params);
        var responseJson = await api.fetchBook({"title": "a"});

        try{
            if(mounted) {
                setState(() {
                    for(var book in responseJson["docs"]){
                        BookModel? model = BookModel.fromJSON(book);
                        if(model != null) {
                            list.add(model);
                        }
                    }
                });
            }
        } on SearchAPIException catch(e){
            print(e.message);
        }
    }

    Widget buildCategory(BuildContext context, String category){
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.white10
                ),
                child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text(
                                category,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold
                                ),
                            ),
                        ],
                    ),
                ),
            ),
        );  
    }

    @override void initState() {
        super.initState();
        for(int i = 0; i < categories.length; i++){
            fetchBooks(categoryParams[i], books[i]);
        }
    }

    @override Widget build(BuildContext context) {
        return const Center(
            child: Text("Hello")
        );
    }
}

