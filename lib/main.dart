import 'dart:async';
import 'package:flutter/material.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:random_string/random_string.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    // title: "Flutter Playground",
    // home: BlizzApp(),
    initialRoute: '/',
    routes: {
      '/': (context) => HomePage(),
      '/DogPage': (context) => DogPage(),
      'LaunchCodes': (context) => LaunchCodes(),
    },
  ));
}

//code pulled from the passcode package
//https://pub.dev/packages/passcode_screen/example
const launchCodesPasscode = '246810';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  bool isAuthenticated = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter Playground'),
          backgroundColor: Colors.blueGrey,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                child: Text('The Best Dog'),
                onPressed: () {
                  Navigator.pushNamed(context, '/DogPage');
                },
              ),
              ElevatedButton(
                child: Text('Launch Codes, Top Secret'),
                onPressed: () {
                  _showLockScreen(
                    context,
                    opaque: false,
                    cancelButton: Text(
                      'Cancel',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      semanticsLabel: 'Cancel',
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }

  _defaultLockScreenButton(BuildContext context) => MaterialButton(
        color: Theme.of(context).primaryColor,
        child: Text('Open Default Lock Screen'),
        onPressed: () {
          _showLockScreen(
            context,
            opaque: false,
            cancelButton: Text(
              'Cancel',
              style: const TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel: 'Cancel',
            ),
          );
        },
      );
  _showLockScreen(
    BuildContext context, {
    required bool opaque,
    CircleUIConfig? circleUIConfig,
    KeyboardUIConfig? keyboardUIConfig,
    required Widget cancelButton,
    List<String>? digits,
  }) {
    Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, secondaryAnimation) =>
              PasscodeScreen(
            title: Text(
              'Enter App Passcode',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            circleUIConfig: circleUIConfig,
            keyboardUIConfig: keyboardUIConfig,
            passwordEnteredCallback: _onPasscodeEntered,
            cancelButton: cancelButton,
            deleteButton: Text(
              'Delete',
              style: const TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel: 'Delete',
            ),
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor: Colors.black.withOpacity(0.8),
            cancelCallback: _onPasscodeCancelled,
            digits: digits,
            passwordDigits: 6,
          ),
        ));
  }

  _onPasscodeEntered(String enteredPasscode) {
    bool isValid = launchCodesPasscode == enteredPasscode;
    _verificationNotifier.add(isValid);
    if (isValid) {
      setState(() {
        this.isAuthenticated = isValid;
      });
    }
    Navigator.pushNamed(context, 'LaunchCodes');
  }

  _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }
}

class DogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eevee!!!!"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
          child: Center(
              child: Column(children: <Widget>[
        Container(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Back!'),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset(
              'assets/images/eevee.jpg',
              height: 500,
              width: 500,
            ),
          ],
        )
      ]))),
    );
  }
}

class LaunchCodes extends StatefulWidget {
  @override
  State<LaunchCodes> createState() => _LaunchCodesState();
}

class _LaunchCodesState extends State<LaunchCodes> {
  String randomNumber = 'X';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Launch Codes"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Container(
            child: Column(children: <Widget>[
          ElevatedButton(
            child: Text('Get the codes!'),
            //https://www.youtube.com/watch?v=hTKBFuw-xyo
            onPressed: () {
              setState(() {
                randomNumber = Random().nextInt(6000001).toString();
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
            child: Text('Back!'),
          ),
          Text('Codes: $randomNumber')
        ])),
      ),
    );
  }
}




// class BlizzApp extends StatelessWidget {
//   const BlizzApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blueGrey,
//         title: const Text('Flutter playground'),
//       ),
//       body: ElevatedButton(
//         child: Text('The best dog?'),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => AboutPage(),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class AboutPage extends StatelessWidget {
//   const AboutPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.red,
//         title: Text('Its Eevee!'),
//       ),
//       body: Image.asset('assets/images/eevee.jpg'),
//     );
//   }
// }
