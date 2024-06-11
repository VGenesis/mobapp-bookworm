import 'package:bookworm/utility/colors.dart';
import 'package:flutter/material.dart';

import 'package:bookworm/models/bookModel.dart';
import 'package:bookworm/utility/searchAPI.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

enum QueryState{ inactive, started, finished, failed, empty }

class SearchPage extends StatefulWidget {
    const SearchPage({super.key});

    @override State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
    final Map<String, dynamic> params = {
        "title": "a"
    };

    QueryState queryState = QueryState.inactive;
    List<BookModel> bookList = [];

    List<bool> switches = [true, false, false];

    int selectedParameter = 0;
    final List<String> parameters = [
        "title", "author", "subjects"
    ];

    final List<String> parameterNames = [
        "titles", "authors", "genres"
    ];


    final ScrollController _scrollController = ScrollController();
    final TextEditingController _controller = TextEditingController();

    double searchBarOpacity = 1.0;

    @override
        void initState(){
            super.initState();
            _scrollController.addListener(_onScroll);
            //searchBarOpacity = true;
        }

    @override
        void dispose() {
            super.dispose();
            _scrollController.removeListener(_onScroll);
        }

    @override Widget build(BuildContext context) {
      String searchText = "Search ${parameterNames[selectedParameter]}";
      return Consumer<PageTheme>(
        builder: (context, currentTheme, child) => Container(
          decoration: BoxDecoration(
            color: currentTheme.theme.colorScheme.primary
          ),
          child: Stack(
            children: [
            generateResults(),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: searchBarOpacity,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: currentTheme.theme.colorScheme.secondary
                      ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0, bottom: 5.0,
                        left: 20.0, right: 20.0
                        ),
                      child: TextField(
                        controller: _controller,
                        onSubmitted: onFormSubmit,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.search),
                          iconColor: currentTheme.theme.colorScheme.onPrimary,
                          labelText: searchText,
                          labelStyle: TextStyle(
                              color: currentTheme.theme.colorScheme.secondary
                              ),
                          filled: true,
                          hoverColor: currentTheme.theme.colorScheme.secondary,
                          fillColor: currentTheme.theme.colorScheme.onPrimary,
                          focusColor: currentTheme.theme.colorScheme.secondary
                          ),
                        style: TextStyle(
                          color: currentTheme.theme.colorScheme.primary,
                          fontSize: currentTheme.theme.textTheme.displaySmall!.fontSize
                          )
                        ),
                      ),
                    ),
        
                    Container(
                      decoration: BoxDecoration(
                        color: currentTheme.theme.colorScheme.secondary,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12), 
                          bottomRight: Radius.circular(12)
                          )
                        ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          generateSwitch("Title", 0),
                          generateSwitch("Author", 1),
                          generateSwitch("Genre", 2)
                        ],
                      ),
                    ),
                  ]
                )
              ),
            ],
          ),
        ),
      );
    }

    Widget generateResults(){
      return Consumer<PageTheme>(
        builder: (context, currentTheme, child) {
          switch(queryState){
            case QueryState.inactive:
              return const Center();
            case QueryState.started:
              return Expanded(
                child: Center(
                  child: Text(
                    "Searching...",
                    style: currentTheme.theme.textTheme.displaySmall
                    ),
                  ),
                );
            case QueryState.finished:
              return Expanded (
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: bookList.length,
                  itemBuilder: (context, index) => bookList[index].build(context)
                  ),
                );
            case QueryState.failed:
              return Expanded(
                child: Center(
                  child: Text(
                    "There has been a problem with the server. Please try again later.",
                    style: currentTheme.theme.textTheme.displaySmall
                    )
                  ),
                );
            case QueryState.empty:
              return Center(
                child: Text(
                  "No books found.",
                  style: currentTheme.theme.textTheme.displaySmall
                ),
              );
            }
        }
      );
    }

    Widget generateSwitch(String text, int switchIndex){
      return Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
        child: Consumer<PageTheme>(
          builder: (context, currentTheme, child) => Column(
            children: [
              SwitchTheme(
                data: currentTheme.theme.switchTheme,
                child: Switch(
                  value: switches[switchIndex],
                  onChanged: (_) => onSwitchPressed(switchIndex)
                ),
              ),
              Text(
                text,
                style: currentTheme.theme.textTheme.titleSmall,
              )
            ],
          ),
        ),
      );
    }

    void onFormSubmit(String param) async{
        searchBarOpacity = 0.0;
        if(param.isEmpty) {
            setState(() { queryState = QueryState.inactive; });
            return;
        }

        setState(() { queryState = QueryState.started; });
        Map<String, dynamic> params = {parameters[selectedParameter]: param};

        try{
            bookList.clear();
            var api = SearchAPI();
            var books = await api.fetchBook(params);
            if(books["numFound"] == 0) {
                setState(() { queryState = QueryState.empty; });
            } else {
                for(var book in books["docs"]){
                    setState(() {
                            BookModel? model = BookModel.fromJSON(book);
                            if(model != null) {
                            bookList.add(model);
                            }
                            });
                }
                setState(() { queryState = QueryState.finished; });
            }
        } on SearchAPIException{
            setState(() { queryState = QueryState.empty; });
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

    void _onScroll(){
        setState(() {
                if(_scrollController.position.userScrollDirection == ScrollDirection.forward){
                searchBarOpacity = (searchBarOpacity + 0.1 >= 1.0)? 1.0 : searchBarOpacity + 0.1;
                } else if(_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
                searchBarOpacity = (searchBarOpacity - 0.1 <= 0.0)? 0.0 : searchBarOpacity - 0.1;
                }
                });
    }
}
