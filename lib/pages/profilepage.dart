import 'package:flutter/material.dart';

import 'package:bookworm/pages/likedbooks.dart';
import 'package:bookworm/utility/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
    State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ThemeData theme = lightTheme;

  LikedBooks books = LikedBooks();

  @override void initState() {
    super.initState();
    LikedBooks.saveBooks();
    var json = LikedBooks.loadBooks();
    print(json);
  }

  @override Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Center(
      child: Text(
        "Profile page",
        style: theme.textTheme.displaySmall,
      ),
    );
  }
}
