import 'package:bookworm/models/bookModel.dart';
import 'package:bookworm/models/readableBookModel.dart';
import 'package:bookworm/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BookReader extends StatefulWidget {
  final BookModel book;
  const BookReader({
      required this.book,
      super.key
      });

  @override State<BookReader> createState() => _BookPageState();
}

enum BookLoadStatus{ idle, started, finished, failed }

class _BookPageState extends State<BookReader> {
  late ReadableBookModel? bookModel;
  var loadStatus = BookLoadStatus.idle;

  int pageCount = 0;
  int currentPage = 0;

  Size screenSize = const Size(0, 0);
  ThemeData theme = lightTheme;

  final WebViewController wvcontroller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(Colors.black)
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {},
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

  void loadBook() async{
    setState(() {
      loadStatus = BookLoadStatus.started;
    });

    bookModel = await ReadableBookModel.fromBookModel(widget.book);

    setState(() {
      loadStatus = (bookModel != null)
      ? BookLoadStatus.finished
      : BookLoadStatus.failed;
    });
  }

  Widget generateBody(BuildContext context){
    switch(loadStatus){
      case BookLoadStatus.idle:
        return const Center();
      case BookLoadStatus.started:
        return Center(
            child: Text(
              "Loading...",
              style: lightTheme.textTheme.titleSmall
              )
            );
      case BookLoadStatus.finished:
        wvcontroller.loadRequest(Uri.parse(bookModel!.getFullUrl()));
        return WebViewWidget(controller: wvcontroller);
      case BookLoadStatus.failed:
        return Center(
            child: Text(
              "Could not load book.",
              style: lightTheme.textTheme.titleSmall
            )
          );
    }
  }

  @override void initState(){
    super.initState();
    loadBook();
  }

  @override Widget build(BuildContext context) {
    BookModel book = widget.book;
    return Consumer<PageTheme>(
      builder: (consumer, currentTheme, child) => Scaffold(
        appBar: AppBar(
          title: Text(book.bookName),
          centerTitle: true,
          foregroundColor: currentTheme.theme.colorScheme.onPrimary,
          backgroundColor: currentTheme.theme.colorScheme.primary
          ),
     
        body: Container(
          color: Colors.black,
          child: generateBody(context),
        ),
      ),
    );
  }
}
