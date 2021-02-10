import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import './Screens/booksScreen.dart';
import './Providers/books.dart';
import './Providers/book.dart';
import './Providers/auth.dart';
import './Screens/addBookScreen.dart';
import './Screens/editScreen.dart';
import './Screens/logInScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, BooksProvider>(
          create: null,
          update: (_, auth, books) => BooksProvider(auth.idUser, auth.token,books==null?[]:books.books),
        ),
        ChangeNotifierProvider<Book>(
          create: (context) => Book(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Consumer<Auth>(
          builder: (context, auth, _) =>
              auth.token == null ? LoginScreen() : BooksScreen(),
        ),
        routes: {
          //BooksScreen.routeName: (context) => BooksScreen(),
          AddBookScreen.routeName: (context) => AddBookScreen(),
          EditScreen.routeName: (context) => EditScreen(),
        },
      ),
    );
  }
}
