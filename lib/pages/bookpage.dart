import 'dart:convert';

import 'package:bookworm/models/searchModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookPage extends StatefulWidget {
    const BookPage({super.key});

    @override State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
    late Future<SearchResultModel> model;

    Future<SearchResultModel> getResults(String url) async {
        final resultsJson = await http.get(Uri.parse(url));

        if(resultsJson.statusCode == 200){
            return SearchResultModel.fromJSON(jsonDecode(resultsJson.body));
        } else {
            throw Exception("Failed to fetch data.");
        }
    }

    @override void initState() {
        super.initState();
        model = getResults("https://openlibrary.org/search.json?q=the+lord+of+the+rings");
    }

    @override Widget build(BuildContext context) {
        return Scaffold(
                appBar: AppBar(
                    title: const Text("Appbar"),
                    centerTitle: true,
                    ),
    
                body: FutureBuilder(
                    future: model,
                    builder: (context, snapshot) {
                        if(snapshot.hasData){
                            var model = snapshot.data;
                            return ListView.builder(
                                itemCount: model!.books.length,
                                itemBuilder: (context, index) => ListTile(
                                    title: Text(model.books[index].title)
                                )
                            );
                        } else {
                            return const Text("No data");
                        }
                    }
                ),

                bottomNavigationBar: BottomNavigationBar(
                    items: const [
                    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                    ]
                    ),
                );
    }
}
