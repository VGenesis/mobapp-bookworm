import 'dart:html';

import 'package:bookworm/models/bookModel.dart';
import 'package:bookworm/utility/searchAPI.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
    const SearchPage({super.key});

    @override State<SearchPage> createState() => _SearchPageState();
}

enum QueryState{
    QUERY_INACTIVE,
    QUERY_INCOMPLETE,
    QUERY_COMPLETE,
    QUERY_FAILED,
    QUERY_NO_DATA
}

class _SearchPageState extends State<SearchPage> {
    final Map<String, dynamic> params = {
        "title": "a"
    };

    QueryState queryState = QueryState.QUERY_INACTIVE;
    List<BookModel> bookList = [];

    bool switchTitle = true, switchAuthor = false, switchGenre = false;
    String selectedParameter = "title";
    final TextEditingController _controller = TextEditingController();

    void onFormSubmit(String param) async{
        if(param.isEmpty) {
            setState(() { queryState = QueryState.QUERY_INACTIVE; });
            return;
        }

        setState(() { queryState = QueryState.QUERY_INCOMPLETE; });
        Map<String, dynamic> params = {selectedParameter: param};

        try{
            var api = SearchAPI();
            var books = await api.fetchJSON(params);
            if(books.isEmpty){
                setState(() { queryState = QueryState.QUERY_INCOMPLETE; });
            } else {
                for(var book in books["docs"]){
                    setState(() {
                        BookModel? model = BookModel.fromJSON(book);
                        if(model != null) {
                            bookList.add(model);
                        }
                    });
                }
                setState(() { queryState = QueryState.QUERY_COMPLETE; });
            }
        } on SearchAPIException{
            print("Error");
            setState(() { queryState = QueryState.QUERY_NO_DATA; });
        }
    }

    Widget generateResults(){
        switch(queryState){
            case QueryState.QUERY_INACTIVE:
                print("Inactive");
                return const Center();
            case QueryState.QUERY_INCOMPLETE:
                print("Incomplete");
                return const Expanded(
                    child: Center(
                        child: Text(
                            "Searching",
                            style: TextStyle(fontSize: 16),
                        ),
                    ),
                );
            case QueryState.QUERY_COMPLETE:
                print("Complete. Book count: ${bookList.length}");
                return Expanded(
                    child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                        itemCount: bookList.length,
                        itemBuilder: (context, index) => bookList[index].buildGrid()
                    ),
                );
            case QueryState.QUERY_FAILED:
                print("Failed");
                return const Center(
                        child: Text(
                            "There has been a problem with the server. Please try again later.",
                            style: TextStyle(
                                fontSize: 14
                                ),
                            )
                        );
            case QueryState.QUERY_NO_DATA:
                print("No data");
                return const Center();
        }
    }

    void onSwitchTitle(bool value){
        setState(() {
                switchTitle = true;
                switchAuthor = false;
                switchGenre = false;
                selectedParameter = "title";
                });
    }

    void onSwitchAuthor(bool value){
        setState(() {
                switchTitle = false;
                switchAuthor = true;
                switchGenre = false;
                selectedParameter = "author_name";
                });
    }

    void onSwitchGenre(bool value){
        setState(() {
                switchTitle = false;
                switchAuthor = false;
                switchGenre = true;
                selectedParameter = "subject";
                });
    }

    @override Widget build(BuildContext context) {
        return Column(
                children: [
                Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                        controller: _controller,
                        onSubmitted: onFormSubmit,
                        ),
                    ),
                Row(
                    children: [
                        Container(
                            height: 40,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                    children: [
                                    const Text(
                                        "title",
                                        style: TextStyle(
                                            fontSize: 12,
                                            ),
                                        ),
                                    Switch.adaptive(
                                        value: switchTitle,
                                        onChanged: onSwitchTitle
                                        ),
                                    ],
                                ),
                            ),
                        ),
                        Container(
                            height: 40,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                    children: [
                                    const Text(
                                        "title",
                                        style: TextStyle(
                                            fontSize: 12,
                                            ),
                                        ),
                                    Switch.adaptive(
                                        value: switchAuthor,
                                        onChanged: onSwitchAuthor
                                        ),
                                    ],
                                ),
                            ),
                        ),
                        Container(
                            height: 40,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                    children: [
                                    const Text(
                                        "title",
                                        style: TextStyle(
                                            fontSize: 12,
                                            ),
                                        ),
                                    Switch.adaptive(
                                        value: switchGenre,
                                        onChanged: onSwitchGenre
                                        ),
                                    ],
                                ),
                            ),
                        )
                    ],
                ),
                Container(
                    child: generateResults()
                ),
            ],
        );
    }
}
