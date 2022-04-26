import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'drawer.dart';
import 'globle.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<Profile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Uint8List bytes;
  Map addFaceJson = {};
  File imageAdd;
  String photo = '';
  String _base64;

  // Uint8List bytes;

  Future<void> _checkFaces() async {
    try {
      imageAdd = await ImagePicker.pickImage(
        // preferredCameraDevice: CameraDevice.front,
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
      );
    } on Exception catch (_) {
      throw Exception("Error on server");
    }

    setState(() {
      if (imageAdd != null) {
        // showFace();

        addFace();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // setState(() {
    showFace();
    // loadFace();

    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      drawer: SafeArea(
          child: AppDrawer(
        selected: 'Profile',
      )),
      body: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: Color(0xff67B2BB),
              height: 250,
            ),
          ),
          Positioned(
            top: 50,
            left: 150,
            child: CircleAvatar(
              radius: 55,
              backgroundColor: Color(0xffFDCF09),
              child: imageAdd != null
                  ? GestureDetector(
                      onTap: _checkFaces,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: imageAdd == null
                            ? Image.network(
                                'https://www.thermaxglobal.com/wp-content/uploads/2020/05/image-not-found.jpg')
                            : Image.file(imageAdd),

                        // Image.file(
                        //   imageAdd,
                        //   width: 100,
                        //   height: 100,
                        //   fit: BoxFit.fitHeight,
                        // ),
                      ),
                    )
                  : GestureDetector(
                      onTap: _checkFaces,
                      child: base64All == null
                          ? Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(50)),
                              width: 100,
                              height: 100,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: base64All == null
                                  ? Image.asset('assets/logo.png')
                                  : Image.memory(bytesAll),

                              // Image.file(
                              //   imageAdd,
                              //   width: 100,
                              //   height: 100,
                              //   fit: BoxFit.fitHeight,
                              // ),
                            ),
                    ),
            ),
            // CircleAvatar(
            //   radius: 70.0,
            //   backgroundImage: NetworkImage(
            //       "https://cdn.imgbin.com/22/5/16/imgbin-computer-icons-user-profile-profile-ico-man-s-profile-illustration-M4UwtQzjtzd9LFP69LEzngUuR.jpg"),
            //   backgroundColor: Colors.transparent,
            // ),
          ),
          Positioned(
            top: 210,
            right: 10,
            left: 10,
            child: Container(
              height: 100,
              child: Card(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(loginJson['name']),
                  ),
                  Container(
                    child: Text(loginJson['department']),
                  ),
                ],
              )),
            ),
          ),
          Positioned(
            top: 350,
            right: 10,
            left: 10,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.phone),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Text(loginJson['mobileNo']),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.email),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Text(loginJson['emaiL_ADDRESS']),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLoading(isLoading) {
    if (isLoading) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () {},
              child: new AlertDialog(
                  content: new Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 25.0),
                    child: new CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: new Text('Please Wait...'),
                  )
                ],
              )),
            );
          });
    } else {
      Navigator.pop(context);
    }
  }

  void _showError() {
    _showLoading(false);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {},
            child: new AlertDialog(
              content: new Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: new Icon(Icons.signal_wifi_off),
                  ),
                  new Text("Unable to connect")
                ],
              ),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // editUsers();
                  },
                  child: new Text('Please try again'),
                ),
              ],
            ),
          );
        });
  }

  Future loadFace() async {
    String base64Image = base64Encode(imageAdd.readAsBytesSync());

    photo = base64Image.toString();
  }

  Future addFace() async {
    _showLoading(true);

    try {
      var url =
          Uri.parse('http://86.96.206.195/apilogin/api/Geofence/UpdatePhoto');
      String base64Image = base64Encode(imageAdd.readAsBytesSync());

      final headers = {"Content-type": "application/json"};
      final json =
          '{"userId": ${loginJson['userName']}, "PhotoId": ${loginJson['userName']}, "Photo": "$base64Image"}';
      final response = await post(url, headers: headers, body: json);
      if (response.statusCode == 200) {
        setState(() {
          base64All = base64Image;
          bytesAll = Base64Codec().decode(base64All);
        });

        Fluttertoast.showToast(
            msg: "Face successfully added",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        _showLoading(false);
      } else {
        Fluttertoast.showToast(
            msg: "Something wrong try again.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        _showLoading(false);
      }
    } catch (x) {
      print(x);
      _showError();
    }
  }

  Future showFace() async {
    Future.delayed(Duration.zero, () {
      _showLoading(true);
    });
    try {
      final response = await http.post(
        Uri.parse('http://86.96.206.195/apilogin/api/Geofence/getphoto'),
        body: {
          'userId': loginJson['userName'],
        },
      );
      if (response.statusCode == 200) {
        // String base64Image = base64Encode(imageAdd.readAsBytesSync());

        // imageAdd = json.decode(response.body)['photo'];

        // if (json.decode(response.body)['photo'] == null) {
        // } else {}

        if (json.decode(response.body) == null) {
          _base64 =
              "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";
        }
        // else {}
        // photo = base64Image.toString();

        _base64 = json.decode(response.body)['photo'];

        bytes = Base64Codec().decode(_base64);

        _showLoading(false);
      } else {
        _showLoading(false);
        Fluttertoast.showToast(
            msg: "Something wrong try again.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (x) {
      print(x);
      _showError();
    }
  }
}
