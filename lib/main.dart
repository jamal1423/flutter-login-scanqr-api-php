import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // potrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PageLogin(title: 'Flutter Demo Home Page'),
    );
  }
}

class PageLogin extends StatefulWidget {
  const PageLogin({super.key, required this.title});

  final String title;

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var txtEditUsername = TextEditingController();
  var txtEditPwd = TextEditingController();

  Widget inputUsername() {
    return TextFormField(
        cursorColor: Colors.white,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        validator: (String? arg) {
        if (arg == null || arg.isEmpty) {
          return 'Username harus diisi';
        } else {
          return null;
        }
      },
        controller: txtEditUsername,
        onSaved: (String? val) {
          txtEditUsername.text = val!;
        },
        decoration: InputDecoration(
          hintText: 'Masukkan Username',
          hintStyle: const TextStyle(color: Colors.white),
          labelText: "Masukkan Username",
          labelStyle: const TextStyle(color: Colors.white),
          prefixIcon: const Icon(
            Icons.person_outlined,
            color: Colors.white,
          ),
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(
              color: Colors.white,
              width: 2.0,
            ),
          ),
        ),
        style: const TextStyle(fontSize: 16.0, color: Colors.white));
  }

  Widget inputPassword() {
    return TextFormField(
      cursorColor: Colors.white,
      keyboardType: TextInputType.text,
      autofocus: false,
      obscureText: true, //make decript inputan
      validator: (String? arg) {
        if (arg == null || arg.isEmpty) {
          return 'Password harus diisi';
        } else {
          return null;
        }
      },
      controller: txtEditPwd,
      onSaved: (String? val) {
        txtEditPwd.text = val!;
      },
      decoration: InputDecoration(
        hintText: 'Masukkan Password',
        hintStyle: const TextStyle(color: Colors.white),
        labelText: "Masukkan Password",
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: Colors.white,
        ),
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
      ),
      style: const TextStyle(fontSize: 16.0, color: Colors.white),
    );
  }

  void _validateInputs() {
    if (_formKey.currentState!.validate()) {
      //If all data are correct then save data to out variables
      _formKey.currentState!.save();
      doLogin(txtEditUsername.text, txtEditPwd.text);
    }
  }

  doLogin(email, password) async {
    //final GlobalKey<State> _keyLoader = GlobalKey<State>();
    //Dialogs.loading(context, _keyLoader, "Proses ...");
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: CupertinoActivityIndicator(),
          ),
        ),
      ),
    );

    try {
      final response = await http.post(
          Uri.parse("https://23media.web.id/aplikasi/flutter/login.php"),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Access-Control-Allow-Origin': '*',
            'Accept': '*/*'
          },
          body: jsonEncode({
            "email": email,
            "password": password,
          }));

      final output = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if(context.mounted){
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
              output['message'],
              style: const TextStyle(fontSize: 16),
            )),
          );
        }

        if (output['success'] == true) {
          saveSession(email);
        }
      } else {
        if(context.mounted){
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
              output.toString(),
              style: const TextStyle(fontSize: 16),
            )),
          );
        }
      }
    } catch (e) {
      Navigator.pop(context, '$e');
      debugPrint('$e');
    }
  }

  saveSession(String email) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("email", email);
    await pref.setBool("is_login", true);

    if(context.mounted){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const HalamanHome(),
        ),
        (route) => false,
      );
    }
  }

  void ceckLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var islogin = pref.getBool("is_login");
    if (islogin != null && islogin) {
      if(context.mounted){
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const HalamanHome(),
          ),
          (route) => false,
        );
      }
    }
  }

  @override
  void initState() {
    ceckLogin();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Container(
        margin: const EdgeInsets.all(0),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blueAccent, Color.fromARGB(255, 21, 236, 229)],
        )),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 60.0, bottom: 0),
                child: Center(
                  child: SizedBox(
                    width: 200,
                    height: 80,
                    child: Icon(Icons.person_2_outlined, size: 50, color: Colors.white,),
                  ),
                ),
              ),
              // const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: const Text(
                  "Form Login",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    inputUsername(),
                    const SizedBox(height: 20.0),
                    inputPassword(),
                    const SizedBox(height: 5.0),
                  ],
                )
              ),
              Container(
                padding: const EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 97, 187, 247),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: const BorderSide(color: Colors.white60),
                    ),
                    elevation: 10,
                    minimumSize: const Size(200, 58)
                  ),
                  onPressed: () => _validateInputs(),
                  icon: const Icon(Icons.login_outlined, color: Colors.white,),
                  label: const Text(
                    "Masuk",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
