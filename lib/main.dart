import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_assistant/common/colors.dart';

import 'Provider/assistant_provider.dart';
import 'screen/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AssistanceProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Voice Assistant',
        theme: ThemeData.light(useMaterial3: true).copyWith(
            scaffoldBackgroundColor: Pallete.whiteColor,
            appBarTheme: const AppBarTheme(
              backgroundColor: Pallete.whiteColor,
            )),
        home: const MyHomePage(),
      ),
    );
  }
}
