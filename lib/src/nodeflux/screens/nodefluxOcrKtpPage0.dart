import 'dart:convert';
import 'dart:io';

import '../../../Widget/bezierContainer.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import "package:image_cropper/image_cropper.dart";
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
// import 'package:simple_app/model/faceVerifModel.dart';
// import 'package:simple_app/model/fetchIdCardModel.dart';
import '../../models/ktpModel.dart';
// import 'package:simple_app/model/ocrModel.dart';
//import 'package:simple_app/views/fetchIdCard.dart';
import 'nodefluxOcrKtpResult.dart';
import "package:image_cropper/image_cropper.dart";

import '../models/nodeflux_data_model.dart';
import '../models/nodeflux_job_model.dart';
import '../models/nodeflux_result_model.dart';
import '../models/nodeflux_result2_model.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class NodefluxOcrKtp0 extends StatefulWidget {
//  File imageFileProfile;
//  OkayfaceOcr1({this.imageFileProfile});

  @override
  _NodefluxOcrKtp0State createState() => _NodefluxOcrKtp0State();
}

class _NodefluxOcrKtp0State extends State<NodefluxOcrKtp0> {
  File _imageFileIdCard;
  File _ektpImage;

  var loading = false;
  bool _inProcess = false;
  int ocrMinPhotoSize=256000; // 250KB as min photo size is not mentioned
  int ocrMaxPhotoSize=819200; //800KB as mentioned in Nodeflux API doc
  int minPhotoSize=256000; // 250KB
  int maxPhotoSize=512000; // 500KB

  //File _ocrImage;

