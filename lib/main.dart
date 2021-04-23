import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/auth.dart';
import './widgets/splash.dart';
import './screens/auth_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/user_products_screen.dart';
import './screens/orders_screen.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './providers/cart.dart';
import './providers/products_data.dart';

import './screens/product_detail_screen.dart';
import './screens/product_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primaryColor: Colors.cyanAccent,
            primarySwatch: Colors.cyan,
            accentColor: Colors.yellowAccent,
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
          home: authData.isAuth
              ? ProductsScreen()
              : FutureBuilder(
            future: authData.tryAutoLogin(),
            builder: (ctx, authResultSnapshot) =>
            authResultSnapshot.connectionState ==
                ConnectionState.waiting
                ? Splash()
                : AuthScreen(),
          ),
          routes: {
            "/prodetail": (ctx) => ProductDetailScreen(),
            "/cart": (ctx) => CartScreen(),
            "/orders": (ctx) => OrdersScreen(),
            "/manageproducts": (ctx) => UserProductsScreen(),
            "/editproduct": (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
