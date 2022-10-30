import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_final/home.dart';
import 'package:project_final/login.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  registerSubmit() async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: _email.text.toString().trim(), password: _pass.text);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('akun berhasil terdaftar. Silahkan login!')));
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (ctx) => Login()));
    } catch (e) {
      print(e);
      SnackBar(content: Text(e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                'img/flutter.png',
                height: 50,
                width: 50,
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 15),
              child: const Text(
                "Register",
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 30),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _email,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email/Username",
                    hintText: "Contoh: Email@gmail.com"),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _pass,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    hintText: "Password"),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                  style: raisedButtonStyle,
                  onPressed: () {
                    registerSubmit();
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ),
            SizedBox(height: 20),
            Text(
              "Sudah Punya akun?",
              textAlign: TextAlign.center,
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (ctx) => Login()));
                },
                child: Text(
                  "Klik disini",
                )),
          ],
        ),
      ),
    );
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      onPrimary: Colors.grey,
      primary: Colors.blue,
      minimumSize: Size(88, 36),
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6))));
}
