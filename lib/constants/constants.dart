import 'package:flutter/material.dart';
import 'package:hungry_iubian/commonWidget.dart';
import 'package:hungry_iubian/models/user.dart';
import 'package:responsive_builder/responsive_builder.dart';

bool isDesktop(SizingInformation sizingInformation) {
  if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
    return true;
  }
  return false;
}

class DashboardSkeleton extends StatefulWidget {
  const DashboardSkeleton({
    super.key,
    required this.body,
    required this.user,
    this.floatingActionButton,
  });
  final Widget body;
  final User user;
  final Widget? floatingActionButton;
  @override
  State<DashboardSkeleton> createState() => _DashboardSkeletonState();
}

class _DashboardSkeletonState extends State<DashboardSkeleton> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar:  CustomeAppBar(
          userName: widget.user.userName,
        ),
        drawer: widget.user.userType == 'customer'
            ? CustomerDrawer(
                username: widget.user.userName,
                email: widget.user.email as String)
            : AdminDrawer(
                username: widget.user.userName,
                email: widget.user.email as String),
        body: widget.body,
        floatingActionButton: widget.floatingActionButton,
      );
}
