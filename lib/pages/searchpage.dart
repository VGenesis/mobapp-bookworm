import 'dart:math';

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

    Widget loadingIcon(Color color) {
      return SizedBox(
        width: 32,
        height: 32,
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
          color: color,
        ),
      );
    }

    double loadOffset = 0;
    String searchParam = "";

    bool scrollLoading = false;
    final ScrollController _scrollController = ScrollController();
    final TextEditingController _textController = TextEditingController();

    double searchBarOpacity = 1.0;

    void onScrollControllerAttach() async{
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _scrollController.position.isScrollingNotifier.addListener(() async {
          double maxScroll = _scrollController.position.maxScrollExtent;
          double currentScroll = _scrollController.position.pixels;
          double delta = 200;
          if(maxScroll - currentScroll < delta && !scrollLoading){
            Map<String, dynamic> params = {
              parameters[selectedParameter]: searchParam,
              "offset": bookList.length.toString()
            };

            try{
              setState(() { scrollLoading = true; });
              var api = SearchAPI();
              var books = await api.fetchBook(params);
              if(books["numFound"] == 0) {
                return;
              } else {
                for(var book in books["docs"]){
                  setState(() {
                      BookModel? model = BookModel.fromJSON(book);
                      if(model != null) {
                      bookList.add(model);
                      }
                      scrollLoading = false;
                      });
                }
              }
            } on SearchAPIException{
              scrollLoading = false;
              return;
            }
          }
        });
      });
    }

    void onScroll() {
      final direction = _scrollController.position.userScrollDirection;
      if(direction == ScrollDirection.forward){
        setState(() { 
          searchBarOpacity = min(searchBarOpacity + 0.1, 1.0);
        });
      } else if(direction == ScrollDirection.reverse) {
        setState(() {
          searchBarOpacity = max(searchBarOpacity - 0.1, 0.0);
        });
      } else if(_scrollController.position.isScrollingNotifier.value){
        if(searchBarOpacity < 0.8) {
          setState(() { searchBarOpacity = 0.0; });
        } else {
          setState(() { searchBarOpacity = 1.0; });
        }
      }
    }

    @override void initState(){
      super.initState();
    }

    @override void dispose() {
      super.dispose();
      _scrollController.position.isScrollingNotifier.removeListener(onScrollControllerAttach);
    }

    @override Widget build(BuildContext context) {
      String searchText = "Search ${parameterNames[selectedParameter]}";
      return Consumer<PageTheme>(
        builder: (context, currentTheme, child) => Container(
          decoration: BoxDecoration(
            color: currentTheme.theme.colorScheme.onPrimary,
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
                      color: currentTheme.theme.colorScheme.primary,
                      padding: const EdgeInsets.only(
                        top: 10.0, bottom: 5.0,      
                        left: 20.0, right: 20.0
                      ),
                      child: TextField(
                        controller: _textController,
                        onSubmitted: (value) {
                          bookList.clear();
                          onFormSubmit(value);
                        },
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
        
                    Container(
                      decoration: BoxDecoration(
                        color: currentTheme.theme.colorScheme.primary,
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
              return Center(
                child: loadingIcon(currentTheme.theme.colorScheme.primary),
              );
            case QueryState.finished:
              onScrollControllerAttach();
              return Flex(
                direction: Axis.vertical,
                children: [
                  Expanded (
                    child: NotificationListener(
                      onNotification: (t) {
                        if(
                          t is ScrollNotification || 
                          t is ScrollEndNotification
                        ){
                          onScroll();
                        }
                        return false;
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: bookList.length + 1,
                        itemBuilder: (context, index) {
                          return (index < bookList.length)
                          ? bookList[index].build(context)
                          : SizedBox(
                              height: 100,
                              child: (scrollLoading)
                              ? Center(
                                child: loadingIcon(currentTheme.theme.colorScheme.primary),
                              )
                              : Container()
                            );
                        }
                      ),
                    ),
                  ),
                ]
              );
            case QueryState.failed:
              setState(() { searchBarOpacity = 1.0; });
              return Expanded(
                child: Center(
                  child: Text(
                    "There has been a problem with the server. Please try again later.",
                    style: currentTheme.theme.textTheme.displaySmall
                    )
                  ),
                );
            case QueryState.empty:
              setState(() { searchBarOpacity = 1.0; });
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
      setState(() { searchBarOpacity = 0.0; });
      if(param.isEmpty) {
          setState(() { queryState = QueryState.inactive; });
          return;
      }

      setState(() { queryState = QueryState.started; });
      Map<String, dynamic> params = {
        parameters[selectedParameter]: param,
        "offset": bookList.length.toString()
      };

      try{
        var api = SearchAPI();
        var books = await api.fetchBook(params);
        if(books["numFound"] == 0) {
          setState(() { queryState = QueryState.empty; });
          return;
        } else {
          for(var book in books["docs"]){
            setState(() {
              BookModel? model = BookModel.fromJSON(book);
              if(model != null) {
                bookList.add(model);
              }
              searchParam = param;
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
}
