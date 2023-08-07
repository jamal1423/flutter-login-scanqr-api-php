import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:test_app/home_page.dart';

class HalamanProfile extends StatefulWidget {
  const HalamanProfile({super.key});

  @override
  State<HalamanProfile> createState() => _HalamanProfileState();
}

class _HalamanProfileState extends State<HalamanProfile> {
  late Future<Balance> futureBalance;

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
  void initState() {
    super.initState();
    futureBalance = fetchBalance();
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
        title: const Text("Profile", 
          style: TextStyle(
            color: Colors.blue,
            fontSize: 25,
            fontWeight: FontWeight.w600
            ),
        ),
        centerTitle: true,
      ),
      body: ListView(children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 5)
        ),
        Card(
          margin: const EdgeInsets.all(15),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: Colors.grey.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Container(
            // color: Colors.white,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: FutureBuilder<Balance>(
                    future: futureBalance,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text.rich(
                          TextSpan(
                            text: "DATA \n",
                            style: const TextStyle(
                                fontSize: 17),
                            children: [
                              TextSpan(
                                text: " Nama : ${snapshot.data!.nama} \n Nis : ${snapshot.data!.nis} \n Kelas : ${snapshot.data!.kelas} \n Angkatan : ${snapshot.data!.angkatan} \n Lokasi : ${snapshot.data!.lokasi} \n Jenis Kelamin : ${snapshot.data!.jenis_kelamin}",
                                style: const TextStyle(
                                    fontSize: 17),
                              )
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return const CircularProgressIndicator(
                        color: Colors.blue,
                        strokeWidth: 2,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

Future<Balance> fetchBalance() async {
  final response = await http.get(
      Uri.parse("http://23media.web.id/aplikasi/flutter/cek-data.php?nis=10201010"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      });

  if (response.statusCode == 200) {
    return Balance.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load Data.');
  }
}

class Balance {
  String? nama;
  String? nis;
  String? kelas;
  String? angkatan;
  String? lokasi;
  String? jenis_kelamin;

  Balance({this.nama, this.nis, this.kelas, this.angkatan, this.lokasi, this.jenis_kelamin});

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      nama: json['nama'],
      nis: json['nis'],
      kelas: json['kelas'],
      angkatan: json['angkatan'],
      lokasi: json['lokasi'],
      jenis_kelamin: json['jenis_kelamin'],
    );
  }

}