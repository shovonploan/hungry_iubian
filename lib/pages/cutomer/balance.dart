import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hungry_iubian/commonWidget.dart';
import 'package:hungry_iubian/cubits/session.dart';

class CustomerBalance extends StatefulWidget {
  const CustomerBalance({super.key});

  @override
  State<CustomerBalance> createState() => CustomerBalanceState();
}

class CustomerBalanceState extends State<CustomerBalance> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, Session>(builder: (context, state) {
      if (state is SessionValue) {
        return Scaffold(
          appBar: CustomeAppBar(
            userName: state.user.userName,
          ),
          drawer: CustomerDrawer(
            username: state.user.userName,
            email: state.user.email as String,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
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
                                '${state.user.credit} Taka',
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.all(6.0),
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
                        buildPaymentOption(
                            'assets/images/bkash.svg', 'Bkash', true),
                        buildPaymentOption(
                            'assets/images/nagad.svg', 'Nagad', true),
                        buildPaymentOption(
                            'assets/images/5915.jpg', 'Credit card', false),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
      if (state is SessionValue) {
        Navigator.pushNamed(context, "/");
      }
      return const Scaffold();
    });
  }

  Widget buildPaymentOption(String imagePath, String title, bool isSVG) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(context).size.width * 0.15,
        margin: const EdgeInsets.all(6.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.blueGrey[500],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            isSVG
                ? SvgPicture.asset(
                    imagePath,
                    width: 30.0,
                    height: 30.0,
                  )
                : Image.asset(
                    imagePath,
                    width: 30.0,
                    height: 30.0,
                  ),
            const SizedBox(width: 8.0),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  
}
