import 'package:flutter/material.dart';
import '../Providers/auth.dart';
import '../Providers/book.dart';
import 'package:provider/provider.dart';
import '../Screens/editScreen.dart';

import '../assets/constants.dart';

class BookTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final book = context.watch<Book>();
    Icon _leading;
    switch (book.status) {
      case Status.done:
        _leading = doneIcon;
        break;
      case Status.reading:
        _leading = readingIcon;

        break;
      case Status.notStarted:
        _leading = notStartedIcon;
        break;
      default:
        break;
    }
    print('book tile build called');
    return Container(
      //height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //SizedBox(width: 8),
          Consumer<Auth>(
            builder: (_, auth, __) => PopupMenuButton(
              //TODO check width of this button when clicked on
              onSelected: (status) async {
                await context
                    .read<Book>()
                    .changeStatus(status, auth.idUser, auth.token);
              },
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: _leading,
                ),
              ),
              itemBuilder: (context) => <PopupMenuEntry<Status>>[
                PopupMenuItem(
                  value: Status.done,
                  child: doneIcon,
                ),
                PopupMenuItem(
                  value: Status.reading,
                  child: readingIcon,
                ),
                PopupMenuItem(
                  value: Status.notStarted,
                  child: notStartedIcon,
                ),
              ],
            ),
          ),
          //_leading,
          SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    '  ${book.title}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                if (book.author != "")
                  SizedBox(
                    height: 5,
                  ),
                if (book.author != "")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person, size: 14),
                      Text('  ${book.author}'),
                    ],
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                if (book.type != "") Text(book.type),
                Text('${book.eval} %'),
              ],
            ),
          ),
          InkWell(
            child: Icon(
              Icons.edit,
              color: Colors.grey[600],
            ),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(EditScreen.routeName, arguments: book);
            },
          ),
          IconButton(
            icon: Icon(
              book.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () async {
              await book.toggleFavorite(
                  context.read<Auth>().idUser, context.read<Auth>().token);
            },
          ),
        ],
      ),
    );
  }
}
