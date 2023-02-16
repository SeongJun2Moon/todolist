import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final firestore = FirebaseFirestore.instance;

// 앱 실행
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

// 앱 본체(빌드 부분)
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const todoListApp(),
    );
  }
}

// todo 데이터 모델
class TodoModel {
  final String title;
  final String description;

  TodoModel({required this.title, required this.description});
}

// 앱 동작의 핵심 클래스 - Statefulwidget => 바로 뒤의 클래스와 한 덩어리
class todoListApp extends StatefulWidget {
  const todoListApp({Key? key}) : super(key: key);

  @override
  State<todoListApp> createState() => _todoListAppState();
}

class _todoListAppState extends State<todoListApp> {
  String title="";
  String description = "";
  // final url = Uri.parse("http://127.0.0.1:8000/todo");

  List<TodoModel> todos = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text("투두리스트"),
          centerTitle: true,
          leading: IconButton(
            onPressed: () async {
              var result = await firestore.collection('todolist').get();
              todos= [];
              for (var doc in result.docs) {
                setState(() {
                  todos.add(TodoModel(
                      title: doc["title"],
                      description: doc["subtitle"]
                  ));
                  // todos = todos_sub;
                });
              }
              var result2 = await firestore.collection('todolist').get();
              print(result2);
            },
            icon: Icon(Icons.file_open),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  // for (var i=0; i < todos.length; i++) {

                  // }
                  var reslut = await firestore.collection('todolist').get();
                  print(reslut.metadata);
                  int i = 0;
                  List<String>ids = [];
                  for (var doc in reslut.docs) {ids.add(doc.id);};
                  while (true) {
                    if (i < ids.length) {
                      for (var doc in reslut.docs) {
                        firestore.collection('todolist').doc(doc.id).set({
                          'title' : todos[i].title, "subtitle" : todos[i].description
                        });
                        i++;
                      };
                    } else {
                      for (var j = ids.length; j<todos.length; j++) {
                        await firestore.collection('todolist').add({
                          'title':todos[j].title, "subtitle" : todos[j].description,
                        });
                      }
                      break;
                    }
                  }
                },
                icon: Icon(Icons.save)
            )
          ],
        ),
        body: ListView.builder(
            itemBuilder: (_, index) {
              return InkWell(
                child: ListTile(
                  title: Text(todos[index].title),
                  subtitle: Text(todos[index].description),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        todos.removeAt(index);
                      });
                    },
                  ),
                ),
              );
            },
            itemCount: todos.length
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.teal,
            // 클릭했을 때 실행할 함수
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text('할 일'),
                      actions: [
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              title = value;
                            });
                          },
                          decoration: InputDecoration(hintText: "todo 제목"),
                        ),
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              description = value;
                            });
                          },
                          decoration: InputDecoration(hintText: "todo 내용"),
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {
                                todos.add(TodoModel(
                                    title: title,
                                    description: description
                                ));
                              });
                            }, child: Text("todo 추가"),
                          ),
                        ),
                      ],
                    );
                  }
              );
            },
            child: Icon(Icons.add,)
        )
    );
  }
}
