import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_iubian/constants/constants.dart';
import 'package:hungry_iubian/cubits/session.dart';
import 'package:responsive_builder/responsive_builder.dart';

class GenerateReport extends StatefulWidget {
  const GenerateReport({super.key});

  @override
  State<GenerateReport> createState() => _GenerateReportState();
}

class _GenerateReportState extends State<GenerateReport> {
  bool choose = true;

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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    choose = !choose;
                                  });
                                },
                                child: Text("Sales Data"),
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(
                                      sizingInformation.screenSize.width * 0.1,
                                      sizingInformation.screenSize.height *
                                          0.05),
                                  foregroundColor:
                                      choose ? Colors.white : Colors.black,
                                  backgroundColor:
                                      choose ? Colors.blue : Colors.blueGrey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 16.0),
                                ),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    choose = !choose;
                                  });
                                },
                                child: Text("Payment Data"),
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(
                                      sizingInformation.screenSize.width * 0.1,
                                      sizingInformation.screenSize.height *
                                          0.05),
                                  foregroundColor:
                                      choose ? Colors.black : Colors.white,
                                  backgroundColor:
                                      choose ? Colors.blueGrey : Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 16.0),
                                ),
                              ),
                            ]),
                        SizedBox(
                          width: sizingInformation.screenSize.width * 0.3,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: Text("Generate Report"),
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(
                                    sizingInformation.screenSize.width * 0.1,
                                    sizingInformation.screenSize.height * 0.05),
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                              ),
                            ),
                          ],
                        ),
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
