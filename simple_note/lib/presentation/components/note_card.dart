import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class NoteCard extends StatelessWidget {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final Function(String id, String title, String content) onUpdate;
  final Function(String id) onRemove;

  const NoteCard(
      {Key? key,
      required this.title,
      required this.content,
      required this.date,
      required this.id,
      required this.onUpdate,
      required this.onRemove})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat _dateFormatter = DateFormat('dd MMM');
    final DateFormat _timeFormatter = DateFormat('h:mm');

    final titleController = TextEditingController();
    titleController.text = this.title;
    final contentController = TextEditingController();
    contentController.text = this.content;
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(30.0),
      decoration: BoxDecoration(
        color: Color(0xFFF5F7FB),
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                  // softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    onRemove(this.id);
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.redAccent,
                  )),
            ],
          ),
          SizedBox(height: 15.0),
          Text(
            content,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.w300,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                _dateFormatter.format(date),
                style: TextStyle(
                  color: Color(0xFFAFB4C6),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                  color: Color(0xFF417BFB),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Edit Note",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                    ],
                                  ),
                                  TextField(
                                      controller: titleController,
                                      decoration: InputDecoration(
                                          labelText: 'Title',
                                          hintText: titleController.text)),
                                  SizedBox(height: 40),
                                  TextField(
                                      controller: contentController,
                                      decoration: InputDecoration(
                                          labelText: 'Content',
                                          hintText: titleController.text)),
                                  SizedBox(height: 40),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel')),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Colors.redAccent,
                                            ),
                                          ),
                                          onPressed: () {
                                            onUpdate(
                                                this.id,
                                                titleController.text,
                                                contentController.text);
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Submit',
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
