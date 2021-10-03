import 'package:fetch_voice_data/constants.dart';
import 'package:fetch_voice_data/firebase/firbase_api.dart';
import 'package:fetch_voice_data/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      designSize: const Size(Constants.width, Constants.height),
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder<String>(
            future: FireAuth.signIn(),
            builder: (context, snapshot) {
              double width = MediaQuery.of(context).size.width;
              double height = MediaQuery.of(context).size.height;

              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    String userId = snapshot.data!;
                    return MyHomePage(
                      userId: userId,
                      width: width,
                      height: height,
                    );
                  } else {
                    return const Scaffold(
                        body: Center(child: Text("There was an error")));
                  }
                case ConnectionState.waiting:
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 2.2,
                      ),
                    ),
                  );
                default:
                  return const Scaffold(
                      body: Center(child: Text("There was an error")));
              }
            }),
      ),
    );
  }
}
