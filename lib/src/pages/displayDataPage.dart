import 'package:flutter/material.dart';
import 'signup.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Widget/bezierContainer.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../call_sample/call_sample.dart';
import 'congratulationPage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DisplayDataPage extends StatefulWidget {
  DisplayDataPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DisplayDataPageState createState() => _DisplayDataPageState();
}

class _DisplayDataPageState extends State<DisplayDataPage> {
  DateTime selectedbirthdate=null;
  File _imageFile=new File('');

  TextEditingController nikController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();
  TextEditingController birthplaceController = TextEditingController();
  TextEditingController mobilePhoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

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
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => VideoCallPage()));;

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => CallSample(host: 'demo.cloudwebrtc.com')));
          },
          child:

          Container(
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
              'Saya siap melakukan video call',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ));
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }



  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
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
          text: 'eKTP & Contact ',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'Information',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            // TextSpan(
            //   text: 'Form',
            //   style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            // ),
          ]),
    );
  }

  Widget _ektpFormWidget() {
    return Column(
      children: <Widget>[
        showNikInput(true),
        //showNameInput(true),
        buildTextFormFieldName(),
        showBirthdateInput(true),
        showBirthplaceInput(false),
        showEmailInput(true),
        showMobilePhoneInput(true),
        showUploadEktpButton(),
        showUploadSelfieButton(),
        showUploadSelfieEktpButton(),
        showUploadNpwpButton()
        // _entryField("Email id"),
        // _entryField("Password", isPassword: true),
      ],
    );
  }

  Widget showNikInput(bool isMandatory) {
    String label=(isMandatory)?'NIK *':'NIK';
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
      child: new TextFormField(
        // obscureText: true,
        // obscuringCharacter: "*",
        maxLines: 1,
        keyboardType: TextInputType.number,
        autofocus: false,
        controller: nikController,
        decoration: new InputDecoration(
            hintText: label,
            icon: new Icon(
              Icons.credit_card,
              color: Colors.grey,
            )),
        // onChanged: (text) {
        //   resetPreSubmitErrorMessage();
        //   resetPostSubmitErrorMessages();
        // },
        validator: (value) {
          // if (value.isEmpty) {
          //   return 'NIK can\'t be empty';
//          } else if (!RegExp(r"^[0-9]*").hasMatch(value.trim())) {
//              return 'NIK can only be numbers';
//          } else if (value.trim().length!=16) {
//            return 'NIK character amount is wrong';
//          }
        },
        onSaved: (value) => firestoreNik = value,
//        onSaved: (value) => _email = value.trim(),
//        onChanged: (value) {
//          debugPrint('Something changed in Title Email Field');
//          updateEmailContent();
//        },
      ),
    );
  }

  Widget showNameInput(bool isMandatory) {
    String label=(isMandatory)?'Name *':'Name';
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        controller: nameController,
        decoration: new InputDecoration(
            hintText: label,
            icon: new Icon(
              Icons.person,
              color: Colors.grey,
            )),
        validator: (value) {
//          if (value.isEmpty) {
//            return 'Name can\'t be empty';
//          } else if (!RegExp(r"[a-zA-Z ]*").hasMatch(value)) {
//              return 'Name can only contains alphabets';
//          } else if (value.trim().length<1){
//            return 'Name can\'t be empty';
//          }
        },
      ),
    );
  }

  Widget showBirthdateInput(isMandatory) {
    String label=(isMandatory)?'Birthdate *':'Birthdate';
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        // obscureText: true,
        // obscuringCharacter: "*",
        maxLines: 1,
        keyboardType: TextInputType.datetime,
        autofocus: false,
        controller: birthdateController,
        decoration: new InputDecoration(
            hintText: label,
            icon: new Icon(
              Icons.calendar_today,
              color: Colors.grey,
            )),
        onTap: () {
          showDatePicker(
            context:this.context,
            //initialDate:selectedbirthdate==null? DateTime.now():selectedbirthdate,
            initialDate:DateTime.now(),
            //firstDate: DateTime.now().add(Duration(years:16)),
            firstDate: DateTime(1900, 1, 1),
            lastDate:DateTime.now(),
            //lastDate: Jiffy(DateTime.now()).add(years: -17)
          ).then((selectedDate){
            selectedbirthdate=selectedDate;
            birthdateController.text= DateFormat('dd-MM-yyyy').format(selectedDate).toString();
            //new DateFormat.yMMMd().format(selectedDate);
                ;
          });
        },
        onChanged: (value) {
          updatebirthdate();
        },
      ),
    );
  }

  Widget showBirthplaceInput(bool isMandatory) {
    String label=(isMandatory)?'Birthplace *':'Birthplace';
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        controller: birthplaceController,
        decoration: new InputDecoration(
            hintText: label,
            icon: new Icon(
              Icons.location_city,
              color: Colors.grey,
            )),
        validator: (value) {
//          if (value.isEmpty) {
//            return 'Birthplace can\'t be empty';
//          } else if (!RegExp(r"[a-zA-Z ]*").hasMatch(value)) {
//            return 'Birthplace can only contains alphabets';
//          } else if (value.trim().length<1){
//            return 'Birthplace can\'t be empty';
//          }
        },
//        onSaved: (value) => _email = value.trim(),
//        onChanged: (value) {
//          debugPrint('Something changed in Title Email Field');
//          updateEmailContent();
//        },
      ),
    );
  }

  Widget showMobilePhoneInput(bool isMandatory) {
    String label=(isMandatory)?'Mobile Phone Number * (e.g. 08xxxxx)':'Mobile Phone Number (e.g. 08xxxxx)';
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        // obscureText: true,
        // obscuringCharacter: "*",
        keyboardType: TextInputType.phone,
        autofocus: false,
        controller: mobilePhoneController,
        decoration: new InputDecoration(
            hintText: label,
            icon: new Icon(
              Icons.phone_android,
              color: Colors.grey,
            )),
        validator: (value) {
//          if (value.isEmpty) {
//            return 'Mobile Phone can\'t be empty';
//          } else if (!RegExp(r"^[0-9]*").hasMatch(value.trim())) {
//            return 'Mobile Phone can only be numbers';
//          } else if (value.trim().length<12) {
//            return 'Mobile Phone digit amount is wrong';
//          }
        },
//        onSaved: (value) => _email = value.trim(),
//        onChanged: (value) {
//          debugPrint('Something changed in Title Email Field');
//          updateEmailContent();
//        },
      ),
    );
  }

  Widget showEmailInput(bool isMandatory) {
    String label=(isMandatory)?'Email *':'Email';
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        controller: emailController,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) {
//          if (value.isEmpty) {
//            return 'Name can\'t be empty';
//          } else if (!RegExp(r"[a-zA-Z ]*").hasMatch(value)) {
//              return 'Name can only contains alphabets';
//          } else if (value.trim().length<1){
//            return 'Name can\'t be empty';
//          }
        },
      ),
    );
  }

  Widget showUploadSelfieButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.lightBlue,
            child: new Text('Ambil Foto Selfie',
                style: new TextStyle(fontSize: 12.0, color: Colors.white)),
            //onPressed: () { navigateToPage('Login Face');}
            onPressed: getImage,
          ),
        ));
  }

  Widget showUploadEktpButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.lightBlue,
            child: new Text('Ambil Foto eKTP',
                style: new TextStyle(fontSize: 12.0, color: Colors.white)),
            //onPressed: () { navigateToPage('Login Face');}
            onPressed: getImage,
          ),
        ));
  }

  Widget showUploadSelfieEktpButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.lightBlue,
            child: new Text('Foto Selfie dg eKTP Bawah Dagu',
                style: new TextStyle(fontSize: 12.0, color: Colors.white)),
            //onPressed: () { navigateToPage('Login Face');}
            onPressed: getImage,
          ),
        ));
  }

  Widget showUploadNpwpButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.lightBlue,
            child: new Text('Ambil Foto NPWP',
                style: new TextStyle(fontSize: 12.0, color: Colors.white)),
            //onPressed: () { navigateToPage('Login Face');}
            onPressed: getImage,
          ),
        ));
  }

  Future getImage() async {

    File registerSelfieimage;
    //Future<bool> faceMatchFound=Future<bool>.value(false);
    bool faceMatchFound1 = false;
    registerSelfieimage= await ImagePicker.pickImage(source: ImageSource.camera);
    if(registerSelfieimage != null) {
      File cropped = await ImageCropper.cropImage(
          sourcePath: registerSelfieimage.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 80,
          maxWidth: 300,
          maxHeight: 400,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.blueAccent,
            toolbarTitle: "Adjust Like Passport Photo",
            statusBarColor: Colors.blue,
            backgroundColor: Colors.white,
          )
      );

      registerSelfieimage=cropped;
      // _errorMessage='';
    }

    setState(() {
      _imageFile = registerSelfieimage;
    });

  }

  Widget showUploadPhotoButton(String photoTypeName){
    return Padding(
        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
        child: RaisedButton(
          color: Colors.orange,
          textColor: Colors.white,
          child:
          photoTypeName=='selfie'?
          Text(
            'Take Selfie',
            textScaleFactor: 1.5,
          ):
          Text(
            'Take eKTP Photo',
            textScaleFactor: 1.5,
          ),
          onPressed: () {
            getImage;
            //_getImage(this.context, ImageSource.camera);
//        setState(() {
//          debugPrint("Photo button clicked");
//
//        });
          },
        )
    );
  }

  // _getImage(BuildContext context, ImageSource source) async{
  //   this.setState(() {
  //     loading = true;
  //   });
  //   try{
  //     Directory tempDir = await getTemporaryDirectory();
  //     String tempPath = tempDir.path;
  //
  //     if (await tempDir.exists())
  //       tempDir.delete(recursive: false);
  //
  //     Directory appdocdir= await getApplicationSupportDirectory();
  //     String test=appdocdir.path;
  //
  //     if (await appdocdir.exists())
  //       appdocdir.delete(recursive: false);
  //
  //     var picture =  await ImagePicker.pickImage(source: source);
  //
  //     int appFileDirectory=picture.path.lastIndexOf('/');
  //     String resultDirectory=picture.path.substring(0,appFileDirectory+1); // = appdocdir+'/Pictures/'
  //     String resultPath=resultDirectory+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';
  //     //String resultPath='/storage/emulated/0/Android/data/com.smartherd.flutter_app_section2/files/Pictures/'+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';
  //
  //     int photoQuality=50;
  //     if(picture != null) {
  //       try {
  //         var result = await FlutterImageCompress.compressAndGetFile(
  //           picture.absolute.path, resultPath,
  //           quality: photoQuality,
  //         );
  //
  //         int pictureLength=picture.lengthSync();
  //         int resultLength=result.lengthSync();
  //
  //         var i = 1;
  //
  //         while ((resultLength < professionalMinPhotoSize || resultLength > professionalMaxPhotoSize) && photoQuality>0 && photoQuality<100) {
  //           if (result!=null)
  //             await result.delete();
  //           resultPath=resultDirectory+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';
  //           photoQuality=(resultLength>professionalMaxPhotoSize)? photoQuality-10:photoQuality+10;
  //           result = await FlutterImageCompress.compressAndGetFile(
  //             picture.absolute.path, resultPath,
  //             quality: photoQuality,
  //           );
  //           resultLength=result.lengthSync();
  //         }
  //
  //         double sizeinKb=resultLength.toDouble()/1024;
  //         debugPrint('Photo compressed size is '+sizeinKb.toString()+' kb');
  //         //print(pictureLength+resultLength);
  //         await picture.delete();
  //         this.setState(() {
  //           //_imageFileProfile = cropped;
  //           _professionalImage = result;
  //           loading = false;
  //         });
  //       } catch (e) {
  //         print (e);
  //         debugPrint("Error $e");
  //       }
  //     }else{
  //       this.setState(() {
  //         loading = false;
  //       });
  //     }
  //   } catch (e) {
  //     print (e);
  //     debugPrint("Error $e");
  //   }
  //   //Navigator.of(context).pop();
  // }

  Widget showPhotoUploadedInfo() {
    if (_imageFile != null) {
      return new Padding(
          padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
          child: new Center(
              child:
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const <Widget>[
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 24.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                  Text(
                    'This photo is successfully uploaded',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.green,
                        height: 1.0,
                        fontWeight: FontWeight.bold),
                  )
                ],
              )
          ));
    } else {
      return new Padding(
          padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
          child: new Center(
              child:
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const <Widget>[
                  Icon(
                    Icons.info,
                    color: Colors.lightBlue,
                    size: 20.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                  Text(
                    ' Must upload this photo',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.lightBlue,
                        height: 1.0,
                        fontWeight: FontWeight.bold),
                  )
                ],
              )
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
          height: height,
            child: Stack(
              children: <Widget> [
                Positioned(
                  top: -MediaQuery.of(context).size.height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: BezierContainer(),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ListView(
                      padding: EdgeInsets.all(8),
                      children: <Widget>[
                        SizedBox(height: 150),
                        _title(),
                        SizedBox(height: 100),
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
                        SizedBox(height: 50),
                        _showNextButton()
                      ],
                    )
                  // firestore end
            )
              ]
            )
        )
        // firestore start

    );
  }

  Widget _showNextButton() {
    return
      InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CongratulationPage(email: firestoreEmail)));;
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
              'Langkah Berikutnya',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          )
      );

  }

  Widget buildItem(DocumentSnapshot doc) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget> [
              Text(
                  'Name: ${(doc.data() as dynamic)['name']}',
                  style: TextStyle(fontSize: 18)
              ),
              Text(
                  'NIK: ${(doc.data() as dynamic)['nik']}',
                  style: TextStyle(fontSize: 18)
              ),
              Text(
                  'Birthdate: ${(doc.data() as dynamic)['dob']}',
                  style: TextStyle(fontSize: 18)
              ),
              Text(
                  'Birth Place: ${(doc.data() as dynamic)['pob']}',
                  style: TextStyle(fontSize: 18)
              ),
              Text(
                  'Email: ${(doc.data() as dynamic)['email']}',
                  style: TextStyle(fontSize: 18)
              ),
              Text(
                  'Mobile Phone Number: ${(doc.data() as dynamic)['mobile']}',
                  style: TextStyle(fontSize: 18)
              ),
              SizedBox(height: 12),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: <Widget>[
              //     FlatButton(
              //       onPressed: () =>
              //     )
              //   ],
              // )
            ]
        )
    );
  }

  Widget build2(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: -height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: BezierContainer()),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      _title(),
                      SizedBox(height: 50),
                      _ektpFormWidget(),
                      SizedBox(height: 20),
                      _submitButton(),
                      SizedBox(height: 20)
                      // Container(
                      //   padding: EdgeInsets.symmetric(vertical: 10),
                      //   alignment: Alignment.centerRight,
                      //   child: Text('Forgot Password ?',
                      //       style: TextStyle(
                      //           fontSize: 14, fontWeight: FontWeight.w500)),
                      // ),
                      //_divider(),
                      //_facebookButton(),
                      //SizedBox(height: height * .055),
                      //_createAccountLabel(),
                    ],
                  ),
                ),
              ),
              Positioned(top: 40, left: 0, child: _backButton()),
              // firestore start
              ListView(
                padding: EdgeInsets.all(8),
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: buildTextFormFieldName(),
                  ),
                  Row (
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: createData,
                        child: Text('Create', style: TextStyle(color: Colors.black)),
                        color: Colors.green,
                      ),
                      RaisedButton(
                        onPressed: firestoreId != null? readData: null,
                        child: Text('Read', style: TextStyle(color: Colors.black)),
                        color: Colors.blue,
                      )

                    ],
                  ),
                ],
              )
              // firestore end
            ],
          ),
        ));
  }

  void createData() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      DocumentReference ref = await db.collection('form').add({'name': '$firestoreName', 'nik': '$firestoreNik', 'address': '$firestoreAddress', 'birthdate': '$firestoreBirthdate', 'birthday': '$firestoreBirthday', 'mobilePhone': '$firestoreMobilePhone', 'email': '$firestoreEmail'});
      setState(() => firestoreId = ref.id);
      print (ref.id);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => CallSample(host: 'demo.cloudwebrtc.com')));
    }
  }

  void readData() async {
    DocumentSnapshot snapshot = await db.collection('form').doc(firestoreId).get();
    print ((snapshot.data as dynamic)['name']);
  }

  TextFormField buildTextFormFieldName(){
    return TextFormField (
      decoration: new InputDecoration(
          hintText: 'Name',
          icon: new Icon(
            Icons.person,
            color: Colors.grey,
          )),
      // validator: (value) {
      //   if (value.isEmpty) {
      //     return 'Please enter some text';
      //   }
      // },
      onSaved: (value) => firestoreName = value,
    );
  }

  TextFormField buildTextFormFieldNik(){
    return TextFormField (
      decoration: new InputDecoration(
          hintText: 'NIK',
          icon: new Icon(
            Icons.credit_card,
            color: Colors.grey,
          )),
      // validator: (value) {
      //   if (value.isEmpty) {
      //     return 'Please enter some text';
      //   }
      // },
      onSaved: (value) => firestoreNik = value,
    );
  }

  TextFormField buildTextFormFieldAddress(){
    return TextFormField (
      decoration: new InputDecoration(
          hintText: 'Address',
          icon: new Icon(
            Icons.home,
            color: Colors.grey,
          )),
      // validator: (value) {
      //   if (value.isEmpty) {
      //     return 'Please enter some text';
      //   }
      // },
      onSaved: (value) => firestoreAddress = value,
    );
  }

  TextFormField buildTextFormFieldBirthdate(){
    return TextFormField (
      decoration: new InputDecoration(
          hintText: 'Birthdate',
          icon: new Icon(
            Icons.calendar_today,
            color: Colors.grey,
          )),
      // validator: (value) {
      //   if (value.isEmpty) {
      //     return 'Please enter some text';
      //   }
      // },
      onSaved: (value) => firestoreBirthdate = value,
    );
  }

  TextFormField buildTextFormFieldBirthday(){
    return TextFormField (
      decoration: new InputDecoration(
          hintText: 'Birthday',
          icon: new Icon(
            Icons.location_city,
            color: Colors.grey,
          )),
      // validator: (value) {
      //   if (value.isEmpty) {
      //     return 'Please enter some text';
      //   }
      // },
      onSaved: (value) => firestoreBirthday = value,
    );
  }

  TextFormField buildTextFormFieldEmail(){
    return TextFormField (
      decoration: new InputDecoration(
          hintText: 'Email',
          icon: new Icon(
            Icons.mail,
            color: Colors.grey,
          )),
      // validator: (value) {
      //   if (value.isEmpty) {
      //     return 'Please enter some text';
      //   }
      // },
      onSaved: (value) => firestoreEmail = value,
    );
  }

  TextFormField buildTextFormFieldMobilePhone(){
    return TextFormField (
      decoration: new InputDecoration(
          hintText: 'Mobile Phone Number (e.g. 08xxxx)',
          icon: new Icon(
            Icons.phone_android,
            color: Colors.grey,
          )),
      // validator: (value) {
      //   if (value.isEmpty) {
      //     return 'Please enter some text';
      //   }
      // },
      onSaved: (value) => firestoreMobilePhone = value,
    );
  }


  void updatebirthdate(){
    //note.title = titleController.text;
    birthdateController.text= (selectedbirthdate==null? '':selectedbirthdate.toString());
  }
}
