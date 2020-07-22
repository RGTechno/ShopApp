import 'package:flutter/material.dart';
import './screens/product_detail_screen.dart';
import './screens/product_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.cyanAccent,
        primarySwatch: Colors.cyan,
        textTheme: ThemeData.light().textTheme.copyWith(
          headline6: TextStyle(
            fontSize: 30,
            fontFamily: "OrbitronBold",
          ),
          headline5: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: "OrbitronRegular",
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ProductsScreen(),
      routes: {
        "/prodetail": (ctx) => ProductDetailScreen(),
      },
    );
  }
}
