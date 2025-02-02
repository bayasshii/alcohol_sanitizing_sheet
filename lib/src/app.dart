import 'package:alcohol_sanitizing_sheet/src/diary/diary.dart';
import 'package:alcohol_sanitizing_sheet/src/diary/diary_create.dart';
import 'package:alcohol_sanitizing_sheet/src/diary/diary_list.dart';
import 'package:alcohol_sanitizing_sheet/src/summary/summary_create.dart';
import 'package:alcohol_sanitizing_sheet/src/helper.dart/db_helper.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyDiaryHomePage(title: 'MyDiaryHomePage'),
    );
  }
}

class MyDiaryHomePage extends StatefulWidget {
  MyDiaryHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyDiaryHomePageState createState() => _MyDiaryHomePageState();
}

class _MyDiaryHomePageState extends State<MyDiaryHomePage> {
  int _selectedIndex = 0;

  List<Widget> get widgetOptions => [
        DiaryList(
          diaryList: diaryList,
          onReload: _reloadData,
        ),
        Summary(),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late Future<List<Diary>> diaryList;

  Future<List<Diary>> fetchDiariesFromDB() async {
    return await DBHelper.fetchDiaries();
  }

  @override
  void initState() {
    super.initState();
    diaryList = fetchDiariesFromDB();
  }

  Future<void> _reloadData() async {
    setState(() {
      diaryList = fetchDiariesFromDB();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: 144,
          child: Image.asset(
            'assets/images/logotype.png',
            fit: BoxFit.scaleDown,
          ),
        ),
        backgroundColor: Color(0xFFFFFFFF),
      ),
      body: widgetOptions
          .elementAt(_selectedIndex), // This will be the list of diaries
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DiaryCreatePage()),
          );
          _reloadData();
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
