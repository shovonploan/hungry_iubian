import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_iubian/cubits/session.dart';
import 'package:hungry_iubian/models/user.dart';
import 'package:hungry_iubian/pages/admin/home.dart';
import 'package:hungry_iubian/pages/cutomer/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userName = TextEditingController();
  final _password = TextEditingController();
  final dio = Dio();

  void auth(BuildContext context, String userName, String password) async {
    try {
      final response = await dio.post(
        'http://localhost:3000/login',
        data: {
          'userName': userName,
          'password': password,
        },
      );
      if (response.data != []) {
        User user = User.fromJson(response.data[0]);
        context.read<SessionCubit>().login(user);
        navigate(context, user);
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void navigate(BuildContext context, User user) {
    if (user.userType == "customer") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CustomerHome()),
      );
    } else if (user.userType == "admin")
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminHome()),
      );
  }

  @override
  void dispose() {
    _userName.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cons) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(124, 144, 231, 1),
                Color.fromRGBO(231, 57, 245, 1),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              width: (cons.minWidth < 767)
                  ? MediaQuery.of(context).size.width * 0.8
                  : MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 255, 255, 0.8),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.jpg',
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: TextFormField(
                              controller: _userName,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter User Name';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: 'User Name',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: TextFormField(
                              controller: _password,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter password';
                                }
                                return null;
                              },
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(124, 144, 231, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                auth(context, _userName.text, _password.text);
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              child: Text(
                                'Login',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
