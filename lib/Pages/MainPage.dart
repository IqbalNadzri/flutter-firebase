import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_navigation/Pages/PreWorkPage.dart';
import 'package:project_navigation/Widget/Navbar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, this.userID, String? simNumber});

  final String? userID;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBAr(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16296E),
        title: const Text('Home',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: CupertinoColors.white,
        ),
        ),
        iconTheme: const IconThemeData(
          color: CupertinoColors.white,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Colors.lightBlueAccent,
                  ),
                  borderRadius: BorderRadius.circular(20.0)
                ),
                margin: const EdgeInsets.all(50),
                color: const Color(0xFFE0F7FA),
                elevation: 9,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Job ID',
                          enabled: true,
                          filled: true,
                          fillColor: CupertinoColors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          )
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                        onPressed: (){
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                              builder: (context)=> const PreWork()));
                        },
                      color: Colors.green,
                      padding: const EdgeInsets.all(10),
                      child: const Text('Enter',
                      style: TextStyle(
                        color: CupertinoColors.white,
                      ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
