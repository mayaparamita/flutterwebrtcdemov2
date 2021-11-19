import 'package:flutter/material.dart';
import 'pages/splashscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/welcomePage.dart';

void main3() {
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
