// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_flutter_nfcenabler/managers/providers/provider_status.dart';
import 'package:mobile_flutter_nfcenabler/models/model.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:sic4310/library.dart';

class NfcTask {
  static NfcTask? _instance;

  // get instance
  static NfcTask get instance {
    if (_instance == null) {
      _instance = new NfcTask();
    }
    return _instance!;
  }

  ProviderStatus? _providerStatus;

  Future<void> readResistance(
      BuildContext context, ProviderStatus provider) async {
    _providerStatus = provider;

    int counter = 0;

    // call class SicCoreTask for basic RFID and UART commands
    Sic431XCore sic4310core = Sic431XCore();

    bool isAvailable = await NfcManager.instance.isAvailable();

    await NfcManager.instance.startSession(
        alertMessage: 'Please tap a tag.',
        onDiscovered: (NfcTag tag) async {
          _providerStatus!.setStatusTap();
          print(_providerStatus!.page);

          try {
            // start with clear flag
            bool _checkFlag = await sic4310core.clearFlag(tag);
            if (!_checkFlag) {
              // IOS stop session nfc polling
              if (Platform.isIOS) {
                NfcManager.instance
                    .stopSession(alertMessage: 'Please tap again!');
              }
            }
            // validate power
            _checkFlag = await sic4310core.checkPower(tag);
            if (_checkFlag) {
              switch (_providerStatus!.page) {
                case 'text':
                  Uint8List? _response;
                  switch (fuTextArgs.select.index) {
                    case 0:
                      try {
                        List<int> data = fuTextArgs.text.codeUnits;
                        await Future.delayed(Duration(seconds: 2));
                        await sic4310core.clearFlag(tag);
                        // send transceive command
                        await sic4310core.txRu(
                            tag, Uint8List.fromList([36] + data));

                        await Future.delayed(Duration(milliseconds: 32));
                        // receive data from command receive
                        _response = await sic4310core.rxUr(tag);

                        if (_response!.isNotEmpty) {
                          provider.setStatusSuccess();
                        } else {
                          provider.setStatusInitial();
                        }
                      } catch (e) {
                        provider.setStatusError('Set FU LCD Display failed.');

                        if (Platform.isIOS) {
                          NfcManager.instance.stopSession(
                              errorMessage: 'Set FU LCD Display failed.');
                        }
                      }
                      break;

                    case 1:
                      try {
                        await Future.delayed(Duration(seconds: 2));

                        while (isAvailable) {
                          List<int> data =
                              DateFormat('   dd/MM/yyyy       kk:mm:ss')
                                  .format(DateTime.now())
                                  .codeUnits;
                          await Future.delayed(Duration(seconds: 1));
                          await sic4310core.clearFlag(tag);
                          // send transceive command
                          _response = await sic4310core.txRu(
                              tag, Uint8List.fromList([36] + data));

                          await Future.delayed(Duration(milliseconds: 32));
                          // receive data from command receive
                          _response = await sic4310core.rxUr(tag);

                          if (_response!.isNotEmpty) {
                            provider.setStatusSuccess();
                          } else {
                            provider.setStatusInitial();
                          }
                        }
                      } catch (e) {
                        provider.setStatusError('Set FU LCD Display failed.');

                        if (Platform.isIOS) {
                          NfcManager.instance.stopSession(
                              errorMessage: 'Set FU LCD Display failed.');
                        }
                      }
                      break;

                    case 2:
                      try {
                        await Future.delayed(Duration(seconds: 1));

                        while (isAvailable) {
                          List<int> data =
                              ('Total send: ' + (counter++).toString())
                                  .codeUnits;

                          await Future.delayed(Duration(seconds: 2));

                          // send transceive command
                          _response = await sic4310core.txRu(
                              tag, Uint8List.fromList([36] + data));

                          await Future.delayed(Duration(milliseconds: 32));
                          // receive data from command receive
                          _response = await sic4310core.rxUr(tag);

                          if (_response!.isNotEmpty) {
                            provider.setStatusSuccess();
                          } else {
                            provider.setStatusInitial();
                          }
                        }
                      } catch (e) {
                        provider.setStatusError('Set FU LCD Display failed.');

                        if (Platform.isIOS) {
                          NfcManager.instance.stopSession(
                              errorMessage: 'Set FU LCD Display failed.');
                        }
                      }
                  }
                  break;
              }
            }
          } catch (e) {
            print(e.toString());
            _providerStatus!.setStatusError(e.toString());

            if (Platform.isIOS) {
              NfcManager.instance.stopSession(errorMessage: 'Tag was lost.');
            }
          }
        });
  }
}
