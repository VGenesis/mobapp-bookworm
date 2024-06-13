import 'package:bookworm/models/bookModel.dart';
import 'package:bookworm/pages/bookreader.dart';
import 'package:flutter/material.dart';

import 'package:bookworm/pages/likedbooks.dart';
import 'package:bookworm/utility/colors.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
    State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void unlike(int index) async{
    BookModel book = LikedBooks.get(index);
    showDialog(
      context: context,
      builder: (context) => Consumer<PageTheme>(
        builder: (context, currentTheme, child) => SimpleDialog(
          backgroundColor: currentTheme.theme.colorScheme.error,
          titlePadding: const EdgeInsets.all(4.0),
          title: Opacity(
            opacity: 0.8,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Remove book \"${book.bookName}\"?",
                      maxLines: 2,
                      style: currentTheme.theme.textTheme.titleMedium
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: currentTheme.theme.colorScheme.onPrimary,
                            borderRadius: BorderRadius.circular(8.0)
                          ),
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              "No",
                              style: TextStyle(
                                color: currentTheme.theme.colorScheme.error,
                                fontSize: currentTheme.theme.textTheme.titleMedium!.fontSize
                              )
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: currentTheme.theme.colorScheme.onPrimary,
                            borderRadius: BorderRadius.circular(8.0)
                          ),
                          child: TextButton(
                            onPressed: () {
                              LikedBooks.removeBook(book);
                              Navigator.of(context).pop();
                              setState(() {});
                            },
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                color: currentTheme.theme.colorScheme.error,
                                fontSize: currentTheme.theme.textTheme.titleMedium!.fontSize
                              )
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }

  @override Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: LikedBooks.count(),
      itemBuilder: (context, index) {
        var book = LikedBooks.get(index);
        return Consumer<PageTheme>(
          builder: (context, currentTheme, child) => ListTile(
            title: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: currentTheme.theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 6,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: book.image
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.bookName,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: currentTheme.theme.textTheme.titleSmall
                            ),
                            Text(
                              book.authorName,
                              style: TextStyle(
                                color: currentTheme.theme.textTheme.titleSmall!.color,
                                fontSize: 12,
                                fontStyle: FontStyle.italic
                              )
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => unlike(index),
                            icon: Icon(
                              Icons.favorite,
                              color: currentTheme.theme.colorScheme.onPrimary
                            )
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookReader(book: book)
                              )
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: currentTheme.theme.colorScheme.onPrimary,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Read",
                                    style: TextStyle(
                                      color: currentTheme.theme.colorScheme.primary,
                                      fontSize: 12
                                    ),
                                  ),
                                  Icon(
                                    Icons.play_arrow,
                                    color: currentTheme.theme.colorScheme.primary
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ),
        );
      }
    );
  }
}
