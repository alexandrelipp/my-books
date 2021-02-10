import 'dart:convert';
import '../assets/secret.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum Status {
  notStarted,
  reading,
  done,
}

class Book with ChangeNotifier {
  String id;
  String title;
  String author;
  String description;
  String type;
  int eval;
  bool isFavorite;
  Status status;
  int page;

  Future<void> changeStatus(Status newStatus, String idUser, String token) async {
    if (status == newStatus) return;
    final url = '$dbUrl$idUser/$id.json?auth=$token';
    final response = await http.patch(
      url,
      body: jsonEncode(
        {'status': newStatus.toString().split('.').last},
      ),
    );
    if (response.statusCode >= 400) {
      print(response.body);
      throw Error();
    }
    status = newStatus;
    notifyListeners();
  }

  Future<void> toggleFavorite(String idUser, String token) async {
    final url = '$dbUrl$idUser/$id.json?auth=$token';
    final response = await http.patch(url, body: jsonEncode({'isFavorite': !isFavorite}));
    if (response.statusCode >= 400) throw Error();

    isFavorite = !isFavorite;
    notifyListeners();
  }

  Book(
      {this.id,
      this.title,
      this.author,
      this.description,
      this.eval,
      this.isFavorite = false,
      this.type,
      this.page = 0,
      this.status = Status.notStarted});
}
