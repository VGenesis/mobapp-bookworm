class SearchBookModel{
    final String title;
    final String? authorName;

    SearchBookModel({
        required this.title,
        this.authorName
    });

    factory SearchBookModel.fromJSON(Map<String, dynamic> json){
        var title = json["title"];
        var authorNameField = json["author_name"];
        
        return SearchBookModel(
                title: title,
                authorName: (authorNameField != null) ? authorNameField[0] : "",
        );
    }
}

class SearchResultModel{
    final int count;
    final List<SearchBookModel> books;

    SearchResultModel({
        required this.count,
        required this.books
    });

    factory SearchResultModel.fromJSON(Map<String, dynamic> json){
        List<SearchBookModel> books = [];
        try{
            List<dynamic> docs = json["docs"];

            for(int i = 0; i < docs.length; i++){
                books.add(SearchBookModel.fromJSON(docs[i]));
            }

            return SearchResultModel(
                count: docs.length,
                books: books
            );

        } on FormatException catch (e){
            print(e.message);
            throw const FormatException("Invalid JSON Structure.");
        }
    }
}
