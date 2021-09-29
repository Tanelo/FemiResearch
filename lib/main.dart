import 'package:fetch_voice_data/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'constants.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    print(width);
    print(height);

    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: () => MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(width: width, height: height),
      ),
    );
  }
}
