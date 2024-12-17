import 'package:flutter/material.dart';
import 'package:onegold/Pages/login.dart';
import 'package:onegold/Providers/address_provider.dart';
import 'package:onegold/Providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'Pages/main_store.dart';
import 'Providers/category_provider.dart';
import 'Providers/customer_provider.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StoreProvider()),
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider())
      ],
      child: MaterialApp(
        routes: {
          '/store': (context) => const Store(),
        },
          debugShowCheckedModeBanner: false,
          title: 'OneGold',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const Login()),
    );
  }
}
