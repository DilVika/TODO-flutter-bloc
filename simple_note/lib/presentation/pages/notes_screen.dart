import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:simple_note/business_logic/blocs/bloc/notes_bloc.dart';
import 'package:simple_note/data/models/note_model.dart';
import 'package:simple_note/presentation/components/note_card.dart';
import 'package:simple_note/ultis/DI.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  NotesBloc _bloc = ModuleContainer.getInjector().get<NotesBloc>();

  @override
  void initState() {
    _bloc.add(FetchNote(page: 1, limit: 100));
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();

    final contentController = TextEditingController();

    return Scaffold(
      body: BlocProvider(
        create: (context) => _bloc,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.notes_outlined),
                  SizedBox(width: 20.0),
                  Text(
                    'Your Notes',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.0),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
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
                                            "Create Note",
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
                                                contentController.clear();
                                                titleController.clear();
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
                                                if (contentController.text !=
                                                        '' &&
                                                    titleController.text !=
                                                        '') {
                                                  _bloc.add(
                                                    AddNote(
                                                        title: titleController
                                                            .text,
                                                        content:
                                                            contentController
                                                                .text),
                                                  );
                                                  contentController.clear();
                                                  titleController.clear();
                                                  Navigator.pop(context);
                                                }
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
                      icon: Icon(Icons.add),
                      label: Text('Add')),
                  IconButton(
                      onPressed: () {
                        //todo
                      },
                      icon: Icon(Icons.sort_by_alpha)),
                ],
              ),
              SizedBox(height: 20.0),
              BlocConsumer<NotesBloc, NotesState>(listener: (context, state) {
                if (state is NoteError) {
                  print(state.error);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Text("Error: \"$state.error\""),
                        );
                      });
                }
              }, buildWhen: (_, curState) {
                return !(curState is NoteError);
              }, builder: (context, state) {
                print(state);
                if (state is NotesInitial) {
                  // man hinh cho gi do
                  return Container();
                }
                if (state is NotesFetching) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is NoteFetched) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount:
                        state.list != null ? state.list!.notes.length : 0,
                    itemBuilder: (BuildContext context, int index) {
                      return NoteCard(
                        title: state.list!.notes[index].title,
                        content: state.list!.notes[index].content,
                        date: state.list!.notes[index].date,
                        id: state.list!.notes[index].id,
                        onRemove: (String id) {
                          _bloc.add(RemoveNote(id: id));
                        },
                        onUpdate: (String id, String title, String content) {
                          _bloc.add(
                              EditNote(id: id, title: title, content: content));
                        },
                      );
                    },
                  );
                }

                return Container();
              }),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}

// final Map<String, int> categories = {
//   'Notes': 112,
//   'Work': 58,
//   'Home': 23,
//   'Complete': 31,
// };

// final List<Note> notes = [
//   Note(
//     title: 'Buy ticket',
//     content: 'Buy airplane ticket through Kayak for \$318.38',
//     date: DateTime(2019, 10, 10, 8, 30),
//   ),
//   Note(
//     title: 'Walk with dog',
//     content: 'Walk on the street with my favorite dog.',
//     date: DateTime(2019, 10, 10, 8, 30),
//   ),
// ];
