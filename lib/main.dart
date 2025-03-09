import 'package:flutter/material.dart';
import 'package:gekattendance/providers/user_provider.dart';
import 'package:gekattendance/views/app.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
    child: MyApp(),
  ));
}
