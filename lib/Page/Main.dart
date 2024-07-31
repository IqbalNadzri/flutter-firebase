import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_navigation/Pages/PreWorkPage.dart';
import 'package:project_navigation/Widget/Navbar.dart';

class Main extends StatefulWidget {
  const Main({super.key, this.userID, String? simNumber});
  final String? userID;

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBAr(),
      appBar: AppBar(
        backgroundColor: Color(0xFF1A237E),
        title: const Text('Home',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Card(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.lightBlueAccent,
                    ),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  margin: EdgeInsets.all(50),
                  color: Color(0xFF1A237E),
                  elevation: 9,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        margin: EdgeInsets.all(20),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Job ID',
                            enabled: true,
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            )
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      MaterialButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                              builder: (context) =>PreWork()
                          ));
                        },
                        color: Colors.green,
                        padding: EdgeInsets.all(10),
                        child: const Text('Enter',
                        style: TextStyle(
                        color: Colors.white,
                        ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
