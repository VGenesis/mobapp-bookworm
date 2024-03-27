import 'package:bookworm/models/bookModel.dart';
import 'package:bookworm/utility/colors.dart';
import 'package:bookworm/utility/searchAPI.dart';
import 'package:flutter/material.dart';

enum QueryState{
    QUERY_INACTIVE,
    QUERY_INCOMPLETE,
    QUERY_COMPLETE,
    QUERY_FAILED,
    QUERY_NO_DATA
}

class SearchPage extends StatefulWidget {
    const SearchPage({super.key});

    @override State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
    final Map<String, dynamic> params = {
        "title": "a"
    };


    QueryState queryState = QueryState.QUERY_INACTIVE;
    List<BookModel> bookList = [];

    List<bool> switches = [true, false, false];

    int selectedParameter = 0;
    final List<String> parameters = [
        "title", "author", "subject"
    ];

    final ScrollController _scrollController = ScrollController(
        onAttach: (position) => {
            print("scrolling")
        }
    );
    final TextEditingController _controller = TextEditingController();

    @override Widget build(BuildContext context) {
        String searchText = "Search ${parameters[selectedParameter]}s";
        return Column(
            children: [
                Container(
                    decoration: const BoxDecoration(
                        color: Colors.white12,
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextField(
                            controller: _controller,
                            onSubmitted: onFormSubmit,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                                icon: const Icon(Icons.search),
                                labelText: searchText,
                                filled: true,
                                hoverColor: cBlack[2],
                                fillColor: cBlack[3]
                            ),
                            style: pageTextStyle(16),
                        ),
                    ),
                ),
                Container(
                    decoration: const BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12), 
                            bottomRight: Radius.circular(12)
                        )
                    ),
                    child: Row(
                        children: [
                            const SizedBox(width: 60),
                            generateSwitch("Title", 0),
                            generateSwitch("Author", 1),
                            generateSwitch("Genre", 2)
                        ],
                    ),
                ),
                Container(child: generateResults()),
            ],
        );
    }

    Widget generateResults(){
        switch(queryState){
            case QueryState.QUERY_INACTIVE:
                return const Center();
            case QueryState.QUERY_INCOMPLETE:
                return const Expanded(
                    child: Center(
                        child: Text(
                            "Searching",
                            style: TextStyle(fontSize: 16),
                        ),
                    ),
                );
            case QueryState.QUERY_COMPLETE:
                return Expanded (
                    child: NotificationListener(
                        onNotification: (t) {
                            if(t is ScrollEndNotification){
                            }
                            return true;
                        },
                        child: ListView.builder(
                            controller: _scrollController,
                            itemCount: bookList.length,
                            itemBuilder: (context, index) => bookList[index].build(context)
                        ),
                    ),
                );
            case QueryState.QUERY_FAILED:
                return const Center(
                        child: Text(
                            "There has been a problem with the server. Please try again later.",
                            style: TextStyle(
                                fontSize: 14
                                ),
                            )
                        );
            case QueryState.QUERY_NO_DATA:
                return const Center();
        }
    }

    Widget generateSwitch(String text, int switchIndex){
        return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Switch.adaptive(
                        activeTrackColor: Colors.blue[400],
                        inactiveTrackColor: Colors.black87,
                        focusColor: Colors.blue[300],
                        value: switches[switchIndex],
                        onChanged: (value) => onSwitchPressed(switchIndex)
                    ),
                    Text(
                        text,
                        style: TextStyle(
                            color:  switches[switchIndex] 
                                    ? Colors.white : Colors.grey
                        ),
                    ),
                    ],
                ),
            ),
        );
    }

    void onFormSubmit(String param) async{
        if(param.isEmpty) {
            setState(() { queryState = QueryState.QUERY_INACTIVE; });
            return;
        }

        setState(() { queryState = QueryState.QUERY_INCOMPLETE; });
        Map<String, dynamic> params = {parameters[selectedParameter]: param};

        try{
            bookList.clear();
            var api = SearchAPI();
            var books = await api.fetchBook(params);
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

    void onSwitchPressed(int switchIndex){
        setState(() {
            selectedParameter = switchIndex;
            for(int i = 0; i < switches.length; i++){
                switches[i] = (i == switchIndex);
            }
        });
    }

    TextStyle pageTextStyle(double size) {
        return TextStyle(
            color: Colors.white,
            fontSize: size
        );
    }
}
