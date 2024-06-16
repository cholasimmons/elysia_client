import 'dart:io';

import 'package:dummy/_utils/constants.dart';
import 'package:dummy/_utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StatsProvider with ChangeNotifier {
  String _serverName = 'Unknown';
  String _hostIP = 'Unknown';
  // String _connectionStatus = 'Unknown';
  ConnectionStatus _connectionStatus = ConnectionStatus.offline;
  String _authStatus = 'Unknown';

  bool _isLoadingServerName = false;
  bool _isLoadingHostIP = false;
  bool _isLoadingConnectionStatus = false;
  bool _isLoadingAuthStatus = false;

  String get serverName => _serverName;
  String get hostIP => _hostIP;
  ConnectionStatus get connectionStatus => _connectionStatus;
  String get authStatus => _authStatus;
  bool get isLoadingServerName => _isLoadingServerName;
  bool get isLoadingHostIP => _isLoadingHostIP;
  bool get isLoadingConnectionStatus => _isLoadingConnectionStatus;
  bool get isLoadingAuthStatus => _isLoadingAuthStatus;

  Future<void> fetchServerName() async {
    _connectionStatus = ConnectionStatus.connecting;
    _isLoadingServerName = true;
    notifyListeners();

    try {
      final response =
          await http.get(Uri.parse('${Constants.host}/server/name'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _serverName = data['name'];
      } else {
        throw Exception('Failed to load server name');
      }
    } on HandshakeException catch (e) {
      // Handle the HandshakeException
      print('HandshakeException: $e');
    } catch (e) {
      // Handle other exceptions
      print('Exception: $e');
    } finally {
      _isLoadingServerName = false;
      _connectionStatus = ConnectionStatus.online;
      notifyListeners();
    }
  }

  Future<void> fetchHostIP() async {
    _connectionStatus = ConnectionStatus.connecting;
    _isLoadingHostIP = true;
    notifyListeners();

    try {
      final response =
          await http.get(Uri.parse('${Constants.host}/server/host'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _hostIP = data['host'];
      } else {
        throw Exception('Failed to load host IP');
      }
    } on HandshakeException catch (e) {
      // Handle the HandshakeException
      print('HandshakeException: $e');
    } catch (e) {
      // Handle other exceptions
      print('Exception: $e');
    } finally {
      _isLoadingHostIP = false;
      _connectionStatus = ConnectionStatus.online;
      notifyListeners();
    }
  }

  Future<void> fetchConnectionStatus() async {
    _connectionStatus = ConnectionStatus.connecting;
    _isLoadingConnectionStatus = true;
    notifyListeners();

    try {
      final response =
          await http.get(Uri.parse('${Constants.host}/server/status'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _connectionStatus = data['status'];
      } else {
        throw Exception('Failed to load connection status');
      }
    } on HandshakeException catch (e) {
      // Handle the HandshakeException
      print('HandshakeException: $e');
    } catch (e) {
      // Handle other exceptions
      print('Exception: $e');
    } finally {
      _isLoadingConnectionStatus = false;
      _connectionStatus = ConnectionStatus.online;
      notifyListeners();
    }
  }

  Future<void> fetchAuthStatus() async {
    _connectionStatus = ConnectionStatus.connecting;
    _isLoadingAuthStatus = true;
    notifyListeners();

    try {
      final response =
          await http.get(Uri.parse('${Constants.host}/auth/status'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _authStatus = data['status'];
      } else {
        throw Exception('Failed to check auth status');
      }
    } on HandshakeException catch (e) {
      // Handle the HandshakeException
      print('HandshakeException: $e');
    } catch (e) {
      // Handle other exceptions
      print('Exception: $e');
    } finally {
      _isLoadingAuthStatus = false;
      _connectionStatus = ConnectionStatus.online;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    _connectionStatus = ConnectionStatus.connecting;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('${Constants.host}/'));

      if (response.statusCode == 200) {
        // final data = jsonDecode(response.body);
        // _authStatus = data['status'];
        print('Refresh Success');
      } else {
        throw Exception('Failed to refresh');
      }
    } on HandshakeException catch (e) {
      // Handle the HandshakeException
      print('HandshakeException: $e');
    } catch (e) {
      // Handle other exceptions
      print('Exception: $e');
    } finally {
      _connectionStatus = ConnectionStatus.online;
      notifyListeners();
    }
  }
}
