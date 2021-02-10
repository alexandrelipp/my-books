import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/books.dart';
import '../Providers/book.dart';

import '../Widgets/textFormWithIcon.dart';

class EditScreen extends StatefulWidget {
  static const routeName = '/editScreen';

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  var _isLoading = false;
  var _changesMade = false;
  Book localBook;
  var _isInit = false;
  var _favSelections = [true, false];
  var _statusSelections = [true, false, false];
  var _statusColor = Colors.red;

  Future<bool> _onBackPressed() async {
    if (!_changesMade) return true;
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Changes will not to be saved'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      localBook = ModalRoute.of(context).settings.arguments as Book;
      if (localBook.isFavorite) {
        _favSelections = [false, true];
      }
      if (localBook.status == Status.reading) {
        _statusSelections[0] = false;
        _statusSelections[1] = true;
      } else if (localBook.status == Status.done) {
        _statusSelections[0] = false;
        _statusSelections[2] = true;
      }
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    print('build of add called');
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomPadding:
            false, //prevent add button to be on top of keyboard
        appBar: AppBar(
          title: Text('Edit Book'),
          actions: [
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  final answer = await showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      actions: [
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text('No'),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: Text('Yes'),
                        ),
                      ],
                      title:
                          Text('Are you sure you want to delete this book ? '),
                      content: Text('This operation is not reversable'),
                    ),
                  );
                  if (answer) {
                    context.read<BooksProvider>().deleteBook(localBook.id);
                    Navigator.of(context).pop();
                  }
                }),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            onChanged: () {
              setState(() {
                _changesMade = true;
              });
            },
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      TextFormWithIcon(
                        Icons.title,
                        'Title*',
                        initialValue: localBook.title,
                        validator: (String value) {
                          if (value.length < 2)
                            return 'Please provide a title that is at least 2 characters long';
                          return null;
                        },
                        onSave: (value) {
                          localBook.title = value;
                        },
                      ),
                      TextFormWithIcon(
                        Icons.person,
                        'Author',
                        initialValue: localBook.author,
                        onSave: (value) {
                          if (value != null) {
                            localBook.author = value;
                          }
                        },
                      ),
                      TextFormWithIcon(
                        Icons.category,
                        'Type',
                        initialValue: localBook.type,
                        onSave: (value) {
                          if (value != null) {
                            localBook.type = value;
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: localBook.eval.toString(),
                          onSaved: (value) {
                            localBook.eval = int.parse(value);
                          },
                          validator: (value) {
                            final number = int.tryParse(value);
                            if (number == null) {
                              return 'Please provide a number';
                            }
                            if (number < 0 || number > 100) {
                              return 'Please provide a number in range of 0 and 100';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            suffixText: '/100',
                            filled: true,
                            labelText: 'Grade',
                            icon: Icon(Icons.grade),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: localBook.description,
                          onSaved: (value) {
                            if (value != null) {
                              localBook.description = value;
                            }
                          },
                          textInputAction: TextInputAction.newline,
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Description',
                            helperMaxLines: 2,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: ToggleButtons(
                            borderWidth: 3.0,
                            selectedBorderColor: Colors.red,
                            selectedColor: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                            children: [
                              SizedBox(
                                width: 100,
                                child: Icon(
                                  Icons.favorite_border,
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: Icon(Icons.favorite),
                              ),
                            ],
                            isSelected: _favSelections,
                            onPressed: (index) {
                              localBook.isFavorite = index == 0 ? false : true;
                              setState(() {
                                _favSelections[0] = !_favSelections[0];
                                _favSelections[1] = !_favSelections[1];
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: LayoutBuilder(builder: (context, contraints) {
                            return ToggleButtons(
                              selectedColor: Colors.black,
                              selectedBorderColor: _statusColor,
                              borderWidth: 3.0,
                              borderRadius: BorderRadius.circular(20),
                              children: [
                                SizedBox(
                                  width: contraints.maxWidth * 0.32,
                                  child: Text(
                                    'Not Started',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(),
                                  ),
                                ),
                                SizedBox(
                                  width: contraints.maxWidth * 0.32,
                                  child: Text(
                                    'Reading',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  width: contraints.maxWidth * 0.32,
                                  child: Text(
                                    'Done',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                              isSelected: _statusSelections,
                              onPressed: (index) {
                                setState(() {
                                  for (var i = 0; i < 3; i++) {
                                    if (i == index)
                                      _statusSelections[i] = true;
                                    else
                                      _statusSelections[i] = false;
                                  }
                                  switch (index) {
                                    case 0:
                                      _statusColor = Colors.red;
                                      localBook.status = Status.notStarted;
                                      break;
                                    case 1:
                                      _statusColor = Colors.yellow;
                                      localBook.status = Status.reading;
                                      break;
                                    case 2:
                                      _statusColor = Colors.green;
                                      localBook.status = Status.done;
                                      break;
                                    default:
                                      _statusColor = Colors.green;
                                  }
                                });
                              },
                            );
                          }),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onSaved: (value) {
                            localBook.page = int.parse(value);
                          },
                          initialValue: '0',
                          validator: (value) {
                            final number = int.tryParse(value);
                            if (number == null) {
                              return 'Please provide a number';
                            }
                            if (number < 0) {
                              return 'Please provide a number greater then 0';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            filled: true,
                            labelText: 'Current Page',
                            icon: Icon(Icons.menu_book_outlined),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _changesMade
                      ? () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            _formKey.currentState.save();
                            print(localBook.title);
                            print(localBook.author);
                            //print(localBook.isFav);
                            print(localBook.eval);
                            print(localBook.description);

                            print(localBook.status.toString().split('.').last);
                            print(localBook.page);

                            await context.read<BooksProvider>().editBook(localBook);

                            Navigator.of(context).pop('added');
                            //TODO add correct snackbar
                          }
                        }
                      : null,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    width: double.infinity,
                    height: 45,
                    child: Center(
                      child: _isLoading
                          ? CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            )
                          : Text('Save Changes'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
