// import 'dart:core';
//
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'src/call_sample/call_sample.dart';
// import 'src/call_sample/data_channel_sample.dart';
// import 'src/route_item.dart';
//
// void main() => runApp(new MyApp());
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => new _MyAppState();
// }
//
// enum DialogDemoAction {
//   cancel,
//   connect,
// }
//
// class _MyAppState extends State<MyApp> {
//   List<RouteItem> items;
//   String _server = '';
//   SharedPreferences _prefs;
//
//   bool _datachannel = false;
//   @override
//   initState() {
//     super.initState();
//     _initData();
//     _initItems();
//   }
//
//   _buildRow(context, item) {
//     return ListBody(children: <Widget>[
//       ListTile(
//         title: Text(item.title),
//         onTap: () => item.push(context),
//         trailing: Icon(Icons.arrow_right),
//       ),
//       Divider()
//     ]);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//           appBar: AppBar(
//             title: Text('Flutter-WebRTC example'),
//           ),
//           body: ListView.builder(
//               shrinkWrap: true,
//               padding: const EdgeInsets.all(0.0),
//               itemCount: items.length,
//               itemBuilder: (context, i) {
//                 return _buildRow(context, items[i]);
//               })),
//     );
//   }
//
//   _initData() async {
//     _prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _server = _prefs.getString('server') ?? 'demo.cloudwebrtc.com';
//     });
//   }
//
//   void showDemoDialog<T>({BuildContext context, Widget child}) {
//     showDialog<T>(
//       context: context,
//       builder: (BuildContext context) => child,
//     ).then<void>((T value) {
//       // The value passed to Navigator.pop() or null.
//       if (value != null) {
//         if (value == DialogDemoAction.connect) {
//           _prefs.setString('server', _server);
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (BuildContext context) => _datachannel
//                       ? DataChannelSample(host: _server)
//                       : CallSample(host: _server)));
//         }
//       }
//     });
//   }
//
//   _showAddressDialog(context) {
//     showDemoDialog<DialogDemoAction>(
//         context: context,
//         child: AlertDialog(
//             title: const Text('Enter server address:'),
//             content: TextField(
//               onChanged: (String text) {
//                 setState(() {
//                   _server = text;
//                 });
//               },
//               decoration: InputDecoration(
//                 hintText: _server,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             actions: <Widget>[
//               FlatButton(
//                   child: const Text('CANCEL'),
//                   onPressed: () {
//                     Navigator.pop(context, DialogDemoAction.cancel);
//                   }),
//               FlatButton(
//                   child: const Text('CONNECT'),
//                   onPressed: () {
//                     Navigator.pop(context, DialogDemoAction.connect);
//                   })
//             ]));
//   }
//
//   _initItems() {
//     items = <RouteItem>[
//       RouteItem(
//           title: 'P2P Call Sample',
//           subtitle: 'P2P Call Sample.',
//           push: (BuildContext context) {
//             _datachannel = false;
//             _showAddressDialog(context);
//           }),
//       RouteItem(
//           title: 'Data Channel Sample',
//           subtitle: 'P2P Data Channel.',
//           push: (BuildContext context) {
//             _datachannel = true;
//             _showAddressDialog(context);
//           }),
//     ];
//   }
// }

import 'package:flutter/material.dart';
import '../../src/pages/splashscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/welcomePage.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen.timer(
      seconds: 3,
      navigateAfterSeconds: AfterSplash(),
      title: Text(
        'IST Mobile Banking',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      image: Image.asset('images/logoist.jpg'),
      photoSize: 150.0,
      backgroundColor: Colors.white,
      loaderColor: Colors.red,
    );
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Welcome In SplashScreen Package'),
    //     automaticallyImplyLeading: false,
    //   ),
    //   body: Center(
    //     child: Text(
    //       'Succeeded!',
    //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
    //     ),
    //   ),
    // );
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme:GoogleFonts.latoTextTheme(textTheme).copyWith(
          bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}

