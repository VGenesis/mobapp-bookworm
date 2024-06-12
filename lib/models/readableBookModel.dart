import 'package:bookworm/models/bookModel.dart';
import 'package:bookworm/utility/searchAPI.dart';

class ReadableBookModel{
  static const String baseURL = "archive.org/details";
  static const String mode = "1up";
  static const String view = "theater";
  final String archiveID;
  final int pageCount;

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

  String getFullUrl(){
    return "https://$baseURL/$archiveID/mode/$mode?ref=ol&view=$view";
  }
}
