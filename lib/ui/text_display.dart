import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_flutter_nfcenabler/managers/providers/provider_status.dart';
import 'package:mobile_flutter_nfcenabler/managers/tasks/NfcTask.dart';
import 'package:mobile_flutter_nfcenabler/models/model.dart';
import 'package:provider/provider.dart';

class TextDisplay extends StatefulWidget {
  static const routeName = '/TextDisplay';

  @override
  _TextDisplayState createState() => _TextDisplayState();
}

class _TextDisplayState extends State<TextDisplay> {
  @override
  void didChangeDependencies() {
    if (Platform.isAndroid) {
      NfcTask.instance.readResistance(
          context, Provider.of<ProviderStatus>(context, listen: false));
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Text Display',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.4)),
        backgroundColor: Colors.black,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(true);
            }),
      ),
      body: Column(
        children: [
          Expanded(child: _radioSelect()),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 50,
            margin: EdgeInsets.all(10),
            child: _openTap(),
          ),
        ],
      ),
    );
  }

  Widget _openTap() {
    return Consumer<ProviderStatus>(builder: (context, provider, child) {
      return OutlinedButton(
        onPressed: () {
          provider.setStatusInitial();
          provider.page = 'text';

          if (Platform.isAndroid) {
            tapDialog(context);
          }

          if (Platform.isIOS) {
            NfcTask.instance.readResistance(context, provider);
          }
        },
        style: OutlinedButton.styleFrom(backgroundColor: Colors.blue),
        // color: Colors.blue[600],
        child: Text(
          'Scan',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.4,
              fontSize: 24,
              color: Colors.white),
        ),
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      );
    });
  }

  Widget _radioSelect() {
    return Column(
      children: <Widget>[
        RadioListTile<SELECTMODE>(
            title: Text(
              'Text',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.4,
                fontSize: 18,
              ),
            ),
            value: SELECTMODE.TEXT,
            groupValue: fuTextArgs.select,
            onChanged: (val) {
              setState(() {
                fuTextArgs.select = val!;
              });
            }),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: TextField(
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.all(5),
            ),
            onChanged: (value) {
              fuTextArgs.text = value;
            },
          ),
        ),
        RadioListTile<SELECTMODE>(
            title: Text(
              'Current Time',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.4,
                fontSize: 18,
              ),
            ),
            value: SELECTMODE.CURRENTTIME,
            groupValue: fuTextArgs.select,
            onChanged: (val) {
              setState(() {
                fuTextArgs.select = val!;
              });
            }),
        RadioListTile<SELECTMODE>(
            title: Text(
              'Counter Time',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.4,
                fontSize: 18,
              ),
            ),
            value: SELECTMODE.COUNTERTIME,
            groupValue: fuTextArgs.select,
            onChanged: (val) {
              setState(() {
                fuTextArgs.select = val!;
              });
            }),
      ],
    );
  }
}

void tapDialog(BuildContext context) {
  showDialog(
      barrierDismissible:
          false, //makes dialogs dismissible or not on external click
      context: context,
      builder: (context) {
        return Consumer<ProviderStatus>(builder: (context, provider, child) {
          return AlertDialog(
            content: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: new EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).size.height * 0.05),
                          child: Text(
                            '${provider.status}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.07,
                              fontWeight: FontWeight.bold,
                              color: provider.color,
                              letterSpacing: 3,
                            ),
                          ),
                        ),
                        Container(
                          padding: new EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).size.height * 0.05),
                          child: Image.asset('${provider.image}'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      });
}
