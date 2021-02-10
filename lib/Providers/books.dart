import 'dart:convert';

import 'package:flutter/material.dart';
import '../assets/secret.dart';
import './book.dart';
import 'package:http/http.dart' as http;

enum SortOption {
  title,
  author,
  grade,
  type,
}

class BooksProvider with ChangeNotifier {
  var _books = <Book>[];

  int get nBooks => _books.length;
  final String idUser;
  final String token;

  BooksProvider(this.idUser, this.token, this._books);

  List<Book> get books => [..._books];

  List<Book> get favoritesBooks =>
      _books.where((book) => book.isFavorite).toList();

  void editBook(Book book) async {
    final url =
        '$dbUrl$idUser/${book.id}.json?auth=$token';
    final response = await http.patch(
      url,
      body: json.encode({
        'title': book.title,
        'author': book.author,
        'description': book.description,
        'type': book.type,
        'eval': book.eval,
        'isFavorite': book.isFavorite,
        'status': book.status.toString().split('.').last,
        'page': book.page,
      }),
    );
    if (response.statusCode >= 400) throw Error();
    _books[_books.indexWhere((element) => element.id == book.id)] = book;
    notifyListeners();
  }

  void deleteBook(String bookId) {
    _books.removeWhere((book) => book.id == bookId);
    notifyListeners();
    final url =
        '$dbUrl$idUser/$bookId.json?auth=$token';

    http.delete(url).then((reponse) {
      if (reponse.statusCode >= 400) {
        //TODO manage error(add it back if needed)
        throw Error();
      }
    });
  }

  void sortBooks(SortOption sort) {
    switch (sort) {
      case SortOption.title:
        _books.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortOption.author:
        _books.sort((a, b) {
          if ((a.author == '') && (b.author == '')) return 0;
          if (a.author == '') return 1;
          if (b.author == '') return -1;
          return a.author.compareTo(b.author);
        });
        break;
      case SortOption.grade:
        _books.sort((b, a) => a.eval.compareTo(b.eval));
        break;
      case SortOption.type:
        _books.sort((a, b) {
          if ((a.type == '') && (b.type == '')) return 0;
          if (a.type == '') return 1;
          if (b.type == '') return -1;
          return a.type.compareTo(b.type);
        });
        break;
      default:
        return;
    }
    notifyListeners();
  }

  Future<void> loadBooks() async {
    final url =
        '$dbUrl$idUser.json?auth=$token';
    final response = await http.get(url);
    var temp = <Book>[];
    final data = json.decode(response.body) as Map<String, dynamic>;
    data.forEach((bookId, value) {
      Status bookstatus;
      switch (value['status']) {
        case 'reading':
          bookstatus = Status.reading;
          break;
        case 'botStarted':
          bookstatus = Status.notStarted;
          break;
        case 'done':
          bookstatus = Status.done;
          break;
        default:
          bookstatus = Status.notStarted;
      }

      temp.add(
        Book(
          id: bookId,
          title: value['title'],
          type: value['type'],
          author: value['author'],
          description: value['description'],
          isFavorite: value['isFavorite'],
          eval: value['eval'],
          page: value['book'],
          status: bookstatus,
        ),
      );
    });
    _books = [...temp];
    notifyListeners();
  }

  Future<void> addBook(Book book) async {
    //TODO ADD TRY CATCH
    final url =
        '$dbUrl$idUser.json?auth=$token';
    final response = await http.post(url,
        body: json.encode({
          'title': book.title,
          'author': book.author,
          'description': book.description,
          'type': book.type,
          'eval': book.eval,
          'isFavorite': book.isFavorite,
          'status': book.status.toString().split('.').last,
          'page': book.page,
        }));
    book.id = json.decode(response.body)['name'];
    _books.add(book);
    notifyListeners();
  }
}
