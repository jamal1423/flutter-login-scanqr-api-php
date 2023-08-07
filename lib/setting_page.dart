import 'package:flutter/material.dart';
import 'package:test_app/home_page.dart';

class HalamanSetting extends StatefulWidget {
  const HalamanSetting({super.key});

  @override
  State<HalamanSetting> createState() => _HalamanSettingState();
}

class _HalamanSettingState extends State<HalamanSetting> {
  _goBack(BuildContext context) {
    // Navigator.pop(context);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const HalamanHome(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffC4DFCB),
      appBar: AppBar(
        leading: IconButton(
          color: Colors.blue,
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: (){
            _goBack(context);
          }, 
        ),
        title: const Text(
          "Settings", 
          style: TextStyle(
            color: Colors.blue,
            fontSize: 25,
            fontWeight: FontWeight.w600
          ),
        ),
        centerTitle: true,
      ),
    );
  }
}