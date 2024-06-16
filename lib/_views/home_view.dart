import 'package:dummy/_providers/auth_provider.dart';
import 'package:dummy/_providers/stats_provider.dart';
import 'package:dummy/_widgets/stats_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.title});

  // Fields in a Widget subclass are always marked "final".

  final String title;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _status = "INACTIVE";

  void _connect() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _status = "CONNECTING";
      if (kDebugMode) {
        print('_connection function');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    final statsProvider = Provider.of<StatsProvider>(context);

    return ChangeNotifierProvider(
        create: (ctx) => AuthProvider(),
        child: Consumer<AuthProvider>(
            builder: (ctx, auth, _) => Scaffold(
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    titleTextStyle: const TextStyle(fontSize: 14),
                    title: Text(widget.title),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StatWidget(
                          title: 'Server Name',
                          statValue: statsProvider.isLoadingServerName
                              ? 'Fetching...'
                              : statsProvider.serverName,
                          isLoading: statsProvider.isLoadingServerName,
                          fetchFunction: statsProvider.fetchServerName,
                        ),
                        StatWidget(
                          title: 'Host IP',
                          statValue: statsProvider.isLoadingHostIP
                              ? 'Fetching...'
                              : statsProvider.hostIP,
                          isLoading: statsProvider.isLoadingHostIP,
                          fetchFunction: statsProvider.fetchHostIP,
                        ),
                        StatWidget(
                            title: 'Connection Status',
                            statValue: statsProvider.isLoadingConnectionStatus
                                ? 'Fetching...'
                                : '${statsProvider.connectionStatus}',
                            isLoading:
                                false, // statsProvider.isLoadingConnectionStatus,
                            fetchFunction:
                                null // statsProvider.fetchConnectionStatus,
                            ),
                        StatWidget(
                          title: 'Authenticated',
                          statValue: auth.isLoading
                              ? 'Checking...'
                              : auth.user == null
                                  ? 'No'
                                  : auth.user!.email,
                          isLoading: statsProvider.isLoadingAuthStatus,
                          fetchFunction: statsProvider.fetchAuthStatus,
                        ),
                      ],
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: statsProvider.fetchConnectionStatus,
                    tooltip: 'Refresh',
                    child: Align(
                      alignment: Alignment.center,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 700),
                        transform: Matrix4.rotationZ(
                            statsProvider.isLoadingConnectionStatus
                                ? 3.14
                                : 0), // Rotate 180 degrees if isLoading is true
                        child: const Icon(Icons.sync),
                      ),
                    ),
                  ), // This trailing comma makes auto-formatting nicer for build methods.
                )));
  }
}
