import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_iubian/constants/constants.dart';
import 'package:hungry_iubian/cubits/session.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
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
                      top: sizingInformation.screenSize.height * 0.1,
                    ),
                    child: Center(
                      child: Text(
                        "Welcome To Admin panel",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: (sizingInformation.screenSize.width < 767)
                              ? 24
                              : 48,
                          color: Colors.blueGrey,
                        ),
                      ),
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
