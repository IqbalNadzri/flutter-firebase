import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_navigation/Widget/Navbar.dart';

class WorkPage extends StatefulWidget {
  const WorkPage({super.key});

  @override
  State<WorkPage> createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  File? _imageFile5;
  String _locationMessage = '';

  _getCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );
    setState(() {
      if(pickedFile != null) {
        _imageFile5 = File(pickedFile.path);
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
          _locationMessage = 'location services are disabled.';
        });
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationMessage = 'Location permission are denied!';
          });
          return;
        }
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      setState(() {
        _locationMessage = 'Latitude: ${position.latitude} , Longitude: ${position.longitude}';
      });
    } catch(e) {
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
      drawer: const NavBAr(),
      appBar: AppBar(
        title: const Text('Job',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Color(0xFF1A237E),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Card(
                  color: Colors.indigo.shade50,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.indigo,
                    ),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: _imageFile5 != null ?
                        Stack(
                          children: [
                            Image.file(
                              _imageFile5!.absolute,
                              scale: 10,
                            ),
                            IconButton(
                              onPressed: () {
                                _getCamera();
                              },
                              icon: Icon(CupertinoIcons.camera_fill),
                            )
                          ],
                        ) :
                        Center(
                        child: InkWell(
                          onTap: () {
                            _getCamera();
                          },
                          child: Icon(CupertinoIcons.camera),
                        ),
                        )
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