  createAlertDialogIdCard(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Make a Choice!"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      //_getImage(context, ImageSource.gallery);
                      _getEktpImage(context, ImageSource.gallery);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      //_getImage(context, ImageSource.camera);
                      _getEktpImage(context, ImageSource.camera);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  _getImage_withCompress(BuildContext context, ImageSource source) async{
    this.setState(() {
      loading = true;
    });
    try{
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      if (await tempDir.exists())
        tempDir.delete(recursive: false);

      Directory appdocdir= await getApplicationSupportDirectory();
      String test=appdocdir.path;

      if (await appdocdir.exists())
        appdocdir.delete(recursive: false);

      var picture =  await ImagePicker.pickImage(source: source);

      int appFileDirectory=picture.path.lastIndexOf('/');
      String resultDirectory=picture.path.substring(0,appFileDirectory+1); // = appdocdir+'/Pictures/'
      String resultPath=resultDirectory+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';
      //String resultPath='/storage/emulated/0/Android/data/com.smartherd.flutter_app_section2/files/Pictures/'+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';

      int photoQuality=50;
      if(picture != null) {
        try {
          var result = await FlutterImageCompress.compressAndGetFile(
            picture.absolute.path, resultPath,
            quality: photoQuality,
          );

          int pictureLength=picture.lengthSync();
          int resultLength=result.lengthSync();

          var i = 1;

          while ((resultLength < ocrMinPhotoSize || resultLength > ocrMaxPhotoSize) && photoQuality>0 && photoQuality<100) {
            if (result!=null)
              await result.delete();
            resultPath=resultDirectory+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';
            photoQuality=(resultLength>ocrMaxPhotoSize)? photoQuality-10:photoQuality+10;
            result = await FlutterImageCompress.compressAndGetFile(
              picture.absolute.path, resultPath,
              quality: photoQuality,
            );
            resultLength=result.lengthSync();
          }

          double sizeinKb=resultLength.toDouble()/1024;
          debugPrint('Photo compressed size is '+sizeinKb.toString()+' kb');
          //print(pictureLength+resultLength);
          await picture.delete();
          this.setState(() {
            //_imageFileProfile = cropped;
            _imageFileIdCard = result;
            loading = false;
          });
        } catch (e) {
          print (e);
          debugPrint("Error $e");
        }
      }else{
        this.setState(() {
          loading = false;
        });
      }
    } catch (e) {
      print (e);
      debugPrint("Error $e");
    }
    //Navigator.of(context).pop();
  }

  // _getOcrImage(BuildContext context, ImageSource source) async{
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
  //     if(picture != null){
  //       File cropped = await ImageCropper.cropImage(
  //           sourcePath: picture.path,
  //           aspectRatio: CropAspectRatio(ratioX: 8, ratioY: 5),
  //           compressQuality: 100,
  //           maxWidth: 640,
  //           maxHeight: 480,
  //           compressFormat: ImageCompressFormat.jpg,
  //           androidUiSettings: AndroidUiSettings(
  //             toolbarColor: Colors.deepOrange,
  //             toolbarTitle: "RPS Cropper",
  //             statusBarColor: Colors.deepOrange.shade900,
  //             backgroundColor: Colors.white,
  //           )
  //       );
  //
  //       picture = cropped;
  //       int appFileDirectory=picture.path.lastIndexOf('/');
  //       String resultDirectory=picture.path.substring(0,appFileDirectory+1); // = appdocdir+'/Pictures/'
  //       String resultPath=resultDirectory+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';
  //       //String resultPath='/storage/emulated/0/Android/data/com.smartherd.flutter_app_section2/files/Pictures/'+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';
  //
  //       int photoQuality=50;
  //       if(picture != null) {
  //         // try {
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
  //         while ((resultLength < ocrMinPhotoSize || resultLength > ocrMaxPhotoSize) && photoQuality>0 && photoQuality<100) {
  //           if (result!=null)
  //             await result.delete();
  //           resultPath=resultDirectory+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';
  //           photoQuality=(resultLength>ocrMaxPhotoSize)? photoQuality-10:photoQuality+10;
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
  //         _ocrImage = result;
  //         ocrProcess(this.context);
  //         // this.setState(() {
  //         //   _ocrImage = result;
  //         //   loading = false;
  //         // });
  //       }  else {
  //         this.setState(() {
  //           loading = false;
  //           createAlertDialog(this.context, 'Error','Error taking photos. Please redo.');
  //         });
  //       }// end if picture after cropped is not null
  //     } else{ // if picture before cropped is null
  //       this.setState(() {
  //         loading = false;
  //         createAlertDialog(this.context, 'Error','Error taking photos. Please redo.');
  //       });
  //     }
  //   } catch (e) {
  //     print (e);
  //     debugPrint("Error $e");
  //     createAlertDialog(this.context, 'Error', e.substring(0, 50));
  //   }
  //   //Navigator.of(context).pop();
  // }


  _getImageold(BuildContext context, ImageSource source) async {

    this.setState(() {
      _inProcess = true;
    });
    var picture = await ImagePicker.pickImage(source: source);

    if(picture != null){
      //File cropped=picture;
      File cropped = await ImageCropper.cropImage(
          sourcePath: picture.path,
          aspectRatio: CropAspectRatio(ratioX: 8, ratioY: 5),
          compressQuality: 100,
          maxWidth: 640,
          maxHeight: 480,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.deepOrange,
            toolbarTitle: "RPS Cropper",
            statusBarColor: Colors.deepOrange.shade900,
            backgroundColor: Colors.white,
          )
      );
      this.setState(() {
        _imageFileIdCard = cropped;
        _inProcess = false;
      });
    }else{
      this.setState(() {
        _inProcess = false;
      });
    }


    Navigator.of(context).pop();
  }

  _getEktpImage(BuildContext context, ImageSource source) async{
    this.setState(() {
      //loading = true;
    });
    try{
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      if (await tempDir.exists())
        tempDir.delete(recursive: false);

      Directory appdocdir= await getApplicationSupportDirectory();
      String test=appdocdir.path;

      if (await appdocdir.exists())
        appdocdir.delete(recursive: false);

      var picture =  await ImagePicker.pickImage(source: source);

      int appFileDirectory=picture.path.lastIndexOf('/');
      String resultDirectory=picture.path.substring(0,appFileDirectory+1); // = appdocdir+'/Pictures/'
      String resultPath=resultDirectory+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';
      //String resultPath='/storage/emulated/0/Android/data/com.smartherd.flutter_app_section2/files/Pictures/'+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';

      int photoQuality=50;
      if(picture != null) {
        try {
          var result = await FlutterImageCompress.compressAndGetFile(
            picture.absolute.path, resultPath,
            quality: photoQuality,
          );

          int pictureLength=picture.lengthSync();
          int resultLength=result.lengthSync();

          var i = 1;

          while ((resultLength < minPhotoSize || resultLength > maxPhotoSize) && photoQuality>0 && photoQuality<100) {
            if (result!=null)
              await result.delete();
            resultPath=resultDirectory+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';
            photoQuality=(resultLength>maxPhotoSize)? photoQuality-10:photoQuality+10;
            result = await FlutterImageCompress.compressAndGetFile(
              picture.absolute.path, resultPath,
              quality: photoQuality,
            );
            resultLength=result.lengthSync();
          }

          double sizeinKb=resultLength.toDouble()/1024;
          debugPrint('Photo compressed size is '+sizeinKb.toString()+' kb');
          //print(pictureLength+resultLength);
          await picture.delete();
          this.setState(() {
            //_imageFileProfile = cropped;
            _ektpImage = result;
            //loading = false;
          });
        } catch (e) {
          print (e);
          debugPrint("Error $e");
        }
      }else{
        this.setState(() {
          //loading = false;
        });
      }
    } catch (e) {
      print (e);
      debugPrint("Error $e");
    }
    Navigator.of(context).pop();
    //Navigator.of(context).pop();
    //uploadImage(_ektpImage, "ektp");
    // MAYA NOTE: DI SINI MULAI PROCESS OCR
  }

