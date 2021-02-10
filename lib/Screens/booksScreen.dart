import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/books.dart';
import '../Providers/book.dart';
import '../Widgets/bookTile.dart';
import './addBookScreen.dart';

//TODO refresh when pulled up

class BooksScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _BooksScreenState createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  Future<void> futureData;
  var showFavoriteOnly = false;

  @override
  void initState() {
    futureData = Provider.of<BooksProvider>(context, listen: false).loadBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var dataProvider = context.watch<BooksProvider>();
    List<Book> books =
        showFavoriteOnly ? dataProvider.favoritesBooks : dataProvider.books;
    print('build called');

    return Scaffold(
      drawer: Container(
        width: 250,
        child: Drawer(
          child: Column(
            children: [
              AppBar(),
              ListTile(
                title: Text('All Books'),
              ),
              ListTile(
                title: Text('Not started'),
              ),
              ListTile(
                title: Text('Reading'),
              ),
              ListTile(
                title: Text('Done'),
              ),
              ListTile(
                title: Text('Settings'),
              ),
              ListTile(
                title: Text('Statistics'),
              ),
              ListTile(
                title: Text('Report a bug'),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        //centerTitle: true,
        title: Text('My Books'),
        actions: [
          //TODO implement search
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          PopupMenuButton(
            onSelected: (SortOption sort) {
              dataProvider.sortBooks(sort);
            },
            itemBuilder: (context) => <PopupMenuEntry<SortOption>>[
              const PopupMenuItem(
                child: Text('Sort by Title'),
                value: SortOption.title,
              ),
              const PopupMenuItem(
                child: Text('Sort by Author'),
                value: SortOption.author,
              ),
              const PopupMenuItem(
                child: Text('Sort by Grade'),
                value: SortOption.grade,
              ),
              const PopupMenuItem(
                child: Text('Sort by Type'),
                value: SortOption.type,
              ),
            ],
          ),
          const SizedBox(width: 10),
          Icon(showFavoriteOnly ? Icons.favorite : Icons.favorite_border),
          Switch(
            value: showFavoriteOnly,
            onChanged: (newValue) {
              setState(() {
                showFavoriteOnly = newValue;
              });
            },
          )
        ],
      ),
      floatingActionButton: Fab(),
      body: FutureBuilder(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  'Unable to load book data, please check your internet connexion'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ListView.builder(
              itemBuilder: (context, index) {
                if (index < books.length) {
                  return Column(
                    children: [
                      ChangeNotifierProvider.value(
                        value: books[index],
                        child: BookTile(),
                      ),
                      Divider(
                        thickness: 2,
                      ),
                    ],
                  );
                }
                return SizedBox(height: 100);
              },
              itemCount: books.length + 1,
            ),
          );
        },
      ),
    );
  }
}

class Fab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () async {
        final result =
            await Navigator.of(context).pushNamed(AddBookScreen.routeName);
        print(result);
        if (result == 'added') {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Book added !'),
            ),
          );
        }
      },
    );
  }
}
