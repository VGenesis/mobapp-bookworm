import 'package:flutter/material.dart';

import 'package:bookworm/utility/searchAPI.dart';
import 'package:bookworm/models/bookModel.dart';

class Homepage extends StatefulWidget {
    const Homepage({super.key});

    @override
        State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
    final Map<String, dynamic> params = {
        "q": "a",
        "limit": "10"
    };


    Sorting sort = Sorting.SORT_POPULAR;
    bool sortSwitchValue = false;

    List<BookModel> books = [];

    Future<void> fetchNewBooks() async {
        var api = SearchAPI();
        api.addParams(params);
        var responseJson = await api.fetchJSON({"title": "a"});

        try{
            if(mounted) {
              setState(() {
                    for(var book in responseJson["docs"]){
                    BookModel? model = BookModel.fromJSON(book);
                    if(model != null) {
                    books.add(model);
                    }
                    }
                    });
            }
        } on Exception {
            print("Fetch disposed");
        }
    }

    @override void initState(){
        super.initState();
        fetchNewBooks();
    }

    @override Widget build(BuildContext context) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
                Expanded(
                    child: ListView.builder(
                        itemCount: books.length,
                        itemBuilder: (context, index) => books[index].buildList() 
                    ),
                )
            ]
        );
    }
}

