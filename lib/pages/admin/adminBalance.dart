import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_iubian/constants/constants.dart';
import 'package:hungry_iubian/cubits/session.dart';
import 'package:hungry_iubian/models/user.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AdminBalnce extends StatefulWidget {
  const AdminBalnce({super.key});

  @override
  State<AdminBalnce> createState() => _AdminBalnceState();
}

class _AdminBalnceState extends State<AdminBalnce> {
  final _formKey = GlobalKey<FormState>();
  final _userId = TextEditingController();
  final _money = TextEditingController();
  User? fetchEduser;
  @override
  void dispose() {
    _userId.dispose();
    _money.dispose();
    super.dispose();
  }

  void findUser() async {
    if (_userId.text.isNotEmpty) {
      try {
        final response = await Dio().get(
          'http://localhost:3000/user',
          data: {
            'id': _userId.text,
          },
        );
        if (response.data.isNotEmpty) {
          setState(() {
            fetchEduser = User.fromJson(response.data[0]);
            _money.text = fetchEduser!.credit.toString();
            _userId.clear();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Invalid User id'), backgroundColor: Colors.red),
          );
        }
      } catch (error) {
        print('Error: $error');
      }
    }
  }

  void setMoney() async {
    try {
      final _ = await Dio().put(
        'http://localhost:3000/credit',
        queryParameters: {
          'id': fetchEduser!.userId,
          'amount': _money.text,
        },
      );
      findUser();
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, Session>(
      builder: (context, state) {
        if (state is SessionValue) {
          return DashboardSkeleton(
              body: ResponsiveBuilder(
                builder: (context, sizingInformation) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: TextFormField(
                                controller: _userId,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'User ID',
                                  hintText: 'Enter your user ID',
                                  prefixIcon: const Icon(Icons.person),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide:
                                        const BorderSide(color: Colors.blue),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 16.0),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a valid userId';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.01),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  findUser();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(
                                    MediaQuery.of(context).size.width * 0.1,
                                    MediaQuery.of(context).size.height * 0.05),
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                              ),
                              child: const Text("Find"),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1),
                        (fetchEduser != null)
                            ? Container(
                                padding: const EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width * 0.15,
                                margin: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/credit.jpg',
                                      width: double.infinity,
                                      height: 200.0,
                                      fit: BoxFit.fill,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          const Text(
                                            'User Credit Balance',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            '${fetchEduser!.credit} Taka',
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        (fetchEduser != null)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: TextFormField(
                                      controller: _money,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: 'Credit',
                                        hintText: 'Enter credit',
                                        prefixIcon: const Icon(Icons.money),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                              color: Colors.blue),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 12.0,
                                                horizontal: 16.0),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter amount';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.01),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _userId.text =
                                            fetchEduser!.userId.toString();
                                      });
                                      if (_formKey.currentState!.validate()) {
                                        setMoney();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(
                                          MediaQuery.of(context).size.width *
                                              0.1,
                                          MediaQuery.of(context).size.height *
                                              0.05),
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0, horizontal: 16.0),
                                    ),
                                    child: const Text("Update"),
                                  ),
                                ],
                              )
                            : Container()
                      ],
                    ),
                  );
                },
              ),
              user: state.user);
        } else if (state is SessionValue) {
          Navigator.pushNamed(context, "/");
        }
        return const Scaffold();
      },
    );
  }
}
