import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project_navigation/Pages/MainPage.dart';
import 'package:simnumber/sim_number.dart';
import 'package:simnumber/siminfo.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final storage = const FlutterSecureStorage();
  final _formkey = GlobalKey<FormState>();
  final String? simNumber='';

  final _auth = FirebaseAuth.instance;

  var _rememberemail;
  var _rememberpassword;
  var _rememberme;

  String? userID;

  bool _isObscure3 = true;
  bool visible = false;
  bool rememberMe = false;

  @override
  void initState() {
    autofill();
    super.initState();
  }

  autofill() async {
    _rememberemail = await storage.read(key: 'rememberemail');
    _rememberpassword = await storage.read(key: 'rememberpassword');
    _rememberme = await storage.read(key: 'rememberme');
    setState(() {
      if (_rememberme == 'true') {
        rememberMe = true;
        emailController = TextEditingController(text: _rememberemail);
        passwordController = TextEditingController(text: _rememberpassword);
      } else {
        emailController = TextEditingController();
        passwordController = TextEditingController();
      }
    });
  }

  void routes() {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      var ll = FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .get()
      .then((DocumentSnapshot documentSnapshot)async {
        if (documentSnapshot.exists) {
          if (documentSnapshot.get('role').contains("Loading")) {
            var y = user.uid;
            await storage.write(key: "email", value: emailController.text);
            await storage.write(key: "password", value: passwordController.text);
            await storage.write(key: "uid", value: y);
            if(rememberMe == true) {
              await storage.write(key: "rememberme", value: rememberMe.toString());
              await storage.write(key: "rememberemail", value: emailController.text);
              await storage.write(key: "rememberpassword", value: passwordController.text);
            } else {
              await storage.write(key: "rememberme", value: rememberMe.toString());
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainPage(userID: y,),
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                title: Text('Alert'),
                content: Text(
                  'You are not Loading role'
                ),
              ),
            );
          }
        }
      });
    } catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          content: Text('Enter corrext email n password'),
        ),
      );
    }
  }

  void signIn(String email,String password) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: Text(''),
        );
      });
    if (_formkey.currentState!.validate()) {
      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
        );
        Navigator.of(context).pop();
        routes();
      } on FirebaseAuthException catch (e) {
        print(e);
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('Enter correct email and password'),
            );
          }
        );
      }
    }
  }

  _guest() async{
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      SimInfo simInfo = await SimNumber.getSimData();
      String simNumber = '';
      for (var s in simInfo.cards) {
        print('Serial number: ${s.slotIndex} ${s.phoneNumber}');
        simNumber = s.phoneNumber ??'';
        await firestore.collection('sim_numbers').add({
          'sim_number' :simNumber,
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainPage(simNumber: s.phoneNumber))
        );
        print('Sim number saved successfully!');
      }
    } on Exception catch (e) {
      debugPrint("error! code !");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainPage(simNumber: 'simNumber')),
      );
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          content: Text('You need to have simcard to login as a guest!'),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 100),
                  Center(
                    child: Image.asset(
                      'images/logos.jpg',
                      width: 150,
                    ),
                  ),
                  Column(
                    children: [
                      Card(
                        color: const Color(0XFFE8EAF6),
                        margin: const EdgeInsets.all(45),
                        elevation: 3,
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.all(12),
                            child: Form(
                              key: _formkey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Email',
                                      enabled: true,
                                      contentPadding: const EdgeInsets.only(
                                          left: 14.0, bottom: 8.0, top: 8.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.length == 0) {
                                        return "Email cannot be empty";
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (value) {
                                      emailController.text = value!;
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                  ),

                                  const SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                    controller: passwordController,
                                    obscureText: _isObscure3,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                          icon: Icon(_isObscure3
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                          onPressed: () {
                                            setState(() {
                                              _isObscure3 = !_isObscure3;
                                            });
                                          }),
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Password',
                                      enabled: true,
                                      contentPadding: const EdgeInsets.only(
                                          left: 14.0, bottom: 8.0, top: 15.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    validator: (value) {
                                      RegExp regex = RegExp(r'^.{6,}$');
                                      if (value!.isEmpty) {
                                        return "Password cannot be empty";
                                      }
                                      if (!regex.hasMatch(value)) {
                                        return ("please enter valid password min. 6 character");
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (value) {
                                      passwordController.text = value!;
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                          value: rememberMe,
                                          onChanged: (value) {
                                            setState(() {
                                              rememberMe = value!;
                                            });
                                          }),
                                      const Text('Remember Me'),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextButton(
                                        onPressed: (){
                                          _guest();
                                        },
                                        child: const Text('Sign in as a Guest',
                                          style: TextStyle(
                                            color: CupertinoColors.activeBlue,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  MaterialButton(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0))),
                                    elevation: 5.0,
                                    splashColor: const Color(0xFF1A237E),
                                    height: 40,
                                    onPressed: () {
                                      setState(() {
                                        visible = true;
                                      });
                                      signIn(emailController.text,
                                          passwordController.text);
                                    },
                                    color: Colors.white,
                                    child: const Text(
                                      "Login",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Container(
                    alignment: Alignment.bottomCenter,
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        const Text('Powered By'),
                        Image.asset(
                          'images/poweredBy.png',
                          alignment: Alignment.bottomCenter,
                          width: 100,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
