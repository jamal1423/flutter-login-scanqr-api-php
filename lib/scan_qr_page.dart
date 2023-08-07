import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/home_page.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanQr extends StatefulWidget {
  const ScanQr({super.key});

  @override
  State<ScanQr> createState() => _ScanQrState();
}

class _ScanQrState extends State<ScanQr> {
  String _scanBarcode = 'Unknown';
  String tempData = "";
  late Future<ScanData> futureBalance;

  // Future<void> startBarcodeScanStream() async {
  //   FlutterBarcodeScanner.getBarcodeStreamReceiver(
  //           '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
  //       .listen((barcode) => print(barcode));
  // }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      // print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    //barcode scanner flutter ant 
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  // Future<void> scanBarcodeNormal() async {
  //   String barcodeScanRes;
  //   try {
  //     barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //         '#ff6666', 'Cancel', true, ScanMode.BARCODE);
  //     print(barcodeScanRes);
  //   } on PlatformException {
  //     barcodeScanRes = 'Failed to get platform version.';
  //   }

  //   if (!mounted) return;
  //   setState(() {
  //     _scanBarcode = barcodeScanRes;
  //   });
  // }

  @override
  void initState() {
    super.initState();
  }

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
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        
        backgroundColor: const Color(0xffC4DFCB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
            onPressed: (){
              _goBack(context);
            }, 
          ),
          title: const Text(
            "Scan", 
            style: TextStyle(
              color: Colors.blue,
              fontSize: 25,
              fontWeight: FontWeight.w600
            ),
          ),
          centerTitle: true,
        ),
        body: Builder(builder: (BuildContext context) {
          
          futureBalance = fetchBalance(_scanBarcode);
          
          return Container(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            alignment: Alignment.center,
            child: Flex(
              direction: Axis.vertical,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(color: Colors.white60),
                    ),
                    elevation: 10,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () => scanQR(),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.qr_code_scanner_outlined, size: 35,),
                      Text(" Scan Data", 
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8)
                ),
                
                Text('NIS : $_scanBarcode\n',
                    style: const TextStyle(fontSize: 20)),

                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Container(
                    width: 400,
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: FutureBuilder<ScanData>(
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
                              // return const Text("");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ])
          );
        })
      )
    );
  }

    Future<ScanData> fetchBalance(String getData) async {
    final response = await http.get(
        Uri.parse("http://23media.web.id/aplikasi/flutter/cek-data.php?nis=$getData"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });

    if (response.statusCode == 200) {
      return ScanData.fromJson(json.decode(response.body));
      
    } else {
      throw Exception('Failed to load Data.');
    }
  }
}

class ScanData {
  String? nama;
  String? nis;
  String? kelas;
  String? angkatan;
  String? lokasi;
  String? jenis_kelamin;

  ScanData({this.nama, this.nis, this.kelas, this.angkatan, this.lokasi, this.jenis_kelamin});

  factory ScanData.fromJson(Map<String, dynamic> json) {
    return ScanData(
      nama: json['nama'],
      nis: json['nis'],
      kelas: json['kelas'],
      angkatan: json['angkatan'],
      lokasi: json['lokasi'],
      jenis_kelamin: json['jenis_kelamin'],
    );
  }
}