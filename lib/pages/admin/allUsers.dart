import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_iubian/constants/constants.dart';
import 'package:hungry_iubian/cubits/session.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  List<Map<String, dynamic>> users = [];
  void getAllUsers() async {
    try {
      final response = await Dio().get('http://localhost:3000/users');
      users = [];
      for (var i = 0; i < response.data.length; i++) {
        users.add(response.data[i]);
      }
      setState(() {});
    } catch (error) {
      print('Dio error: $error');
    }
  }

  void deleteUser(int userId) async {
    try {
      final _ = await Dio().delete(
        'http://localhost:3000/deleteUser',
        queryParameters: {'userId': userId},
      );
      getAllUsers();
    } catch (error) {
      print('Dio error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, Session>(
      builder: (context, state) {
        if (state is SessionValue) {
          return DashboardSkeleton(
              body: ResponsiveBuilder(
                builder: (context, sizingInformation) {
                  return Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.02),
                    child: SingleChildScrollView(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DataTable(
                            columns: const [
                              DataColumn(label: Text('User Name')),
                              DataColumn(label: Text('Date of Birth')),
                              DataColumn(label: Text('Account Created')),
                              DataColumn(label: Text('User Type')),
                              DataColumn(label: Text('Credit')),
                              DataColumn(label: Text('Phone')),
                              DataColumn(label: Text('Email')),
                              DataColumn(label: Text('Passport No')),
                              DataColumn(label: Text('Father Name')),
                              DataColumn(label: Text('Mother Name')),
                              DataColumn(label: Text('Delete User')),
                            ],
                            rows: users
                                .map((user) => DataRow(
                                      cells: [
                                        DataCell(Text(user['userName'])),
                                        DataCell(Text(user['dateOfBirth'])),
                                        DataCell(Text(user['accountCreated'])),
                                        DataCell(Text(user['userType'])),
                                        DataCell(
                                            Text(user['credit'].toString())),
                                        DataCell(Text(user['phone'])),
                                        DataCell(Text(user['email'])),
                                        DataCell(Text(user['passportNo'])),
                                        DataCell(Text(user['fatherName'])),
                                        DataCell(Text(user['motherName'])),
                                        DataCell(ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Dialog Title'),
                                                    content: const Text(
                                                        'Are you sure you want to delete'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(); // Close the dialog
                                                        },
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          deleteUser(
                                                              user['userId']);
                                                        },
                                                        child: const Text(
                                                            'Delete'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: const Text("Delete"))),
                                      ],
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/createUser')
                      .then((value) => getAllUsers());
                },
                backgroundColor: Colors.blueAccent,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
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
