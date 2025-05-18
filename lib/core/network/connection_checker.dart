import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class ConnectionChecker {
  //static var isConnected;

  Future<bool> get isConnected;
}

class ConnectionCheckerImpl implements ConnectionChecker {
  final InternetConnection internetConnection;
  ConnectionCheckerImpl(this.internetConnection);
  @override
  Future<bool> get isConnected async =>
      await internetConnection.hasInternetAccess; // this will just let us know that at any point  app has internet connection or not .
}
