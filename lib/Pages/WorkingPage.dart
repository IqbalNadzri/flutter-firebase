import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_navigation/Widget/Navbar.dart';

class Work extends StatefulWidget {
  const Work({super.key});

  @override
  State<Work> createState() => _WorkState();
}

class _WorkState extends State<Work> {

  File? _imageFile2;
  String _locationMessage = '';

  _getCamera2() async {
    XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
    );
    setState(() {
      if(pickedFile !=null) {
        _imageFile2 = File(pickedFile.path);
      }
    });
  }

  _getCamera3() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );
    setState(() {
      if(pickedFile !=null) {
        _imageFile2 = File(pickedFile.path);
      }
    });
  }

  void _getLocation1() async {
    bool serviceEnabled;
    LocationPermission permission;

    try{
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
        if(permission == LocationPermission.denied) {
          setState(() {
            _locationMessage = 'Location denied';
          });
          return;
        }
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        );
        setState(() {
          _locationMessage = 'Latitude = ${position.latitude}, Longitude = ${position.longitude}';
        });
      }
    } catch(e) {
      setState(() {
        _locationMessage = 'Location problem error: $e';
      });
    }
  }

  void _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if(!serviceEnabled) {
        setState(() {
          _locationMessage = 'Location services are disabled.' ;
        });
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if(permission == LocationPermission.denied) {
          setState(() {
            _locationMessage = 'Location permissions are denied!';
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
    } catch (e) {
      setState(() {
        _locationMessage='Error getting Location: $e';
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
          color: CupertinoColors.white,
        ),
        ),
        iconTheme: const IconThemeData(
          color: CupertinoColors.white,
        ),
        backgroundColor: const Color(0xFF1A237E),
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
                        child: _imageFile2 != null ?
                          Stack(
                            children: [
                              Image.file(
                                _imageFile2!.absolute,
                                scale: 10,
                              ),
                              IconButton(
                                  onPressed: (){
                                    _getCamera2();
                                  },
                                  icon: const Icon(CupertinoIcons.camera_fill),
                              )
                            ],
                          ) :
                        Center(
                          child: InkWell(
                            onTap: (){
                              _getCamera2();
                              },
                            child: const Icon(CupertinoIcons.camera) ,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        width: 600,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: CupertinoColors.white,
                        ),
                        child: Text (
                          _locationMessage,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      MaterialButton(
                          onPressed: (){

                          },
                        color: Colors.green,
                        padding: const EdgeInsets.all(10),
                        child: const Text('Send',
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
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: (){

            },
            child: const Card(
              color: Color(0xFF1A237E),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 60,
                ),
                child: Text('Add',
                style: TextStyle(
                  fontSize: 20,
                  color: CupertinoColors.white,
                ),
                ),
              ),
            ),
          ),
          const SizedBox( width:150),
          InkWell(
            onTap: () {

            },
            child: const Card(
              color: Colors.red,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 60,
                ),
                child: Text('End',
                style: TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 20,
                ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
