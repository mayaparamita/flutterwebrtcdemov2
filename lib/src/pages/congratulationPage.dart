import 'package:flutter/material.dart';
import '../../Widget/bezierContainer.dart';
import 'loginPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'WelcomePage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class CongratulationPage extends StatefulWidget {
  CongratulationPage({Key key, this.title, this.email}) : super(key: key);

  final String title;
  final String email;


  @override
  _CongratulationPageState createState() => _CongratulationPageState();
}

class _CongratulationPageState extends State<CongratulationPage> {
  //firestore
  String firestoreId;
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String firestoreName;
  String firestoreNik;
  String firestoreAddress;
  String firestoreBirthdate;
  String firestoreBirthday;
  String firestoreMobilePhone;
  String firestoreEmail;

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return
      InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => WelcomePage()));;
          },
          child:Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.shade200,
                      offset: Offset(2, 4),
                      blurRadius: 5,
                      spreadRadius: 2)
                ],
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xfffbb448), Color(0xfff7892b)])),
            child: Text(
              'Selesai',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          )
      );

  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => WelcomePage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'IST',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: ' Bank',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            // TextSpan(
            //   text: 'rnz',
            //   style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            // ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Username"),
        _entryField("Email id"),
        _entryField("Password", isPassword: true),
      ],
    );
  }
  Widget buildItem(DocumentSnapshot doc) {
    return Text(
        '${(doc.data() as dynamic)['email']}',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    //String emailAddress= widget.email.toString();
    //print('INI EMAIL ADDRESS: '+emailAddress);

    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .1),
                    _title(),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      'Selamat! Anda telah berhasil membuka rekening di Bank IST!',
                      style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold), textAlign: TextAlign.left,
                    ),
                    //_emailPasswordWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Proses verifikasi bapak/ibu sudah selesai. Pemberitahuan akan kami kirimkan melalui email:',
                      style: TextStyle(color: Colors.black, fontSize: 17), textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: db.collection('form').snapshots(),
                        builder: (context, snapshot){
                          if (snapshot.hasData) {
                            return Column(children:snapshot.data.docs.map((doc)=> buildItem(doc)).toList());
                          } else {
                            return SizedBox();
                          }
                        }
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Silahkan bapak/ibu cek di email tsb untuk melihat hasil verifikasi dari pihak Bank dalam 24 jam',
                      style: TextStyle(color: Colors.black, fontSize: 17), textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    _submitButton(),
                    SizedBox(height: height * .14),
                    //_loginAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
