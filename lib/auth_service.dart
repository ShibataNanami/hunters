import 'package:flutter/material.dart';

class GenerateQRCode extends StatefulWidget {
  const GenerateQRCode({super.key});

  @override
  GenerateQRCodeState createState() => GenerateQRCodeState();
}

class GenerateQRCodeState extends State<GenerateQRCode> {
  TextEditingController controller = TextEditingController();
  String message = '';
  bool _qrCodeGenerated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter + QR code'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    message = value;
                    if (_qrCodeGenerated) {
                      setState(() {
                        _qrCodeGenerated = false;
                      });
                    }
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => setState(() {
                  _qrCodeGenerated = true;
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
