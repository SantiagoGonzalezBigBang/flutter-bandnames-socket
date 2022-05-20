import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

enum ServerStatus {
  online,
  offline,
  connecting
}

class SocketService with ChangeNotifier {

  SocketService(){
    _initConfig();
  }

  ServerStatus _serverStatus = ServerStatus.connecting;
  late socket_io.Socket _socket;
  
  ServerStatus get serverStatus => _serverStatus;
  socket_io.Socket get socket => _socket;
  // Function get emit => _socket.emit;



  void _initConfig() {

    // socket_io.Socket socket = socket_io.io('http://localhost:3000', {
    //   'transports': ['websocket'],
    //   'autoConnect': true
    // });
    
    _socket = socket_io.io('https://flutter-socket-server-santy.herokuapp.com', 
      socket_io.OptionBuilder()
        .setTransports(['websocket'])
        .enableAutoConnect()
        .build()
    );

    _socket.onConnect((_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });

    // _socket.on('nuevo-mensaje', (data) {
    //   print('nuevo-mensaje:');
    //   print('Nombre: ${data['nombre']}');
    //   print(data.containsKey('mensaje2') ? data['mensaje2'] : 'No hay');
    // });

  }
}