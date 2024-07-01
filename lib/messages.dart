import 'package:flutter/material.dart';
import 'Message.dart';
import 'DbHelperMsg.dart';

class Messages extends StatefulWidget {
  const Messages({super.key, required this.title});
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  List<Message> _items = List<Message>.empty();
  List<Message> _selectedMsgs = List<Message>.empty();
  DbHelperMsg _db = DbHelperMsg();
  bool _isSelected = false;

  @override
  void initState() {
    //_db.clearTableContents();
    List<Message> msgs = Message.loadMsgs();
    _saveMsgs(msgs).then((onValue) {
      _db.getAllMsgs().then((msgs) {
        setState(() {
          msgs.forEach((msg) {
            _items.add(Message.fromMap(msg));
          });
        });
      });
    });
    print("Items length= ${_items.length}");
    super.initState();
  }

  Future<void> _saveMsgs(List<Message> msgs) async {
    for (var msg in msgs) {
      int result = await _db.saveMsg(msg);
      print('result= ${result}');
    }
  }

  void _deleteMsgs() {
    print('_deleteMsgs');
    _items.clear();
    _selectedMsgs.forEach((msg) async{
      print("id= ${msg.getId} date= ${msg.getDate} msg= ${msg.getMsg}");
      await _db.deleteMsg(msg.getId);
    });

    _db.getAllMsgs().then((msgs) {
      setState(() {
        msgs.forEach((msg) {
          _items.add(Message.fromMap(msg));
        });
        print('_items Lengthhh= ${_items.length}');
      });
    });
    _selectedMsgs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSA ListView Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('ListView Demo'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: ListView.builder(
              itemCount: _items.length,
              padding: const EdgeInsets.all(15.0),
              itemBuilder: (context, position) {
                return Column(
                  children: <Widget>[
                    Divider(height: 5.0),
                    CheckboxListTile(
                        title:  Text(
                          _items[position].getDate,
                          style: const TextStyle(
                            fontSize: 22.0,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        subtitle: Text(
                          _items[position].getMsg,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        value: _items[position].getCheckBox,
                        onChanged: (bool? newValue) {
                          print('position in ListView= ${position}');
                          setState(() {
                            _items[position].setCheckBox = newValue!;
                          });
                          newValue!
                              ? _selectedMsgs.add(_items[position])
                              : _selectedMsgs.remove(_items[position]);
                        }),
                  ],
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.remove),
          onPressed: () => _deleteMsgs(),
        ),
      ),
    );
  }
}