  _getImage(BuildContext context, ImageSource source) async {
    this.setState(() {
      _inProcess = true;
    });
    var picture = await ImagePicker.pickImage(source: source);

    if(picture != null){
      //File cropped=picture;
      File cropped = await ImageCropper.cropImage(
          sourcePath: picture.path,
          aspectRatio: CropAspectRatio(ratioX: 8, ratioY: 5),
          compressQuality: 100,
          maxWidth: 640,
          maxHeight: 480,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.deepOrange,
            toolbarTitle: "RPS Cropper",
            statusBarColor: Colors.deepOrange.shade900,
            backgroundColor: Colors.white,
          )
      );
      this.setState(() {
        _imageFileIdCard = cropped;
        _inProcess = false;
      });
    }else{
      this.setState(() {
        _inProcess = false;
      });
    }

  }
  // _getImage(BuildContext context, ImageSource source) async {
  //
  //   this.setState(() {
  //     _inProcess = true;
  //   });
  //   var picture = await ImagePicker.pickImage(source: source);
  //
  //   if(picture != null){
  //     //File cropped=picture;
  //     // File cropped = await ImageCropper.cropImage(
  //     //     sourcePath: picture.path,
  //     //     aspectRatio: CropAspectRatio(ratioX: 8, ratioY: 5),
  //     //     compressQuality: 100,
  //     //     maxWidth: 640,
  //     //     maxHeight: 480,
  //     //     compressFormat: ImageCompressFormat.jpg,
  //     //     androidUiSettings: AndroidUiSettings(
  //     //       toolbarColor: Colors.deepOrange,
  //     //       toolbarTitle: "RPS Cropper",
  //     //       statusBarColor: Colors.deepOrange.shade900,
  //     //       backgroundColor: Colors.white,
  //     //     )
  //     // );
  //     File cropped = picture;
  //     this.setState(() {
  //       _imageFileIdCard = cropped;
  //       _inProcess = false;
  //     });
  //   }else{
  //     this.setState(() {
  //       _inProcess = false;
  //     });
  //   }

  Widget _decideImageIdCardView() {
    if (_ektpImage == null) {
      return Image.asset("images/no_photo_selected.png",
        width: 300.0,
        height: 180.0,
        fit: BoxFit.cover,);
    } else {
      return Image.file(
        _ektpImage,
        width: 300.0,
        height: 180.0,
        fit: BoxFit.cover,
      );
    }
  }

  nodefluxOcrKtpProcess(BuildContext context) async{
    setState(() {
      loading = true;
    });
    //String trx_id = 'Liveness_' + DateFormat('yyyyMMddHHmmss').format(DateTime.now());
    String authorization = 'NODEFLUX-HMAC-SHA256 Credential=ZZC8MB2EHH01G3FX60ZNZS7KA/20201110/nodeflux.api.v1beta1.ImageAnalytic/StreamImageAnalytic, SignedHeaders=x-nodeflux-timestamp, Signature=5a6b903b95b8f3c9677169d69b13b4f790799ffba897405b7826770f51fd4a21';
    String contentType = 'application/json';
    String xnodefluxtimestamp='20201110T135945Z';
    final imageBytes = _imageFileIdCard.readAsBytesSync();
    String base64Image = 'data:image/jpeg;base64,'+base64Encode(imageBytes);
    String dialog = "";
    bool isPassed=false;
    String currentStatus='';
    NodefluxDataModel nodefluxDataModel=NodefluxDataModel();
    NodefluxJobModel nodefluxJobModel=NodefluxJobModel();
    NodefluxResultModel nodefluxResultModel = NodefluxResultModel();
    NodefluxResult2Model nodefluxResult2Model =NodefluxResult2Model();
    bool okValue=true;
    try{
      // var data = "images: ["+ base64Image +"]";

      //var uri = Uri.parse('https://api.cloud.nodeflux.io/v1/analytics/ocr-ktp');
      var url='https://api.cloud.nodeflux.io/v1/analytics/ocr-ktp';
      // var response = http.post(uri, headers: {
      //   "Content-Type": "application/json",
      //   "x-nodeflux-timestamp": "20201110T135945Z",
      //       "Authorization": authorization,
      // }, body:data).then((http.Response response) {});
      List<String> photoBase64List=List<String>();
      photoBase64List.add(base64Image);

      var response;
      while (currentStatus!='success' && okValue) {
        response = await http
            .post(Uri.parse(url), body: json.encode({
          "images":photoBase64List
        }), headers: {"Accept": "application/json",  "Content-Type": "application/json",
          "x-nodeflux-timestamp": "20201110T135945Z",
          "Authorization": authorization,});

        print(response.body);

        var respbody=response.body;
        nodefluxDataModel=NodefluxDataModel.fromJson00(jsonDecode(response.body));
        okValue=nodefluxDataModel.ok;
        if (okValue) {
          nodefluxDataModel=NodefluxDataModel.fromJson0(jsonDecode(response.body));
          nodefluxJobModel=nodefluxDataModel.job;
          nodefluxResultModel = nodefluxJobModel.result;

          currentStatus=nodefluxResultModel.status;
        } else {
          dialog=nodefluxDataModel.message;
          isPassed=false;
        }
      }

      if (response!=null && currentStatus=="success") {
        nodefluxDataModel=NodefluxDataModel.fromJson(jsonDecode(response.body));
        nodefluxJobModel=nodefluxDataModel.job;
        nodefluxResultModel = nodefluxJobModel.result;
        nodefluxResult2Model = nodefluxResultModel.result[0];
      }


      // List<Map> carOptionJson = new List();
      // CarJson carJson = new CarJson(base64Image);
      // carOptionJson.add(carJson.TojsonData());

      // var body = json.encode({
      //   "LstUserOptions": carOptionJson
      // });

      // var data = "images: ["+ base64Image +"]";

      // http.Response response = await http.post("https://api.cloud.nodeflux.io/v1/analytics/ocr-ktp", body: data,
      //     headers: {'Content-type': 'application/json', 'Authorization':authorization, 'x-nodeflux-timestamp':xnodefluxtimestamp});


      // http.Response response = await http.post(
      //     Uri.encodeFull('https://api.cloud.nodeflux.io/v1/analytics/ocr-ktp'),
      //     body: body,
      //     headers: {'Content-type': 'application/json', 'Authorization':authorization, 'x-nodeflux-timestamp':xnodefluxtimestamp});

      // var request = new http.MultipartRequest('POST', uri);
      //
      //
      // // request.fields['trx_id'] = trx_id;
      // // request.fields['gestures_set'] = gestureSetSelected;
      // // request.headers['token'] = token;
      // request.headers['Content-Type'] = contentType;
      // request.headers['Authorization']= authorization;
      // request.headers['x-nodeflux-timestamp']=xnodefluxtimestamp;
      // // for (int i=0;i<livenessCompressedPhotos.length;i++) {
      // //   request.files.add(http.MultipartFile('file', File(livenessCompressedPhotos[i].path).readAsBytes().asStream(), File(livenessCompressedPhotos[i].path).lengthSync(), filename: basename(livenessCompressedPhotos[i].path)));
      // // }
      // request.fields['images']=base64Image;
      //request.files.add(http.MultipartFile('images', File(photo1Compressed.path).readAsBytes().asStream(), File(photo1Compressed.path).lengthSync(), filename: basename(photo1Compressed.path)));
//      request.files.add(http.MultipartFile('file', File(photo1Compressed.path).readAsBytes().asStream(), File(photo1Compressed.path).lengthSync(), filename: basename(photo1Compressed.path)));

      // comentted start
      // var response = await request.send();
      // var resStr = await response.stream.bytesToString();
      // print(resStr);


      // Map<String, dynamic> listResult = jsonDecode(resStr.toString());
      // NodefluxDataModel nodefluxDataModel=NodefluxDataModel.fromJson(listResult);
      // NodefluxResultModel nodefluxResultModel = nodefluxDataModel.result;
      // //NodefluxResult2Model nodefluxResult2Model = nodefluxResultModel.result[0];
      // //AsliGesturesSetNamesModel gestureModel = AsliGesturesSetNamesModel.fromJson(listResult);
      //
      // decipherin result
      if (nodefluxResultModel.status=="success" && nodefluxDataModel.message=="OCR Success") { // if photo ktp
        // process
        dialog="OCR Process success";
        isPassed=true;
        Navigator.of(context).push(MaterialPageRoute(
          // builder: (context) => NodefluxOcrKtpResult(nodefluxResultModel.result[0])));
            builder: (context) => NodefluxOcrKtpResult(nodefluxResultModel.result[0])));
      } else if (nodefluxDataModel.message=="The image might be in wrong orientation") { // if photo not ktp/ wrong orientation
        dialog=nodefluxDataModel.message+" or photo is not KTP";
        // } else {// if status not success or on going
        //   dialog="The image might be in wrong orientation or photo is not KTP";
      }
    }
    catch(e){
      debugPrint('Error $e');
      dialog=e;
    }
//    await photo1Compressed.delete();
//    await photo2Compressed.delete();
//    await photo3Compressed.delete();
//    await photo4Compressed.delete();
//    await photo5Compressed.delete();
//    await photo6Compressed.delete();
//    await photo7Compressed.delete();
//    await photo8Compressed.delete();

    setState(() {
      loading = false;
    });
    createAlertDialog(context,isPassed?'Success!':'Failed',dialog);
  }
  //OKAY FACE API START HERE
