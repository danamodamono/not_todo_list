import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:not_todo_list/conponents/card_background.dart';
import 'package:not_todo_list/conponents/confirm_dialog.dart';
import 'package:not_todo_list/db/db_goal.dart';
import 'package:not_todo_list/goal_list_page/goal_list_page_edit_screen.dart';
import 'package:not_todo_list/main.dart';

class GoalListPage extends StatefulWidget {
  const GoalListPage({Key? key}) : super(key: key);

  @override
  State<GoalListPage> createState() => _GoalListPageState();
}

class _GoalListPageState extends State<GoalListPage> {
  List<Place> _goalList = [];

  @override
  void initState() {
    super.initState();
    _getAllPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 85,
          leading: IconButton(
            icon: Icon(Icons.add, size: 30.0,),
            onPressed: () => _addNewWord(),
          ),
          title: Text("目標リスト"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () => showConfirmDialog(
                  context: context,
                  title: '削除',
                  content: 'リストを削除してもいいですか？',
                  onConfirmed: (isConfirmed) {
                    if (isConfirmed) {
                      _deletePlace(_goalList[0]);
                    }
                  }
              ),
            ),
          ],
        ),

        body: Stack(
          children: [
            CardBackground(),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 50.0,
                  ),
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
                  Text(
                    '例１',
                    // "${_goalList[0].strLong}",
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Divider(
                    height: 30.0,
                    color: Colors.blueGrey,
                    indent: 8.0,
                    endIndent: 8.0,
                    thickness: 1.0,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
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
                  Text(
                    '例２',
                    // "${_goalList[0].strMiddle}",
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Divider(
                    height: 30.0,
                    color: Colors.blueGrey,
                    indent: 8.0,
                    endIndent: 8.0,
                    thickness: 1.0,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
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
                  Text(
                    '例３',
                    // "${_goalList[0].strShort}",
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Divider(
                    height: 30.0,
                    color: Colors.blueGrey,
                    indent: 8.0,
                    endIndent: 8.0,
                    thickness: 1.0,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            )
          ],
        ));
  }

  void _getAllPlaces() async {
    print('==================================$_goalList');
    _goalList = await dbGoal.allPlaces;
    print('==================================$_goalList');
    setState(() {});
  }

  _addNewWord() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => GoalListPageEditScreen(
                  status: EditStatus.ADD,
                )));
  }

  _deletePlace(Place selectedStamp) async {
    await dbGoal.deleteWord(selectedStamp);
    Fluttertoast.showToast(
      msg: "削除が完了しました",
      toastLength: Toast.LENGTH_LONG,
    );
    _getAllPlaces();
  }


}
