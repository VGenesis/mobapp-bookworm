import 'package:bookworm/models/bookModel.dart';
import 'package:bookworm/utility/searchAPI.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReadableBookModel{
    final String archiveID;

    final WebViewController _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
            NavigationDelegate(
                onProgress: (int progress){},
                onPageStarted: (String url) {},
                onPageFinished: (String url) {},
                onWebResourceError: (WebResourceError error) {},
                onNavigationRequest: (NavigationRequest request){
                    if(request.url.startsWith("https://www.youtube.com/")) {
                        return NavigationDecision.prevent;
                    }
                    return NavigationDecision.navigate;
                }
            )
        );

    ReadableBookModel({
        required this.archiveID
    });

    void loadBook(String url){
        _controller.loadRequest(Uri.parse(url));
    }

    static Future<ReadableBookModel?> fromBookModel(BookModel model) async{
        if(model.coverEditionKey == "") return null;

        try{
            String modelEditionKey = model.coverEditionKey!;
            SearchAPI api = SearchAPI();
            var json = await api.fetchReaderData(modelEditionKey);

            return ReadableBookModel(
                archiveID: json["ocaid"]
            );
        } on Exception {
            print("Exception caught during ReadableBookModel initialization");
            return null;
        }
    }

    Widget build(){
        return WebViewWidget(
            controller: _controller,
        );
    }
}
