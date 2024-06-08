import 'package:bookworm/models/bookModel.dart';
import 'package:bookworm/utility/searchAPI.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReadableBookModel{
  static const String baseURL = "archive.org/details";
  static const String mode = "1up";
  static const String view = "theater";
  final String archiveID;
  final int pageCount;

  final WebViewController wvcontroller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(Colors.black)
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {

        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onHttpError: (HttpResponseError e) {},
        onWebResourceError: (WebResourceError e) {},
        onNavigationRequest: (NavigationRequest request) async {
          if(await canLaunchUrl(Uri.parse(request.url))){
            await launchUrl(Uri.parse(request.url));
          }else{
            throw "Could not launch ${request.url}";
          }
          return NavigationDecision.prevent;
        }
      )
    );

  ReadableBookModel({
    required this.archiveID,
    required this.pageCount
  });

  static Future<ReadableBookModel?> fromBookModel(BookModel model) async{
    if(model.coverEditionKey == "") return null;

    try{
      String modelEditionKey = model.coverEditionKey!;
      SearchAPI api = SearchAPI();
      var json = await api.fetchReaderData(modelEditionKey);

      return (json["ocaid"] != null)
      ? ReadableBookModel(
        archiveID: json["ocaid"],
        pageCount: 0
      )
      : null;
    } on SearchAPIException {
      return null;
    }
  }

  Widget build(){
    String fullURL = "https://$baseURL/$archiveID/mode/$mode?ref=ol&view=$view";
    wvcontroller.loadRequest(Uri.parse(fullURL));
    return WebViewWidget(controller: wvcontroller);
  }
}
