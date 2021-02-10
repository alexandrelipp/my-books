import 'package:flutter/material.dart';
import '../Screens/booksScreen.dart';

//TODO not used at the moment check if keep or not

class TabsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          title: Text('Main Men'),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'All',

                //child: BooksScreen(),
              ),
              Tab(
                text: 'Favorites',
                //child: BooksScreen(),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BooksScreen(),
            BooksScreen(),
          ],
        ),
      ),
    );
  }
}
