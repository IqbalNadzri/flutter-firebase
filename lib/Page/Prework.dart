import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_navigation/Pages/WorkingPage.dart';
import 'package:project_navigation/Widget/Navbar.dart';

class Prework extends StatefulWidget {
  const Prework({super.key});

  @override
  State<Prework> createState() => _PreworkState();
}

class _PreworkState extends State<Prework> {
  File? imageFile4;
  String _locationMessage ='';

  _getCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );
    setState(() {
      if(pickedFile != null) {
        imageFile4 = File(pickedFile.path);
      }
    });
  }

  void _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if(!serviceEnabled) {
        setState(() {
          _locationMessage = 'Location services are disabled';
        });
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationMessage = 'Location permisssoins are denied';
          });
          return;
        }
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print(position);
      setState(() {
        _locationMessage =
            'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
        print(_locationMessage);
      });
    } catch (e) {
      print('Error getting location: $e');
      setState(() {
        _locationMessage = 'Error getting location: $e';
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBAr(),
      appBar: AppBar(
        title: Text('Job',
        style: TextStyle(
          color: Colors.white,
        ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Color(0xFF1A237E),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Pre-Work Photo',
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(
            height: 70,
          ),
          Padding(
            padding: EdgeInsets.all(40),
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.indigoAccent,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.indigo.shade50,
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: imageFile4 != null
                    ? Stack(
                      children: [
                        Image.file(
                          imageFile4!.absolute,
                          scale: 10,
                        ),
                        IconButton(
                          onPressed: () {
                            _getCamera();
                          },
                          icon: Icon(
                            CupertinoIcons.camera,
                            size: 10,
                          ),
                        )
                      ],
                    )
                    : Center(
                      child: InkWell(
                        onTap: _getCamera,
                        child: Icon(CupertinoIcons.camera_rotate),
                      ),
                    )
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.all(60),
                    padding: EdgeInsets.all(16),
                    width: 900,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white
                    ),
                    child: Text(
                      _locationMessage,
                      style: TextStyle(
                        fontSize: 20
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Work()));
                    },
                    color: Colors.green,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Send',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}
