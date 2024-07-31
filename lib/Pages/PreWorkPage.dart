import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_navigation/Widget/Navbar.dart';

import 'WorkingPage.dart';

class PreWork extends StatefulWidget {
  const PreWork({super.key});

  @override
  State<PreWork> createState() => _PreWorkState();
}

class _PreWorkState extends State<PreWork> {
  File? imageFile1;
  String _locationMessage = '';

  _getCamera1() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );
    setState(() {
      if (pickedFile != null) {
        imageFile1 = File(pickedFile.path);
      }
    });
  }

  void _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationMessage = 'Location services are disabled.';
        });
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationMessage = 'Location permissions are denied.';
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
    super.initState();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBAr(),
      appBar: AppBar(
        title: const Text(
          'job',
          style: TextStyle(
            color: CupertinoColors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: CupertinoColors.white,
        ),
        backgroundColor: const Color(0xFF1A237E),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Pre-Work Photo',
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,

              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(
            height: 70,
          ),
          Padding(
            padding: const EdgeInsets.all(40),
            child: Card(
              shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Colors.indigoAccent,
                  ),
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.indigo.shade50,
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: imageFile1 != null
                        ? Stack(
                            children: [
                              Image.file(
                                imageFile1!.absolute,
                                scale: 10,
                              ),
                              IconButton(
                                  onPressed: () {
                                    _getCamera1();
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.camera_fill,
                                    size: 10,
                                  )),
                            ],
                          )
                        : Center(
                            child: InkWell(
                              onTap: _getCamera1,
                              child:
                                  const Icon(CupertinoIcons.camera_rotate_fill),
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.all(60),
                    padding: const EdgeInsets.all(16),
                    width: 900,
                    decoration:  BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      color: CupertinoColors.white,
                    ),
                    child: Text(
                      _locationMessage,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Work()));
                    },
                    color: Colors.green,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Send',
                      style: TextStyle(
                        color: CupertinoColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
