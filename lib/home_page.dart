import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:test_app/main.dart';
import 'package:test_app/profile_page.dart';
import 'package:test_app/scan_qr_page.dart';
import 'package:test_app/setting_page.dart';

class HalamanHome extends StatefulWidget {
  const HalamanHome({super.key});

  @override
  State<HalamanHome> createState() => _HalamanHomeState();
}

class _HalamanHomeState extends State<HalamanHome> {
  int _index = 0;

  int pageIndex = 0;
  
  final pages = [
    const Page1(),
    const Page2(),
    // const Page3(),
    const Page4(),
  ];

  String email = "";
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var islogin = pref.getBool("is_login");
    if (islogin != null && islogin == true) {
      setState(() {
        email = pref.getString("email")!;
      });
    } else {
      if(context.mounted){
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const MyApp(),
          ),
          (route) => false,
        );
      }
    }
  }

  logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.remove("is_login");
      preferences.remove("email");
    });

    if(context.mounted){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const MyApp(),
        ),
        (route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
          "Berhasil logout",
          style: TextStyle(fontSize: 16),
        )),
      );
    }
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffC4DFCB),
      appBar: AppBar(
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("Profile"),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text("Settings"),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text("Logout"),
              ),
            ];
          }, onSelected: (value) {
            if (value == 0) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const HalamanProfile(),
                ),
                (route) => false,
              );
            } else if (value == 1) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const HalamanSetting(),
                ),
                (route) => false,
              );
            } else if (value == 2) {
              logOut();
            }
          }),
        ],
        leading: const Icon(
          Icons.menu,
          // color: Theme.of(context).primaryColor,
          color: Colors.blue,
        ),
        title: const Text(
          "App Testing",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: pages[pageIndex],
      bottomNavigationBar: buildMyNavBar(context),
    );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 0;
              });
            },
            icon: pageIndex == 0
                ? const Icon(
                    Icons.home_filled,
                    color: Color.fromARGB(255, 33, 4, 130),
                    size: 35,
                  )
                : const Icon(
                    Icons.home_outlined,
                    color: Colors.white,
                    size: 35,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            // onPressed: () {
            //   setState(() {
            //     pageIndex = 1;
            //   });
            // },
            onPressed: (){
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const ScanQr(),
                ),
                (route) => false,
              );
            },
            icon: pageIndex == 1
                ? const Icon(
                    Icons.qr_code_scanner_outlined,
                    color: Color.fromARGB(255, 33, 4, 130),
                    size: 35,
                  )
                : const Icon(
                    Icons.qr_code_scanner_outlined,
                    color: Colors.white,
                    size: 35,
                  ),
          ),
          // IconButton(
          //   enableFeedback: false,
          //   onPressed: () {
          //     setState(() {
          //       pageIndex = 2;
          //     });
          //   },
          //   icon: pageIndex == 2
          //       ? const Icon(
          //           Icons.widgets_rounded,
          //           color: Colors.white,
          //           size: 35,
          //         )
          //       : const Icon(
          //           Icons.widgets_outlined,
          //           color: Colors.white,
          //           size: 35,
          //         ),
          // ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 2;
              });
            },
            icon: pageIndex == 2
                ? const Icon(
                    Icons.person,
                    color: Color.fromARGB(255, 33, 4, 130),
                    size: 35,
                  )
                : const Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: 35,
                  ),
          ),
        ],
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffC4DFCB),
      child: Center(
        child: Text(
          "Menu Home",
          style: TextStyle(
            color: Colors.green[900],
            fontSize: 45,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );

    // return Card(
    //   margin: const EdgeInsets.all(15),
    //   color: Colors.white,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(10),
    //     side: BorderSide(
    //       color: Colors.grey.withOpacity(0.5),
    //       width: 1,
    //     ),
    //   ),
    //   child: Container(
    //     // color: Colors.white,
    //     height: 200,
    //     child: const Column(
    //       mainAxisAlignment: MainAxisAlignment.spaceAround,
    //       mainAxisSize: MainAxisSize.max,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: <Widget>[
    //         Padding(
    //           padding:  EdgeInsets.only(left: 20),        
    //         ),
    //         Text("Testing")
    //       ],
    //     ),
    //   ),
    // );
  }
}
  
class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
      return Container(
      padding: const EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: const BorderSide(color: Colors.white60),
          ),
          elevation: 10,
          minimumSize: const Size.fromHeight(50),
        ),
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const ScanQr(),
            ),
            (route) => false,
          );
        },
        label: const Text(
          "Menu Scan Data",
          style:
              TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        icon: const Icon(Icons.arrow_forward_ios_outlined, color: Colors.white,),
      ),
    );
  }
}
  
// class Page3 extends StatelessWidget {
//   const Page3({Key? key}) : super(key: key);
  
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: const Color(0xffC4DFCB),
//       child: Center(
//         child: Text(
//           "Menu 3",
//           style: TextStyle(
//             color: Colors.green[900],
//             fontSize: 45,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }
// }
  
class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffC4DFCB),
      child: Center(
        child: Text(
          "Menu Profiles",
          style: TextStyle(
            color: Colors.green[900],
            fontSize: 45,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