//   comparingImages(BuildContext context) async {
//     setState(() {
//       loading = true;
//     });
//
//     FetchIdCardModel ficModel = new FetchIdCardModel();
//
//     String dialog = "";
//     final imageBytes = _imageFileIdCard.readAsBytesSync();
//     String base64Image = base64Encode(imageBytes);
//
//         // try {
//           var streamIdCard = http.ByteStream(
//               DelegatingStream.typed(_imageFileIdCard.openRead()));
//           var lengthIdCard = await _imageFileIdCard.length();
//
//           //start ocr
//           String url = 'https://okayiddemo.innov8tif.com/okayid/api/v1/ocr';
//           Map map = {
//             'apiKey': 'm9c1urQ4b8SL7cBIEzzXDUviSadSfPJB',
//             'base64ImageString': base64Image
//           };
//
//           OcrModel ocr = await apiRequestOcr(url, map);
//
//           for (int i = 0;
//           i < ocr.result[0].listVerifiedFields.pFieldMaps.length;
//           i++) {
//             switch (
//             ocr.result[0].listVerifiedFields.pFieldMaps[i].fieldType) {
//               case 2:
//                 {
//                   ficModel.nik = ocr
//                       .result[0].listVerifiedFields.pFieldMaps[i].fieldVisual;
//                 }
//                 break;
//               case 25:
//                 {
//                   ficModel.nama = ocr
//                       .result[0].listVerifiedFields.pFieldMaps[i].fieldVisual;
//                 }
//                 break;
//               case 6:
//                 {
//                   ficModel.tempatLahir = ocr
//                       .result[0].listVerifiedFields.pFieldMaps[i].fieldVisual;
//                 }
//                 break;
//               case 5:
//                 {
//                   ficModel.tglLahir = "17/12/1984";
// //                  ficModel.tglLahir = ocr
// //                      .result[0].listVerifiedFields.pFieldMaps[i].fieldVisual;
//                 }
//                 break;
//               case 69271564:
//                 {
//                   ficModel.jenisKelamin = ocr
//                       .result[0].listVerifiedFields.pFieldMaps[i].fieldVisual;
//                 }
//                 break;
//               case 17:
//                 {
//                   ficModel.alamat = ocr
//                       .result[0].listVerifiedFields.pFieldMaps[i].fieldVisual;
//                 }
//                 break;
//               case 189:
//                 {
//                   ficModel.rtrw = ocr
//                       .result[0].listVerifiedFields.pFieldMaps[i].fieldVisual;
//                 }
//                 break;
//               case 77:
//                 {
//                   ficModel.kelurahan = ocr
//                       .result[0].listVerifiedFields.pFieldMaps[i].fieldVisual;
//                 }
//                 break;
//               case 64:
//                 {
//                   ficModel.kecamatan = ocr
//                       .result[0].listVerifiedFields.pFieldMaps[i].fieldVisual;
//                 }
//                 break;
//               case 363:
//                 {
//                   ficModel.agama = ocr
//                       .result[0].listVerifiedFields.pFieldMaps[i].fieldVisual;
//                 }
//                 break;
//               case 160:
//                 {
//                   ficModel.status = ocr
//                       .result[0].listVerifiedFields.pFieldMaps[i].fieldVisual;
//                 }
//                 break;
//               case 312:
//                 {
//                   ficModel.pekerjaan = ocr
//                       .result[0].listVerifiedFields.pFieldMaps[i].fieldVisual;
//                 }
//                 break;
//             }
//           }
//           //end ocr
//           dialog="Real eKTP Document confirmed";
//           Navigator.of(context).push(MaterialPageRoute(
//               builder: (context) => NodefluxOcrKtpResult(ficModel)));
//
//         // } catch (e) {
//         //   dialog = "ERROR NO FACE DETECTED";
//         //   debugPrint("Error $e");
//         // }
//       // }
//     // } else {
//     //   dialog = "Unexpected Error";
//     // }
//     setState(() {
//       loading = false;
//     });
//     createAlertDialog(context, dialog);
//   }


  apiRequest(String url, Map jsonMap) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    var result = new StringBuffer();
    await for (var contents in response.transform(utf8.decoder)) {
      result.write(contents);
    }

    Map<String, dynamic> myList = jsonDecode(result.toString());

    KtpModel sample = KtpModel.fromJson(myList);

    httpClient.close();
    return sample;
  }
  //
  // apiRequestOcr(String url, Map jsonMap) async {
  //   HttpClient httpClient = new HttpClient();
  //   HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
  //   request.headers.set('content-type', 'application/json');
  //   request.add(utf8.encode(json.encode(jsonMap)));
  //   HttpClientResponse response = await request.close();
  //   // todo - you should check the response.statusCode
  //   var result = new StringBuffer();
  //   await for (var contents in response.transform(utf8.decoder)) {
  //     result.write(contents);
  //   }
  //
  //   Map<String, dynamic> myList = jsonDecode(result.toString());
  //
  //   OcrModel sample = OcrModel.fromJson(myList);
  //
  //   httpClient.close();
  //   return sample;
  // }
  //OKAY FACE API END HERE

  createAlertDialog(BuildContext context, String title, String message) {
    Widget okButton = FlatButton(
      child: Text("Close"),
      onPressed: () {Navigator.of(context).pop(); },
    );

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text(title), content: Text(message),  actions: [
            okButton,
          ],);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OCR KTP'),
        leading: IconButton(icon: Icon(
            Icons.arrow_back),
            onPressed: () {
              // Write some code to control things, when user press back button in AppBar
              moveToLastScreen();
            }
        ),
      ),
      body: Container(
        child: Center(
            child: loading
                ? Center(child: CircularProgressIndicator())
                : Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _decideImageIdCardView(),
                    RaisedButton(
                      onPressed: () {
                        createAlertDialogIdCard(context);
                      },
                      child: Text("Select Image Id Card!",
                          style: TextStyle(color: Colors.white)),
                      color:Colors.lightBlue,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            (_imageFileIdCard==null) ? null: nodefluxOcrKtpProcess(context);
                          },
                          child: Text("Process",
                              style: TextStyle(color: Colors.white)),
                          color: (_imageFileIdCard==null) ? Colors.black12: Colors.lightBlue,
                        )
                      ],
                    )
                  ],
                ),
                (_inProcess) ? Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height * 0.95,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ):Center()
              ],
            )
        ),
      ),
    );
  }

  showProcessButton()
  {

  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
