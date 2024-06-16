import 'package:dummy/_providers/auth_provider.dart';
import 'package:dummy/_providers/stats_provider.dart';
import 'package:dummy/_widgets/aboutDialog_widget.dart';
import 'package:dummy/_widgets/bottomsheet_widget.dart';
import 'package:dummy/_widgets/stats_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
    ValueNotifier<bool> isDialOpen = ValueNotifier(false);
    bool customDialRoot = true;
    bool extend = false;
    bool rmIcons = false;

    void _openIconButtonPressed() {
      showDialog(
          context: context,
          builder: (context) => aboutApp(),
          barrierColor: Colors.black87.withOpacity(0.5));
    }

    return ChangeNotifierProvider(
        create: (ctx) => AuthProvider(),
        child: Consumer<AuthProvider>(
            builder: (ctx, auth, _) => Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.inversePrimary,
                  titleTextStyle: const TextStyle(fontSize: 16),
                  // centerTitle: true,
                  title: Text(widget.title),
                  actions: <Widget>[
                    IconButton(
                        icon: const Icon(Icons.info),
                        onPressed: _openIconButtonPressed)
                  ],
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
                resizeToAvoidBottomInset: true,
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endDocked,
                floatingActionButton: SpeedDial(
                  icon: Icons.add,
                  activeIcon: Icons.close,
                  spacing: 3,
                  openCloseDial: isDialOpen,
                  childPadding: const EdgeInsets.all(4),
                  spaceBetweenChildren: 4,
                  buttonSize: const Size.fromRadius(36),
                  // label: extend ? Text('Open') : null,
                  childrenButtonSize: const Size.fromRadius(28),
                  visible: true,
                  direction: SpeedDialDirection.left,
                  switchLabelPosition: false,
                  closeManually: false,
                  useRotationAnimation: true,
                  elevation: 8,
                  animationDuration: const Duration(milliseconds: 600),
                  children: [
                    SpeedDialChild(
                      child: !rmIcons ? const Icon(Icons.computer) : null,
                      label: 'Configure Server',
                      backgroundColor: Colors.amber,
                      shape: const CircleBorder(),
                      onTap: () {
                        // Open the bottom sheet to configure the server
                        showModalBottomSheet(
                            context: context,
                            barrierColor: Colors.blueGrey.withOpacity(0.7),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(30))),
                            builder: (context) => Container(height: 300));
                      },
                    ),
                    // SpeedDialChild(
                    //   child: statsProvider.isLoadingConnectionStatus
                    //       ? const Icon(Icons.pause)
                    //       : const Icon(Icons.play_arrow),
                    //   label: statsProvider.isLoadingConnectionStatus
                    //       ? 'Stop Loading'
                    //       : 'Start Loading',
                    //   shape: const CircleBorder(),
                    //   onTap: () {
                    //     statsProvider.fetchConnectionStatus; // Toggle isLoading
                    //   },
                    // ),
                  ],
                  // This trailing comma makes auto-formatting nicer for build methods.
                ))));
  }
}
