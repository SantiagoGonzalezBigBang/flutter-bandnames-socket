import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_names/models/models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<BandModel> bands = [
    BandModel(id: '1', name: 'Metalica', votes: 5),
    BandModel(id: '2', name: 'Queen', votes: 1),
    BandModel(id: '3', name: 'Heroes del silencio', votes: 2),
    BandModel(id: '4', name: 'Bon Jovi', votes: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: const Text(
          'Band Names',
          style: TextStyle(
            color: Colors.black87
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, index) => _buildBandTile(bands[index]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1.0,
        child: const Icon(
          Icons.add
        ),
      ),
    );
  }

  Widget _buildBandTile(BandModel bandModel) {
    return Dismissible(
      key: Key(bandModel.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        // print(direction);
      },
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.only(left: 8.0),
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Delete Band',
            style: TextStyle(
              color: Colors.white
            ),
          ),
        )
      ),
      child: ListTile(      
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(bandModel.name.substring(0,2)),
        ),
        title: Text(
          bandModel.name
        ),
        trailing: Text(
          '${bandModel.votes}',
          style: const TextStyle(
            fontSize: 20.0
          ),
        ),
        onTap: () {
          // print(bandModel.name);
        },
      ),
    );
  }

  addNewBand() {

    final textEditingController = TextEditingController();

    if (Platform.isAndroid) {
      //* Android 
      return showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'New band name:'
            ),
            content: TextField(
              controller: textEditingController,
            ),
            actions: [
              MaterialButton(
                onPressed: () => addBandToList(textEditingController.text),
                elevation: 5.0,
                textColor: Colors.blue,
                child: const Text(
                  'Add'
                ),
              )
            ],
          );
        }
      );
    }

    showCupertinoDialog(
      context: context, 
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text(
            'New band name:'
          ),
          content: CupertinoTextField(
            controller: textEditingController,
          ),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Dismiss'
              )
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => addBandToList(textEditingController.text),
              child: const Text(
                'Add'
              )
            ),
          ],
        );
      }
    );

  }

  void addBandToList(String bandName) {

    if (bandName.length > 1) {
      bands.add(
        BandModel(id: DateTime.now().toString(), name: bandName, votes: 0)
      );
      setState(() {});
    } 

    Navigator.pop(context);

  }
  
}