import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  List<Map<String, dynamic>> _items = [];
  final shoppingBox = Hive.box('shopping_box'); //

  void _refreshItems() {
    final data = shoppingBox.keys.map((key) {
      final item = shoppingBox.get(key); // returns item of key denoted
      print('key is $item ');
      return {'key': key, 'name': item['name'], 'password': item['password']};
    }).toList();
    setState(() {
      _items = data.reversed.toList();
    });
    print('_items is ${_items}');
  }

  Future<void> _createBox(Map<String, dynamic> item) async {
    await shoppingBox.add(item);
    _refreshItems();
  }

  Future<void> _updateBox(int itemkey, Map<String, dynamic> item) async {
    await shoppingBox.put(itemkey, item);
    _refreshItems();
  }
  Future<void> _deleteBox(int itemkey)async{
    await shoppingBox.delete(itemkey);
    _refreshItems();
  }

  void showBottomModel(BuildContext context, int? itemkey) {
    if (itemkey != null) {
      final existingItem =
          _items.firstWhere((element) => element['key'] == itemkey);
      _nameController.text = existingItem['name'];
      _passwordController.text = existingItem['password'];
    }
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return SizedBox(
          // height: 300,
          height: MediaQuery.of(context).size.height * 0.5,

          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 8,
                  left: 8,
                  right: 8,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      label: Text('Name'),
                    ),
                  ),
                  TextField(
                    controller: _passwordController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      label: Text('Password'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (itemkey == null) {
                        _createBox({
                          'name': _nameController.text,
                          'password': _passwordController.text
                        });
                      }
                      if (itemkey != null) {
                        _updateBox(itemkey, {
                          'name': _nameController.text.trim(),
                          'password': _passwordController.text.trim()
                        });
                      }

                      print(shoppingBox.length);
                      _nameController.clear();
                      _passwordController.clear();
                      print('${shoppingBox.keys} : ${shoppingBox.values}');
                      Navigator.pop(context);
                    },
                    child: Text(itemkey == null ? 'submit' : 'update'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _refreshItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('hive'),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          var item = _items[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(item['name']),
              subtitle: Text(item['password']),
              tileColor: Colors.yellowAccent[100],
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () {
                        showBottomModel(context, item['key']);
                      },
                      icon: const Icon(Icons.edit)),
                   IconButton(
                    onPressed: (){_deleteBox(item['key']);},
                    icon:const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          return showBottomModel(context, null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
