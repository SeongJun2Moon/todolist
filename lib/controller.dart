import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class List extends StatefulWidget {
  const List({Key? key}) : super(key: key);

  @override
  State<List> createState() => _ListState();
}

class _ListState extends State<List> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('리스트페이지임'),
    );
  }
}
