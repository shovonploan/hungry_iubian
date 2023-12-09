import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_iubian/cubits/cart.dart';
import 'package:hungry_iubian/cubits/menu.dart';
import 'package:hungry_iubian/cubits/session.dart';
import 'package:hungry_iubian/pages/admin/menuCard.dart';
import 'package:hungry_iubian/pages/cutomer/balance.dart';
import 'package:hungry_iubian/pages/cutomer/home.dart';
import 'package:hungry_iubian/pages/cutomer/menu.dart';
import 'package:hungry_iubian/pages/cutomer/orders.dart';
import 'package:hungry_iubian/pages/cutomer/profile.dart';
import 'package:hungry_iubian/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (ctx) => SessionCubit()),
        BlocProvider(create: (ctx) => MenuCubit()),
        BlocProvider(create: (ctx) => CartCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginPage(),
        onGenerateRoute: (settings) {
          if (settings.name == '/') {
            return MaterialPageRoute(
              builder: (context) => const LoginPage(),
            );
          } else if (settings.name == '/home') {
            return MaterialPageRoute(
              builder: (context) => const CustomerHome(),
            );
          } else if (settings.name == '/profile') {
            return MaterialPageRoute(
              builder: (context) => const CustomerProfile(),
            );
          } else if (settings.name == '/balance') {
            return MaterialPageRoute(
              builder: (context) => const CustomerBalance(),
            );
          } else if (settings.name == '/customerMenu') {
            return MaterialPageRoute(
              builder: (context) => const CustomerMenuCard(),
            );
          }
          else if (settings.name == '/customerOrder') {
            return MaterialPageRoute(
              builder: (context) => const CustomerOrders(),
            );
          }
          else if (settings.name == '/adminMenu') {
            return MaterialPageRoute(
              builder: (context) => const AdminMenucard(),
            );
          }
          return MaterialPageRoute(
            builder: (context) => const LoginPage(),
          );
        },
      ),
    );
  }
}
