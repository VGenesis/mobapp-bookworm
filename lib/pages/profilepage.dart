import 'package:bookworm/utility/colors.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
    State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ThemeData theme = lightTheme;

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
