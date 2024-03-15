import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_flutter_nfcenabler/managers/providers/provider_status.dart';
import 'package:mobile_flutter_nfcenabler/ui/text_display.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp])
      .then((_) => runApp(MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => ProviderStatus()),
            ],
            child: MyApp(),
          )));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NFC Demo',
      initialRoute: TextDisplay.routeName,
      routes: {
        TextDisplay.routeName: (ctx) => TextDisplay(),
      },
    );
  }
}
