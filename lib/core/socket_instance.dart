import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

// Singleton service to manage Socket.IO connection, globally available across the widget tree
class SocketService with WidgetsBindingObserver {
  // Singleton instance
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;
  bool _isConnected = false;
  String _userId =
      "67d107850965e9e646a51210"; // Simulated user ID (replace with actual user ID)

  // Get the socket instance
  IO.Socket get socket => _socket!;
  // Get connection status
  bool get isConnected => _isConnected;

  // Initialize the service (call in main.dart before runApp)
  Future<void> initialize() async {
    WidgetsBinding.instance.addObserver(this);
    connect(); // Connect to the socket (background service assumed to be handled)
  }

  // Connect to the Socket.IO server
  void connect() {
    if (_socket != null && _socket!.connected) return;

    _socket = IO.io(
      'http://192.168.1.68:5051', // Replace with your socketUrl
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableReconnection()
          .setReconnectionAttempts(200)
          .setReconnectionDelay(1000)
          .setReconnectionDelayMax(5000)
          .disableAutoConnect()
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      _isConnected = true;
      print('Socket connected');
      // Emit new-captain-connect event (similar to React Native)
      _socket!.emit('new-captain-connect', _userId);
    });

    _socket!.onDisconnect((_) {
      _isConnected = false;
      print('Socket disconnected');
    });

    _socket!.onConnectError((error) {
      print('Connection error: $error');
    });

    _socket!.onError((error) {
      print('Socket error: $error');
    });

    // Handle new-order in background
    socket.on('new-order', (data) async {
      print("New order received in SocketService: $data");
      // Trigger overlay in background
      if (await FlutterOverlayWindow.isActive()) {
        // Send data to existing overlay
        await FlutterOverlayWindow.shareData(data);
      } else {
        // Show new overlay
        await FlutterOverlayWindow.showOverlay(
          enableDrag: true,
          overlayTitle: "New Order",
          overlayContent: 'New order received',
          flag: OverlayFlag.defaultFlag,
          visibility: NotificationVisibility.visibilityPublic,
          positionGravity: PositionGravity.auto,
          height: 600,
          width: WindowSize.matchParent,
          startPosition: const OverlayPosition(0, -259),
        );

        // Send data to the new overlay
        await FlutterOverlayWindow.shareData(data);
      }
    });
  }

  // Disconnect from the server
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _isConnected = false;
  }

  // Emit an event to the server
  void emit(String event, dynamic data) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit(event, data);
    }
  }

  // Listen for an event from the server
  void on(String event, Function(dynamic) callback) {
    _socket?.on(event, callback);
  }

  // Handle app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('AppLifecycleState: $state');
    if (state == AppLifecycleState.detached) {
      disconnect();
    }
  }

  // Clean up resources
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    disconnect();
  }
}
