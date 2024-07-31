
import 'package:flutter/material.dart';

import '../Pages/Login.dart';
import '../Pages/MainPage.dart';


class NavBAr extends StatefulWidget {
  const NavBAr({super.key});

  @override
  State<NavBAr> createState() => _NavBArState();
}

class _NavBArState extends State<NavBAr> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.only(),
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('TESTER',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: const Text('testeremail.com',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(child: Image.asset('images/redf.png')
              ),
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('images/bckgorunf.png'),
                alignment: Alignment.topCenter,
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context)=> const MainPage(),
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context)=> const LoginPage())
            ),
          )
        ],
      ),
    );
  }
}
