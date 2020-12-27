import 'package:flutter/material.dart';
import 'message.dart';
import 'DbHelperMsg.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => new _MessagesState();
}

class _MessagesState extends State<Messages> {
  List<Message> _items = new List();
  List<Message> _selectedMsgs = new List();
  DbHelperMsg _db = new DbHelperMsg();
  bool _isSelected;

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
                        title: Text(
                          '${_items[position].getDate}',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        subtitle: Text(
                          '${_items[position].getMsg}',
                          style: new TextStyle(
                            fontSize: 18.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        value: _items[position].getCheckBox,
                        onChanged: (bool newValue) {
                          print('position in ListView= ${position}');
                          setState(() {
                            _items[position].setCheckBox = newValue;
                          });
                          newValue
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
