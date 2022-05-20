import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:band_names/models/models.dart';
import 'package:band_names/services/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<BandModel> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('active-bands', _handleActiveBands);

    super.initState();
  }

  _handleActiveBands(dynamic data) {
    bands = (data as List).map((e) => BandModel.fromMap(e)).toList();

    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);
    
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
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: socketService.serverStatus == ServerStatus.online ? Icon(
              Icons.check_circle,
              color: Colors.blue[300],
            ) : const Icon(
              Icons.offline_bolt,
              color: Colors.red,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          _showChart(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, index) => _buildBandTile(bands[index]),
            ),
          ),
        ],
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

    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(bandModel.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) => socketService.socket.emit('delete-band', {
        'id': bandModel.id
      }),
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
        onTap: () => socketService.socket.emit('vote-band', {
          'id': bandModel.id
        })        
      ),
    );
  }

  addNewBand() {

    final textEditingController = TextEditingController();

    if (Platform.isAndroid) {
      //* Android 
      return showDialog(
        context: context, 
        builder: (context) => AlertDialog(
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
        )        
      );
    }

    showCupertinoDialog(
      context: context, 
      builder: (context) => CupertinoAlertDialog(
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
      )
    );

  }

  void addBandToList(String bandName) {

    if (bandName.length > 1) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket.emit('add-band', {
        'name': bandName
      });
    }

    Navigator.pop(context);

  }

  Widget _showChart() {
    Map<String, double> dataMap = {};

    for (var element in bands) {
      dataMap.putIfAbsent(element.name, () => element.votes.toDouble());
    }

    final List<Color> colorList = [
      Colors.indigo,
      Colors.pink,
      Colors.yellow,
      Colors.amberAccent,
      Colors.blue,
      Colors.red
    ];

    return dataMap.isNotEmpty ? PieChart(
      dataMap: dataMap,
      animationDuration: const Duration(milliseconds: 800),
      // chartLegendSpacing: 32,
      // chartRadius: MediaQuery.of(context).size.width / 2.7,
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: ChartType.disc,
      ringStrokeWidth: 32,
      // centerText: "HYBRID",
      legendOptions: const LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: true,
        legendShape: BoxShape.circle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: const ChartValuesOptions(
        showChartValueBackground: true,
        // showChartValues: true,
        showChartValuesInPercentage: true,
        showChartValuesOutside: false,
        decimalPlaces: 1,
      ),
      // gradientList: ---To add gradient colors---
      // emptyColorGradient: ---Empty Color gradient---
    ) : Container();
  }
  
}