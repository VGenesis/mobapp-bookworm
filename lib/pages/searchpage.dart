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

    List<bool> switches = [true, false, false];

    final List<String> parmeters = [
        "title", "author", "subject"
    ];
    String selectedParameter = "title";
    final TextEditingController _controller = TextEditingController();

    TextStyle pageTextStyle(double size) {
        return TextStyle(
            color: Colors.white,
            fontSize: size
        );
    }

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
        double bookGridWidth = (MediaQuery.of(context).size.width / BookModel.cardWidth);
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
                return Expanded(
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: bookGridWidth.toInt()),
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

    void onSwitchPressed(int switchIndex){
        setState(() {
            selectedParameter = "title";
            for(int i = 0; i < switches.length; i++){
                switches[i] = (i == switchIndex);
            }
        });
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

    @override Widget build(BuildContext context) {
        return Column(
            children: [
                Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                        controller: _controller,
                        onSubmitted: onFormSubmit,
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                            filled: true,
                            hoverColor: Colors.black54,
                            fillColor: Colors.black87
                        ),
                        style: pageTextStyle(16),
                        ),
                    ),
                Row(
                    children: [
                        generateSwitch("Title", 0),
                        generateSwitch("Author", 1),
                        generateSwitch("Genre", 2)
                    ],
                ),
                Container(child: generateResults()),
            ],
        );
    }
}
