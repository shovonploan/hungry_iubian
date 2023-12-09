import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_iubian/commonWidget.dart';
import 'package:hungry_iubian/cubits/session.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, Session>(builder: (context, state) {
      if (state is SessionValue) {
        return Scaffold(
          appBar: CustomeAppBar(
            userName: state.user.userName,
          ),
          drawer: AdminDrawer(
            username: state.user.userName,
            email: state.user.email as String,
          ),
          body: Center(
            child: Text("Main content"),
            ),
        );
      }
      if (state is SessionValue) {
        Navigator.pushNamed(context, "/");
      }
      return const Scaffold();
    });
  }
}