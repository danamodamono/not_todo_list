import 'package:drift/drift.dart' hide Column;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:not_todo_list/conponents/card_background.dart';
import 'package:not_todo_list/db/db_goal.dart';
import 'package:not_todo_list/goal_list_page/goal_list_page.dart';
import 'package:not_todo_list/main.dart';

enum EditStatus { ADD, EDIT }

class GoalListPageEditScreen extends StatefulWidget {

  final EditStatus status;
  final Place? place;

  GoalListPageEditScreen({required this.status, this.place});

  @override
  _GoalListPageEditScreenState createState() => _GoalListPageEditScreenState();
}

class _GoalListPageEditScreenState extends State<GoalListPageEditScreen> {
  TextEditingController longNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController shortNameController = TextEditingController();

  String _titleText = "";

  bool _isGoalNameEnabled = true;

  @override
  void initState() {
    super.initState();
    if (widget.status == EditStatus.ADD) {
      _isGoalNameEnabled = true;
      _titleText = "新規登録";
      longNameController.text = "";
      middleNameController.text = "";
      shortNameController.text = "";

    } else {
      _titleText = "編集して再登録";
      _isGoalNameEnabled = false;
      longNameController.text = widget.place!.strLong;
      middleNameController.text = widget.place!.strMiddle;
      shortNameController.text = widget.place!.strShort;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _backToGoalListPage(),
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 85,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 30.0,),
            onPressed: () => _backToGoalListPage(),
          ),
          title: Text(_titleText),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.done),
              tooltip: "登録",
              onPressed: () => _onWordRegistered(),
              iconSize: 30,
            )
          ],
        ),
        body: Stack(
            children: [
              CardBackground(),
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 50.0,
                    ),
                    _longNameInputPart(),
                    SizedBox(
                      height: 20.0,
                    ),
                    _middleNameInputPart(),
                    SizedBox(
                      height: 20.0,
                    ),
                    _shortNameInputPart(),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
      ),
    );
  }

  Widget _longNameInputPart() {
    return Column(
      children: <Widget>[
        Text(
          "長期目標",
          style: TextStyle(
            fontSize: 25.0,
            color: Colors.blueGrey,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        TextField(
          enabled: _isGoalNameEnabled,
          controller: longNameController,
          keyboardType: TextInputType.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30.0,
            color: Colors.black87,
          ),
        )
      ],
    );
  }

  Widget _middleNameInputPart() {
    return Column(
      children: <Widget>[
        Text(
          "中期目標",
          style: TextStyle(
            fontSize: 25.0,
            color: Colors.blueGrey,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        TextField(
          enabled: _isGoalNameEnabled,
          controller: middleNameController,
          keyboardType: TextInputType.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30.0,
            color: Colors.black87,
          ),
        )
      ],
    );
  }

  Widget _shortNameInputPart() {
    return Column(
      children: <Widget>[
        Text(
          "短期目標",
          style: TextStyle(
            fontSize: 25.0,
            color: Colors.blueGrey,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        TextField(
          enabled: _isGoalNameEnabled,
          controller: shortNameController,
          keyboardType: TextInputType.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30.0,
            color: Colors.black87,
          ),
        )
      ],
    );
  }


  Future<bool> _backToGoalListPage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => GoalListPage()));
    return Future.value(false);
  }

  _onWordRegistered() {
    if (widget.status == EditStatus.ADD) {
      _insertWord();
    } else {
      _updateWord();
    }
  }

  _insertWord() async {
    if (longNameController.text == "") {
      Fluttertoast.showToast(
        msg: "名称を入力しないと登録できません",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    var place = PlacesCompanion(
      strLong: Value(longNameController.text),
      strMiddle: Value(middleNameController.text),
      strShort: Value(shortNameController.text),
    );

    try {
      await dbGoal.addPlace(place);
      longNameController.clear();
      middleNameController.clear();
      shortNameController.clear();
      // 登録完了メッセージ
      Fluttertoast.showToast(
        msg: "登録が完了しました",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    } on SqliteException catch (e) {
      Fluttertoast.showToast(
        msg: "この名称は既に登録されていますので登録できません",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  void _updateWord() async {
    if (longNameController.text == "") {
      Fluttertoast.showToast(
        msg: "名称を入力しないと登録できません",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    var place = PlacesCompanion(
      strLong: Value(longNameController.text),
      strMiddle: Value(middleNameController.text),
      strShort: Value(shortNameController.text),
    );

    try {
      await dbGoal.updateWord(place);
      _backToGoalListPage();
      Fluttertoast.showToast(
        msg: "編集が完了しました",
        toastLength: Toast.LENGTH_LONG,
      );
    } on SqliteException catch (e) {
      Fluttertoast.showToast(
        msg: "何らかの問題が発生して登録できませんでした。: $e",
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }
  }
}


