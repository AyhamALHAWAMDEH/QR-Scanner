
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scanner/qr_scan_page.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'QR Scanner'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void>? _launched;
  Uri? _currentUri;
  String _scannedDataDisplay = 'No data scanned yet';

  @override
  void initState() {
    super.initState();
  }

  bool _isUrl(String text) {
    final RegExp urlPattern = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
      caseSensitive: false,
      multiLine: false,
    );
    return urlPattern.hasMatch(text);
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // تم حذف AppBar
      body: Center( // تم تغيير ListView إلى Center
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // للتوسيط العمودي
          children: <Widget>[
            Image.asset(
              'assets/logo.png', // مسار الصورة
              width: 200.0, // عرض الصورة
              height: 200.0, // ارتفاع الصورة
            ),
            const SizedBox(height: 50.0), // المسافة بين الصورة والزر
            ElevatedButton(
              onPressed: () async {

            String? scannedData = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QRScanPage()),
                  );
                  if (scannedData != null) {
                    setState(() {
                      if (_isUrl(scannedData)) {
                        // إذا كان النص يمثل رابط URL
                        _currentUri = Uri.parse(scannedData);
                        _launchInBrowser(_currentUri!);
                        _scannedDataDisplay = 'URL opened: $scannedData';
                      } else {
                        // إذا كان النص عادي وليس رابط
                        _scannedDataDisplay = 'Scanned data: $scannedData';
                      }
                    });
                  }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B96C4), // لون خلفية الزر
              ),
              child: const Text(
                'Scan QR Code',
                style: TextStyle(
                  fontSize: 18.0, // حجم الخط للزر
                  color: Colors.white, // لون الخط للزر
                ),
              ),
            ),
            const SizedBox(height: 15.0), // المسافة بين الزر والنص
            Text(
              _scannedDataDisplay,
              style: const TextStyle(
                fontSize: 14.0, // حجم النص
                color: Colors.black, // لون النص
              ),
            ),
          ],
        ),
      ),
    );
  }
}